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
    signal clk : std_logic := '0';
    signal random : integer;
    signal prng_rst : std_logic := '1';
   
begin
clk <= not clk after 5ns;

process (prng_rst) 
begin
    prng_rst <= not prng_rst after 50ns;
end process;

inst_PRNG : entity work.PRNG(Behavioral)
port map (random => random, clk => clk, prng_rst => prng_rst);

end Behavioral;
