/*
 * Copyright (C) 2017 - 2019 Xilinx, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 */

#include <string.h>
#include "ff.h"
#include "lwip/inet.h"
#include "lwip/sockets.h"

#include "webserver.h"
#include "xil_printf.h"


// Ajout pour S4i GIF402
#include "s4i_tools.h"

char *notfound_header =
	"<html> \
	<head> \
		<title>404</title> \
		<style type=\"text/css\"> \
		div#request {background: #eeeeee} \
		</style> \
	</head> \
	<body> \
	<h1>404 Page Not Found</h1> \
	<div id=\"request\">";

char *notfound_footer =
	"</div> \
	</body> \
	</html>";

/* dynamically generate 404 response:
 * this inserts the original request string in betwween the notfound_header &
 * footer strings
 */
int do_404(int sd, char *req, int rlen)
{
	int len, hlen;
	int BUFSIZE = 1024;
	char buf[BUFSIZE];

	len = strlen(notfound_header) + strlen(notfound_footer) + rlen;

	hlen = generate_http_header(buf, "html", len);
	if (lwip_write(sd, buf, hlen) != hlen) {
		xil_printf("error writing http header to socket\r\n");
		xil_printf("http header = %s\n\r", buf);
		return -1;
	}

	len = lwip_write(sd, notfound_header, strlen(notfound_header));
	if (len != strlen(notfound_header)) {
		xil_printf("error writing not found header to socket\r\n");
		xil_printf("not found header = %s\n\r", notfound_header);
		return -1;
	}

	len = lwip_write(sd, req, rlen);
	if (len != rlen) {
		xil_printf("error writing org req to socket\r\n");
		xil_printf("org req = %s\n\r", notfound_footer);
		return -1;
	}

	len = lwip_write(sd, notfound_footer, strlen(notfound_footer));
	if (len != strlen(notfound_footer)) {
		xil_printf("error writing not found footer to socket\r\n");
		xil_printf("http footer = %s\n\r", notfound_footer);
		return -1;
	}


	return 0;
}

int do_http_post(int sd, char *req, int rlen)
{
	int BUFSIZE = 1024;
	int len, n;
	char buf[BUFSIZE];

	xil_printf("!!! HTTP GOT POST\r\n");

	if (is_cmd_print(req)) {
		/* HTTP data starts after "\r\n\r\n" sequence */
		char *data = strstr(req, "\r\n\r\n") + 4;

		/* calculate number of bytes to be printed */
		len = rlen - (data - req);

		xil_printf("http POST: print\r\n");
		xil_printf("-------------------------------------\r\n");
		/* as buffer isn't null terminated, printf %s won't work */
		for (n = 0; n < len; n++)
			xil_printf("%c", data[n]);
		xil_printf("\r\n-------------------------------------\r\n\r\n");

		len = generate_http_header(buf, "js", 1);
		buf[len++] = '0'; /* single byte payload - '0' - to ack */
		buf[len++] = 0;

	} else {
		xil_printf("http POST: unsupported command\r\n");
		return -1;
	}

	if (lwip_write(sd, buf, len) != len) {
		xil_printf("error writing http POST response to socket\r\n");
		xil_printf("http header = %s\r\n", buf);
		return -1;
	}

	return 0;
}

