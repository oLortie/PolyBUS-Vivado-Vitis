----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Charles Lévesque-Matte
-- 
-- Create Date: 05/16/2021 03:09:51 PM
-- Design Name: 
-- Module Name: shift_reg - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity shift_reg is
    Port ( D : in STD_LOGIC;
           i_CLK : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (7 downto 0);
           READY : out STD_LOGIC);
end shift_reg;

architecture Behavioral of shift_reg is

-- Signal declaration 
signal s_shift_reg : std_logic_vector(7 downto 0) := "00";
signal s_buf_cnt   : integer range 0 to 7;
signal s_rst       : std_logic;

begin
s_rst <= '0';
    process (i_CLK, s_rst)
        begin 
            if rising_edge(i_CLK) and s_buf_cnt < 7 then
                if s_rst = '1' then
                    s_buf_cnt <= 0;
                else
                    s_shift_reg(6 downto 0) <= s_shift_reg(7 downto 1);
                    s_shift_reg(7) <= D;
                    s_buf_cnt <= s_buf_cnt + 1;
                    s_rst <= '1';
                end if; 
             else
                READY <= '1';                      
            end if;
    end process;

-- Signal assignation
Q <= s_shift_reg;

end Behavioral;
