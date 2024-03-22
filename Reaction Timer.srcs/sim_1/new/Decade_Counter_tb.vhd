library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decade_counter_tb is
end decade_counter_tb;

architecture Behavioral of decade_counter_tb is
    signal RESET: std_logic := '0';
    signal INCREMENT : std_logic := '0';
    signal EN : std_logic := '1';
    signal COUNT: std_logic_vector (3 downto 0) := (others => '0');      
    signal TICK : STD_LOGIC; 
    
begin

INCREMENT <= not INCREMENT after 5ns;

inst_decade_counter_tb : entity work.decade_counter(Behavioral)
port map (EN => EN, INCREMENT=>INCREMENT, COUNT=>COUNT, TICK=>TICK, RESET=>RESET);

end Behavioral;