/* respond for a file GET request */
int do_http_get(int sd, char *req, int rlen)
{
	int BUFSIZE = 1400;
	char filename[MAX_FILENAME];
	char buf[BUFSIZE];              // Buffer de sortie (en-tête + contenu)
	int fsize, hlen, n;
	char *fext;
	FIL fil;
	FRESULT Res;

    // NOTE: La méthode retourne 0 si tout se passe bien, -1 si une erreur est
    // survenue. La réponse à transmettre au client doit être entrée dans la
    // variable buf, qui est un tableau de taille fixe. La taille du contenu
    // doit être indiquée dans l'en-tête (voir les méthodes 
    // TODO: Ici, il faudrait détecter si une requête correspond
    // à un élément connu, par exemple un de vos capteurs, et y répondre
    // adéquatement.
    // La structure a été mise en place, mais vous devez compléter le code de
    // réponse ainsi que la méthode s4i_is_cmd_sws(req), qui retourne toujours
    // zéro pour l'instant.
	xil_printf(req);
    if (s4i_is_cmd_sws(req)) {
        xil_printf("!!! HTTP GET: cmd/sws\r\n");
        
        // Obtient l'état des interrupteurs.
        unsigned int switches = s4i_get_sws_state();
        xil_printf("!!! HTTP GET: switch state: %x\r\n", switches);

        // La variable sw_buf contient pour l'instant une structure JSON vide.
        // Elle devrait contenir une structure comme :
        //   {switches: [1,0,0,1]}
        char* sw_buf;
        sprintf(sw_buf, "{switches: [%d, %d, %d, %d]}",
						switches & 1,
						(switches >> 1) & 1,
						(switches >> 2) & 1,
						(switches >> 3) & 1);

        // TODO: Remplir sw_buf avec l'état des interrupteurs. 
        // Un indice : Utilisez sprintf et strcat.


        // Génération de l'entête, qui a besoin de connaître la taille du buffer
        // généré (sw_buf ici).
        unsigned int sw_len = strlen(sw_buf);
        unsigned int len = generate_http_header(buf, "js", sw_len);
        strcat(buf, sw_buf); // Concaténation de l'entête et de la réponse.
        len += sw_len;

        // Écriture sur le socket.
        if (lwip_write(sd, buf, len) != len) {
            xil_printf("Error writing GET response to socket\r\n");
            xil_printf("http header = %s\r\n", buf);
            return -1;
        }

    }
    else if (s4i_is_cmd_respiration(req)) {

    	float respirationVoltage = s4i_GetRespirationVoltage();

    	char* respirationVoltage_buf;
    	sprintf(respirationVoltage_buf, "{ \"respiration\" : %f}", respirationVoltage);
    	// { "respiration" : 3.12321321 }

    	unsigned int respirationVoltage_len = strlen(respirationVoltage_buf);
    	unsigned int len = generate_http_header(buf, "js", respirationVoltage_len);

    	strcat(buf, respirationVoltage_buf);
    	len += respirationVoltage_len;

    	if (lwip_write(sd, buf, len) != len) {
			xil_printf("Error writing GET response to socket\r\n");
			xil_printf("http header = %s\r\n", buf);
			return -1;
		}

    }
    else if (s4i_is_cmd_perspiration(req)) {

        float perspirationVoltage = s4i_GetPerspirationVoltage();

        char* perspirationVoltage_buf;
        sprintf(perspirationVoltage_buf, "{\"perspiration\" : %f}", perspirationVoltage);

        unsigned int perspirationVoltage_len = strlen(perspirationVoltage_buf);
        unsigned int len = generate_http_header(buf, "js", perspirationVoltage_len);

        strcat(buf, perspirationVoltage_buf);
        len += perspirationVoltage_len;

        if (lwip_write(sd, buf, len) != len) {
    		xil_printf("Error writing GET response to socket\r\n");
    		xil_printf("http header = %s\r\n", buf);
    		return -1;
    	}

    }
    else if (s4i_is_cmd_pouls(req)) {

        float poulsVoltage = s4i_GetPoulsVoltage();

        char* poulsVoltage_buf;
        sprintf(poulsVoltage_buf, "{\"pouls\" : %f}", poulsVoltage);

        unsigned int poulsVoltage_len = strlen(poulsVoltage_buf);
        unsigned int len = generate_http_header(buf, "js", poulsVoltage_len);

        strcat(buf, poulsVoltage_buf);
        len += poulsVoltage_len;

        if (lwip_write(sd, buf, len) != len) {
        	xil_printf("Error writing GET response to socket\r\n");
        	xil_printf("http header = %s\r\n", buf);
        	return -1;
        }

    }
    else if (s4i_is_cmd_pression(req)) {

        float pressionVoltage = s4i_GetPressionVoltage();

        char* pressionVoltage_buf;
        sprintf(pressionVoltage_buf, "{\"pression\" : %f}", pressionVoltage);

        unsigned int pressionVoltage_len = strlen(pressionVoltage_buf);
        unsigned int len = generate_http_header(buf, "js", pressionVoltage_len);

        strcat(buf, pressionVoltage_buf);
        len += pressionVoltage_len;

        if (lwip_write(sd, buf, len) != len) {
            xil_printf("Error writing GET response to socket\r\n");
            xil_printf("http header = %s\r\n", buf);
            return -1;
        }

    }
    else if (s4i_is_cmd_rawData(req)) {
    	float respirationVoltage = s4i_GetRespirationVoltage();
    	float perspirationVoltage = s4i_GetPerspirationVoltage();
    	float poulsVoltage = s4i_GetPoulsVoltage();
    	float pressionVoltage = s4i_GetPressionVoltage();

    	char* rawData_buf;
    	sprintf(rawData_buf, "{\"respiration\" : %f, \"perspiration\" : %f, \"pouls\" : %f, \"pression\" : %f}", respirationVoltage, perspirationVoltage, poulsVoltage, pressionVoltage);

    	unsigned int rawData_len = strlen(rawData_buf);
		unsigned int len = generate_http_header(buf, "js", rawData_len);

		strcat(buf, rawData_buf);
		len += rawData_len;

		if (lwip_write(sd, buf, len) != len) {
			xil_printf("Error writing GET response to socket\r\n");
			xil_printf("http header = %s\r\n", buf);
			return -1;
		}
    }
    else {
        // Si la requête n'est pas un point d'accès ("route") connu, on tente de
        // charger un fichier depuis la carte microSD.
        // Sinon, erreur 404.

        /* determine file name */
        extract_file_name(filename, req, rlen, MAX_FILENAME);

        /* respond with 404 if not present */
        Res = f_open(&fil, filename, FA_READ);
        if (Res) {
            xil_printf("file %s not found, returning 404\r\n", filename);
            do_404(sd, req, rlen);
            return -1;
        }

        /* respond with correct file */

        xil_printf("http GET: %s\r\n", filename);

        /* get a pointer to file extension */
        fext = get_file_extension(filename);

        /* obtain file size */
        fsize = f_size(&fil);

        /* write the http headers */
        hlen = generate_http_header(buf, fext, fsize);
        if (lwip_write(sd, buf, hlen) != hlen) {
            xil_printf("error writing http header to socket\r\n");
            xil_printf("http header = %s\r\n", buf);
            f_close(&fil);
            return -1;
        }

        /* now write the file */
        while (fsize > 0) {
            int w;

            f_read(&fil, (void *)buf, BUFSIZE, (unsigned int *)&n);
            if ((w = lwip_write(sd, buf, n)) != n) {
                xil_printf("error writing file (%s) to socket, remaining unwritten bytes = %d\r\n", filename, fsize - n);
                xil_printf("attempted to lwip_write %d bytes, actual bytes written = %d\r\n", n, w);
                return -1;
            }

            fsize -= n;
        }

        f_close(&fil);
    }

	return 0;
}

