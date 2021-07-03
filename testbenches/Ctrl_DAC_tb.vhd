----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/06/2021 08:59:23 PM
-- Design Name: 
-- Module Name: Ctrl_DAC_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Ctrl_DAC_tb is
--  Port ( );
end Ctrl_DAC_tb;

architecture Behavioral of Ctrl_DAC_tb is
     
    component Ctrl_DAC
    Port (
        reset                       : in    std_logic;  
        clk_DAC                     : in    std_logic; 						-- Horloge à fournir à l'ADC
        i_data1                     : in    std_logic_vector (11 downto 0); -- échantillon à envoyer   
        i_data2                     : in    std_logic_vector (11 downto 0);     
        i_DAC_Strobe                : in    std_logic;                      -- Synchronisation: strobe déclencheur de la séquence de réception
        
        o_DAC_nCS                   : out   std_logic;                      -- Signal Chip select vers le DAC  
        o_bit_value1                : out   std_logic;                       -- valeur du bit à envoyer
        o_bit_value2                : out   std_logic 
        );
    end component;
    
    
    component Ctrl_AD1 is
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
    
    
    signal reset_sim        : std_logic;
    signal clk_DAC_sim      : std_logic := '0';
    signal i_data1_sim       : std_logic_vector (11 downto 0);
    signal i_data2_sim       : std_logic_vector (11 downto 0);
    signal i_DAC_Strobe_sim : std_logic;
    
    signal o_DAC_nCS_sim    : std_logic;
    signal o_bit_value1_sim : std_logic;
    signal o_bit_value2_sim : std_logic;
    
    signal s_ADC_nCS                        : std_logic;
    signal o_echantilllon_pret_ADC          : std_logic;
    signal o_ech1_ADC                       : std_logic_vector(11 downto 0);
    signal o_ech2_ADC                       : std_logic_vector(11 downto 0);
    signal d_strobe_100Hz                   : std_logic;
    signal d_compteDelai                    : std_logic;
    signal d_compteurDelaiStrobe            : integer;
    signal d_strobe_100Hz_ADC               : std_logic;
    signal compt_gen_R                      : unsigned(7 downto 0) := x"00";
    signal s_param                          : std_logic_vector(11 downto 0);
    signal s_param_persp                    : std_logic_vector(11 downto 0);
    
    constant CLK_PERIOD : time := 200 ns;
    constant DAC_STROBE_PERIOD : time := 10 ms;
    constant seconde : time := 4000 ms;
      
    type table_forme is array (integer range 0 to 254) of std_logic_vector(11 downto 0);
    constant mem_forme_onde_R : table_forme := (
 -- forme d'une onde carrée
 -- chaque cycle a 48 echantillons
    x"187",
    x"1CF",
    x"29D",
    x"3DD",
    x"57C",
    x"762",
    x"96E",
    x"B7B",
    x"D66",
    x"EFA",
    x"FF0",
    x"FFF",
    x"EE8",
    x"CBD",
    x"9BD",
    x"627",
    x"245",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"097",
    x"26F",
    x"372",
    x"39B",
    x"31F",
    x"230",
    x"103",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"013",
    x"081",
    x"0C4",
    x"0CE",
    x"0A9",
    x"06A",
    x"028",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"004",
    x"01F",
    x"034",
    x"040",
    x"046",
    x"048",
    x"04A",
    x"04C",
    x"04F",
    x"053",
    x"059",
    x"05F",
    x"065",
    x"06A",
    x"06D",
    x"06D",
    x"06B",
    x"067",
    x"061",
    x"05A",
    x"051",
    x"046",
    x"03A",
    x"02D",
    x"01E",
    x"00D",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
     x"187",
    x"1CF",
    x"29D",
    x"3DD",
    x"57C",
    x"762",
    x"96E",
    x"B7B",
    x"D66",
    x"EFA",
    x"FF0",
    x"FFF",
    x"EE8",
    x"CBD",
    x"9BD",
    x"627",
    x"245",
   
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"097",
    x"26F",
    x"372",
    x"39B",
    x"31F",
    x"230",
    x"103",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"013",
    x"081",
    x"0C4",
    x"0CE",
    x"0A9",
    x"06A",
    x"028",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"004",
    x"01F",
    x"034",
    x"040",
    x"046",
    x"048",
    x"04A",
    x"04C",
    x"04F",
    x"053",
    x"059",
    x"05F",
    x"065",
    x"06A",
    x"06D",
    x"06D",
    x"06B",
    x"067",
    x"061",
    x"05A",
    x"051",
    x"046",
    x"03A",
    x"02D",
    x"01E",
    x"00D",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
     x"187",
    x"1CF",
    x"29D",
    x"3DD",
    x"57C",
    x"762",
    x"96E",
    x"B7B",
    x"D66",
    x"EFA",
    x"FF0",
    x"FFF",
    x"EE8",
    x"CBD",
    x"9BD",
    x"627",
    x"245",
    x"000",
    
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"097",
    x"26F",
    x"372",
    x"39B",
    x"31F",
    x"230",
    x"103",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"013",
    x"081",
    x"0C4",
    x"0CE",
    x"0A9",
    x"06A",
    x"028",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"004",
    x"01F",
    x"034",
    x"040",
    x"046",
    x"048",
    x"04A",
    x"04C",
    x"04F",
    x"053",
    x"059",
    x"05F",
    x"065",
    x"06A",
    x"06D",
    x"06D",
    x"06B",
    x"067",
    x"061",
    x"05A",
    x"051",
    x"046",
    x"03A",
    x"02D",
    x"01E",
    x"00D",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000"
    );
  
    
