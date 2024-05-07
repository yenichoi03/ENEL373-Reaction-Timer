library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_block_tb is
end FSM_block_tb;

-----------------------------------------------------------------
-- Run simulation for at least 110 us (scaled by 100000) i.e. 11 seconds
-----------------------------------------------------------------

architecture Behavioral of FSM_block_tb is

signal fake_clk : STD_LOGIC := '0';


component FSM is
Port ( CLK, RST: in STD_LOGIC;
       BTNC, BTNU, BTND, BTNL, BTNR  : in STD_LOGIC := '0';
       op : out STD_LOGIC_VECTOR(2 downto 0) := "000";
       CURRENT_TIME : out STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
       RESULT : in STD_LOGIC_VECTOR(15 downto 0);                               
       COUNT_1,COUNT_2,COUNT_3,COUNT_4 : in STD_LOGIC_VECTOR (3 downto 0);  -- uses one segment of the 7 segment display 
       counter_en, prng_en, alu_en, shift_en, shift_rst: out STD_LOGIC := '0';
       message : out STD_LOGIC_VECTOR (31 downto 0) := x"aaaaaaaa" ;       -- each nibble of message represent one character or digit on a 7 segment display.
       random1, random2, random3 : in integer range 0 to 5000);
end component;

signal enable, reset, global_rst, BTNC, BTNU, BTND, BTNL, BTNR, counter_en, counter_rst, op_done : STD_LOGIC := '0';
signal op, sel : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal A, B, C, R : INTEGER := 0;
signal COUNT_1,COUNT_2,COUNT_3,COUNT_4 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal CURRENT_TIME, RESULT : STD_LOGIC_VECTOR (15 downto 1) := (others => '0');
signal message : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal  random1, random2, random3 : integer range 0 to 5000;

begin
    fake_clk <= not fake_clk after 1ns;
    process
    begin
    wait for 1ns;
    BTNC <= '1';
    wait for 1ps;
    BTNC <= '0';
    wait for 5ns;
    BTNC <= '1';
    wait for 1ps;
    BTNC <= '0';
    BTNU <= '1';
    end process;
    test_fsm : FSM port map (random1 => random1, random2=> random2, random3=> random3, BTNC => BTNC, BTNU => BTNU, BTND => BTND, BTNL => BTNL, BTNR => BTNR, CLK => fake_clk, RST => global_rst, RESULT => RESULT, CURRENT_TIME => CURRENT_TIME, COUNT_1 => COUNT_1, COUNT_2 => COUNT_2, COUNT_3 => COUNT_3, COUNT_4 => COUNT_4, COUNTER_EN => enable, MESSAGE => message, op => op);


end Behavioral;
