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
           trigger : in STD_LOGIC_VECTOR (3 downto 0);
           prng_en : in std_logic);  -- get this value from Mux: (BCD : out STD_LOGIC_VECTOR (3 downto 0);)
end PRNG;

architecture Behavioral of PRNG is
    
begin

    process (trigger, prng_en)
    variable num : integer range 0 to 15;       --This variable is so that we don't require a clock
    
    begin 
    if (prng_en = '1') then 
        if (trigger = "0000") then
            random <= "1111";
            
        elsif (trigger /= "0000") then 
            num := TO_INTEGER(UNSIGNED(trigger(3 downto 0)));
        
                if num > 7 then
                    num := num - 5;
                    num := num * 2;
                    
                    
                elsif num < 7 then
                    num := num + 2;
                    num := num * 3;
               
                end if;  
           end if;
           
           if prng_en = '1' then 
               random <= std_logic_vector(to_unsigned(num, 4));
           end if;
    end if;
       
    end process;
    
end Behavioral;
