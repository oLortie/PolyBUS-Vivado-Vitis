----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/15/2021 03:39:55 PM
-- Design Name: 
-- Module Name: Calcul_pression - Behavioral
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

entity Calcul_pression is
    Port ( 
           i_strobe : in std_logic;
           i_signal : in STD_LOGIC_VECTOR (11 downto 0);
           i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           o_pression_sanguine : out STD_LOGIC_VECTOR (11 downto 0);
           o_enable : out STD_LOGIC);
end Calcul_pression;

architecture Behavioral of Calcul_pression is

component DLatch1 is 
Port ( write_enable : in STD_LOGIC;
           i_signal : in STD_LOGIC_VECTOR (11 downto 0);
           o_signal : out STD_LOGIC_VECTOR (11 downto 0);
           clk : in STD_LOGIC);
end component;

component MEF is
    Port ( i_signal : in STD_LOGIC_VECTOR (11 downto 0);
           i_strobe : in std_logic;
           clk : in STD_LOGIC;
           o_write_enable1 : out STD_LOGIC;
           i_previous : in STD_LOGIC_VECTOR (11 downto 0);
           o_latch : out STD_LOGIC_VECTOR (11 downto 0);
           o_latch_previous : out STD_LOGIC_VECTOR (11 downto 0);
           o_write_enable2 : out STD_LOGIC;
         
         
           o_signal_ready : out STD_LOGIC;
           i_reset : in STD_LOGIC;
           o_enable_previous : out STD_LOGIC);
end component;

component moyenne is
    Port ( clk       : in std_logic;
           i_signal1 : in STD_LOGIC_VECTOR (11 downto 0);
           i_signal2 : in STD_LOGIC_VECTOR (11 downto 0);
           o_pressionSanguine : out STD_LOGIC_VECTOR (11 downto 0));
end component;

signal s_MEFtoLatch : std_logic_vector (11 downto 0);
signal s_MEFtoLatchPrev : std_logic_vector (11 downto 0);
signal s_LatchtoMoy1 : std_logic_vector (11 downto 0);
signal s_LatchtoMoy2 : std_logic_vector (11 downto 0);
signal s_write_enable1 : std_logic;
signal s_write_enable2 : std_logic;
signal s_MEFtoPrev : std_logic_vector (11 downto 0);
signal s_previous : std_logic_vector (11 downto 0);
signal s_enable_previous : std_logic;
begin

inst_DLatch1 : DLatch1
port map(
        write_enable => s_write_enable1,
        i_signal => s_MEFtoLatch,
        o_signal => s_LatchtoMoy1,
        clk => i_clk
);

inst_DLatch2 : DLatch1
port map(
        write_enable => s_write_enable2,
        i_signal => s_MEFtoLatch,
        o_signal => s_LatchtoMoy2,
        clk => i_clk
);

inst_moyenne : moyenne
port map( clk => i_clk,
        i_signal1 => s_LatchtoMoy1,
        i_signal2 => s_LatchtoMoy2,
        o_pressionSanguine => o_pression_sanguine
);

inst_MEF : MEF
port map(
           i_strobe => i_strobe,
           i_signal => i_signal,
           i_previous => s_previous,
           clk => i_clk,
           o_write_enable1 => s_write_enable1,          
           o_latch => s_MEFtoLatch,
           o_latch_previous => s_MEFtoLatchPrev,
           o_write_enable2 => s_write_enable2,
           o_signal_ready => o_enable,
           o_enable_previous => s_enable_previous,
           i_reset => i_reset
);

inst_DLatchPrev : DLatch1
port map(
        write_enable => s_enable_previous,
        i_signal => s_MEFtoLatchPrev,
        o_signal => s_previous,
        clk => i_clk
);
end Behavioral;
