----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/25/2021 10:35:19 AM
-- Design Name: 
-- Module Name: FctBin2Thermo - Behavioral
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

entity FctBin2Thermo is
    Port ( i_echantillon : in STD_LOGIC_VECTOR (11 downto 0);
           o_thermo : out STD_LOGIC_VECTOR (7 downto 0));
end FctBin2Thermo;

architecture Behavioral of FctBin2Thermo is

    signal s_echantillon3Bits : std_logic_vector (2 downto 0);

begin

    s_echantillon3Bits <= i_echantillon(11 downto 9);
    
    process (s_echantillon3Bits)
    begin
        case s_echantillon3Bits is
        when "000" =>
            o_thermo <= "00000001";
        when "001" =>
            o_thermo <= "00000011";
        when "010" =>
            o_thermo <= "00000111";
        when "011" =>
            o_thermo <= "00001111";
        when "100" =>
            o_thermo <= "00011111";
        when "101" =>
            o_thermo <= "00111111";
        when "110" =>
            o_thermo <= "01111111";
        when "111" =>
            o_thermo <= "11111111";
        when others =>
            o_thermo <= "00000000";
        end case;
    end process;


end Behavioral;
