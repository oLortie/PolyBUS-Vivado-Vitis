/*
 * s4i_tools.c
 *
 *  Created on: 21 fÃ©vr. 2020
 *      Author: francoisferland
 */

#include "s4i_tools.h"
#include "xparameters.h"
#include "myADCip.h"
#include "RegisterDefines.h"

#include <xgpio.h>

const float ReferenceVoltage = 3.3;

XGpio s4i_xgpio_input_;

void s4i_init_hw()
{
    // Initialise l'accï¿½s au matÅ½riel GPIO pour s4i_get_sws_state().
	XGpio_Initialize(&s4i_xgpio_input_, XPAR_AXI_GPIO_0_DEVICE_ID);
	XGpio_SetDataDirection(&s4i_xgpio_input_, 1, 0xF);
}

int s4i_is_cmd_sws(char *buf)
{
	/* then check for cmd/sws */
	return (!strncmp(buf + 5, "cmd/sws", 7));

    // TODO: VÅ½rifier si la chaâ€�ne donnÅ½e correspond Ë† "cmd/sws".
    // Retourner 0 si ce n'est pas le cas.
    // Attention: la chaâ€�ne possï¿½de la requï¿½te complï¿½te (ex. "GET cmd/sws").
    // Un indice : Allez voir les mÅ½thodes similaires dans web_utils.c.


}

int s4i_is_cmd_respiration(char *buf)
{
	return (!strncmp(buf + 5, "cmd/respiration", 15));
}

int s4i_is_cmd_perspiration(char *buf)
{
	return (!strncmp(buf + 5, "cmd/perspiration", 16));
}

int s4i_is_cmd_pouls(char *buf)
{
	return (!strncmp(buf + 5, "cmd/pouls", 9));
}

int s4i_is_cmd_pression(char *buf)
{
	return (!strncmp(buf + 5, "cmd/pression", 12));
}

int s4i_is_cmd_rawData(char* buf)
{
	return (!strncmp(buf + 5, "cmd/rawData", 11));
}

unsigned int s4i_get_sws_state()
{
    // Retourne l'Å½tat des 4 interrupteurs dans un entier (un bit par
    // interrupteur).
    return XGpio_DiscreteRead(&s4i_xgpio_input_, 1);
}

u16 s4i_getSampleRespirationRaw()
{
	u16 rawData =  MYADCIP_mReadReg(ADCIP_BASEADRESS, ) & 0xFFF;
	return rawData;
}


float s4i_GetRespirationVoltage()
{
	float conversionFactor = ReferenceVoltage / ((1 << RESPIRATION_NUM_BITS) - 1);

	u16 rawSample = s4i_getSampleRespirationRaw();

	float respirationVoltage = ((float)rawSample) * conversionFactor;

	return respirationVoltage;

}

u16 s4i_getSamplePerspirationRaw()
{
	u16 rawData =  (MYADCIP_mReadReg(ADCIP_BASEADRESS, 0x20) & 0xFFF000) >> 12;
	return rawData;
}


float s4i_GetPerspirationVoltage()
{
	float conversionFactor = ReferenceVoltage / ((1 << PERSPIRATION_NUM_BITS) - 1);

	u16 rawSample = s4i_getSamplePerspirationRaw();

	float PerspirationVoltage = ((float)rawSample) * conversionFactor;

	return PerspirationVoltage;

}

u16 s4i_getSamplePoulsRaw()
{
	u16 rawData =  MYADCIP_mReadReg(ADCIP_BASEADRESS, 0x0) & 0xFFF;
	return rawData;
}


float s4i_GetPoulsVoltage()
{
	float conversionFactor = ReferenceVoltage / ((1 << POULS_NUM_BITS) - 1);

	u16 rawSample = s4i_getSamplePoulsRaw();

	float PoulsVoltage = ((float)rawSample) * conversionFactor;

	return PoulsVoltage;

}

u16 s4i_getSamplePressionRaw()
{
	u16 rawData =  (MYADCIP_mReadReg(ADCIP_BASEADRESS, 0x0) & 0xFFF000) >> 12;
	return rawData;
}


float s4i_GetPressionVoltage()
{
	float conversionFactor = ReferenceVoltage / ((1 << PRESSION_NUM_BITS) - 1);

	u16 rawSample = s4i_getSamplePressionRaw();

	float PressionVoltage = ((float)rawSample) * conversionFactor;

	return PressionVoltage;

}

