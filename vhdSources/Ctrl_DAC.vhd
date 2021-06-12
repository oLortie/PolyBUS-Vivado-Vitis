----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/06/2021 02:55:01 PM
-- Design Name: 
-- Module Name: Ctrl_DAC - Behavioral
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

entity Ctrl_DAC is
    Port (
        reset                       : in    std_logic;  
        clk_DAC                     : in    std_logic; 						-- Horloge à fournir à l'ADC
        i_data                      : in    std_logic_vector (11 downto 0); -- échantillon à envoyer        
        i_DAC_Strobe                : in    std_logic;                      -- Synchronisation: strobe déclencheur de la séquence de réception
        
        o_DAC_nCS                   : out   std_logic;                      -- Signal Chip select vers le DAC  
        o_bit_value                 : out   std_logic                       -- valeur du bit à envoyer
        );
end Ctrl_DAC;

architecture Behavioral of Ctrl_DAC is

    component MEF_DAC
    Port (
        reset                       : in std_logic;  
        clk_DAC                     : in std_logic; 				    
   
        i_DAC_Strobe                : in std_logic;                      
        i_val_cpt                   : in std_logic_vector (4 downto 0);
         
        o_DAC_nCS                   : out std_logic;                       
        o_en_compt                  : out std_logic;
        o_reset_compt               : out std_logic;
        o_en_reg                    : out std_logic;
        o_rst_reg                   : out std_logic;
        o_load_reg                  : out std_logic
        );
    end component;

    component reg_dec12
    Port ( i_clk       : in std_logic;      -- horloge
           i_reset     : in std_logic;      -- reinitialisation
           i_load      : in std_logic;      -- activation chargement parallele
           i_en        : in std_logic;      -- activation decalage
           i_dat_bit   : in std_logic;      -- entree serie
           i_dat_load  : in std_logic_vector(11 downto 0);    -- entree parallele
           o_dat       : out  std_logic_vector(11 downto 0)   -- sortie parallele
           );
    end component;
    
    component compteur_nbits
    generic (nbits : integer := 5);
    port ( clk             : in    std_logic; 
           i_en            : in    std_logic; 
           reset           : in    std_logic; 
           o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
           );
    end component;
    
    signal d_en_cpt   : std_logic;
    signal d_rst_cpt  : std_logic;
    signal d_en_reg   : std_logic;
    signal d_rst_reg  : std_logic;
    signal d_load_reg : std_logic;
    signal d_dat_out  : std_logic_vector (11 downto 0);
    signal d_val_cpt  : std_logic_vector (4 downto 0);

begin

    inst_MEF : MEF_DAC
    Port Map (
        reset => reset,
        clk_DAC => clk_DAC,
        i_DAC_Strobe => i_DAC_Strobe,      
        i_val_cpt => d_val_cpt,
        o_DAC_nCS => o_DAC_nCS,      
        o_en_compt => d_en_cpt,
        o_reset_compt => d_rst_cpt,
        o_en_reg => d_en_reg,
        o_rst_reg => d_rst_reg,
        o_load_reg => d_load_reg
    );    
    
    inst_reg_dec12 : reg_dec12
    Port Map (
        i_clk => clk_DAC,
        i_reset => reset,
        i_load => d_load_reg,
        i_en => d_en_reg,
        i_dat_bit => '0',
        i_dat_load => i_data,
        o_dat => d_dat_out
     );
     
     inst_compteur : compteur_nbits
     generic map (nbits => 5)
     Port Map (
        clk => clk_DAC,
        i_en => d_en_cpt,
        reset => d_rst_cpt,
        o_val_cpt => d_val_cpt
    );
    
    o_bit_value <= d_dat_out(11);

end Behavioral;
