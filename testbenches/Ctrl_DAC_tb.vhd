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
        i_data                      : in    std_logic_vector (11 downto 0); -- échantillon à envoyer        
        i_DAC_Strobe                : in    std_logic;                      -- Synchronisation: strobe déclencheur de la séquence de réception
        
        o_DAC_nCS                   : out   std_logic;                      -- Signal Chip select vers le DAC  
        o_bit_value                 : out   std_logic                       -- valeur du bit à envoyer
        );
    end component;
    
    signal reset_sim        : std_logic;
    signal clk_DAC_sim      : std_logic := '0';
    signal i_data_sim       : std_logic_vector (11 downto 0);
    signal i_DAC_Strobe_sim : std_logic;
    
    signal o_DAC_nCS_sim    : std_logic;
    signal o_bit_value_sim  : std_logic;
    
    constant CLK_PERIOD : time := 200 ns;
    constant DAC_STROBE_PERIOD : time := 10 ms;
    
begin

    uut : Ctrl_DAC
        Port Map (
            reset => reset_sim,
            clk_DAC => clk_DAC_sim,
            i_data => i_data_sim,     
            i_DAC_Strobe =>i_DAC_Strobe_sim,
            o_DAC_nCS => o_DAC_nCS_sim,
            o_bit_value => o_bit_value_sim
            );
            
    reset_sim <= '0';
            
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
    
    tb : process
    begin
        wait for DAC_Strobe_PERIOD;
            i_data_sim <= X"F01";
        wait for DAC_Strobe_PERIOD;
            i_data_sim <= X"F02";
        wait for DAC_Strobe_PERIOD;
            i_data_sim <= X"F03";
        wait for DAC_Strobe_PERIOD;
            i_data_sim <= X"F04";
        wait for DAC_Strobe_PERIOD;
            i_data_sim <= X"F05";
    end process;


end Behavioral;
