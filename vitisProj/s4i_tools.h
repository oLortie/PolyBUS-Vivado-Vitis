/*
 * s4i_tools.h
 *
 *  Created on: 21 f�vr. 2020
 *      Author: francoisferland
 */

#ifndef SRC_S4I_TOOLS_H_
#define SRC_S4I_TOOLS_H_

#include <xil_types.h>

#define S4I_NUM_SWITCHES	4

typedef enum {
	respi025 = 0,
	respi05 = 1
} RespirationSelect;

typedef enum {
	level1 = 0,
	level2 = 1
} PerspirationSelect;

void			s4i_init_hw();
int             s4i_is_cmd_respiration(char *buf);
int             s4i_is_cmd_perspiration(char* buf);
int             s4i_is_cmd_pouls(char *buf);
int             s4i_is_cmd_pression(char *buf);
int             s4i_is_cmd_rawData(char* buf);
int 			s4i_is_cmd_respirationSelect(char* buf);
int             s4i_is_cmd_perspirationSelect(char* buf);
int				s4i_is_cmd_parameters(char*buf);
u16 s4i_getSampleRespirationRaw();
float s4i_GetRespirationVoltage();
u16 s4i_getSamplePerspirationRaw();
float s4i_GetPerspirationVoltage();
u16 s4i_getSamplePoulsRaw();
float s4i_GetPoulsVoltage();
u16 s4i_getSamplePressionRaw();
float s4i_GetPressionVoltage();
u16 s4i_getSampleBPM();
float s4i_GetBPM();
u16 s4i_getSampleFrequenceRespiration();
float s4i_GetFrequenceRespiration();
u16 s4i_getSampleAnalysePerspiration();
float s4i_GetAnalysePerspiration();
u16 s4i_getSamplePression();
float s4i_GetParametrePression();
u16 s4i_getCertitude();
u16 s4i_getCounter();


void s4i_setRespirationSelect(RespirationSelect select);
void s4i_setPerspirationSelect(PerspirationSelect select);


#endif /* SRC_S4I_TOOLS_H_ */
