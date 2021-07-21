----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/20/2021 10:46:50 AM
-- Design Name: 
-- Module Name: CompteurMensonge - Behavioral
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

entity CompteurMensonge is
generic (threshold : std_logic_vector(7 downto 0) := "01111111");
    Port ( i_pourcentage_confiance  : in STD_LOGIC_VECTOR (7 downto 0);
           i_clk                    : in STD_LOGIC;
           i_reset                  : in STD_LOGIC;
           i_en                     : in STD_LOGIC;
           o_count_mensonge         : out STD_LOGIC_VECTOR(7 downto 0));
end CompteurMensonge;

architecture Behavioral of CompteurMensonge is

component MEF_compteur_mensonge is
generic (threshold : std_logic_vector(7 downto 0) := threshold);
    Port ( i_clk : in STD_LOGIC;
           i_ech : in STD_LOGIC_VECTOR (7 downto 0);
           i_reset : in STD_LOGIC;
           i_en : in STD_LOGIC;
           i_val_cpt_conf : in std_logic_vector(7 downto 0);
           o_strobe_compteur_mensonge : out STD_LOGIC;
           o_en_compteur_conf         : out STD_LOGIC;
           o_reset_compteur_conf      : out STD_LOGIC
           );
end component;

component compteur_nbits 
generic (nbits : integer := 8);
   port ( clk             : in    std_logic; 
          i_en            : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
          );
end component;

signal s_en_compteur_mensonge   : std_logic;
signal s_en_compteur_conf       : std_logic;
signal s_reset_compteur_conf    : std_logic;
signal s_val_cpt_conf           : std_logic_vector(7 downto 0);

begin

inst_compteur_mensonge : compteur_nbits
port map(
    clk => i_clk,
    i_en => s_en_compteur_mensonge,
    reset => i_reset,
    o_val_cpt => o_count_mensonge
);

inst_compteur_confirmation : compteur_nbits
port map(
    clk => i_clk,
    i_en => s_en_compteur_conf,
    reset => s_reset_compteur_conf,
    o_val_cpt => s_val_cpt_conf
);

inst_mef_compteur : MEF_compteur_mensonge
port map(
    i_clk                       => i_clk,
    i_en                        => i_en,
    i_reset                     => i_reset,
    i_ech                       => i_pourcentage_confiance,
    i_val_cpt_conf              => s_val_cpt_conf,
    o_strobe_compteur_mensonge  => s_en_compteur_mensonge,
    o_en_compteur_conf          => s_en_compteur_conf,
    o_reset_compteur_conf       => s_reset_compteur_conf
);



end Behavioral;
