--------------------------------------------------------------------------------
-- MEF de controle du convertisseur AD7476  
-- AD7476_mef.vhd
-- ref: http://www.analog.com/media/cn/technical-documentation/evaluation-documentation/AD7476A_7477A_7478A.pdf 
---------------------------------------------------------------------------------------------
--	Librairy and Package Declarations
---------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

---------------------------------------------------------------------------------------------
--	Entity Declaration
---------------------------------------------------------------------------------------------
entity AD7476_mef is
port(
    clk_ADC                 : in std_logic;
    reset			        : in std_logic;
    i_ADC_Strobe            : in std_logic;     --  cadence echantillonnage AD1   
    i_Count_value           : in std_logic_vector (4 downto 0); 
    
    o_ADC_nCS		        : out std_logic;    -- Signal Chip select vers l'ADC  
    o_Decale			    : out std_logic;    -- Signal de décalage
    o_reset_cpt             : out std_logic;    -- Reset Compteur
    o_FinSequence_Strobe    : out std_logic     -- Strobe de fin de séquence d'échantillonnage 
);
end AD7476_mef;
 
---------------------------------------------------------------------------------------------
--	Object declarations
---------------------------------------------------------------------------------------------
architecture Behavioral of AD7476_mef is

    type State_type is(Idle, ReadingZeros, Lecture, Confirmation);

--	Components

--	Constantes

--	Signals
    signal etat_courant, etat_suivant : State_type;

--	Registers

-- Attributes

begin

-- Assignation du prochain état
process (clk_ADC, reset)
begin
    if reset = '1' then
        etat_courant <= Idle;
    end if;
    if rising_edge(clk_ADC) then
        etat_courant <= etat_suivant;
    end if;
end process;

-- Calcul du prochain état
process (i_ADC_strobe, i_Count_value, etat_courant)
begin
    case etat_courant is
    when Idle =>
        if i_ADC_strobe = '1' then
            etat_suivant <= Lecture;
        else
            etat_suivant <= Idle;
        end if;
--    when ReadingZeros =>
--        if i_Count_value = "00011" then
--            etat_suivant <= Lecture;
--        else
--            etat_suivant <= ReadingZeros;
--        end if;
    when Lecture =>
        if i_Count_value = "01110" then
            etat_suivant <= Confirmation;
        else
            etat_suivant <= Lecture;
        end if;
    when Confirmation =>
        etat_suivant <= Idle;
    when others =>
        etat_suivant <= Idle;
    end case;
end process;

-- Calcul des sorties
process (etat_courant)
begin
    case etat_courant is
    when Idle =>
        o_ADC_nCS <= '1';
        o_Decale <= '0';
        o_FinSequence_Strobe <= '0';
        o_reset_cpt <= '1';
--    when ReadingZeros =>
--        o_ADC_nCS <= '0';
--        o_Decale <= '0';
--        o_FinSequence_Strobe <= '0';
--        o_reset_cpt <= '0';
    when Lecture =>
        o_ADC_nCS <= '0';
        o_Decale <= '1';
        o_FinSequence_Strobe <= '0';
        o_reset_cpt <= '0';
    when Confirmation =>
        o_ADC_nCS <= '1';
        o_Decale <= '0';
        o_FinSequence_Strobe <= '1';
        o_reset_cpt <= '1';
    when others =>
        o_ADC_nCS <= '0';
        o_Decale <= '0';
        o_FinSequence_Strobe <= '0';
        o_reset_cpt <= '0';
    end case;
end process;
 
end Behavioral;
