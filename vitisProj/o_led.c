/*
 * main.c
 *
 * Atelier #3 - Projet S4 G�nie informatique - H21
 *
 *  Author: Larissa Njejimana
 */



#include <xgpio.h>
#include <stdio.h>
#include "s4i_tools.h"
#include "o_led.h"
#include "PmodOLED.h"

/**
#include "xil_printf.h"
#include "xparameters.h"
#include "sleep.h"

#include "myADCip.h"*/

//PmodOLED oledDevice;


void o_led_initialize(PmodOLED *oledDevice)
{


	// Initialiser le Pmod Oled
	OLED_Begin(oledDevice, XPAR_PMODOLED_0_AXI_LITE_GPIO_BASEADDR, XPAR_PMODOLED_0_AXI_LITE_SPI_BASEADDR, 0, 0);
	// D�sactiver la mise � jour automatique de l'�cran de l'OLED
	OLED_SetCharUpdate(oledDevice, 0);
	// Pr�parer l'�cran pour afficher l'�tat des boutons et des switch
	OLED_ClearBuffer(oledDevice);
	OLED_SetCursor(oledDevice, 0, 3);
	OLED_PutString(oledDevice, "Voltage = ");
	OLED_SetCursor(oledDevice, 0, 2);
		OLED_PutString(oledDevice, "BPM = ");
	OLED_Update(oledDevice);

	print("Initialisation finie\n\r");
};

void o_led_refresh_data(PmodOLED *oledDevice){


		char voltageChar[5];
		char BPMchar[5];

		// lire la tension provenant du PmodAD1
		float currentVoltage = s4i_GetRespirationVoltage();
		float currentBPM = s4i_GetBPM();

		// mettre les fonctions pour aller chercher les data



		// Affichage du voltage sur le Pmod OLED
		sprintf(voltageChar,"%2.2f",currentVoltage);
		sprintf(BPMchar,"%2.2f",currentBPM);
		OLED_SetCursor(oledDevice, 10, 3);
		OLED_PutString(oledDevice, voltageChar);

		OLED_SetCursor(oledDevice, 10, 2);
		OLED_PutString(oledDevice, BPMchar);
		OLED_Update(oledDevice);

		OLED_SetCursor(oledDevice, 15, 3);
		OLED_PutString(oledDevice, "V");
		OLED_Update(oledDevice);

}


