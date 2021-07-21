----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/04/2021 03:44:24 AM
-- Design Name: 
-- Module Name: DLatch1 - Behavioral
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

entity DLatch1 is
    Port ( write_enable : in STD_LOGIC;
           i_signal : in STD_LOGIC_VECTOR (11 downto 0);
           o_signal : out STD_LOGIC_VECTOR (11 downto 0);
           clk : in STD_LOGIC);
end DLatch1;

architecture Behavioral of DLatch1 is

begin
process (clk)
begin
if write_enable = '1' then
    o_signal <= i_signal;
end if;
end process;
end Behavioral;