enum http_req_type { HTTP_GET, HTTP_POST, HTTP_UNKNOWN };
enum http_req_type decode_http_request(char *req, int l)
{
	char *get_str = "GET";
	char *post_str = "POST";

	if (!strncmp(req, get_str, strlen(get_str)))
		return HTTP_GET;

	if (!strncmp(req, post_str, strlen(post_str)))
		return HTTP_POST;

	return HTTP_UNKNOWN;
}

void dump_payload(char *p, int len)
{
	int i, j;

	for (i = 0; i < len; i += 16) {
		for (j = 0; j < 16; j++)
			xil_printf("%c ", p[i+j]);
		xil_printf("\r\n");
	}
	xil_printf("total len = %d\r\n", len);
}

/* generate and write out an appropriate response for the http request */
int generate_response(int sd, char *http_req, int http_req_len)
{
	enum http_req_type request_type;
	request_type = decode_http_request(http_req, http_req_len);

	switch (request_type) {
	case HTTP_GET:
		return do_http_get(sd, http_req, http_req_len);
	case HTTP_POST:
		return do_http_post(sd, http_req, http_req_len);
	default:
		xil_printf("request_type != GET|POST\r\n");
		dump_payload(http_req, http_req_len);
		return do_404(sd, http_req, http_req_len);
	}
}
