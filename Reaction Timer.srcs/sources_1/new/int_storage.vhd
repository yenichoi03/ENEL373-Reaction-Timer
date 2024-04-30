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
            time_a, time_b, time_c: out integer := 0);
end int_storage;

architecture Behavioral of int_storage is
    
    signal new_time : INTEGER := 0;
    signal last_time : INTEGER := 0;
    signal store_en : boolean := false;
    signal ones, tens, hunds, thous : INTEGER := 0;
    signal count : INTEGER := 0;
    
      
begin


    thous <= TO_INTEGER(UNSIGNED(time_in(15 downto 12)));
    hunds <= TO_INTEGER(UNSIGNED(time_in(11 downto 8)));
    tens <= TO_INTEGER(UNSIGNED(time_in(7 downto 4)));
    ones <= TO_INTEGER(UNSIGNED(time_in(3 downto 0)));
    
    new_time <= (thous *1000) + (hunds*100) + (tens *10) + ones;
    


    process(time_in) is
    begin
    if not (time_in = x"0000") then
        if (count = 0) then
            time_a <= new_time;
            count <= count + 1;
        elsif (count = 1) then
            time_b <= new_time;
            count <= count + 1;
        elsif (count = 2) then
            time_c <= new_time;
            count <= 0;
        end if;
    end if;
    end process;

--    time_a <= 2000;
--    time_b <= 1000;
--    time_c <= 3000;
--    time_a <= new_time;
--    time_b <= new_time;
--    time_c <= new_time;
end Behavioral;
