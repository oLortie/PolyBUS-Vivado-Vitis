/*
 * s4i_tools.c
 *
 *  Created on: 21 fÃ©vr. 2020
 *      Author: francoisferland
 */

#include "s4i_tools.h"
#include "xparameters.h"
#include "PolyBUSip.h"
#include "Counterip.h"
#include "SingleValueip.h"
#include "RegisterDefines.h"

#include <xil_io.h>

const float ReferenceVoltage = 3.3;


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

int s4i_is_cmd_respirationSelect(char* buf)
{
	return (!strncmp(buf + 6, "cmd/respirationSelect", 21));
}

int s4i_is_cmd_perspirationSelect(char* buf)
{
	return (!strncmp(buf + 6, "cmd/perspirationSelect", 22));
}

int	s4i_is_cmd_parameters(char*buf)
{
	return (!strncmp(buf + 5, "cmd/parameters", 14));
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
	u32 rawData = SINGLEVALUEIP_mReadReg(XPAR_BPMIP_0_S00_AXI_BASEADDR, SINGLEVALUEIP_S00_AXI_SLV_REG0_OFFSET);

	return rawData & 0xFFF;
}


float s4i_GetBPM()
{
	u16 rawSample = s4i_getSampleBPM();
	double raw = ((double)rawSample);
	return 60.0/(((float)raw)*0.01);

}

void s4i_setRespirationSelect(RespirationSelect select)
{
	switch (select)
	{
		case respi025:
			MyADCIPRegister[5] &= 0xFFFFFFFE;
			break;
		case respi05:
			MyADCIPRegister[5] |= 0x00000001;
			break;
		default:
			break;
	}
}

void s4i_setPerspirationSelect(PerspirationSelect select) {
	switch (select)
	{
		case level1:
			MyADCIPRegister[5] &= 0xFFFFFFFD;
			break;
		case level2:
			MyADCIPRegister[5] |= 0x00000002;
			break;
		default:
			break;
	}
}

u16 s4i_getSampleFrequenceRespiration()
{
	u32 rawData = SINGLEVALUEIP_mReadReg(XPAR_RESPIRATIONIP_0_S00_AXI_BASEADDR, SINGLEVALUEIP_S00_AXI_SLV_REG0_OFFSET);

	return rawData & 0xFFF;
}



float s4i_GetFrequenceRespiration()
{
	u16 rawSample = s4i_getSampleFrequenceRespiration();
	double raw = 1.0/(((double)rawSample)*0.01);
	return (float)raw;

}

u16 s4i_getSampleAnalysePerspiration()
{
	u32 rawData = POLYBUSIP_mReadReg(XPAR_POLYBUSIP_0_S00_AXI_BASEADDR, POLYBUSIP_S00_AXI_SLV_REG2_OFFSET);

	return rawData & 0xFFF;
}


float s4i_GetAnalysePerspiration()
{
	float conversionFactor = ReferenceVoltage / ((1 << PERSPIRATION_NUM_BITS) - 1);

	u16 rawSample = s4i_getSampleAnalysePerspiration();

	float moyennePerspiration = ((float)rawSample) * conversionFactor;

	return moyennePerspiration;

}

u16 s4i_getSamplePression()
{
	u32 rawData = POLYBUSIP_mReadReg(XPAR_POLYBUSIP_0_S00_AXI_BASEADDR, POLYBUSIP_S00_AXI_SLV_REG2_OFFSET);

	return (rawData & 0xFFF000) >> 12;
}


float s4i_GetParametrePression()
{
	u16 rawSample = s4i_getSamplePression();
	double raw = ((double)rawSample);
	return (((float)raw));

}

u16 s4i_getCertitude() {
	u32 rawData = POLYBUSIP_mReadReg(XPAR_POLYBUSIP_0_S00_AXI_BASEADDR, POLYBUSIP_S00_AXI_SLV_REG0_OFFSET);

	return (rawData & 0xFF000000) >> 24;
}

u16 s4i_getCounter()
{
	u32 rawData = COUNTERIP_mReadReg(XPAR_COUNTERIP_0_S00_AXI_BASEADDR, COUNTERIP_S00_AXI_SLV_REG0_OFFSET);

	return (rawData & 0xFF000000) >> 24;
}



