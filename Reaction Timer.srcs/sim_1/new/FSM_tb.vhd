library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_tb is
end FSM_tb;

-----------------------------------------------------------------
-- Run simulation for at least 110 us (scaled by 100000) i.e. 11 seconds
-----------------------------------------------------------------

architecture Behavioral of FSM_tb is

signal fake_clk : STD_LOGIC := '0';


component FSM is
    Port ( CLK, RST: in STD_LOGIC;
           BTN : in STD_LOGIC := '0';                                  -- This is also used as a reset as well
           COUNT_1,COUNT_2,COUNT_3,COUNT_4 : in STD_LOGIC_VECTOR (3 downto 0);  -- uses one segment of the 7 segment display 
           counter_en, counter_rst : out STD_LOGIC := '0'; 
           message : out STD_LOGIC_VECTOR (31 downto 0));       -- each nibble of message represent one character or digit on a 7 segment display.
    end component;

signal enable, reset, button, counter_en, counter_rst : STD_LOGIC := '0';
signal COUNT_1,COUNT_2,COUNT_3,COUNT_4 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal message : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
    fake_clk <= not fake_clk after 1ms;
    test_fsm : FSM port map (BTN => button, CLK => fake_clk, RST => reset, COUNT_1 => COUNT_1, COUNT_2 => COUNT_2, COUNT_3 => COUNT_3, COUNT_4 => COUNT_4, COUNTER_EN => counter_en, COUNTER_RST => counter_rst, MESSAGE => message);


end Behavioral;
