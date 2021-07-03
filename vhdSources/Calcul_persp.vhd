----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/02/2021 03:27:39 PM
-- Design Name: 
-- Module Name: Calcul_persp - Behavioral
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
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Calcul_persp is 
    port( 
    i_clk : in STD_LOGIC;
    i_reset : in STD_LOGIC;
    i_en : in STD_LOGIC;
    i_ech : in STD_LOGIC_VECTOR (11 downto 0);
    o_param : out STD_LOGIC_VECTOR (11 downto 0));
    
end Calcul_persp;

architecture Behavioral of Calcul_persp is
   
    signal ech         : unsigned(11 downto 0);
    signal d_total     : unsigned(11 downto 0);
   
    signal valeur1    : unsigned(11 downto 0);
    signal valeur2    : unsigned(11 downto 0);
    signal valeur3    : unsigned(11 downto 0);
    signal valeur4    : unsigned(11 downto 0);  
    
    signal Mvaleur1    : unsigned(11 downto 0);
    signal Mvaleur2    : unsigned(11 downto 0);
    signal Mvaleur3    : unsigned(11 downto 0);
    signal Mvaleur4    : unsigned(11 downto 0);  
    signal counter     : unsigned(2 downto 0);
    
    
begin

ech <= unsigned(i_ech);

process(i_clk,i_reset)
    begin
       if (i_reset ='1') then
             valeur1  <= "000000000000";
             valeur2  <= "000000000000";
             valeur3  <= "000000000000";
             valeur4  <= "000000000000";
             Mvaleur1 <= "000000000000";
             Mvaleur2 <= "000000000000";
             Mvaleur3 <= "000000000000";
             Mvaleur4 <= "000000000000";
             counter  <= "000";
             
       end if;      
       if rising_edge(i_clk)  then 
           if i_en ='1' then
             valeur4 <= valeur3;
             valeur3 <= valeur2;
             valeur2 <= valeur1;
             valeur1 <= ech;
                 
             Mvaleur4 <= shift_right(valeur3,2);
             Mvaleur3 <= shift_right(valeur2,2);
             Mvaleur2 <= shift_right(valeur1,2);
             Mvaleur1 <= shift_right(ech,2);
                        
             d_total <= Mvaleur1 + Mvaleur2 + Mvaleur3 + Mvaleur4;
           
             if counter = "011" then
                 o_param <= std_logic_vector(Mvaleur1 + Mvaleur2 + Mvaleur3 + Mvaleur4);
                 counter <= "000";
             else
                counter <= counter +1;
             end if;  
           end if;
       end if;
       
    end process;


end Behavioral;
