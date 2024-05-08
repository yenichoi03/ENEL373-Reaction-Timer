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
    signal random1, random2, random3 : integer range 0 to 5000;
    signal prng_en : std_logic := '0';
   
begin
clk <= not clk after 5ns;

process 
begin
    prng_en <= '1'; 
    wait for 10ns;
    prng_en <= '0';
    wait for 20ns;
end process;


inst_PRNG : entity work.PRNG(Behavioral)
port map (random1 => random1, random2 => random2, random3 => random3, clk => clk, prng_en => prng_en);

end Behavioral;
