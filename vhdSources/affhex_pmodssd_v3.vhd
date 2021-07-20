---------------------------------------------------------------------------------------------
-- circuit affhex_pmodssd_v3.vhd
---------------------------------------------------------------------------------------------
-- Université de Sherbrooke - Département de GEGI
-- Version         : 3.0
-- Nomenclature    : 0.8 GRAMS
-- Date            : revision 16 mai 2019 
-- Auteur(s)       : Réjean Fontaine, Daniel Dalle
-- Technologies    : FPGA Zynq (carte ZYBO Z7-10 ZYBO Z7-20)
--
-- Outils          : vivado 2016.1 64 bits, vivado 2018.2
---------------------------------------------------------------------------------------------
-- Description:
-- Affichage sur module de 2 chiffes (7 segments) sur PmodSSD 
-- reference https://reference.digilentinc.com/reference/pmod/pmodssd/start 
--           PmodSSD™ Reference Manual Doc: 502-126 Digilent, Inc.
--
-- Revisions
-- mise a jour D Dalle 16 mai 2019 controle de la memorisation de l'affichage
-- mise a jour D Dalle 30 avril 2019 constantes horloges en Hz (pour coherence avec autres modules)
-- mise a jour D Dalle 17 decembre 2018 constantes horloges en Hz (pour coherence avec autres modules)
-- mise a jour D Dalle 22 octobre 2018 corrections, simplifications
-- mise a jour D Dalle 15 octobre documentation affhex_pmodssd_sol_v0.vhd
-- mise a jour D Dalle 12 septembre pour eviter l'usage d'une horloge interne
-- mise a jour D Dalle 7 septembre, calcul des constantes.
-- mise a jour D Dalle 5 septembre 2018, nom affhexPmodSSD, 6 septembre :division horloge
-- module de commande le l'afficheur 2 segments 2 digits sur pmod
-- Daniel Dalle revision pour sortir les signaux du connecteur Pmod directement
-- Daniel Dalle 30 juillet 2018:
-- revision pour une seule entre sur 8 bits affichee sur les deux chiffres Hexa
--
-- Creation selon affhex7segx4v3.vhd 
-- (Daniel Dalle, Réjean Fontaine Universite de Sherbrooke, Departement GEGI)
-- 26 septembre 2011, revision 12 juin 2012, 25 janvier 2013, 7 mai 2015
-- Contrôle de l'afficheur a sept segment (BASYS2 - NEXYS2)
-- horloge 100MHz et diviseur interne
---------------------------------------------------------------------------------------------
-- À faire :
--
--
--
---------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity affhexPmodSSD_v3 is
generic (const_CLK_Hz: integer := 100_000_000);               -- horloge en Hz, typique 100 MHz 
    Port (   clk        : in   STD_LOGIC;                     -- horloge systeme, typique 100 MHz (preciser par le constante)
             reset      : in   STD_LOGIC;
             DA         : in   STD_LOGIC_VECTOR (7 downto 0); -- donnee a afficher sur 8 bits : chiffre hexa position 1 et 0     
             i_aff_mem  : in   STD_LOGIC;                     -- demande memorisation affichage continu, si 0: continu
             JPmod      : out  STD_LOGIC_VECTOR (7 downto 0)  -- sorties directement adaptees au connecteur PmodSSD
           );
end affhexPmodSSD_v3;

architecture Behavioral of affhexPmodSSD_v3 is

-- realisation compteur division horloge pour multiplexer affichage SSD
-- constante pour ajuster selon l horloge pilote du controle des afficheurs
constant CLK_SSD_Hz_des   : integer  := 5000; --Hz   -- horloge desiree pour raffraichir afficheurs 7 segment
constant const_div_clk_SSD : integer  := (const_CLK_Hz/CLK_SSD_Hz_des-1);
constant cdvia  : std_logic_vector (15  downto 0):= conv_std_logic_vector(const_div_clk_SSD, 16); -- donne 5 KHz soit 200 us
signal   counta : std_logic_vector (15 downto 0) := (others => '0');

signal donn   :  STD_LOGIC_VECTOR (3 downto 0);
signal DA_sel :  STD_LOGIC_VECTOR (7 downto 0);
signal segm   :  STD_LOGIC_VECTOR (6 downto 0);
--
signal SEL        :  STD_LOGIC;
signal q_DA       : std_logic_vector (7 downto 0);
signal q_aff_mem  :  STD_LOGIC;

begin

-- selection chiffre pour affichage
local_CLK_proc: process(CLK)
begin
   if(CLK'event and CLK = '1') then
      counta <= counta + 1;
      if (counta = cdvia) then -- devrait se produire aux 200 us approx
           counta <= (others => '0');
           SEL <= not SEL;     -- bascule de la selection du chiffre (0 ou 1)
                               -- SEL devrait avoir periode de 400 us approx          
      end if;
   end if;
end process;

-- multiplexage pour affichage digit
sel_digit_proc: process(SEL, DA_sel)
begin
     if SEL = '0' then 
            donn <= DA_sel(3 downto 0); 
        else
            donn <= DA_sel(7 downto 4);
        end if;               
end process;

-- multiplexage pour selection donnee (continue ou bloquée)
sel_aff_proc: process(i_aff_mem, DA)
begin
     if i_aff_mem = '0' then 
            DA_sel <= DA; 
        else
            DA_sel <= q_DA;
        end if;               
end process;
      
  inst_reg_aff : process ( clk, reset)
  begin
     if (reset = '1') then
        q_DA <= (others => '0');
     else
        -- if rising_edge (d_ac_bclk) and d_str_btn(1) = '1' then 
        if rising_edge (clk) and q_aff_mem = '0' and i_aff_mem ='0' then 
           q_DA <= DA;
        end if;
     end if;
  end process;


fin_continu_process : process (CLK)
   begin
      if (rising_edge(CLK)) then
         q_aff_mem <= i_aff_mem;
      end if;      
   end process;

-- correspondance des segments des afficheurs
segment:  process (donn, segm)
    begin   
      case donn is
            --                      "gfedcba"
            when "0000" => segm  <= "0111111"; -- 0
            when "0001" => segm  <= "0000110"; -- 1
            when "0010" => segm  <= "1011011"; -- 2
            when "0011" => segm  <= "1001111"; -- 3
            when "0100" => segm  <= "1100110"; -- 4
            when "0101" => segm  <= "1101101"; -- 5 
            when "0110" => segm  <= "1111101"; -- 6 
            when "0111" => segm  <= "0000111"; -- 7 
            when "1000" => segm  <= "1111111"; -- 8
            when "1001" => segm  <= "1101111"; -- 9 
            when "1010" => segm  <= "1110111"; -- A
            when "1011" => segm  <= "1111100"; -- b 
            when "1100" => segm  <= "0111001"; -- C 
            when "1101" => segm  <= "1011110"; -- d 
            when "1110" => segm  <= "1111001"; -- E
            when "1111" => segm  <= "1110001"; -- F 
            when others => segm  <= "0000000";
       end case;
    end process;

-- assignation des sorties sur le connecteur Pmod
sortie_proc: process(segm, SEL)
begin
-- contenu segm "gfedcba" pour version Pmod
   JPmod(0) <= segm(0);
   JPmod(1) <= segm(1);
   JPmod(2) <= segm(2);
   JPmod(3) <= segm(3);
   JPmod(4) <= segm(4);
   JPmod(5) <= segm(5);
   JPmod(6) <= segm(6);
   JPmod(7) <= SEL;
end process;


end Behavioral;

