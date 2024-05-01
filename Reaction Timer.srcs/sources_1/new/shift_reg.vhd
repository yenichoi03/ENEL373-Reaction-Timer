----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2024 22:49:08
-- Design Name: 
-- Module Name: shift_reg - Behavioral
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

entity shift_reg is
    Port ( time_in : in STD_LOGIC_VECTOR (15 downto 0);
           A_prev, B_prev: in INTEGER;
           A,B, C : out INTEGER:=0;
           shift_en : in STD_LOGIC);
end shift_reg;

architecture Behavioral of shift_reg is

signal new_time : INTEGER := 0;
signal thous, hunds, tens, ones : INTEGER := 0;
    
begin

thous <= TO_INTEGER(UNSIGNED(time_in(15 downto 12)))*1000;
hunds <= TO_INTEGER(UNSIGNED(time_in(11 downto 8)))*100;
tens <= TO_INTEGER(UNSIGNED(time_in(7 downto 4)))*10;
ones <= TO_INTEGER(UNSIGNED(time_in(3 downto 0)))*1;

new_time <= thous + hunds + tens + ones;

process(shift_en)

begin
if(rising_edge(shift_en)) then
    A <= new_time;
    B <= A_prev;
    C <= B_prev;
end if;

end process;


end Behavioral;
