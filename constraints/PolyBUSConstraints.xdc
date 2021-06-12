
##Clock signal
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { sys_clock }]; #IO_L12P_T1_MRCC_35 Sch=sysclk
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { sys_clock }];

##Switches
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { i_sw[0] }]; 
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { i_sw[1] }]; 
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { i_sw[2] }]; 
set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { i_sw[3] }]; 

##LEDs
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { o_leds[0] }]; 
set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { o_leds[1] }]; 
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { o_leds[2] }]; 
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { o_leds[3] }]; 

set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { o_ledtemoin_b }]; 

##Buttons
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { i_btn[0] }]; 
set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { i_btn[1] }]; 
set_property -dict { PACKAGE_PIN K19   IOSTANDARD LVCMOS33 } [get_ports { i_btn[2] }]; 
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { i_btn[3] }]; 
    
##Pmod Header JC                                                                                                                  
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { o_ADC_NCS }]; 			 
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports { i_ADC_D0 }]; 	     
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { i_ADC_D1 }];           
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { o_ADC_CLK }];           

  
##Pmod Header JD                                                                                                                  
#set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[0] }];         
#set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[1] }]; 	 
#set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[2] }];         
#set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[3] }];         
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[4] }];         
#set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[5] }];         
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[6] }];         
#set_property -dict { PACKAGE_PIN V18   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[7] }];

##Pmod Header JD                                                                                                                  
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { o_DAC_NCS }];         
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { o_DAC_D0 }]; 	 
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { o_DAC_D1 }];         
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { o_DAC_CLK }];
   
##Pmod Header JE                                                                                                                  
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { Pmod_OLED[0] }]; 				 
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { Pmod_OLED[1] }];                
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { Pmod_OLED[2] }];                
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { Pmod_OLED[3] }];                
set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports { Pmod_OLED[4] }];                
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { Pmod_OLED[5] }];                
set_property -dict { PACKAGE_PIN T17   IOSTANDARD LVCMOS33 } [get_ports { Pmod_OLED[6] }];                
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { Pmod_OLED[7] }]; 

###Pmod Header JA                                                                                                 #  pmod8LD 
set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[0] }]; #IO_L21P_T3_DQS_AD14P_35 Sch=JA1_R_p		#  pmod haut   
set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[1] }]; #IO_L22P_T3_AD7P_35 Sch=JA2_R_P          #  pmod haut   
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[2] }]; #IO_L24P_T3_AD15P_35 Sch=JA3_R_P         #  pmod haut    
set_property -dict { PACKAGE_PIN K14   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[3] }]; #IO_L20P_T3_AD6P_35 Sch=JA4_R_P          #  pmod haut   
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[4] }]; #IO_L21N_T3_DQS_AD14N_35 Sch=JA1_R_N    #  pmod bas  
set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[5] }]; #IO_L22N_T3_AD7N_35 Sch=JA2_R_N         #  pmod bas  
set_property -dict { PACKAGE_PIN J16   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[6] }]; #IO_L24N_T3_AD15N_35 Sch=JA3_R_N        #  pmod bas
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { Pmod_8LD[7] }]; #IO_L20N_T3_AD6N_35 Sch=JA4_R_N         #  pmod bas

