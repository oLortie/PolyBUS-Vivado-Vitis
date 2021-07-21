--------------------------------------------------------------------------------
-- Controle du module pmod AD1
-- Ctrl_AD1.vhd
-- ref: http://www.analog.com/media/cn/technical-documentation/evaluation-documentation/AD7476A_7477A_7478A.pdf 

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity Ctrl_AD1 is
port ( 
    reset                       : in    std_logic;  
    clk_ADC                     : in    std_logic; 						-- Horloge ï¿½ fournir ï¿½ l'ADC
    i_DO1                       : in    std_logic;                      -- Bit de donnï¿½e en provenance de l'ADC         
    i_DO2                       : in    std_logic;                      -- Bit de donnï¿½e en provenance de l'ADC 
    o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
	
    i_ADC_Strobe                : in    std_logic;                      -- Synchronisation: strobe dï¿½clencheur de la sï¿½quence de rï¿½ception    
    o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une rï¿½ception complï¿½te d'un ï¿½chantillon  
    o_echantillon1              : out   std_logic_vector (11 downto 0); -- valeur de l'ï¿½chantillon reï¿½u
    o_echantillon2              : out   std_logic_vector (11 downto 0)  -- valeur de l'ï¿½chantillon reï¿½u
);
end Ctrl_AD1;

architecture Behavioral of Ctrl_AD1 is

    signal d_Decale : std_logic;
    signal d_reset_cpt  : std_logic;
    signal d_val_compteur : std_logic_vector (4 downto 0);
    signal d_register1_value : std_logic_vector(11 downto 0);
    signal d_register2_value : std_logic_vector(11 downto 0);
  
    component AD7476_mef
    port ( 
        clk_ADC                 : in std_logic;
        reset			        : in std_logic;
        i_ADC_Strobe            : in std_logic;     --  cadence echantillonnage AD1   
        i_Count_value           : in std_logic_vector (4 downto 0); 
        i_register1_value       : in std_logic_vector(11 downto 0);
        i_register2_value       : in std_logic_vector(11 downto 0);
        
        o_ADC_nCS		        : out std_logic;    -- Signal Chip select vers l'ADC  
        o_Decale			    : out std_logic;    -- Signal de décalage
        o_reset_cpt             : out std_logic;    -- Reset Compteur
        o_echantillon1          : out std_logic_vector(11 downto 0);
        o_echantillon2          : out std_logic_vector(11 downto 0);
        o_FinSequence_Strobe    : out std_logic     -- Strobe de fin de séquence d'échantillonnage
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
  
    
begin

--  Machine a etats finis pour le controle du AD7476
    MEF : AD7476_mef
    port map (
        clk_ADC                 => clk_ADC,
        reset                   => reset,
        i_ADC_Strobe            => i_ADC_Strobe,
        i_Count_value           => d_val_compteur,
        i_register1_value       => d_register1_value,
        i_register2_value       => d_register2_value,
        o_ADC_nCS               => o_ADC_nCS,
        o_Decale                => d_Decale,
        o_reset_cpt             => d_reset_cpt,
        o_FinSequence_Strobe    => o_echantillon_pret_strobe,
        o_echantillon1          => o_echantillon1,
        o_echantillon2          => o_echantillon2
    );
    
    inst_reg_dec12_1 : reg_dec12
    Port Map (
            i_clk       => clk_ADC,
            i_reset     => reset,
            i_load      => '0',
            i_en        => d_Decale,
            i_dat_bit   => i_DO1,
            i_dat_load  => "000000000000",
            o_dat       => d_register1_value
     );
     
     inst_reg_dec12_2 : reg_dec12
     Port Map (
            i_clk       => clk_ADC,
            i_reset     => reset,
            i_load      => '0',
            i_en        => d_Decale,
            i_dat_bit   => i_DO2,
            i_dat_load  => "000000000000",
            o_dat       => d_register2_value
     );
     
     inst_compteur : compteur_nbits
     generic map (nbits => 5)
     Port Map (
        clk => clk_ADC,
        i_en => '1',
        reset => d_reset_cpt,
        o_val_cpt => d_val_compteur
    );

end Behavioral;
