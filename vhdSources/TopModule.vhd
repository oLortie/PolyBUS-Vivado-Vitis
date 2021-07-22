----------------------------------------------------------------------------------
-- Exercice1 Atelier #3 S4 G�nie informatique - H21
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
            i_data_certitude : in STD_LOGIC_VECTOR ( 7 downto 0 );
            i_data_compteur : in STD_LOGIC_VECTOR ( 7 downto 0 );
            i_data_mensonge : in STD_LOGIC;
            o_perspiration_select : out STD_LOGIC;
            o_respiration_select : out STD_LOGIC
            );
    end component;

    component Ctrl_DAC
    Port (
        reset                       : in    std_logic;  
        clk_DAC                     : in    std_logic; 						-- Horloge � fournir � l'ADC
        i_data1                     : in    std_logic_vector (11 downto 0); -- �chantillon � envoyer 
        i_data2                     : in    std_logic_vector (11 downto 0); -- �chantillon � envoyer       
        i_DAC_Strobe                : in    std_logic;                      -- Synchronisation: strobe d�clencheur de la s�quence de r�ception
        
        o_DAC_nCS                   : out   std_logic;                      -- Signal Chip select vers le DAC  
        o_bit_value1                : out   std_logic;                      -- valeur du bit � envoyer
        o_bit_value2                : out   std_logic                       -- valeur du bit � envoyer
        );
    end component;
    
    component Ctrl_AD1
    port ( 
        reset                       : in    std_logic;  
        clk_ADC                     : in    std_logic; 						-- Horloge � fournir � l'ADC
        i_DO1                       : in    std_logic;                      -- Bit de donn�e en provenance de l'ADC   
        i_DO2                       : in    std_logic;                      -- Bit de donn�e en provenance de l'ADC      
        o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
        
        i_ADC_Strobe                : in    std_logic;                      -- Synchronisation: strobe d�clencheur de la s�quence de r�ception    
        o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une r�ception compl�te d'un �chantillon  
        o_echantillon1              : out   std_logic_vector (11 downto 0); -- valeur de l'�chantillon re�u
        o_echantillon2              : out   std_logic_vector (11 downto 0)  -- valeur de l'�chantillon re�u
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
    
    component Calcul_pression is
    Port ( 
           i_strobe : in std_logic;
           i_signal : in STD_LOGIC_VECTOR (11 downto 0);
           i_clk : in STD_LOGIC;
           o_pression_sanguine : out STD_LOGIC_VECTOR (11 downto 0);
           o_enable : out STD_LOGIC;
           i_reset : in STD_LOGIC);
    end component;
    
    component CompteurMensonge is
    generic (threshold : std_logic_vector(7 downto 0) := "01111111");
        Port ( i_pourcentage_confiance  : in STD_LOGIC_VECTOR (7 downto 0);
               i_clk                    : in STD_LOGIC;
               i_reset                  : in STD_LOGIC;
               i_en                     : in STD_LOGIC;
               o_count_mensonge         : out STD_LOGIC_VECTOR(7 downto 0));
    end component;
    
    component affhexPmodSSD_v3 is
    generic (const_CLK_Hz: integer := 100_000_000);               -- horloge en Hz, typique 100 MHz 
        Port (   clk        : in   STD_LOGIC;                     -- horloge systeme, typique 100 MHz (preciser par le constante)
                 reset      : in   STD_LOGIC;
                 DA         : in   STD_LOGIC_VECTOR (7 downto 0); -- donnee a afficher sur 8 bits : chiffre hexa position 1 et 0     
                 i_aff_mem  : in   STD_LOGIC;                     -- demande memorisation affichage continu, si 0: continu
                 JPmod      : out  STD_LOGIC_VECTOR (7 downto 0)  -- sorties directement adaptees au connecteur PmodSSD
               );
    end component;
    
    component Synchro_Horloges is
    generic (const_CLK_syst_MHz: integer := freq_sys_MHz);
    Port ( 
        clkm        : in  std_logic;  -- Entr�e  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
        o_S_5MHz    : out std_logic;  -- source horloge divisee          (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
        o_CLK_5MHz  : out std_logic;
        o_S_100Hz   : out  std_logic; -- source horloge 100 Hz : out  std_logic;   -- (100  Hz approx:  99,952 Hz) 
        o_stb_100Hz : out  std_logic; -- strobe 100Hz synchro sur clk_5MHz 
        o_S_1Hz     : out  std_logic  -- Signal temoin 1 Hz
    );
    end component;
    
    component kcpsm6 is
    generic(               hwbuild : std_logic_vector(7 downto 0) := X"00";
                  interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
           scratch_pad_memory_size : integer := 64);
    port (                 address : out std_logic_vector(11 downto 0);
                       instruction : in std_logic_vector(17 downto 0);
                       bram_enable : out std_logic;
                           in_port : in std_logic_vector(7 downto 0);
                          out_port : out std_logic_vector(7 downto 0);
                           port_id : out std_logic_vector(7 downto 0);
                      write_strobe : out std_logic;
                    k_write_strobe : out std_logic;
                       read_strobe : out std_logic;
                         interrupt : in std_logic;
                     interrupt_ack : out std_logic;
                             sleep : in std_logic;
                             reset : in std_logic;
                               clk : in std_logic);
    end component;
    
    component CalculMensonge is
    generic(             C_FAMILY : string := "S6"; 
                C_RAM_SIZE_KWORDS : integer := 1;
             C_JTAG_LOADER_ENABLE : integer := 0);
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    rdl : out std_logic;                    
                    clk : in std_logic);
    end component;
    
    signal clk_5MHz                     : std_logic;
    signal d_S_5MHz                     : std_logic;
    signal clk_100Hz                    : std_logic := '0';
    signal d_strobe_100Hz               : std_logic := '0';  -- cadence echantillonnage AD1
    signal d_strobe_100Hz2              : std_logic := '0';
    signal d_strobe_100Hz_ADC           : std_logic := '0';
    signal d_strobe_100Hz_ADC2          : std_logic := '0';
    signal d_strobe_1Hz                 : std_logic := '0';
    
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
    signal d_param_mensonge             : std_logic_vector(7 downto 0);
    signal d_pression_ready             : std_logic;
    signal s_count_mensonge             : std_logic_vector(7 downto 0 );
    
    
    signal s_temp                       : std_logic_vector(7 downto 0);
    
    signal d_compteurRespiration025 : integer range 0 to 500 := 0;
    signal d_compteurRespiration05 : integer range 0 to 500 := 0;
    signal d_compteur100 : integer range 0 to 500 := 0;
    signal d_compteurPouls70 : integer range 0 to 500 := 0;
    signal d_compteurPouls85 : integer range 0 to 500 := 0;
    
    signal d_compteurDelaiStrobe : integer range 0 to 501 := 0;
    signal d_compteDelai : std_logic := '0';
    
    --
    -- Signals for connection of KCPSM6 and Program Memory.
    --
    
    signal         address : std_logic_vector(11 downto 0);
    signal     instruction : std_logic_vector(17 downto 0);
    signal     bram_enable : std_logic;
    signal         in_port : std_logic_vector(7 downto 0);
    signal        out_port : std_logic_vector(7 downto 0);
    signal         port_id : std_logic_vector(7 downto 0);
    signal    write_strobe : std_logic;
    signal  k_write_strobe : std_logic;
    signal     read_strobe : std_logic;
    signal       interrupt : std_logic;
    signal   interrupt_ack : std_logic;
    signal    kcpsm6_sleep : std_logic;
    signal    kcpsm6_reset : std_logic;

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
        i_DO1 => i_ADC_D0,                                      -- bit de donn�es provenant de l'ADC
        i_DO2 => i_ADC_D1,                                      -- bit de donn�es provenant de l'ADC
        o_ADC_nCS => o_ADC_NCS,                                 -- chip select pour le convertisseur (ADC)
        i_ADC_Strobe => d_strobe_100Hz_ADC,                     -- synchronisation: d�clencheur de la s�quence d'�chantillonnage
        o_echantillon_pret_strobe => o_echantillon_pret_strobe, -- strobe indicateur d'une r�ception compl�te d'un �chantillon
        o_echantillon1 => d_echantillon1,                       -- valeur de l'�chantillon re�u (12 bits)
        o_echantillon2 => d_echantillon2                        -- valeur de l'�chantillon re�u (12 bits)
    );
    
    inst_calcul_Pouls : Calcul_pouls
    port map (
        i_clk => clk_100Hz,
        i_reset => reset,
        i_en => o_echantillon_pret_strobe,
        i_ech => d_echantillon1,
        o_param => d_param_bpm
    );
    
    inst_calcul_respiration : Calcul_pouls
    port map(
    i_clk => clk_100Hz,
    i_reset => reset,
    i_en => d_strobe_100Hz, -- strobe disponible pour les signaux qui passent pas dans la boucle ?
    i_ech => d_echantillon3,
    o_param => d_param_respiration
    );
    
    --d_param_respiration <= "000100101100";
    
    inst_calcul_perspiration : Calcul_persp
    port map (
    i_clk => clk_100Hz,
    i_reset => reset,
    i_en => d_strobe_100Hz, -- strobe disponible pour les signaux qui passent pas dans la boucle ?
    i_ech => d_echantillon4,
    o_param => d_param_perspiration
    );
    
    inst_calcul_pression : Calcul_pression 
    Port map( 
           i_strobe => o_echantillon_pret_strobe,
           i_signal => d_echantillon2,
           i_clk => clk_5MHz,
           o_pression_sanguine => d_param_pression,
           o_enable => d_pression_ready,
           i_reset => reset
    );
    
    inst_compteur_mensonge : CompteurMensonge
    generic map (
        threshold => "00111100"
        )
    port map(
    i_pourcentage_confiance  => d_param_mensonge,
    i_clk                    => clk_5MHz,
    i_reset                  => reset,
    i_en                     => d_strobe_100Hz,
    o_count_mensonge         => s_count_mensonge 
    );
    --s_count_mensonge <= "00001111";
    
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
           o_S_100Hz    => clk_100Hz,
           o_stb_100Hz  => d_strobe_100Hz,
           o_S_1Hz      => d_strobe_1Hz
    );
    
    o_DAC_CLK <= clk_5MHz;
    o_ledtemoin_b <= d_strobe_1Hz;
    
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
            i_data_bpm => d_param_bpm,
            i_data_respiration => d_param_respiration,
            i_data_perspiration => d_param_perspiration,
            i_data_pression => d_param_pression,
            i_data_certitude => d_param_mensonge,
            i_data_compteur => s_count_mensonge,
            i_data_mensonge => '0',
            o_respiration_select => d_respiration_select,
            o_perspiration_select => d_perspiration_select
        );
        
    processor: kcpsm6
    generic map (                 
        hwbuild => X"00", 
        interrupt_vector => X"3FF",
        scratch_pad_memory_size => 64) -- other options are 128, 256
    port map(      
                   address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => sys_clock
           );
           
    kcpsm6_sleep <= '0';
    interrupt <= interrupt_ack;
    
    program_rom: CalculMensonge                     --Name to match your PSM file
    generic map(             
            C_FAMILY => "7S",                       --Family 'S6', 'V6' or '7S'
            C_RAM_SIZE_KWORDS => 2,                 --Program size '1', '2' or '4'
            C_JTAG_LOADER_ENABLE => 0               --Include JTAG Loader when set to '1' 
               )      
    port map(      
               address => address,      
           instruction => instruction,
                enable => bram_enable,
                   rdl => kcpsm6_reset,
                   clk => sys_clock
              );
              
    --========================================================
    -- INPUT PORTS
    --========================================================
    input_ports: process(sys_clock)
      begin
        if sys_clock'event and sys_clock = '1' then
    
          case port_id(2 downto 0) is
            when "000" =>    in_port <= d_param_bpm(7 downto 0);
            when "001" =>    in_port <= d_param_respiration(7 downto 0);
            when "010" =>    in_port <= "0000" & d_param_respiration(11 downto 8);
            when "011" =>    in_port <= d_param_perspiration(7 downto 0);
            when "100" =>    in_port <= "00000000";
            when "101" =>    in_port <= "00000000";
       
            when others =>    in_port <= "XXXXXXXX";  
    
          end case;
    
        end if;
    
      end process input_ports;
      
    output_ports: process(sys_clock)
    begin  
      if sys_clock'event and sys_clock = '1' then
        -- 'write_strobe' is used to qualify all writes to general output ports.
        if write_strobe = '1' then
          if port_id = "00000110" then -- port 06
            d_param_mensonge <= out_port(7 downto 0);
          end if;
        end if;
      end if; 
  
    end process output_ports;      
        
    main_process : process (clk_100Hz)
    begin
        if rising_edge(clk_100Hz) then
            case i_sw(0) is
                when '0' =>
                    d_DAC_data1 <= mem_pouls70(d_compteurPouls70);
                when '1' =>
                    d_DAC_data1 <= mem_pouls85(d_compteurPouls85);
                when others =>
                    d_DAC_data1 <= mem_pouls70(d_compteurPouls70);
            end case;
            
            case i_sw(1) is
                when '0' =>
                    d_DAC_data2 <= mem_pre12080(d_compteur100);
                when '1' =>
                    d_DAC_data2 <= mem_pre13080(d_compteur100);
                when others =>
                    d_DAC_data2 <= mem_pre12080(d_compteur100);
            end case;
            
            case d_respiration_select is
            --case i_sw(2) is
                when '0' =>
                    d_echantillon3 <= mem_respi025Hz(d_compteurRespiration025);
                when '1' =>
                    d_echantillon3 <= mem_respi05Hz(d_compteurRespiration05);
                when others =>
                    d_echantillon3 <= mem_respi025Hz(d_compteurRespiration025);
            end case;
            
            case d_perspiration_select is
            --case i_sw(3) is
                when '0' =>
                    d_echantillon4 <= mem_persp1(d_compteur100);
                when '1' =>
                    d_echantillon4 <= mem_persp2(d_compteur100);
                when others =>
                    d_echantillon4 <= mem_persp2(d_compteur100);
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

