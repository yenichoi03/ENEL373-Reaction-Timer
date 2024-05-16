----------------------------------------------------------------------------------
-- Title: Pseudo Random Number Generator
-- Authors: EWB, YYC, & MWD
-- Date: 2024
-- Description: This component generates a pseudorandom number on every clock edge
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PRNG is
    Port (  CLK : in std_logic;                               -- Clock input
            RANDOM : out integer range 0 to 5000);            -- Pseudo random integer output 
end PRNG;

architecture Behavioral of PRNG is

    signal trigger : std_logic_vector(3 downto 0) := "0001";  -- Aribtrary starting seed
    
begin

    randomise: process (clk)
    begin        
        if rising_edge(clk) then 
            trigger <= trigger(2 downto 0) & (trigger(3) xor trigger(1)); 
        end if;
    end process randomise;
    
    random <= 500 * TO_INTEGER(UNSIGNED(trigger(3 downto 0))); -- Scaled to a reasonable delay time
    
end Behavioral;
