----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2024 22:41:45
-- Design Name: 
-- Module Name: result_to_bcd_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity result_to_bcd_tb is
--  Port ( );
end result_to_bcd_tb;

architecture Behavioral of result_to_bcd_tb is

signal r : integer := 8765;
signal bcd : STD_LOGIC_VECTOR(15 downto 0);

begin

inst_resulttobcd : entity work.result_to_bcd(Behavioral)
port map (int_result => r, bcd_result => bcd);

end Behavioral;
