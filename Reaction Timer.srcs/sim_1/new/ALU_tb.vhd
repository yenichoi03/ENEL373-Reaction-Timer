----------------------------------------------------------------------------------
-- Title: Shift Register Testbench
-- Authors: EWB, YYC, & MWD
-- Date: 2024
-- Description: This testbench simulates the behaviour of the ALU for various opperations
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is

component ALU is
     Port (OP : in STD_LOGIC_VECTOR(2 downto 0);                  -- Code selects whether the ALU will output: best time, worst time, or average time
          ALU_EN : in STD_LOGIC;                                  -- ALU performs arithmetic when this input is high
          clk : in STD_LOGIC;                                     -- Clock in 
          A: in integer range 0 to 9999;                          -- Newest reaction time
          B: in integer range 0 to 9999;                          -- Middle reaction time
          C: in integer range 0 to 9999;                          -- Oldest reaction time
          R: out integer range 0 to 9999 := 1111);                -- Result from arithmetic operation
end component;

signal op : std_logic_vector (2 downto 0) := "101"; -- 001 for add, 010 for divide, 100 for compare
signal alu_en : std_logic := '1';
signal a, b : integer := 1;
signal c : integer := 4;
signal r : integer := 0;
signal clk : std_logic := '0';

begin

process
begin 
    clk <= not clk after 1ns;
    op <= "010";
    wait for 5ns; 
    op <= "100";
    wait for 5ns;
    op <= "001";
    wait for 5ns;
end process;

ALU_tb : ALU port map (CLK => clk, OP => op, A=>a, B=>b, C=>c, R=>r, ALU_EN => alu_en);

end Behavioral;
