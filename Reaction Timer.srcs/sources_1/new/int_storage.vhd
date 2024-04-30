----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2024 17:07:18
-- Design Name: 
-- Module Name: int_storage - Behavioral
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

entity int_storage is
    Port (  time_in : in std_logic_vector (15 downto 0);
            time_a, time_b, time_c: inout integer := 0);
end int_storage;

architecture Behavioral of int_storage is
    
    signal new_time : INTEGER := 0;
    signal thous, hunds, tens, ones : INTEGER := 0;

begin

    thous <= TO_INTEGER(UNSIGNED(time_in(15 downto 12)));
    hunds <= TO_INTEGER(UNSIGNED(time_in(11 downto 8)));
    tens <= TO_INTEGER(UNSIGNED(time_in(7 downto 4)));
    ones <= TO_INTEGER(UNSIGNED(time_in(3 downto 0)));
    new_time <= (thous *1000) + (hunds*100) + (tens *10) + ones;


end Behavioral;
