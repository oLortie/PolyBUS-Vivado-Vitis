----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/04/2021 03:44:24 AM
-- Design Name: 
-- Module Name: MEF - Behavioral
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

entity MEF is
    Port ( i_signal : in STD_LOGIC_VECTOR (11 downto 0);
           i_previous : in STD_LOGIC_VECTOR (11 downto 0);
           clk : in STD_LOGIC;
           o_write_enable1 : out STD_LOGIC;
           i_strobe : in STD_LOGIC;
           o_latch_previous : out STD_LOGIC_VECTOR (11 downto 0);
           o_latch : out STD_LOGIC_VECTOR (11 downto 0);
           o_write_enable2 : out STD_LOGIC;
           o_signal_ready : out STD_LOGIC;
           i_reset       : in STD_LOGIC;
           o_enable_previous : out STD_LOGIC);
end MEF;

architecture Behavioral of MEF is
    type State_type is(Growing1, F1_1, F2_1, F3_1, Falling1, G1_1, G2_1, G3_1, Growing2, F1_2, F2_2, F3_2, Falling2, G1_2, G2_2, G3_2);
    signal s_signal : STD_LOGIC_VECTOR (11 downto 0);
    signal s_previous : STD_LOGIC_VECTOR (11 downto 0);
    signal S_reg, S_next : State_type;
begin

process (clk, i_reset)
begin
    if (i_reset = '1') then
        
        s_previous <= "000000000000";
        --o_latch <= s_previous;
       -- s_signal <= "000000000000";
        --o_latch <= "000000000000";
        
        
        --o_enable_previous <= '0';
        S_reg <= Growing1;
    end if;
    
    if (rising_edge(clk) and not(i_reset = '1')) then
        --o_latch <= i_signal;
        
        
        
        if (i_strobe = '1' ) then
            o_enable_previous <= '1';
        else
            o_enable_previous <= '0';
        end if;
        
        s_previous <= i_previous;
        S_reg <= S_next;
    end if;
    
    
end process;



process (i_signal, S_reg)
begin
if i_strobe = '1' then
    
    case S_reg is
        when Growing1 =>
            if i_signal < i_previous then
                S_next <= F1_1;
            else
                S_next <= Growing1;
            end if;       
        when F1_1 =>
            if i_signal < i_previous then
                S_next <= F2_1;
            else
                S_next <= Growing1;
            end if; 
        when F2_1 =>
            if i_signal < i_previous then
                S_next <= F3_1;
            else
                S_next <= Growing1;
            end if; 
        when F3_1 =>            
            S_next <= Falling1; 
        when Falling1 =>
            if i_signal > i_previous then
                S_next <= G1_1;
            else
                S_next <= Falling1;
            end if;
        when G1_1 =>
            if i_signal > i_previous then
                S_next <= G2_1;
            else
                S_next <= Falling1;
            end if;
        when G2_1 =>
            if i_signal > i_previous then
                S_next <= G3_1;
            else
                S_next <= Falling1;
            end if;
        when G3_1 =>
            S_next <= Growing2;
        when Growing2 =>
            if i_signal < i_previous then
                S_next <= F1_2;
            else
                S_next <= Growing2;
            end if;       
        when F1_2 =>
            if i_signal < i_previous then
                S_next <= F2_2;
            else
                S_next <= Growing2;
            end if; 
        when F2_2 =>
            if i_signal < i_previous then
                S_next <= F3_2;
            else
                S_next <= Growing2;
            end if; 
        when F3_2 =>            
            S_next <= Falling2; 
        when Falling2 =>
            if i_signal > i_previous then
                S_next <= G1_2;
            else
                S_next <= Falling2;
            end if;
        when G1_2 =>
            if i_signal > i_previous then
                S_next <= G2_2;
            else
                S_next <= Falling2;
            end if;
        when G2_2 =>
            if i_signal > i_previous then
                S_next <= G3_2;
            else
                S_next <= Falling2;
            end if;
        when G3_2 =>
            S_next <= Growing1;
        when others =>
            S_next <= Growing1;
    end case;
  end if;
  
  o_latch <= s_previous; 
  
  o_latch_Previous <= i_signal; 
end process;

process(S_reg)
begin
    case S_reg is
        when Growing1 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0';  
        when F1_1 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '1';  
            o_write_enable2 <= '0'; 
        when F2_1 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0'; 
        when F3_1 =>            
            o_signal_ready <= '1';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0'; 
        when Falling1 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0'; 
        when G1_1 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0'; 
        when G2_1 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0'; 
        when G3_1 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0'; 
        when Growing2 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0';        
        when F1_2 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '1'; 
        when F2_2 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0';  
        when F3_2 =>            
            o_signal_ready <= '1';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0';  
        when Falling2 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0'; 
        when G1_2 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0'; 
        when G2_2 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0'; 
        when G3_2 =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0'; 
        when others =>
            o_signal_ready <= '0';   
            o_write_enable1 <= '0';  
            o_write_enable2 <= '0'; 
    end case;
    
end process;
end Behavioral;

