----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/04/2021 03:51:50 AM
-- Design Name: 
-- Module Name: moyenne - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity moyenne is
    Port ( clk       : in STD_LOGIC;
           i_signal1 : in STD_LOGIC_VECTOR (11 downto 0);
           i_signal2 : in STD_LOGIC_VECTOR (11 downto 0);
           o_pressionSanguine : out STD_LOGIC_VECTOR (11 downto 0));
end moyenne;

architecture Behavioral of moyenne is
signal x : unsigned (11 downto 0);
signal y : unsigned (11 downto 0);

signal s_unsignedI_signal1 : unsigned(11 downto 0);
signal s_unsignedI_signal2 : unsigned(11 downto 0);
signal s_unsignedz         : unsigned(11 downto 0);



begin
s_unsignedI_signal1 <= unsigned(i_signal1);
s_unsignedI_signal2 <= unsigned(i_signal2);

x <= shift_right(s_unsignedI_signal1, 1);
y <= shift_right(s_unsignedI_signal2, 1);

process(clk)
begin

s_unsignedz <= x+y;
o_pressionSanguine <= std_logic_vector(s_unsignedz);
end process;
end Behavioral;
