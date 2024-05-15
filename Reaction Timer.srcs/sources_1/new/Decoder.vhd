----------------------------------------------------------------------------------
-- Title: Anode Decoder
-- Authors: EWB, YYC, & MWD
-- Date: 2024
-- Description: This component activates the anode for the active display
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decoder is
    Port ( DISPLAY_SEL : in STD_LOGIC_VECTOR (2 downto 0);   -- Selects which of the 8 displays is active
           ANODE : out STD_LOGIC_VECTOR (7 downto 0));       -- Activates corresponding anode
end decoder;

architecture Behavioral of decoder is
begin
    decode: process (DISPLAY_SEL) is
    begin
        ANODE <= "11111111";
        if DISPLAY_SEL = "000" then
            ANODE <= "11111110";
        elsif DISPLAY_SEL = "001" then
            ANODE <= "11111101";
        elsif DISPLAY_SEL = "010" then
            ANODE <= "11111011";
        elsif DISPLAY_SEL = "011" then
            ANODE <= "11110111";
        elsif DISPLAY_SEL = "100" then
            ANODE <= "11101111";
        elsif DISPLAY_SEL = "101" then
            ANODE <= "11011111";
        elsif DISPLAY_SEL = "110" then
            ANODE <= "10111111";
        elsif DISPLAY_SEL = "111" then
            ANODE <= "01111111";               
        else
            ANODE <= "11111111";
        end if;
    end process decode;
end Behavioral;

