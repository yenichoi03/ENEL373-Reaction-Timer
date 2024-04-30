----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2024 12:04:53
-- Design Name: 
-- Module Name: PRNG - Behavioral
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
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PRNG is
    Port ( random : out STD_LOGIC_VECTOR (3 downto 0);
           trigger : in STD_LOGIC);
end PRNG;

architecture Behavioral of PRNG is
begin
    process (trigger)
    variable num : integer := 78;
    
    begin 
        if num < 150 then
            num := num/5;
            num := num + 21;
        elsif num > 150 then
            num := num/12;
        end if;
        random <= std_logic_vector(to_unsigned(num, 4)) ;
     end process;
    
end Behavioral;
