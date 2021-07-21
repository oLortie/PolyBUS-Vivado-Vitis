----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/18/2021 07:45:50 PM
-- Design Name: 
-- Module Name: CalculMensonge_tb - Behavioral
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

entity CalculMensonge_tb is
--  Port ( );
end CalculMensonge_tb;

architecture Behavioral of CalculMensonge_tb is

    component kcpsm6 is
    generic(               hwbuild : std_logic_vector(7 downto 0) := X"00";
                  interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
           scratch_pad_memory_size : integer := 64);
    port (                 address : out std_logic_vector(11 downto 0);
                       instruction : in std_logic_vector(17 downto 0);
                       bram_enable : out std_logic;
                           in_port : in std_logic_vector(7 downto 0);
                          out_port : out std_logic_vector(7 downto 0);
                           port_id : out std_logic_vector(7 downto 0);
                      write_strobe : out std_logic;
                    k_write_strobe : out std_logic;
                       read_strobe : out std_logic;
                         interrupt : in std_logic;
                     interrupt_ack : out std_logic;
                             sleep : in std_logic;
                             reset : in std_logic;
                               clk : in std_logic);
    end component;
    
    component CalculMensonge is
    generic(             C_FAMILY : string := "S6"; 
                C_RAM_SIZE_KWORDS : integer := 1;
             C_JTAG_LOADER_ENABLE : integer := 0);
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    rdl : out std_logic;                    
                    clk : in std_logic);
    end component;

    --
    -- Signals for connection of KCPSM6 and Program Memory.
    --
    
    signal       sys_clock : std_logic := '0';
    
    signal         address : std_logic_vector(11 downto 0);
    signal     instruction : std_logic_vector(17 downto 0);
    signal     bram_enable : std_logic;
    signal         in_port : std_logic_vector(7 downto 0);
    signal        out_port : std_logic_vector(7 downto 0);
    signal         port_id : std_logic_vector(7 downto 0);
    signal    write_strobe : std_logic;
    signal  k_write_strobe : std_logic;
    signal     read_strobe : std_logic;
    signal       interrupt : std_logic;
    signal   interrupt_ack : std_logic;
    signal    kcpsm6_sleep : std_logic;
    signal    kcpsm6_reset : std_logic;
    
    --
    -- Signaux de simulation
    --
    signal d_param_bpm_sim          : std_logic_vector(11 downto 0);
    signal d_param_respiration_sim  : std_logic_vector(11 downto 0);
    signal d_param_perspiration_sim : std_logic_vector(11 downto 0);
    signal d_param_mensonge_sim     : std_logic_vector(7 downto 0);
    
begin

        
    processor: kcpsm6
    generic map (                 
        hwbuild => X"00", 
        interrupt_vector => X"3FF",
        scratch_pad_memory_size => 64) -- other options are 128, 256
    port map(      
                   address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => sys_clock
           );
           
    kcpsm6_sleep <= '0';
    interrupt <= interrupt_ack;
    
    program_rom: CalculMensonge                     --Name to match your PSM file
    generic map(             
            C_FAMILY => "7S",                       --Family 'S6', 'V6' or '7S'
            C_RAM_SIZE_KWORDS => 2,                 --Program size '1', '2' or '4'
            C_JTAG_LOADER_ENABLE => 0               --Include JTAG Loader when set to '1' 
               )      
    port map(      
               address => address,      
           instruction => instruction,
                enable => bram_enable,
                   rdl => kcpsm6_reset,
                   clk => sys_clock
              );
              
    --========================================================
    -- INPUT PORTS
    --========================================================
    input_ports: process(sys_clock)
      begin
        if sys_clock'event and sys_clock = '1' then
    
          case port_id(2 downto 0) is
            when "000" =>    in_port <= d_param_bpm_sim(7 downto 0); -- BPM
            when "001" =>    in_port <= d_param_respiration_sim(7 downto 0); -- RESPIRATION LOW
            when "010" =>    in_port <= "0000" & d_param_respiration_sim(11 downto 8); -- RESPIRATION HIGH
            when "011" =>    in_port <= d_param_perspiration_sim(7 downto 0);
            when "100" =>    in_port <= "00000000";
            when "101" =>    in_port <= "00000000";
       
            when others =>    in_port <= "XXXXXXXX";  
    
          end case;
    
        end if;
    
      end process input_ports;
      
    output_ports: process(sys_clock)
    begin  
      if sys_clock'event and sys_clock = '1' then
        -- 'write_strobe' is used to qualify all writes to general output ports.
        if write_strobe = '1' then
          if port_id = "00000110" then -- port 06
            d_param_mensonge_sim <= out_port(7 downto 0);
          end if;
        end if;
      end if; 
  
    end process output_ports;
    
    sys_clk_process : process
    begin
        wait for 5ns;
            sys_clock <= not sys_clock;
    end process;
    
    tb : process
    begin
        wait for 43 us; -- pour laisser le temps au module de se setter
        wait for 10 us;
            d_param_bpm_sim <= "000001010101"; -- 85 : 70 BPM
            d_param_respiration_sim <= "000110010000"; -- 400 : 0.25 Hz
            d_param_perspiration_sim <= "000000000000";
        wait;
    
    end process;


end Behavioral;
