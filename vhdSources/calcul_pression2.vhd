----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2021 03:54:00 PM
-- Design Name: 
-- Module Name: calcul_pression2 - Behavioral
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

entity calcul_pression2 is
    Port ( clk : in STD_LOGIC;
           i_en : in STD_LOGIC;
           i_echantillon : in STD_LOGIC_VECTOR (11 downto 0);
           i_reset : in STD_LOGIC;
           o_result : out STD_LOGIC_VECTOR (11 downto 0);
           o_state : out std_logic_vector(3 downto 0);
           o_lastReceived : out std_logic_vector(11 downto 0)
           );
end calcul_pression2;

architecture Behavioral of calcul_pression2 is

    type State_type is (Idle, Montee1, Confirmation1, Descente1, Montee2, Confirmation2, Moyenne);
    signal etat_courant, etat_suivant : State_type;
    
    signal intermediateValue : std_logic_vector(11 downto 0) := "000000000000";
    signal lastReceivedValue : std_logic_vector(11 downto 0) := "000000000000";
    signal tempResult : std_logic_vector(12 downto 0) := "0000000000000";
    
    signal s_LoadData : std_logic := '0';

begin

-- Process de la clock
process (clk, i_reset)
begin
    if (i_reset = '1') then
        etat_courant <= Idle;
    else if (rising_edge(clk)) then
        etat_courant <= etat_suivant;
    end if;
    end if;
end process;

-- Décodeur d'état
process (etat_courant, i_en, i_echantillon)
begin
    case etat_courant is
        when Idle =>
            if (rising_edge(i_en)) then
                if (to_integer(unsigned(i_echantillon)) > to_integer(unsigned(lastReceivedValue))) then
                    etat_suivant <= Montee1;
                else
                    etat_suivant <= Idle;
                end if;
            end if;
        when Montee1 =>
            if (rising_edge(i_en)) then
                if (to_integer(unsigned(i_echantillon)) < to_integer(unsigned(lastReceivedValue))) then
                    etat_suivant <= Confirmation1;
                else
                    etat_suivant <= Montee1;
                end if;
            end if;
        when Confirmation1 =>
            etat_suivant <= Descente1;
        when Descente1 =>
            if (rising_edge(i_en)) then
                if (to_integer(unsigned(i_echantillon)) > to_integer(unsigned(lastReceivedValue))) then
                    etat_suivant <= Montee2;
                else
                    etat_suivant <= Descente1;
                end if;
            end if;
        when Montee2 =>
            if (rising_edge(i_en)) then
                if (to_integer(unsigned(i_echantillon)) < to_integer(unsigned(lastReceivedValue))) then
                    etat_suivant <= Confirmation2;
                else
                    etat_suivant <= Montee2;
                end if;
            end if;
        when Confirmation2 =>
            etat_suivant <= Moyenne;
        when Moyenne =>
            etat_suivant <= Idle;
        when others =>
            etat_suivant <= Idle;
    end case;
    
    if (i_en = '1') then
        intermediateValue <= i_echantillon;
    end if;
    
end process;

-- Décodeur de sorties
process (etat_courant, i_echantillon)
begin
    case etat_courant is
        when Idle =>
            o_state <= "0001";
        when Montee1 =>
            o_state <= "0010";
        when Confirmation1 =>
            tempResult <= "0" & lastReceivedValue;
            o_state <= "0011";
        when Descente1 =>
            o_state <= "0100";
        when Montee2 =>
            o_state <= "0101";
        when Confirmation2 =>
            tempResult <= tempResult + lastReceivedValue;
            o_state <= "0110";
        when Moyenne =>
            o_result <= tempResult(12 downto 1);
            o_state <= "0111";
        when others =>
            
    end case;
end process;

process (i_en)
begin
    if (i_en = '1') then
        lastReceivedValue <= intermediateValue;
    end if;
end process;

o_lastReceived <= lastReceivedValue;


end Behavioral;
