----------------------------------------------------------------------------------
-- Title: Clock Divider
-- Authors: EWB, YYC, & MWD
-- Date: 2024
-- Description: This component converts the input clock signal to a lower frequency clock signal
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
        Port ( CLK : in STD_LOGIC;                              -- Original frequency clock input
               UPPERBOUND : in STD_LOGIC_VECTOR (27 downto 0);  -- Number of rising clock edges per output clock edge
               SLOWCLK : out STD_LOGIC);                        -- Reduced frequency output clock signal
end clock_divider;

architecture Behavioral of clock_divider is
    signal count: std_logic_vector (27 downto 0) := (others => '0');
    signal slow: std_logic := '1';
begin

    SLOWCLK <= slow;
    
    process (CLK)
    begin
        if rising_edge(CLK) then
            if count = UPPERBOUND then
                count <= (others => '0');
                slow <= not slow;
            else
                count <= std_logic_vector(unsigned(count) + 1);
            end if;
        end if;
    end process;
    
end Behavioral;

