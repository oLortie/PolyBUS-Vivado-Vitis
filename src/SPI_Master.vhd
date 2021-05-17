----------------------------------------------------------------------------------
-- Company: PolyBUS
-- Engineer: Charles Lévesque-Matte
-- 
-- Create Date: 05/16/2021 11:23:27 AM
-- Module Name: SPI_Master - Behavioral
-- Target Devices: Zybo Z7 
-- Tool Versions: Vivado 2020.2
-- Description: SPI (Serial Peripheral Interface) Master
-- Creates a master device, send a byte one bit at a time on MOSI
-- receive a byte one bit at a time on MISO. Any data put on tx_BYTE
-- will be sent. Each byte received will be available on rx_BYTE.
-- To start a transaction, one must select a slave. This module supports
-- multibyte transaction. This module wait for o_tx_Ready to send.
-- ************************************************************************
-- The input clk must be 2x faster than the SCLK
-- ************************************************************************
-- SPI mode are : 0, 1, 2, 3:
-- Mode | Clock polarity (CPOL) | Clock Phase
--  0   |          0            |       0
--  1   |          0            |       1
--  2   |          1            |       0
--  3   |          1            |       1
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Auto-Synch on SCLK would be a nice feature.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SPI_Master is
    Port ( MISO : in STD_LOGIC;
           MOSI : out STD_LOGIC;
           SCLK : out STD_LOGIC;
           n_SS : out STD_LOGIC_VECTOR (2 downto 0)
           );
end SPI_Master;

architecture Behavioral of SPI_Master is

-- Signals declaration here
begin


end Behavioral;
