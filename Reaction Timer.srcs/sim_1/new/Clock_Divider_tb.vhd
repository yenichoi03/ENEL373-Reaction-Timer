library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_divider_tb is
end clock_divider_tb;

architecture Behavioral of clock_divider_tb is

signal UPPERBOUND : STD_LOGIC_VECTOR (27 downto 0) := "0000000000000100001001000000";
signal CLK : STD_LOGIC := '1';
signal SLOWCLK : STD_LOGIC;

begin

    CLK <= not CLK after 5ns;
    
    inst_clock_divider: entity work.clock_divider(Behavioral)
    port map(CLK=>CLK, UPPERBOUND=>UPPERBOUND, SLOWCLK =>SLOWCLK);
    
end Behavioral;
