----------------------------------------------------------------------------------
-- Title: Display Counter
-- Authors: EWB, YYC, & MWD
-- Date: 2024
-- Description: This component cyclically selects which of the 8 displays is active
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display_Counter is
    Port ( CLK : in STD_LOGIC;                              -- Clock in controls frequency displays are cycled
           COUNT : out std_logic_vector (2 downto 0));      -- Outputs the currently active display
end Display_Counter;

architecture Behavioral of Display_Counter is
    signal count_tmp: std_logic_vector (2 downto 0) := (others => '0');
begin

    COUNT <= count_tmp;
    process (CLK)
    begin

        if count_tmp = "111" then --8th display
            count_tmp <= "000";   --1st display
        
        elsif rising_edge(CLK) then
                count_tmp <= std_logic_vector(unsigned(count_tmp) + 1);
        end if;
    end process;
    
end Behavioral;
