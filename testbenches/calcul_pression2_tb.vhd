----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2021 04:14:10 PM
-- Design Name: 
-- Module Name: calcul_pression2_tb - Behavioral
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
use work.PolyBUS_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity calcul_pression2_tb is
--  Port ( );
end calcul_pression2_tb;

architecture Behavioral of calcul_pression2_tb is

    component calcul_pression2 is
    Port ( clk : in STD_LOGIC;
           i_en : in STD_LOGIC;
           i_echantillon : in STD_LOGIC_VECTOR (11 downto 0);
           i_reset : in STD_LOGIC;
           o_result : out STD_LOGIC_VECTOR (11 downto 0));
    end component;
    
    signal clk_sim : std_logic := '1';
    signal i_en_sim : std_logic := '1';
    signal i_reset_sim : std_logic := '0';
    signal i_echantillon_sim : std_logic_vector(11 downto 0) := "000000000000";
    signal o_result_sim : std_logic_vector(11 downto 0);
    
    signal d_compteur100 : integer range 0 to 500 := 0;
    
begin

    uut : calcul_pression2
    Port Map (
        clk => clk_sim,
        i_en => i_en_sim,
        i_reset => i_reset_sim,
        i_echantillon => i_echantillon_sim,
        o_result => o_result_sim
        );
    
    clock_process : process
    begin
        wait for 100ns;
            clk_sim <= not clk_sim;
    end process;
    
    strobe_process : process
    begin
        wait for 200 ns;
            i_en_sim <= '0';
        wait for 9800us;
            i_en_sim <= '1';
    end process;
    
    tb : process
    begin
        wait for 10 ms;
        
        i_echantillon_sim <= mem_pre12080(d_compteur100);
            
        if d_compteur100 = 99 then
            d_compteur100 <= 0;
        else
            d_compteur100 <= d_compteur100 + 1;
        end if;
    end process;
    
    


end Behavioral;
