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


entity int_storage_tb is
end int_storage_tb;

architecture Behavioral of int_storage_tb is

signal t : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal a,b,c : INTEGER := 0;
signal toggle : STD_LOGIC := '0';

begin

toggle <= not toggle after 5ns;
process(toggle)
begin
if(toggle = '1') then
    t <= x"6666";
else
    t <= x"8888";
end if;
end process;

inst_storage : entity work.int_storage(Behavioral)
port map (time_in => t, time_a => A, time_b => B, time_c => C);

end Behavioral;