----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/25/2021 10:43:40 AM
-- Design Name: 
-- Module Name: FctBin2Thermo_tb - Behavioral
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

entity FctBin2Thermo_tb is
--  Port ( );
end FctBin2Thermo_tb;

architecture Behavioral of FctBin2Thermo_tb is

    component FctBin2Thermo is
        Port (
            i_echantillon : in  std_logic_vector (11 downto 0);
            o_thermo      : out std_logic_vector (7 downto 0)
            );
    end component;
    
    signal i_echantillon_sim : std_logic_vector (11 downto 0);
    signal o_thermo_sim      : std_logic_vector (7 downto 0);
    
    signal PERIOD : time := 10 us;

begin

    uut : FctBin2Thermo
        Port Map (
            i_echantillon => i_echantillon_sim,
            o_thermo      => o_thermo_sim
            );
            
    tb : process
    begin
        wait for PERIOD;
            i_echantillon_sim <= "000000000000";
        wait for PERIOD;
            i_echantillon_sim <= "001000000000";
        wait for PERIOD;
            i_echantillon_sim <= "010000000000";
        wait for PERIOD;
            i_echantillon_sim <= "011000000000";
        wait for PERIOD;
            i_echantillon_sim <= "100000000000";
        wait for PERIOD;
            i_echantillon_sim <= "101000000000";
        wait for PERIOD;
            i_echantillon_sim <= "110000000000";
        wait for PERIOD;
            i_echantillon_sim <= "111000000000";
    
    
    end process;
    


end Behavioral;
