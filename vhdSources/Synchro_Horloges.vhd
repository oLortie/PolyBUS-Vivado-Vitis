---------------------------------------------------------------------------------------------
--	Synchro_Horloges.vhd 
---------------------------------------------------------------------------------------------
--	Generation d'horloge et de signaux de synchronisation
---------------------------------------------------------------------------------------------
--	Université de Sherbrooke - Département de GEGI
--	
--	Version 		: 3.0				
--	Auteur(s)		: Daniel Dalle
--                    Larissa Njejimana(adaptation 20-02-2019)
--  Outils          : vivado 2019.1 64 bits
--	
--------------------------------
--	Description
--------------------------------
-- Génération de signaux de synchronisation, incluant des "strobes"
---------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;     -- requis pour les constantes  etc.
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs

Library UNISIM;
use UNISIM.vcomponents.all;


entity Synchro_Horloges is
generic (const_CLK_syst_MHz: integer := 100); 
    Port ( 
           clkm         : in STD_LOGIC;      -- Entrée  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
           o_S_5MHz     : out  STD_LOGIC;    -- source horloge divisee   (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
           o_clk_5MHz   : out  STD_LOGIC;    -- horlgoe via bufg
           o_S_100Hz    : out  STD_LOGIC;    -- source horloge 100 Hz : out  STD_LOGIC;   -- (100  Hz approx:  99,952 Hz) 
           o_stb_100Hz  : out  STD_LOGIC;    -- strobe durée 1/clk_5mHz aligne sur front 100Hz
           o_S_1Hz      : out  STD_LOGIC     -- Signal temoin 1 Hz
     );                    
end Synchro_Horloges;

architecture Behavioral of Synchro_Horloges is
 
 constant CLKp_MHz_des : integer := 5; --MHz
 constant constante_diviseur_p: integer  :=(const_CLK_syst_MHz/(2*CLKp_MHz_des));   -- quand on fait toggle sur le signal Clkp5MHzint
 constant cdiv1 : std_logic_vector(3  downto 0):= conv_std_logic_vector(constante_diviseur_p, 4);     
 constant cdiv2 : std_logic_vector(4 downto 0):= conv_std_logic_vector   (25, 5) ;     -- overflow a Clkp5MHzint/26 = 192.3 kHz  soit 5.2 us
 constant cdiv3 : std_logic_vector(15 downto 0):= conv_std_logic_vector (1848, 16) ;   -- overflow a Clk200kHzInt / 1924 = 99.952 = ~100 Hz soit 10.005 ms (t réel)
 constant cdiv4 : std_logic_vector(7 downto 0):= conv_std_logic_vector  (99, 8) ;      -- o_S1Hz = o_clk3 / 100    =  1 Hz soit 1 s
  

signal ValueCounter5MHz     : std_logic_vector(4 downto 0)   := "00000";
signal ValueCounter200kHz   : std_logic_vector(4 downto 0)   := "00000";
signal ValueCounter100Hz    : std_logic_vector(15 downto 0)  := "0000000000000000";
signal ValueCounter1Hz      : std_logic_vector(7 downto 0)   := "00000000";

 signal clk_5MHzInt         : std_logic := '0';
 
 signal q_s5MHzInt          : std_logic := '0';
 signal q_s1HzInt           : std_logic := '0' ;
 signal q_s100HzInt         : std_logic := '0' ;  
 signal q_strobe100HzInt    : std_logic := '0';
 signal q_s100HzInt_5M     : std_logic := '0';
 

begin

ClockBuffer: bufg
port map(
	I	=> q_s5MHzInt,
	O	=> clk_5MHzInt
	);


o_clk_5MHz <= clk_5MHzInt;
o_S_5MHz   <= q_s5MHzInt;
o_S_100Hz  <= q_s100HzInt;
o_S_1Hz    <= q_s1HzInt;
o_stb_100Hz <=  q_strobe100HzInt;

DiviseurHorloge: process(clkm)
begin
   if(clkm'event and clkm = '1') then
       ValueCounter5MHz <= ValueCounter5MHz + 1;
       if (ValueCounter5MHz = cdiv1) then               -- evenement se produit aux 100 approx ns
            ValueCounter5MHz <= "00000";
            q_s5MHzInt <= Not q_s5MHzInt;	            -- pour generer horloge a exterieur du module (prevoir bufg)	
            ValueCounter200kHz <= ValueCounter200kHz + 1;
            if (ValueCounter200kHz = cdiv2) then        -- evenement se produit aux 5 us approx
                 ValueCounter200kHz <= "00000";
                 ValueCounter100Hz <= ValueCounter100Hz + 1;
                 if (ValueCounter100Hz = cdiv3) then    -- evenement se produit aux 5 ms  approx
                      ValueCounter100Hz <= "0000000000000000";
                      q_s100HzInt <= Not q_s100HzInt;
                      ValueCounter1Hz <= ValueCounter1Hz + 1;
                      if (ValueCounter1Hz = cdiv4) then -- evenement se produit aux 500 ms approx
                          ValueCounter1Hz <= "00000000";
                          q_s1HzInt <= Not q_s1HzInt;
                      end if;
                 end if;
            end if;						
		end if;
	end if;
end process;

GenererStrobe100Hz: process(clk_5MHzInt)  
begin
	if(clk_5MHzInt'event and clk_5MHzInt = '1') then
		q_s100HzInt_5M <= q_s100HzInt;
		q_strobe100HzInt <= q_s100HzInt and not(q_s100HzInt_5M);
	end if;
end process;

end Behavioral;
