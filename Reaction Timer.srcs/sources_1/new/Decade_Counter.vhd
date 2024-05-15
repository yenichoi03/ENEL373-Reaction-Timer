----------------------------------------------------------------------------------
-- Title: Decade Counter
-- Authors: EWB, YYC, & MWD
-- Date: 2024
-- Description: This component generates one tick out per 10 ticks in and tracks a count between 0 and 9
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decade_counter is
    Port ( EN : in STD_LOGIC;                               --An input signal to enable the counter 
           RESET : in STD_LOGIC;                            --An input signal to reset the counter
           INCREMENT : in STD_LOGIC;                        --The "clock" input signal to count edges from
           COUNT : out STD_LOGIC_VECTOR (3 downto 0);       --An output with the current count between 0 and 9
           TICK : out STD_LOGIC);                           --A clock output that toggles every time the count does a 0-9 cycle
end decade_counter;

architecture Behavioral of decade_counter is
    signal count_tmp: std_logic_vector (3 downto 0) := (others => '0');   
    signal tick_toggle : std_logic := '0';
begin
    COUNT <= count_tmp;
    TICK <= tick_toggle;
    
    counting: process (INCREMENT, RESET)
    begin
        if RESET = '1' then 
            count_tmp <= "0000";
            tick_toggle <= '1';
        elsif rising_edge(INCREMENT) then
            if EN = '1' then                
                if count_tmp = "1001" then
                    count_tmp <= "0000";
                    tick_toggle <= not tick_toggle; 
                elsif count_tmp = "0101" then
                    tick_toggle <= not tick_toggle; 
                    count_tmp <= std_logic_vector(unsigned(count_tmp) + 1);
                else
                    count_tmp <= std_logic_vector(unsigned(count_tmp) + 1);
                end if;
            end if;
        end if;
    end process counting;

end Behavioral;

