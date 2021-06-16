/*
 * RegisterDefines.h
 *
 *  Created on: 1 juin 2021
 *      Author: olivier lortie
 */

volatile u32* MyADCIPRegister = (volatile u32*) XPAR_MYADCIP_0_S00_AXI_BASEADDR;

//#define MY_AD1_IP_BASEADDRESS XPAR_MYADCIP_0_S00_AXI_BASEADDR
//#define ADCIP_BASEADRESS XPAR_MYADCIP_0_S00_AXI_BASEADDR
//#define REGISTER2_ADDRESS 0x43C00020

#define RESPIRATION_NUM_BITS 	12

#define PERSPIRATION_NUM_BITS 	12

#define POULS_NUM_BITS 	12

#define PRESSION_NUM_BITS 	12
