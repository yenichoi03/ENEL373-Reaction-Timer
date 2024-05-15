----------------------------------------------------------------------------------
-- Title: Display Multiplexer
-- Authors: EWB, YYC, & MWD
-- Date: 2024
-- Description: This component outputs one nibble of the message based on which display is active 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux is
    Port ( DISPLAY_SEL : in STD_LOGIC_VECTOR (2 downto 0);       -- Selects which of the 8 displays is active
           MESSAGE : in STD_LOGIC_VECTOR (31 downto 0);          -- Overall message to be displayed 
           BCD : out STD_LOGIC_VECTOR (3 downto 0);              -- Character to be displayed on the selected display
           DP : out STD_LOGIC);                                  -- High if decimal point should be displayed on selected display
end Mux;

architecture Behavioral of Mux is
    signal nibble: std_logic_vector (3 downto 0) := (others => '0');
    signal dp_enable: std_logic := '0';
begin
    BCD <= nibble;
    DP <= dp_enable;
    multiplex: process (DISPLAY_SEL, MESSAGE) is
    begin
        dp_enable <= '0';
        if DISPLAY_SEL = "000" then              -- Checks for decimal point code from the first 3 displays where dots are displayed
            if MESSAGE(3 downto 0) = x"F" then
                dp_enable <= '1';
            else
                nibble <= MESSAGE(3 downto 0);
            end if;
        elsif DISPLAY_SEL = "001" then
            if MESSAGE(7 downto 4)  = x"F" then
                dp_enable <= '1';
            else
                nibble <= MESSAGE(7 downto 4);
            end if;
        elsif DISPLAY_SEL = "010" then
            if MESSAGE(11 downto 8) = x"F" then
                dp_enable <= '1';
            else
                nibble <= MESSAGE(11 downto 8);
            end if;
        elsif DISPLAY_SEL = "011" then
            nibble <= MESSAGE(15 downto 12);
        elsif DISPLAY_SEL = "100" then
            nibble <= MESSAGE(19 downto 16);
        elsif DISPLAY_SEL = "101" then
            nibble <= MESSAGE(23 downto 20);
        elsif DISPLAY_SEL = "110" then
            nibble <= MESSAGE(27 downto 24);
        elsif DISPLAY_SEL = "111" then
            nibble <= MESSAGE(31 downto 28);
        end if;
    end process multiplex;
end Behavioral;
