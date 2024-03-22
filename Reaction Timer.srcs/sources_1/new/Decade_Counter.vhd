----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 10:19:58
-- Design Name: 
-- Module Name: Decade_Counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

--Another counter to be decoded in bcd_to_7seg in order to output a timer
entity decade_counter is
    Port ( EN : in STD_LOGIC;                               --An input signal to enable the counter 
           RESET : in STD_LOGIC;                            --An input signal to reset the counter
           INCREMENT : in STD_LOGIC;                        --The "clock" input signal to count edges from
           COUNT : out STD_LOGIC_VECTOR (3 downto 0);       --An output with the current count
           TICK : out STD_LOGIC);                           --A clock output that toggles every time the count does a 0-9 cycle
end decade_counter;

architecture Behavioral of decade_counter is
    signal count_tmp: std_logic_vector (3 downto 0) := (others => '0');     --This is for the couput of current count 
    signal tick_toggle : std_logic := '0';
begin
    COUNT <= count_tmp;
    TICK <= tick_toggle;
    
    process (INCREMENT)
    begin
        if RESET = '1' then 
            count_tmp <= "0000";
            tick_toggle <= '1';
        elsif rising_edge(INCREMENT) then
            if EN = '1' then                    --turn this when you  press BTNC and warning state 
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
    end process;

end Behavioral;

