----------------------------------------------------------------------------------
-- Exercice1 Atelier #3 S4 Gï¿½nie informatique - H21
-- Larissa Njejimana
-- v.3 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

use work.PolyBUS_package.all;

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
    o_ADC_CLK       : out std_logic;
    
    -- Pmod_DAC - port_JD haut
    o_DAC_NCS       : out std_logic;  
    o_DAC_D0        : out std_logic;
    o_DAC_D1        : out std_logic;
    o_DAC_CLK       : out std_logic
);
end TopModule;

architecture Behavioral of TopModule is

    constant freq_sys_MHz: integer := 125;  -- MHz

    component PolyBUSBlockDesign_wrapper is
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
            Pmod_OLED_pin10_io : inout STD_LOGIC;
            Pmod_OLED_pin1_io : inout STD_LOGIC;
            Pmod_OLED_pin2_io : inout STD_LOGIC;
            Pmod_OLED_pin3_io : inout STD_LOGIC;
            Pmod_OLED_pin4_io : inout STD_LOGIC;
            Pmod_OLED_pin7_io : inout STD_LOGIC;
            Pmod_OLED_pin8_io : inout STD_LOGIC;
            Pmod_OLED_pin9_io : inout STD_LOGIC;
            i_data_bpm : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_data_perspiration : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_data_respiration : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_data_pression    : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_echantillon1 : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_echantillon2 : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_echantillon3 : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_echantillon4 : in STD_LOGIC_VECTOR ( 11 downto 0 );
            o_leds_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
            o_perspiration_select : out STD_LOGIC;
            o_respiration_select : out STD_LOGIC
            );
    end component;

    component Ctrl_DAC
    Port (
        reset                       : in    std_logic;  
        clk_DAC                     : in    std_logic; 						-- Horloge ï¿½ fournir ï¿½ l'ADC
        i_data1                     : in    std_logic_vector (11 downto 0); -- ï¿½chantillon ï¿½ envoyer 
        i_data2                     : in    std_logic_vector (11 downto 0); -- ï¿½chantillon ï¿½ envoyer       
        i_DAC_Strobe                : in    std_logic;                      -- Synchronisation: strobe dï¿½clencheur de la sï¿½quence de rï¿½ception
        
        o_DAC_nCS                   : out   std_logic;                      -- Signal Chip select vers le DAC  
        o_bit_value1                : out   std_logic;                      -- valeur du bit ï¿½ envoyer
        o_bit_value2                : out   std_logic                       -- valeur du bit ï¿½ envoyer
        );
    end component;
    
    component Ctrl_AD1
    port ( 
        reset                       : in    std_logic;  
        clk_ADC                     : in    std_logic; 						-- Horloge ï¿½ fournir ï¿½ l'ADC
        i_DO1                       : in    std_logic;                      -- Bit de donnï¿½e en provenance de l'ADC   
        i_DO2                       : in    std_logic;                      -- Bit de donnï¿½e en provenance de l'ADC      
        o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
        
        i_ADC_Strobe                : in    std_logic;                      -- Synchronisation: strobe dï¿½clencheur de la sï¿½quence de rï¿½ception    
        o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une rï¿½ception complï¿½te d'un ï¿½chantillon  
        o_echantillon1              : out   std_logic_vector (11 downto 0); -- valeur de l'ï¿½chantillon reï¿½u
        o_echantillon2              : out   std_logic_vector (11 downto 0)  -- valeur de l'ï¿½chantillon reï¿½u
    );
    end component;
    
    component FctBin2Thermo is
    Port ( i_echantillon : in STD_LOGIC_VECTOR (11 downto 0);
           o_thermo : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
   
    
    component Calcul_pouls is
    Port ( i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_en : in STD_LOGIC;
           i_ech : in STD_LOGIC_VECTOR (11 downto 0);
           o_param : out STD_LOGIC_VECTOR (11 downto 0));
    end component;
     
    component Calcul_persp is 
    port( 
    i_clk : in STD_LOGIC;
    i_reset : in STD_LOGIC;
    i_en : in STD_LOGIC;
    i_ech : in STD_LOGIC_VECTOR (11 downto 0);
    o_param : out STD_LOGIC_VECTOR (11 downto 0));
    
    end component;
    
    component Synchro_Horloges is
    generic (const_CLK_syst_MHz: integer := freq_sys_MHz);
    Port ( 
        clkm        : in  std_logic;  -- Entrï¿½e  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
        o_S_5MHz    : out std_logic;  -- source horloge divisee          (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
        o_CLK_5MHz  : out std_logic;
        o_S_100Hz   : out  std_logic; -- source horloge 100 Hz : out  std_logic;   -- (100  Hz approx:  99,952 Hz) 
        o_stb_100Hz : out  std_logic; -- strobe 100Hz synchro sur clk_5MHz 
        o_S_1Hz     : out  std_logic  -- Signal temoin 1 Hz
    );
    end component;
    
    component Pblaze_uCtrler is
    port (
        clk                     : in std_logic;
        i_ADC_echantillon       : in std_logic_vector (11 downto 0); 
        i_ADC_echantillon_pret  : in std_logic;
        o_compteur              : out std_logic_vector(3 downto 0);
        o_echantillon_out       : out std_logic_vector(7 downto 0)
    );
    end component;
    
    component affhexPmodSSD_v3 is
    generic (const_CLK_Hz: integer := 5_000_000);               -- horloge en Hz, typique 100 MHz 
    Port (   clk        : in   STD_LOGIC;                     -- horloge systeme, typique 100 MHz (preciser par le constante)
             reset      : in   STD_LOGIC;
             DA         : in   STD_LOGIC_VECTOR (7 downto 0); -- donnee a afficher sur 8 bits : chiffre hexa position 1 et 0     
             i_aff_mem  : in   STD_LOGIC;                     -- demande memorisation affichage continu, si 0: continu
             JPmod      : out  STD_LOGIC_VECTOR (7 downto 0)  -- sorties directement adaptees au connecteur PmodSSD
           );
    end component;
    
    component CompteurMensonge is 
    generic (threshold : std_logic_vector(7 downto 0) := "01111111");
    Port ( i_pourcentage_confiance  : in STD_LOGIC_VECTOR (7 downto 0);
           i_clk                    : in STD_LOGIC;
           i_reset                  : in STD_LOGIC;
           i_en                     : in STD_LOGIC;
           o_count_mensonge         : out STD_LOGIC_VECTOR(7 downto 0));
    end component;
    
    signal clk_5MHz                     : std_logic;
    signal d_S_5MHz                     : std_logic;
    signal d_strobe_100Hz               : std_logic := '0';  -- cadence echantillonnage AD1
    signal d_strobe_100Hz2              : std_logic := '0';
    signal d_strobe_100Hz_ADC           : std_logic := '0';
    signal d_strobe_100Hz_ADC2          : std_logic := '0';
    
    signal reset                        : std_logic; 
    
    signal o_echantillon_pret_strobe    : std_logic;
    signal d_ADC_Dselect                : std_logic;
    signal d_DAC_data1                  : std_logic_vector (11 downto 0);
    signal d_DAC_data2                  : std_logic_vector (11 downto 0);
    signal d_echantillon1               : std_logic_vector (11 downto 0);
    signal d_echantillon2               : std_logic_vector (11 downto 0); 
    signal d_echantillon3               : std_logic_vector (11 downto 0); 
    signal d_echantillon4               : std_logic_vector (11 downto 0);  
    signal d_param_bpm                  : std_logic_vector(11 downto 0);
    signal d_param_respiration          : std_logic_vector(11 downto 0);
    signal d_param_perspiration         : std_logic_vector(11 downto 0);
    signal d_param_pression             : std_logic_vector(11 downto 0);
    signal d_respiration_select         : std_logic;
    signal d_perspiration_select        : std_logic;
    signal s_count_mensonge             : std_logic_vector(7 downto 0 );
    
    
    signal s_temp                       : std_logic_vector(7 downto 0);
    
    signal d_compteurRespiration025 : integer range 0 to 500 := 0;
    signal d_compteurRespiration05 : integer range 0 to 500 := 0;
    signal d_compteur100 : integer range 0 to 500 := 0;
    signal d_compteurPouls70 : integer range 0 to 500 := 0;
    signal d_compteurPouls85 : integer range 0 to 500 := 0;
    
    signal d_compteurDelaiStrobe : integer range 0 to 501 := 0;
    signal d_compteDelai : std_logic := '0';

begin
    reset    <= i_btn(0);    
    
    inst_Ctrl_DAC1 : Ctrl_DAC
    Port Map (
        reset => reset,  
        clk_DAC => clk_5MHz,
        i_data1 => d_DAC_data1,
        i_data2 => d_DAC_data2,      
        i_DAC_Strobe => d_strobe_100Hz,
        o_DAC_nCS => o_DAC_NCS,
        o_bit_value1 => o_DAC_D0,
        o_bit_value2 => o_DAC_D1
        );
    
    inst_Ctrl_ADC1 : Ctrl_AD1
    port Map ( 
        reset => reset,
        clk_ADC => clk_5MHz,                                    -- pour horloge externe de l'ADC
        i_DO1 => i_ADC_D0,                                      -- bit de données provenant de l'ADC
        i_DO2 => i_ADC_D1,                                      -- bit de données provenant de l'ADC
        o_ADC_nCS => o_ADC_NCS,                                 -- chip select pour le convertisseur (ADC)
        i_ADC_Strobe => d_strobe_100Hz_ADC,                     -- synchronisation: déclencheur de la séquence d'échantillonnage
        o_echantillon_pret_strobe => o_echantillon_pret_strobe, -- strobe indicateur d'une réception complète d'un échantillon
        o_echantillon1 => d_echantillon1,                       -- valeur de l'échantillon reçu (12 bits)
        o_echantillon2 => d_echantillon2                        -- valeur de l'échantillon reçu (12 bits)
    );
    
    inst_calcul_Pouls : Calcul_pouls
    port map (
        i_clk => clk_5MHz,
        i_reset => reset,
        i_en => d_strobe_100Hz,
        i_ech => d_echantillon1,
        o_param => d_param_bpm
    );
    
    inst_calcul_respiration : Calcul_pouls
    port map(
    i_clk => clk_5MHz,
    i_reset => reset,
    i_en => d_strobe_100Hz, -- strobe disponible pour les signaux qui passent pas dans la boucle ?
    i_ech => d_echantillon3,
    o_param => d_param_respiration
    );
    
    inst_calcul_perspiration : Calcul_persp
    port map (
    i_clk => clk_5MHz,
    i_reset => reset,
    i_en => d_strobe_100Hz, -- strobe disponible pour les signaux qui passent pas dans la boucle ?
    i_ech => d_echantillon4,
    o_param => d_param_perspiration
    );
    
    inst_compteur_mensonge : CompteurMensonge
    port map(
    i_pourcentage_confiance  => d_echantillon3(11 downto 4),
    i_clk                    => clk_5MHz,
    i_reset                  => reset,
    i_en                     => o_echantillon_pret_strobe,
    o_count_mensonge         => s_count_mensonge 
    );
    
    inst_afficheur_7_seg :  affhexPmodSSD_v3
    port map(
        clk        =>  clk_5MHz,                    -- horloge systeme, dans notre cas c'est 5 MHZ
        reset      =>   reset,
        DA         => s_count_mensonge,         -- donnee a afficher sur 8 bits : chiffre hexa position 1 et 0     
        i_aff_mem  => '0',                     -- demande memorisation affichage continu, si 0: continu
        JPmod      => s_temp
    );
    
    bin2Thermo : FctBin2Thermo
    Port Map (
        i_echantillon => d_echantillon1,
        o_thermo => Pmod_8LD
    );
    
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
    
    Picoblaze : Pblaze_uCtrler
    port map(
          clk                       =>  clk_5MHz,          
          i_ADC_echantillon         => d_echantillon1,
          i_ADC_echantillon_pret    => o_echantillon_pret_strobe, 
          o_compteur                =>  open, --o_leds,    
          o_echantillon_out         =>  open --Pmod_8LD    
    );
    
    o_DAC_CLK <= clk_5MHz;
    
    BlockDesign : PolyBUSBlockDesign_wrapper
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
            Pmod_OLED_pin1_io => Pmod_OLED(0),  --a changer apres le test
            Pmod_OLED_pin2_io => Pmod_OLED(1),
            Pmod_OLED_pin3_io => Pmod_OLED(2),
            Pmod_OLED_pin4_io => Pmod_OLED(3),
            Pmod_OLED_pin7_io => Pmod_OLED(4),
            Pmod_OLED_pin8_io => Pmod_OLED(5),
            Pmod_OLED_pin9_io => Pmod_OLED(6),
            Pmod_OLED_pin10_io => Pmod_OLED(7),
            i_echantillon1 => d_echantillon1,
            i_echantillon2 => d_echantillon2,
            i_echantillon3 => d_echantillon3,
            i_echantillon4 => d_echantillon4,
            i_data_bpm => std_logic_vector(d_param_bpm),
            i_data_respiration => std_logic_vector(d_param_respiration),
            i_data_perspiration => d_param_perspiration,
            i_data_pression     => d_param_pression,
            o_leds_tri_o => o_leds,
            o_respiration_select => d_respiration_select,
            o_perspiration_select => d_perspiration_select
        );
        
    main_process : process (d_strobe_100Hz)
    begin
        if rising_edge(d_strobe_100Hz) then
            case i_sw(0) is
                when '0' =>
                    d_DAC_data1 <= mem_pouls70(d_compteurPouls70);
                when '1' =>
                    d_DAC_data1 <= mem_pouls85(d_compteurPouls85);
                when others =>
                    d_DAC_data1 <= "000000000000";
            end case;
            
            case i_sw(1) is
                when '0' =>
                    d_DAC_data2 <= mem_pre12080(d_compteur100);
                when '1' =>
                    d_DAC_data2 <= mem_pre13080(d_compteur100);
                when others =>
                    d_DAC_data2 <= "000000000000";
            end case;
            
            --case d_respiration_select is
            case i_sw(2) is
                when '0' =>
                    d_echantillon3 <= mem_respi025Hz(d_compteurRespiration025);
                when '1' =>
                    d_echantillon3 <= mem_respi05Hz(d_compteurRespiration05);
                when others =>
                    d_echantillon3 <= "000000000000";
            end case;
            
            --case d_perspiration_select is
            case i_sw(3) is
                when '0' =>
                    d_echantillon4 <= mem_persp1(d_compteur100);
                when '1' =>
                    d_echantillon4 <= mem_persp2(d_compteur100);
                when others =>
                    d_echantillon4 <= "000000000000";
            end case;
       
            
            if d_compteurPouls70 = mem_pouls70'length-1 then
                d_compteurPouls70 <= 0;
            else
                d_compteurPouls70 <= d_compteurPouls70 + 1;
            end if;
            
            if d_compteurPouls85 = mem_pouls85'length-1 then
                d_compteurPouls85 <= 0;
            else
                d_compteurPouls85 <= d_compteurPouls85 + 1;
            end if;
            
            if d_compteur100 = 99 then
                d_compteur100 <= 0;
            else
                d_compteur100 <= d_compteur100 + 1;
            end if;
            
            if d_compteurRespiration025 = mem_respi025Hz'length-1 then
                d_compteurRespiration025 <= 0;
            else
                d_compteurRespiration025 <= d_compteurRespiration025 + 1;
            end if;
            
            if d_compteurRespiration05 = mem_respi05Hz'length-1 then
                d_compteurRespiration05 <= 0;
            else
                d_compteurRespiration05 <= d_compteurRespiration05 + 1;
            end if;
        end if;
    end process;
    
    DAC_ADC_Strobe : process (d_strobe_100Hz, clk_5MHz)
    begin
        if rising_edge(clk_5MHz) then
            if (d_strobe_100Hz = '1') then
                d_compteDelai <= '1';
            end if;
            if (d_compteDelai = '1') then
                if (d_compteurDelaiStrobe = 500) then
                    d_compteDelai <= '0';
                    d_compteurDelaiStrobe <= 0;
                    d_strobe_100Hz_ADC <= '1';
                else
                    d_compteurDelaiStrobe <= d_compteurDelaiStrobe + 1;
                    d_strobe_100Hz_ADC <= '0';
                end if;
            else
                d_strobe_100Hz_ADC <= '0';
            end if;
        end if;
    end process;
      
end Behavioral;

