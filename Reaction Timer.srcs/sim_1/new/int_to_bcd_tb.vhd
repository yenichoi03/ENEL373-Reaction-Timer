----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2024 22:09:36
-- Design Name: 
-- Module Name: int_storage_tb - Behavioral
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

entity int_storage_tb is
--  Port ( );
end int_storage_tb;

architecture Behavioral of int_to_bcd is

signal bcd : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal r : INTEGER := 8765;


begin


inst_to_bcd : entity work.result_to_bcd(Behavioral)
port map (int_result => r, bcd_result => bcd);

end Behavioral;