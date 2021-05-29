----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2021 05:00:04 PM
-- Design Name: 
-- Module Name: reg_dec12 - Behavioral
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


entity reg_dec12 is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_en  : in STD_LOGIC;
           i_dat : in STD_LOGIC;
           o_dat : out STD_LOGIC_VECTOR (11 downto 0)
           );
end reg_dec12;

architecture Behavioral of reg_dec12 is
-- Signals
signal q_shift_reg : std_logic_vector(11 downto 0);

begin
    reg_dec: process(i_clk, i_rst)
        begin 
            if (i_rst = '1') then 
                q_shift_reg <= (others => '0');
            elsif (rising_edge(i_clk)) then
                if (i_en = '1') then     -- On décale
                    q_shift_reg(11 downto 0) <= q_shift_reg(10 downto 0) & i_dat;
                end if;
            end if;
        end process reg_dec;

    o_dat <= q_shift_reg;


end Behavioral;