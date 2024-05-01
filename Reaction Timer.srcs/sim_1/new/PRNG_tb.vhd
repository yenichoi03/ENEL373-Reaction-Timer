----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2024 13:08:56
-- Design Name: 
-- Module Name: PRNG_tb - Behavioral
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


entity PRNG_tb is
end PRNG_tb;

architecture Behavioral of PRNG_tb is
    signal trigger : STD_LOGIC_VECTOR (3 downto 0);
    signal random : STD_LOGIC_VECTOR (3 downto 0);
    signal prng_en : std_logic := '1';
   
begin

trigger <= "1010" after 150ms; 
trigger <= "1011" after 300ms;  

inst_PRNG : entity work.PRNG(Behavioral)
port map (trigger => trigger, random => random, prng_en => prng_en);

end Behavioral;
