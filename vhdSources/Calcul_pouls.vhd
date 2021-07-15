----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/02/2021 11:54:48 AM
-- Design Name: 
-- Module Name: Calcul_pouls - Behavioral
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

entity Calcul_pouls is
    Port ( i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_en : in STD_LOGIC;
           i_ech : in STD_LOGIC_VECTOR (11 downto 0);
           o_param : out STD_LOGIC_VECTOR (11 downto 0));
end Calcul_pouls;

architecture Behavioral of Calcul_pouls is

component compteur_nbits 
generic (nbits : integer := 12);
   port ( clk             : in    std_logic; 
          i_en            : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
          );
end component;

component MEF_pouls is
Port ( 
    i_bclk      : in std_logic; -- bit clock ... horloge I2S digital audio
    i_reset     : in std_logic; -- 
    cpt         : in std_logic_vector(11 downto 0); -- etat du compteur
    i_dat       : in std_logic_vector(11 downto 0);
    i_en        : in std_logic; -- enable de la MEF
    o_reset_cpt : out  std_logic;  -- reset du compteur
    o_param     : out  std_logic_vector (11 downto 0);  -- load du data dans la sortie
    o_en_cpt    : out std_logic; -- enable du compteuir
    
    i_cpt_conf          : in std_logic_vector(1 downto 0);
    o_reset_cpt_conf    :out std_logic
    
);
end component;



   signal d_reset_cpt : STD_LOGIC ;
   signal d_cpt : std_logic_vector (11 downto 0);
   signal d_reset_cpt_conf : std_logic;
   signal d_cpt_conf : std_logic_vector(1 downto 0);
   signal d_en_cpt : STD_LOGIC ;
   

begin

inst_MEF : MEF_pouls
port map(
    i_bclk      => i_clk, -- bit clock ... horloge I2S digital audio
    i_reset     => i_reset,
    cpt         => d_cpt,
    i_cpt_conf    => d_cpt_conf,
    i_dat       => i_ech,
    i_en        => i_en,
    o_reset_cpt => d_reset_cpt,
    o_param     => o_param,
    o_en_cpt    => d_en_cpt,
          
    o_reset_cpt_conf => d_reset_cpt_conf  
);

inst_compteur : compteur_nbits
port map (
clk => i_clk,
i_en => d_en_cpt,
reset => d_reset_cpt,
o_val_cpt => d_cpt
);

inst_compteur_conf : compteur_nbits
generic map(nbits => 2)
port map(
clk => i_clk,
i_en => d_en_cpt,
reset => d_reset_cpt_conf,
o_val_cpt => d_cpt_conf
);

end Behavioral;
