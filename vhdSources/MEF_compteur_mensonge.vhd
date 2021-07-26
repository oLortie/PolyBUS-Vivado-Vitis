----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/20/2021 11:04:23 AM
-- Design Name: 
-- Module Name: MEF_compteur_mensonge - Behavioral
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
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEF_compteur_mensonge is
generic (threshold : std_logic_vector(7 downto 0) := "01111111");
    Port ( i_clk : in STD_LOGIC;
           i_ech : in STD_LOGIC_VECTOR (7 downto 0);
           i_reset : in STD_LOGIC;
           i_en : in STD_LOGIC;
           i_val_cpt_conf : in std_logic_vector(8 downto 0);
           o_strobe_compteur_mensonge : out STD_LOGIC;
           o_en_compteur_conf         : out STD_LOGIC;
           o_reset_compteur_conf      : out STD_LOGIC       
           );
end MEF_compteur_mensonge;

architecture Behavioral of MEF_compteur_mensonge is

type type_etat is (IDLE,CONFIRMATION,ADD);

signal etat_courant,etat_suivant : type_etat;
signal compteurConfirmation : unsigned(1 downto 0);
signal s_en_compteur_confirmation : std_logic;


begin

process(i_clk,i_reset)
    begin
       if (i_reset ='1') then
             etat_courant <= IDLE;      
       elsif rising_edge(i_clk) then
             etat_courant <= etat_suivant;
       end if;
end process;

process(i_ech,i_en,etat_courant)
begin
    case (etat_courant) is
    when IDLE => 
    if i_en= '1' then
        if i_ech > threshold then
            etat_suivant <= CONFIRMATION;
        end if;
    end if;
    when CONFIRMATION => 
    if i_en ='1' then
         if i_ech <= threshold then
            etat_suivant <=IDLE;
         elsif i_val_cpt_conf = "100101100" then
            etat_suivant <= ADD;
         end if;
    end if;
    WHEN ADD => etat_suivant <= IDLE; 
    end case;
end process;

process(etat_courant)
begin
case(etat_courant) is
WHEN IDLE =>
    o_strobe_compteur_mensonge  <= '0';
    s_en_compteur_confirmation  <= '0';
    o_reset_compteur_conf       <= '1';
WHEN CONFIRMATION=>
    o_strobe_compteur_mensonge  <= '0';
    s_en_compteur_confirmation  <= '1';
    o_reset_compteur_conf       <= '0';
WHEN ADD => 
    o_strobe_compteur_mensonge  <= '1';
    s_en_compteur_confirmation  <= '0';
    o_reset_compteur_conf       <= '0';
end case;
end process;

o_en_compteur_conf <= s_en_compteur_confirmation and i_en;

end Behavioral;
