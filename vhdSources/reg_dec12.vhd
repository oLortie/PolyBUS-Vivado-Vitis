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
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs

entity reg_dec12 is
  Port ( 
    i_clk       : in std_logic;      -- horloge
    i_reset     : in std_logic;      -- reinitialisation
    i_load      : in std_logic;      -- activation chargement parallele
    i_en        : in std_logic;      -- activation decalage
    i_dat_bit   : in std_logic;      -- entree serie
    i_dat_load  : in std_logic_vector(11 downto 0);    -- entree parallele
    o_dat       : out  std_logic_vector(11 downto 0)   -- sortie parallele
);
end reg_dec12;

architecture Behavioral of reg_dec12 is

  --
    signal   q_shift_reg   : std_logic_vector(11 downto 0);   -- registre 
    
  begin 
  -- registre a décalage,  MSB arrive premier, entre par la droite, decalage a gauche  
  reg_dec: process (i_clk, i_reset)
     begin    
       if (i_reset = '1')  then
          q_shift_reg  <= (others =>'0');
      elsif rising_edge(i_clk) then  
                if (i_load = '1')  then
                   q_shift_reg  <= i_dat_load;
                elsif (i_en = '1') then
                   q_shift_reg(11 downto 0) <= q_shift_reg(10 downto 0) & i_dat_bit;
                end if;
       end if;
     end process;
 
     o_dat   <=  q_shift_reg;

end Behavioral;