----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/06/2021 02:24:08 PM
-- Design Name: 
-- Module Name: MEF_DAC - Behavioral
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

entity MEF_DAC is
    Port (
        reset                       : in std_logic;  
        clk_DAC                     : in std_logic; 				     -- Horloge à fournir à l'ADC
   
        i_DAC_Strobe                : in std_logic;                      -- Synchronisation: strobe déclencheur de la séquence de réception  
        i_val_cpt                   : in std_logic_vector (4 downto 0);
         
        o_DAC_nCS                   : out std_logic;                      -- Signal Chip select vers l'ADC 
        o_en_compt                  : out std_logic;
        o_reset_compt               : out std_logic;
        o_en_reg                    : out std_logic;
        o_rst_reg                   : out std_logic;
        o_load_reg                  : out std_logic
        );
end MEF_DAC;

architecture Behavioral of MEF_DAC is

    type State_type is (Idle, Load, SendingZeros, SendingData);
    
    signal etat_courant, etat_suivant : State_type;
    
begin
    -- Process de la clock
    process (reset, clk_DAC)
    begin
        if (reset = '1') then
            etat_courant <= Idle;
        elsif (rising_edge(clk_DAC)) then
            etat_courant <= etat_suivant;
        end if;
    end process;
    
    -- Décodeur d'états
    process (etat_courant, i_DAC_Strobe, i_val_cpt)
    begin
        case etat_courant is
            when Idle =>
                if (i_DAC_Strobe = '1') then
                    etat_suivant <= SendingZeros;
                else
                    etat_suivant <= Idle;
                end if;
            when SendingZeros =>
                if (i_val_cpt = "00010") then
                    etat_suivant <= Load;
                else
                    etat_suivant <= SendingZeros;
                end if;
            when Load =>
                etat_suivant <= SendingData;
            when SendingData =>
                if (i_val_cpt = "01111") then
                    etat_suivant <= Idle;
                else
                    etat_suivant <= SendingData;
                end if;
            when others =>
                etat_suivant <= Idle;
        end case;
    end process;
    
    -- Décodeur de sortie
    process (etat_courant)
    begin
        case etat_courant is
            when Idle =>
                o_DAC_nCS <= '1';
                o_en_compt <= '0';
                o_reset_compt <= '1';
                o_en_reg <= '0';
                o_rst_reg <= '1';
                o_load_reg <= '0';
            when Load =>
                o_DAC_nCS <= '0';
                o_en_compt <= '1';
                o_reset_compt <= '0';
                o_en_reg <= '0';
                o_rst_reg <= '1';
                o_load_reg <= '1';
            when SendingZeros =>
                o_DAC_nCS <= '0';
                o_en_compt <= '1';
                o_reset_compt <= '0';
                o_en_reg <= '0';
                o_rst_reg <= '1';
                o_load_reg <= '0';
            when SendingData =>
                o_DAC_nCS <= '0';
                o_en_compt <= '1';
                o_reset_compt <= '0';
                o_en_reg <= '1';
                o_rst_reg <= '0';
                o_load_reg <= '0';
            when others =>
                o_DAC_nCS <= '1';
                o_en_compt <= '0';
                o_reset_compt <= '1';
                o_en_reg <= '0';
                o_rst_reg <= '1';
                o_load_reg <= '0';
        end case;
    end process;


end Behavioral;
