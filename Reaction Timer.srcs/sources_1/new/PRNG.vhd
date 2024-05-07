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
            counter_rst : in STD_LOGIC := '0';
            random1, random2, random3 : out integer range 0 to 5000);
end PRNG;

architecture Behavioral of PRNG is
    signal trigger1 : std_logic_vector(3 downto 0) := "0001";
    signal trigger2 : std_logic_vector(3 downto 0) := "0010";
    signal trigger3 : std_logic_vector(3 downto 0) := "0100";
    
begin

    process (clk, prng_rst, counter_rst)
    
    begin 
    if (prng_rst = '1') then 
        trigger1 <= "0001";      --initialised seed 
            
    elsif rising_edge(clk) then 
        trigger1 <= trigger1(2 downto 0) & (trigger1(3) xor trigger1(1));
        trigger2 <= trigger2(2 downto 0) & (trigger2(3) xor trigger2(1));
        trigger3 <= trigger3(2 downto 0) & (trigger3(3) xor trigger3(1));
        
        if (counter_rst = '1') then  
            random1 <= 500 * TO_INTEGER(UNSIGNED(trigger1(3 downto 0)));
            random2 <= 500 * TO_INTEGER(UNSIGNED(trigger2(3 downto 0)));
            random3 <= 500 * TO_INTEGER(UNSIGNED(trigger3(3 downto 0)));
            end if;
    end if;
end process;
    

    
end Behavioral;
