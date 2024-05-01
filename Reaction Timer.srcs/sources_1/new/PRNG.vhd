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
           trigger_prev : in std_logic_vector (3 downto 0);
           trigger : in STD_LOGIC_VECTOR (3 downto 0);
           prng_en : in std_logic := '1'); -- get this value from Mux: (BCD : out STD_LOGIC_VECTOR (3 downto 0);)
end PRNG;

architecture Behavioral of PRNG is

    signal num : integer := 0;
    signal initial_num : std_logic_vector := "1010";
    
begin
    process (trigger, trigger_prev, prng_en)
    begin 
    num <= TO_INTEGER(UNSIGNED(trigger(3 downto 0)));
    random <= trigger_prev;
        if num > 7 then
            num <= num - 5;
            num <= num * 2;
            
        elsif num < 7 then
            num <= num + 2;
            num <= num * 3;
        end if;
         
        if rising_edge(prng_en) then 
            random <= std_logic_vector(to_unsigned(num, 4));
        end if; 
     end process;
    
end Behavioral;
