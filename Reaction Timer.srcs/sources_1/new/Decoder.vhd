----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 10:18:04
-- Design Name: 
-- Module Name: Decoder - Behavioral
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

--This selects which anode of the 7 segment display to be enabled
entity decoder is
    Port ( DISPLAY_SELECTED : in STD_LOGIC_VECTOR (2 downto 0);             --The selected 7 segment 
           ANODE : out STD_LOGIC_VECTOR (7 downto 0):="11111111");
end decoder;

architecture Behavioral of decoder is
begin
    decode: process (DISPLAY_SELECTED) is
    begin
        ANODE <= "11111111";
        if DISPLAY_SELECTED = "000" then
            ANODE <= "11111110";
        elsif DISPLAY_SELECTED = "001" then
            ANODE <= "11111101";
        elsif DISPLAY_SELECTED = "010" then
            ANODE <= "11111011";
        elsif DISPLAY_SELECTED = "011" then
            ANODE <= "11110111";
        elsif DISPLAY_SELECTED = "100" then
            ANODE <= "11101111";
        elsif DISPLAY_SELECTED = "101" then
            ANODE <= "11011111";
        elsif DISPLAY_SELECTED = "110" then
            ANODE <= "10111111";
        elsif DISPLAY_SELECTED = "111" then
            ANODE <= "01111111";               
        else
            ANODE <= "11111111";
        end if;
    end process decode;
end Behavioral;

