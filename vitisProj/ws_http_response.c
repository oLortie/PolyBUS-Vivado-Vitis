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
#include "xtime_l.h"

//TODO: Move time calculations to functions in web_utils. Unsuccessfully attempted...
//TODO: Test (or remove?) GET requests for individual data?

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
 * this inserts the original request string in between the notfound_header &
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

	xil_printf("HTTP server received POST\r\n");

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

	} else if (s4i_is_cmd_respirationSelect(req)) {
		char selectChar = req[28];

		if (selectChar == '0') {
			s4i_setRespirationSelect(respi025);
		} else {
			s4i_setRespirationSelect(respi05);
		}


	} else if (s4i_is_cmd_perspirationSelect(req)) {
		char selectChar = req[29];

		if (selectChar == '0') {
			s4i_setPerspirationSelect(level1);
		} else {
			s4i_setPerspirationSelect(level2);
		}
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
	char buf[BUFSIZE];              // Buffer de sortie (en-tete + contenu)
	int fsize, hlen, n;
	char *fext;
	FIL fil;
	FRESULT Res;

    // NOTE: La methode retourne 0 si tout se passe bien, -1 si une erreur est
    // survenue. La reponse a transmettre au client doit etre entree dans la
    // variable buf, qui est un tableau de taille fixe. La taille du contenu
    // doit etre indiquee dans l'en-tete (voir les methodes
    // TODO: Ici, il faudrait detecter si une requete correspond
    // a un element connu, par exemple un de vos capteurs, et y repondre
    // adequatement.
    // La structure a ete mise en place, mais vous devez completer le code de
    // reponse ainsi que la methode s4i_is_cmd_sws(req), qui retourne toujours
    // zero pour l'instant.
	xil_printf("req : %s\n", req);
	//xil_printf(req);
    if (s4i_is_cmd_respiration(req)) {

    	float respirationVoltage = s4i_GetRespirationVoltage();

    	XTime currentClockTime;
    	XTime_GetTime(&currentClockTime);
    	//The current clock time in s since the start of the program
    	float currentMS = ((float)currentClockTime / (COUNTS_PER_SECOND));

    	char respirationVoltage_buf[192];
    	sprintf(respirationVoltage_buf, "{ \"respiration\" : %f, \"time\" : %f }", respirationVoltage, currentMS);

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

    	XTime currentClockTime;
    	XTime_GetTime(&currentClockTime);
    	//The current clock time in s since the start of the program
    	float currentMS = ((float)currentClockTime / (COUNTS_PER_SECOND));

        char perspirationVoltage_buf[192];
        sprintf(perspirationVoltage_buf, "{\"perspiration\" : %f, \"time\" : %f}", perspirationVoltage, currentMS);

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

    	XTime currentClockTime;
    	XTime_GetTime(&currentClockTime);
    	//The current clock time in s since the start of the program
    	float currentMS = ((float)currentClockTime / (COUNTS_PER_SECOND));

        char poulsVoltage_buf[192];
        sprintf(poulsVoltage_buf, "{\"pouls\" : %f, \"time\" : %f}", poulsVoltage, currentMS);

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

    	XTime currentClockTime;
    	XTime_GetTime(&currentClockTime);
    	//The current clock time in s since the start of the program
    	float currentMS = ((float)currentClockTime / (COUNTS_PER_SECOND));

        char pressionVoltage_buf[192];
        sprintf(pressionVoltage_buf, "{\"pression\" : %f, \"time\" : %f}", pressionVoltage, currentMS);

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

    	XTime currentClockTime;
    	XTime_GetTime(&currentClockTime);
    	//The current clock time in s since the start of the program
    	float currentMS = ((float)currentClockTime / (COUNTS_PER_SECOND));

		char rawData_buf[192]; // Normally approx 120 chars but modify if we add a lot more data
    	sprintf(rawData_buf, "{\"respiration\" : %f, \"perspiration\" : %f, \"pouls\" : %f, \"pression\" : %f, \"time\" : %f}", respirationVoltage, perspirationVoltage, poulsVoltage, pressionVoltage, currentMS);
    	//xil_printf("strlen(rawData_buf) = %d", strlen(rawData_buf));

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
    else if (s4i_is_cmd_parameters(req)) {
    	float bpm = s4i_GetBPM();
    	float respiration = s4i_GetFrequenceRespiration();
    	float bloodPressure = 0.0F;
    	float perspiration = s4i_GetAnalysePerspiration();
    	u16 certitude = s4i_getCertitude();

    	char parameters_buf[192]; // Normally approx 135 chars but modify if we add a lot more data
		sprintf(parameters_buf, "{\"bpm\" : %f, \"respiration\" : %f, \"bloodPressure\" : %f, \"perspiration\" : %f, \"certitude\" : %d}", bpm, respiration, bloodPressure, perspiration, certitude);

		unsigned int parameters_len = strlen(parameters_buf);
		unsigned int len = generate_http_header(buf, "js", parameters_len);

		strcat(buf, parameters_buf);
		len += parameters_len;

		if (lwip_write(sd, buf, len) != len) {
			xil_printf("Error writing GET response to socket\r\n");
			xil_printf("http header = %s\r\n", buf);
			return -1;
		}
    }
    else {
        // Si la requete n'est pas un point d'acces ("route") connu, on tente de
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
