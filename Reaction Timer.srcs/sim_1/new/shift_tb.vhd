----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2024 14:54:10
-- Design Name: 
-- Module Name: shift_tb - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift_tb is
--  Port ( );
end shift_tb;

architecture Behavioral of shift_tb is
component shift_reg is
    Port ( time_in : in STD_LOGIC_VECTOR (15 downto 0);
           A,B,C : out INTEGER:=0;
           shift_en, reset : in STD_LOGIC);
end component;

signal t : STD_LOGIC_VECTOR (15 downto 0):= x"0000";
signal A, B, C: INTEGER := 0;
signal shift_en, reset : STD_LOGIC := '0';
begin

shift_en <= not shift_en after 1ns;
process
begin
wait for 2ns;
t <= x"1111";
wait for 3ns;
t <= x"2222";
wait for 1ns;
t <= x"3333";
wait for 2ns; 
t<= x"4444";
end process; 

shift_test : shift_reg port map (reset => reset, shift_en => shift_en, A=>A, B=>B, C=>C, time_in => t);

end Behavioral;
