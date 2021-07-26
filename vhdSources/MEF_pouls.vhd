----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/02/2021 11:56:27 AM
-- Design Name: 
-- Module Name: MEF_pouls - Behavioral
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

entity MEF_pouls is
Port ( 
    i_bclk      : in std_logic; -- bit clock ... horloge I2S digital audio
    i_reset     : in std_logic; -- 
    cpt         : in std_logic_vector(11 downto 0); -- etat du compteur
    i_dat       : in std_logic_vector(11 downto 0);
    i_en        : in std_logic; -- enable de la MEF
    o_reset_cpt : out  std_logic;  -- reset du compteur
    o_param     : out  std_logic_vector (11 downto 0) := X"000";  -- load du data dans la sortie
    o_en_cpt    : out std_logic;-- enable du compteuir
    
    i_cpt_conf          : in std_logic_vector(1 downto 0);
    o_reset_cpt_conf    :out std_logic
   
);
end MEF_pouls;


architecture Behavioral of MEF_pouls is

type type_etat is (IDLE,WAIT_FOR_TRESHOLD,CONFIRMATION,RESETCPT,CALCUL_FREQ_HIGH,CALCUL_FREQ_LOW,LOAD);
    signal etat_courant,etat_suivant : type_etat;
    
    signal s_en_cpt : std_logic;
begin

    
process(i_bclk,i_reset)
    begin
       if (i_reset ='1') then
             etat_courant <= IDLE;
             
             
       else
       if rising_edge(i_bclk) then
             etat_courant <= etat_suivant;
       end if;
       end if;
    end process;

process(etat_courant,i_dat, i_cpt_conf) 
begin
    case etat_courant is
    WHEN IDLE => etat_suivant <= WAIT_FOR_TRESHOLD;
    
    WHEN WAIT_FOR_TRESHOLD =>
                if i_en='1' then
                    if i_dat(11 downto 0) > 0x"C1F" then etat_suivant <= CONFIRMATION; -- Si le msb passe a letat + (0), on entre dans la phase de confirmation
                    else etat_suivant <= WAIT_FOR_TRESHOLD;
                    end if;  
                end if;          
    WHEN CONFIRMATION => if i_en = '1'  then
                            if (i_dat <= 0x"C1F") then 
                                 etat_suivant <= WAIT_FOR_TRESHOLD; -- si on detect une valeur en bas du treshold on drop en attente
                                 
                            elsif  i_dat > 0x"C1F" and i_cpt_conf = "10" then --3 coup de confirm passez
                                 etat_suivant <= LOAD;   
                            else
                                 etat_suivant <= CONFIRMATION;  
                            end if;
                        end if;

    WHEN LOAD => etat_suivant <= RESETCPT;
    
    
    WHEN RESETCPT =>
                      if   i_dat > 0x"C1F" then etat_suivant <= CALCUL_FREQ_HIGH; -- si on a 2 sur le cpt( 3 ech), on commence le calcul de la freq
                      elsif  i_dat <= 0x"C1F" then etat_suivant <= CALCUL_FREQ_LOW;    
                      end if;
    
    WHEN CALCUL_FREQ_HIGH => if  i_en='1' then
                               if i_dat <= 0x"C1F" then etat_suivant <= CALCUL_FREQ_LOW; -- si on detect une valeur negative avant le cpt a trois on retourne IDLE
                               else  etat_suivant <= CALCUL_FREQ_HIGH; -- Si on est encore dans le +, on reste dans le meme state
                               end if;
                            end if;
    WHEN CALCUL_FREQ_LOW =>
                       if  i_en='1' then
                         if i_dat <= 0x"C1F" then etat_suivant <= CALCUL_FREQ_LOW; -- si on reste dans le negatif, reste dans le meme state
                         elsif i_dat > 0x"C1F" then etat_suivant <= CONFIRMATION;
                         end if;
                       end if;
 
    WHEN OTHERS => etat_suivant <= IDLE;    
          
    end case;                     
end process;

process(etat_courant)
begin
    case etat_courant is
     when CONFIRMATION =>
        o_reset_cpt <= '0';
        o_reset_cpt_conf <= '0';
        s_en_cpt <= '1';
     when RESETCPT =>
        o_reset_cpt <='1';
        o_reset_cpt_conf <='1';
        s_en_cpt <= '0';
      when CALCUL_FREQ_HIGH =>
        o_reset_cpt <= '0';
        o_reset_cpt_conf <= '1';
        s_en_cpt <= '1';
       when CALCUL_FREQ_LOW =>
        o_reset_cpt <= '0';
        o_reset_cpt_conf <= '1';
        s_en_cpt <= '1';
        
       when LOAD =>
        o_reset_cpt <= '0';
        o_reset_cpt_conf <= '1';
        s_en_cpt <= '0';
        o_param <= cpt+2;      
       when WAIT_FOR_TRESHOLD =>
        o_reset_cpt <= '0';
        o_reset_cpt_conf <= '1';
        s_en_cpt <= '0';
       when OTHERS =>
        o_reset_cpt <='1';
        o_reset_cpt_conf <= '1';
        s_en_cpt <= '0';
            
      end case;
end process;

   
o_en_cpt <= s_en_cpt and i_en;

end Behavioral;