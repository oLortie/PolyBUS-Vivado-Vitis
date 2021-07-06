/*
 * s4i_tools.h
 *
 *  Created on: 21 févr. 2020
 *      Author: francoisferland
 */

#ifndef SRC_S4I_TOOLS_H_
#define SRC_S4I_TOOLS_H_

#include <xgpio.h>

#define S4I_NUM_SWITCHES	4

void			s4i_init_hw();
int             s4i_is_cmd_respiration(char *buf);
int             s4i_is_cmd_perspiration(char* buf);
int             s4i_is_cmd_pouls(char *buf);
int             s4i_is_cmd_pression(char *buf);
int             s4i_is_cmd_rawData(char* buf);
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

#endif /* SRC_S4I_TOOLS_H_ */
