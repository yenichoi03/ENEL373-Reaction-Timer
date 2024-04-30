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
            sel : in std_logic_vector(2 downto 0);
            time_a, time_b, time_c: out integer := 0);
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

    process(time_in, sel) is
    begin
    if not (time_in = x"0000") then
        if (sel = "001") then
            time_a <= 100;
        elsif(sel = "010") then
            time_b <= 500;
        elsif (sel = "100") then
            time_c <= 300;
        end if;
    end if;
    end process;
end Behavioral;
