----------------------------------------------------------------------------------
-- Exercice1 Atelier #3 S4 Génie informatique - H21
-- Larissa Njejimana
-- v.3 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity Top is
port (
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC; 

    sys_clock       : in std_logic;
    o_leds          : out std_logic_vector ( 3 downto 0 );
    i_sw            : in std_logic_vector ( 3 downto 0 );
    i_btn           : in std_logic_vector ( 3 downto 0 );
    o_ledtemoin_b   : out std_logic;
    
    Pmod_8LD        : inout std_logic_vector ( 7 downto 0 );  -- port JD
    Pmod_OLED       : inout std_logic_vector ( 7 downto 0 );  -- port_JE
    
    -- Pmod_AD1 - port_JC haut
    o_ADC_NCS       : out std_logic;  
    i_ADC_D0        : in std_logic;
    i_ADC_D1        : in std_logic;
    o_ADC_CLK       : out std_logic
);
end Top;

architecture Behavioral of Top is

    constant freq_sys_MHz: integer := 125;  -- MHz
    
    component LectureADC_wrapper is
        port (
            DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
            DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
            DDR_cas_n : inout STD_LOGIC;
            DDR_ck_n : inout STD_LOGIC;
            DDR_ck_p : inout STD_LOGIC;
            DDR_cke : inout STD_LOGIC;
            DDR_cs_n : inout STD_LOGIC;
            DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
            DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
            DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
            DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
            DDR_odt : inout STD_LOGIC;
            DDR_ras_n : inout STD_LOGIC;
            DDR_reset_n : inout STD_LOGIC;
            DDR_we_n : inout STD_LOGIC;
            FIXED_IO_ddr_vrn : inout STD_LOGIC;
            FIXED_IO_ddr_vrp : inout STD_LOGIC;
            FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
            FIXED_IO_ps_clk : inout STD_LOGIC;
            FIXED_IO_ps_porb : inout STD_LOGIC;
            FIXED_IO_ps_srstb : inout STD_LOGIC;
            Pmod_8LD_pin10_io : inout STD_LOGIC;
            Pmod_8LD_pin1_io : inout STD_LOGIC;
            Pmod_8LD_pin2_io : inout STD_LOGIC;
            Pmod_8LD_pin3_io : inout STD_LOGIC;
            Pmod_8LD_pin4_io : inout STD_LOGIC;
            Pmod_8LD_pin7_io : inout STD_LOGIC;
            Pmod_8LD_pin8_io : inout STD_LOGIC;
            Pmod_8LD_pin9_io : inout STD_LOGIC;
            Pmod_OLED_pin10_io : inout STD_LOGIC;
            Pmod_OLED_pin1_io : inout STD_LOGIC;
            Pmod_OLED_pin2_io : inout STD_LOGIC;
            Pmod_OLED_pin3_io : inout STD_LOGIC;
            Pmod_OLED_pin4_io : inout STD_LOGIC;
            Pmod_OLED_pin7_io : inout STD_LOGIC;
            Pmod_OLED_pin8_io : inout STD_LOGIC;
            Pmod_OLED_pin9_io : inout STD_LOGIC;
            i_data_echantillon : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_sw_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
            o_data_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
            o_leds_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 )
            );
    end component;

    component Ctrl_AD1 is
    port ( 
        reset                       : in    std_logic;  
        
        clk_ADC                     : in    std_logic;                      -- Horloge fourni à l'ADC
        i_DO                        : in    std_logic;                      -- Bit de donnée en provenance de l'ADC           
        o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
        
        i_ADC_Strobe                : in    std_logic;                      -- synchronisation: déclencheur de la séquence d'échantillonnage  
        o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une réception complète d'un échantillon  
        o_echantillon               : out   std_logic_vector (11 downto 0)  -- valeur de l'échantillon reçu
    );
    end  component;
   
    component Synchro_Horloges is
    generic (const_CLK_syst_MHz: integer := freq_sys_MHz);
    Port ( 
        clkm        : in  std_logic;  -- Entrée  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
        o_S_5MHz    : out std_logic;  -- source horloge divisee          (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
        o_CLK_5MHz  : out std_logic;
        o_S_100Hz   : out  std_logic; -- source horloge 100 Hz : out  std_logic;   -- (100  Hz approx:  99,952 Hz) 
        o_stb_100Hz : out  std_logic; -- strobe 100Hz synchro sur clk_5MHz 
        o_S_1Hz     : out  std_logic  -- Signal temoin 1 Hz
    );
    end component;  
    
    signal clk_5MHz                     : std_logic;
    signal d_S_5MHz                     : std_logic;
    signal d_strobe_100Hz               : std_logic := '0';  -- cadence echantillonnage AD1
    
    signal reset                        : std_logic; 
    
    signal o_echantillon_pret_strobe    : std_logic;
    signal d_ADC_Dselect                : std_logic; 
    signal d_echantillon                : std_logic_vector (11 downto 0); 

begin
    reset    <= i_btn(0);    
        
     mux_select_Entree_AD1 : process (i_btn(3), i_ADC_D0, i_ADC_D1)
     begin
          if (i_btn(3) ='0') then 
            d_ADC_Dselect <= i_ADC_D0;
          else
            d_ADC_Dselect <= i_ADC_D1;
          end if;
     end process;
     
    Controleur :  Ctrl_AD1 
    port map(
        reset                       => reset,
        
        clk_ADC                     => clk_5MHz,                    -- pour horloge externe de l'ADC 
        i_DO                        => d_ADC_Dselect,               -- bit de données provenant de l'ADC (via um mux)       
        o_ADC_nCS                   => o_ADC_NCS,                   -- chip select pour le convertisseur (ADC )
        
        i_ADC_Strobe                => d_strobe_100Hz,              -- synchronisation: déclencheur de la séquence d'échantillonnage 
        o_echantillon_pret_strobe   => o_echantillon_pret_strobe,   -- strobe indicateur d'une réception complète d'un échantillon 
        o_echantillon               => d_echantillon                -- valeur de l'échantillon reçu (12 bits)
    );

      
   Synchronisation : Synchro_Horloges
    port map (
           clkm         =>  sys_clock,
           o_S_5MHz     =>  o_ADC_CLK,
           o_CLK_5MHz   => clk_5MHz,
           o_S_100Hz    => open,
           o_stb_100Hz  => d_strobe_100Hz,
           o_S_1Hz      => o_ledtemoin_b
    );
    
    BlockDesign : LectureADC_wrapper
        port map(
            DDR_addr => DDR_addr,
            DDR_ba => DDR_ba,
            DDR_cas_n => DDR_cas_n,
            DDR_ck_n => DDR_ck_n,
            DDR_ck_p => DDR_ck_p,
            DDR_cke => DDR_cke,
            DDR_cs_n => DDR_cs_n,
            DDR_dm => DDR_dm,
            DDR_dq => DDR_dq,
            DDR_dqs_n => DDR_dqs_n,
            DDR_dqs_p => DDR_dqs_p,
            DDR_odt => DDR_odt,
            DDR_ras_n => DDR_ras_n,
            DDR_reset_n => DDR_reset_n,
            DDR_we_n => DDR_we_n,
            FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
            FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
            FIXED_IO_mio =>FIXED_IO_mio ,
            FIXED_IO_ps_clk => FIXED_IO_ps_clk,
            FIXED_IO_ps_porb => FIXED_IO_ps_porb,
            FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
            Pmod_8LD_pin1_io => Pmod_8LD(0),
            Pmod_8LD_pin2_io => Pmod_8LD(1),
            Pmod_8LD_pin3_io => Pmod_8LD(2),
            Pmod_8LD_pin4_io => Pmod_8LD(3),
            Pmod_8LD_pin7_io => Pmod_8LD(4),
            Pmod_8LD_pin8_io => Pmod_8LD(5),
            Pmod_8LD_pin9_io => Pmod_8LD(6),
            Pmod_8LD_pin10_io => Pmod_8LD(7),
            Pmod_OLED_pin1_io => Pmod_OLED(0),
            Pmod_OLED_pin2_io => Pmod_OLED(1),
            Pmod_OLED_pin3_io => Pmod_OLED(2),
            Pmod_OLED_pin4_io => Pmod_OLED(3),
            Pmod_OLED_pin7_io => Pmod_OLED(4),
            Pmod_OLED_pin8_io => Pmod_OLED(5),
            Pmod_OLED_pin9_io => Pmod_OLED(6),
            Pmod_OLED_pin10_io => Pmod_OLED(7),
            i_data_echantillon => d_echantillon,
            i_sw_tri_i => i_sw,
            o_data_out => open,
            o_leds_tri_o => o_leds
        );
      
end Behavioral;

