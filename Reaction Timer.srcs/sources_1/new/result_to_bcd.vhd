----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2024 17:18:40
-- Design Name: 
-- Module Name: Int_to_BCD - Behavioral
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


entity result_to_BCD is
    Port ( int_result : in integer;                             -- Interger result from ALU 
           bcd_result : out std_logic_vector(15 downto 0));     -- BCD conversion of resultjhf
end result_to_BCD;

architecture Behavioral of result_to_BCD is

begin
process(int_result)
variable mils, hunds, tens, ones: INTEGER := 0;
begin
mils := int_result/1000;
hunds := (int_result - mils*1000)/100;
tens := (int_result - mils*1000 - hunds*100)/10;
ones := (int_result - mils*1000 - hunds*100 - tens*10);

bcd_result <= STD_LOGIC_VECTOR(to_unsigned(mils, 4)) & STD_LOGIC_VECTOR(to_unsigned(hunds, 4)) & STD_LOGIC_VECTOR(to_unsigned(tens, 4)) & STD_LOGIC_VECTOR(to_unsigned(ones, 4));
end process;
end Behavioral;
