/*
 * main.c
 *
 * Atelier #3 - Projet S4 Gï¿½nie informatique - H21
 *
 *  Author: François marcoux
 */



#include <xgpio.h>
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
	OLED_PutString(oledDevice, "Pouls = ");

	OLED_SetCursor(oledDevice, 0, 1);
	OLED_PutString(oledDevice, "Press = ");

	OLED_SetCursor(oledDevice, 0, 2);
	OLED_PutString(oledDevice, "Respi = ");

	OLED_SetCursor(oledDevice, 0, 3);
	OLED_PutString(oledDevice, "Perspi = ");


	OLED_Update(oledDevice);

	print("Initialisation finie\n\r");
};

void o_led_refresh_data(PmodOLED *oledDevice){


		char voltageChar[5];
		char PressChar[5];
		char Respichar[5];
		char Perspichar[5];

		// lire la tension provenant du PmodAD1
		float currentPouls = s4i_GetBPM();
		float currentPress = s4i_GetPressionVoltage();
		float currentRespi = s4i_GetFrequenceRespiration();
		float currentPerspi = s4i_GetAnalysePerspiration();


		// Affichage du voltage sur le Pmod OLED
		sprintf(voltageChar,"%2.2f",currentPouls);
		sprintf(PressChar,"%2.2f",currentPress);
		sprintf(Respichar,"%2.2f",currentRespi);
		sprintf(Perspichar,"%2.2f",currentPerspi);

		OLED_SetCursor(oledDevice, 10, 0);
		OLED_PutString(oledDevice, voltageChar);

		OLED_SetCursor(oledDevice, 10, 1);
		OLED_PutString(oledDevice, PressChar);

		OLED_SetCursor(oledDevice, 9, 2);
		OLED_PutString(oledDevice, Respichar);

		OLED_SetCursor(oledDevice, 10, 3);
		OLED_PutString(oledDevice, Perspichar);

		OLED_SetCursor(oledDevice, 15, 3);
		OLED_PutString(oledDevice, "V");
		OLED_Update(oledDevice);

}


