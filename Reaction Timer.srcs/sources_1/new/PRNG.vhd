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
    Port (  clk : in std_logic;
            prng_rst : in std_logic;  
            random : out integer);
end PRNG;

architecture Behavioral of PRNG is
    signal trigger : std_logic_vector(3 downto 0) := "0001";
    
begin

    process (clk, prng_rst)
--    variable num : integer range 0 to 15;       --This variable is so that we don't require a clock
    
    begin 
    if (prng_rst = '1') then 
        trigger <= "0001";      --initialised seed 
            
    elsif rising_edge(clk) then 
        trigger <= trigger(2 downto 0) & (trigger(3) xor trigger(1)); 
        end if;
    end process;
    
    random <= TO_INTEGER(UNSIGNED(trigger(3 downto 0)));
    
end Behavioral;
