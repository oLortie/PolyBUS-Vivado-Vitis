/*
 * main.c
 *
 * Atelier #3 - Projet S4 Gï¿½nie informatique - H21
 *
 *  Author: François marcoux
 */



#include <stdio.h>
#include "s4i_tools.h"
#include "o_led.h"
#include "PmodOLED.h"


void o_led_initialize(PmodOLED *oledDevice)
{

	// Initialiser le Pmod Oled
	OLED_Begin(oledDevice, XPAR_PMODOLED_0_AXI_LITE_GPIO_BASEADDR, XPAR_PMODOLED_0_AXI_LITE_SPI_BASEADDR, 0, 0);
	// Dï¿½sactiver la mise ï¿½ jour automatique de l'ï¿½cran de l'OLED
	OLED_SetCharUpdate(oledDevice, 0);
	// Prï¿½parer l'ï¿½cran pour afficher l'ï¿½tat des boutons et des switch
	OLED_ClearBuffer(oledDevice);
	OLED_SetCursor(oledDevice, 0, 0);
	OLED_PutString(oledDevice, "Certitude = ");

	OLED_SetCursor(oledDevice, 0, 3);
	OLED_PutString(oledDevice, "Compteur  = ");


	OLED_Update(oledDevice);

	print("Initialisation finie\n\r");
};

void o_led_refresh_data(PmodOLED *oledDevice){

		char comptChar[5];
		char CertitudeChar[5];

		// lire la tension provenant du PmodAD1
		u16 currentCount = s4i_getCounter();
		u16 currentCertitude = s4i_getCertitude();


		// Affichage du voltage sur le Pmod OLED
		sprintf(comptChar,"%u  ",currentCount);
		sprintf(CertitudeChar,"%u ",currentCertitude);

		OLED_SetCursor(oledDevice, 12, 0);
		OLED_PutString(oledDevice, CertitudeChar);

		OLED_SetCursor(oledDevice, 15, 0);
		OLED_PutString(oledDevice, "%");
		OLED_Update(oledDevice);

		OLED_SetCursor(oledDevice, 12, 3);
		OLED_PutString(oledDevice, comptChar);


}


