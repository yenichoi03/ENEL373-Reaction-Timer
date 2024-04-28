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
           BTNC, BTNU, BTND, BTNL, BTNR  : in STD_LOGIC := '0';
           op : out STD_LOGIC_VECTOR(2 downto 0) := "000";
           CURRENT_TIME : out STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
           RESULT : in STD_LOGIC_VECTOR(15 downto 0);                               
           COUNT_1,COUNT_2,COUNT_3,COUNT_4 : in STD_LOGIC_VECTOR (3 downto 0);  -- uses one segment of the 7 segment display 
           counter_en, counter_rst : out STD_LOGIC := '0'; 
           message : out STD_LOGIC_VECTOR (31 downto 0) := x"aaaaaaaa" );       -- each nibble of message represent one character or digit on a 7 segment display.
    end component;

signal enable, reset, global_rst, BTNC, BTNU, BTND, BTNL, BTNR, counter_en, counter_rst, op_done : STD_LOGIC := '0';
signal op : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal A, B, C, R : INTEGER := 0;
signal COUNT_1,COUNT_2,COUNT_3,COUNT_4 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal CURRENT_TIME, RESULT : STD_LOGIC_VECTOR (15 downto 1) := (others => '0');
signal message : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
    fake_clk <= not fake_clk after 1ns;
    BTNC <= '1' after 1ns;
    BTNC <= '0' after 2ns;
    BTND <= '1' after 3ns;
    test_fsm : FSM port map (BTNC => BTNC, BTNU => BTNU, BTND => BTND, BTNL => BTNL, BTNR => BTNR, CLK => fake_clk, RST => global_rst, RESULT => RESULT, CURRENT_TIME => CURRENT_TIME, COUNT_1 => COUNT_1, COUNT_2 => COUNT_2, COUNT_3 => COUNT_3, COUNT_4 => COUNT_4, COUNTER_EN => enable, COUNTER_RST => reset, MESSAGE => message, op => op);


end Behavioral;