begin

    

    uut : Ctrl_DAC
        Port Map (
            reset => reset_sim,
            clk_DAC => clk_DAC_sim,
            i_data1 => i_data1_sim,
            i_data2 => i_data2_sim,             
            i_DAC_Strobe =>i_DAC_Strobe_sim,
            o_DAC_nCS => o_DAC_nCS_sim,
            o_bit_value1 => o_bit_value1_sim,
            o_bit_value2 => o_bit_value2_sim
            );
               
    inst_ADC : Ctrl_AD1
    port map(
            reset   =>    reset_sim ,                  
            clk_ADC => clk_DAC_sim,                     					-- Horloge ï¿½ fournir ï¿½ l'ADC
            i_DO1   => o_bit_value1_sim,                                           -- Bit de donnï¿½e en provenance de l'ADC         
            i_DO2   => o_bit_value2_sim ,                                        -- Bit de donnï¿½e en provenance de l'ADC 
            o_ADC_nCS =>     s_ADC_nCS,                                   -- Signal Chip select vers l'ADC 
            
            i_ADC_Strobe => d_strobe_100Hz_ADC,                              
            o_echantillon_pret_strobe => o_echantilllon_pret_ADC,                       
            o_echantillon1  => o_ech1_ADC,             
            o_echantillon2  => o_ech2_ADC
    );
    
    inst_calcul_pouls : Calcul_pouls    
    Port map( 
           i_clk => clk_DAC_sim,
           i_reset  => reset_sim,
           i_en     => o_echantilllon_pret_ADC,
           i_ech    => o_ech1_ADC,
           o_param  => s_param
           );
      
    inst_calcul_pers : Calcul_persp
    port map(
           i_clk => clk_DAC_sim,
           i_reset  => reset_sim,
           i_en     => o_echantilllon_pret_ADC,
           i_ech    => o_ech1_ADC,
           o_param  => s_param_persp
           );
    
            
    clk_process : process
    begin
        wait for CLK_PERIOD / 2;
            clk_DAC_sim <= not(clk_DAC_sim);
    end process;
    
    DAC_Strobe_Process : process
    begin
        wait for DAC_STROBE_PERIOD;
            i_DAC_Strobe_sim <= '1';
        wait for CLK_Period;
            i_DAC_Strobe_sim <= '0';
    end process;
    
    sim_entree_D : process (reset_sim, i_DAC_Strobe_sim)
    begin
        if(reset_sim = '1') then  -- Init/reset
           compt_gen_R <= x"00";
           i_data1_sim <= X"000";
   else
      if(i_DAC_Strobe_sim'event and i_DAC_Strobe_sim = '1') then
         i_data1_sim <= mem_forme_onde_R(to_integer(compt_gen_R));
         if (compt_gen_R = mem_forme_onde_R'length-1) then
           compt_gen_R <= x"00";
         else
           compt_gen_R <= compt_gen_R + 1;
         end if;
      end if;
   end if;
end process;
    
    
    tb : process
    begin
        reset_sim <= '1';
        wait for CLK_PERIOD;
        reset_sim <= '0';
        wait for seconde ;
    
    end process;
 
    DAC_ADC_Strobe : process (i_DAC_Strobe_sim, clk_DAC_sim,reset_sim)
    begin
        if reset_sim = '1' then
           d_compteDelai <= '0';
           d_compteurDelaiStrobe <= 0;
           d_strobe_100Hz_ADC <='1' ;
        end if;
        
        if rising_edge(clk_DAC_sim) or falling_edge(clk_DAC_sim) then
            if (i_DAC_Strobe_sim = '1') then
                d_compteDelai <= '1';
            end if;
            if (d_compteDelai = '1') then
                if (d_compteurDelaiStrobe = 1) then
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
