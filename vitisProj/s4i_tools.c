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
	//XGpio_SetDataDirection(&s4i_xgpio_input_, 1, 0xF);
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

u16 s4i_getSampleRespirationRaw()
{
	u16 rawData = MyADCIPRegister[1] & 0xFFF;

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
	u16 rawData = (MyADCIPRegister[1] & 0xFFF000) >> 12;

	//u16 rawData =  (MYADCIP_mReadReg(REGISTER2_ADDRESS, 0x0) & 0xFFF000) >> 12;
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
	u16 rawData = MyADCIPRegister[0] & 0xFFF;

	//u16 rawData =  MYADCIP_mReadReg(ADCIP_BASEADRESS, 0x0) & 0xFFF;
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
	u16 rawData = (MyADCIPRegister[0] & 0xFFF000) >> 12;

	//u16 rawData =  (MYADCIP_mReadReg(ADCIP_BASEADRESS, 0x0) & 0xFFF000) >> 12;
	return rawData;
}


float s4i_GetPressionVoltage()
{
	float conversionFactor = ReferenceVoltage / ((1 << PRESSION_NUM_BITS) - 1);

	u16 rawSample = s4i_getSamplePressionRaw();

	float PressionVoltage = ((float)rawSample) * conversionFactor;

	return PressionVoltage;

}


u16 s4i_getSampleBPM()
{
	u16 rawData = MyADCIPRegister[2] & 0xFFF ;

	return rawData;
}


float s4i_GetBPM()
{
	u16 rawSample = s4i_getSampleBPM();
	float test = (60.0/((float)rawSample*0.01));
	return test;

}




