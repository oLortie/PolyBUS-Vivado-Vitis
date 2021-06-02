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

entity TopModule is
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
end TopModule;

architecture Behavioral of TopModule is

    constant freq_sys_MHz: integer := 125;  -- MHz
    
    type table_forme is array (integer range 0 to 199) of std_logic_vector(11 downto 0);
    constant mem_forme_onde : table_forme := (
 -- forme d'une onde carrée
 -- chaque cycle a 48 echantillons
    x"800",
x"83F",
x"87F",
x"8BE",
x"8FE",
x"93D",
x"97B",
x"9BA",
x"9F8",
x"A35",
x"A72",
x"AAE",
x"AEA",
x"B25",
x"B5F",
x"B98",
x"BD0",
x"C08",
x"C3E",
x"C73",
x"CA7",
x"CDA",
x"D0C",
x"D3C",
x"D6B",
x"D99",
x"DC5",
x"DF0",
x"E1A",
x"E42",
x"E68",
x"E8C",
x"EAF",
x"ED1",
x"EF0",
x"F0E",
x"F2A",
x"F44",
x"F5D",
x"F73",
x"F88",
x"F9B",
x"FAB",
x"FBA",
x"FC7",
x"FD2",
x"FDB",
x"FE2",
x"FE7",
x"FEA",
x"FEB",
x"FEA",
x"FE7",
x"FE2",
x"FDB",
x"FD2",
x"FC7",
x"FBA",
x"FAB",
x"F9B",
x"F88",
x"F73",
x"F5D",
x"F44",
x"F2A",
x"F0E",
x"EF0",
x"ED1",
x"EAF",
x"E8C",
x"E68",
x"E42",
x"E1A",
x"DF0",
x"DC5",
x"D99",
x"D6B",
x"D3C",
x"D0C",
x"CDA",
x"CA7",
x"C73",
x"C3E",
x"C08",
x"BD0",
x"B98",
x"B5F",
x"B25",
x"AEA",
x"AAE",
x"A72",
x"A35",
x"9F8",
x"9BA",
x"97B",
x"93D",
x"8FE",
x"8BE",
x"87F",
x"83F",
x"800",
x"7C0",
x"780",
x"741",
x"701",
x"6C2",
x"684",
x"645",
x"607",
x"5CA",
x"58D",
x"551",
x"515",
x"4DA",
x"4A0",
x"467",
x"42F",
x"3F7",
x"3C1",
x"38C",
x"358",
x"325",
x"2F3",
x"2C3",
x"294",
x"266",
x"23A",
x"20F",
x"1E5",
x"1BD",
x"197",
x"173",
x"150",
x"12E",
x"10F",
x"0F1",
x"0D5",
x"0BB",
x"0A2",
x"08C",
x"077",
x"064",
x"054",
x"045",
x"038",
x"02D",
x"024",
x"01D",
x"018",
x"015",
x"014",
x"015",
x"018",
x"01D",
x"024",
x"02D",
x"038",
x"045",
x"054",
x"064",
x"077",
x"08C",
x"0A2",
x"0BB",
x"0D5",
x"0F1",
x"10F",
x"12E",
x"150",
x"173",
x"197",
x"1BD",
x"1E5",
x"20F",
x"23A",
x"266",
x"294",
x"2C3",
x"2F3",
x"325",
x"358",
x"38C",
x"3C1",
x"3F7",
x"42F",
x"467",
x"4A0",
x"4DA",
x"515",
x"551",
x"58D",
x"5CA",
x"607",
x"645",
x"684",
x"6C2",
x"701",
x"741",
x"780",
x"7C0"
    );
    
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
            i_data_echantillon1 : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_data_echantillon2 : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_data_echantillon3 : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_data_echantillon4 : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_sw_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
            o_data_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
            o_leds_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 )
            );
    end component;

   
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
    signal d_echantillon1               : std_logic_vector (11 downto 0);
    signal d_echantillon2               : std_logic_vector (11 downto 0); 
    signal d_echantillon3               : std_logic_vector (11 downto 0); 
    signal d_echantillon4               : std_logic_vector (11 downto 0);  
    
    signal d_compteur : integer range 0 to 200 := 0;

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
            i_data_echantillon1 => d_echantillon1,
            i_data_echantillon2 => d_echantillon2,
            i_data_echantillon3 => d_echantillon3,
            i_data_echantillon4 => d_echantillon4,
            i_sw_tri_i => i_sw,
            o_data_out => open,
            o_leds_tri_o => o_leds
        );
        
    main_process : process (d_strobe_100Hz)
    begin
        if rising_edge(d_strobe_100Hz) then
            d_echantillon1 <= mem_forme_onde(d_compteur);
            
            if d_compteur = mem_forme_onde'length-1 then
                d_compteur <= 0;
            else
                d_compteur <= d_compteur + 1;
            end if;
        end if;
    end process;
      
end Behavioral;

