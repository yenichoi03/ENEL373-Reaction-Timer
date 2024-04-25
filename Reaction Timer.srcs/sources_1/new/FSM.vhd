----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 10:20:50
-- Design Name: 
-- Module Name: FSM - Behavioral
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

entity FSM is
    Port ( CLK, RST: in STD_LOGIC;
           BTNC, BTNU, BTND, BTNL, BTNR  : in STD_LOGIC := '0';
           op : out STD_LOGIC_VECTOR(2 downto 0) := "000";
           CURRENT_TIME : out STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
           RESULT : in STD_LOGIC_VECTOR(15 downto 0);                               
           COUNT_1,COUNT_2,COUNT_3,COUNT_4 : in STD_LOGIC_VECTOR (3 downto 0);  -- uses one segment of the 7 segment display 
           counter_en, counter_rst : out STD_LOGIC := '0'; 
           message : out STD_LOGIC_VECTOR (31 downto 0) := x"aaaaaaaa" );       -- each nibble of message represent one character or digit on a 7 segment display.
end FSM;

architecture Behavioral of FSM is

    type state is (dot_3, dot_2, dot_1, counting, print_current_time, print_best_time, print_worst_time, print_average_time);
    
    signal current_state, next_state : state := dot_3;
    constant T1: natural := 1000;
    signal t: natural range 0 to T1 -1;
    
    signal best_time : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
    signal worst_time : STD_LOGIC_VECTOR(15 downto 0) := x"FFFF";
    signal sum : STD_LOGIC_VECTOR(47 downto 0) := x"000000000000";
    signal run_count : STD_LOGIC_VECTOR(3 downto 0) := x"0";                 

begin

    STATE_REGISTER: process(CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                current_state <= dot_3;
            else
                current_state <= next_state;
            end if;
        end if;
end process;

NEXT_STATE_DECODE: process (current_state, t, BTNC, BTNU, BTND, BTNL, BTNR)
begin 
    case (current_state) is
        when dot_3 =>
            if t = 999 then
                next_state <= dot_2;
            else
                next_state <= dot_3;
            end if;
            
        when dot_2 =>
            if t = 999 then
                next_state <= dot_1;
            else
                next_state <= dot_2;
            end if;
        when dot_1 =>
            if t = 999 then
                next_state <= counting;
            else
                next_state <= dot_1;
            end if;
        when counting =>
            op <= "000";
            if BTNC = '1' then
                next_state <= print_current_time;
            else
                next_state <= counting;
            end if;
        when print_current_time =>
            if BTNC = '1' and t = 999 then
                next_state <= dot_3;
            elsif BTNU = '1' then
                next_state <= print_worst_time;
                op <= "001";
            elsif BTND = '1' then
                next_state <= print_best_time;
                op <= "100";
            elsif BTNR = '1' then
                next_state <= print_average_time;
                op <= "010";
            else
                next_state <= print_current_time;
            end if;
        when print_worst_time =>
            op <= "000";
            if BTNC = '1' and t = 999 then
                next_state <= dot_3;
            elsif BTND = '1' then
                next_state <= print_best_time;
                op <= "100";
            elsif BTNR = '1' then
                next_state <= print_average_time;
                op <= "010";
            else
                next_state <= print_worst_time;
            end if;
        when print_best_time =>
            op <= "000";
            if BTNC = '1' and t = 999 then
                next_state <= dot_3;
            elsif BTNU = '1' then
                next_state <= print_worst_time;
                op <= "001";
             elsif BTNR = '1' then
                next_state <= print_average_time;
                op <= "010";
            else
                next_state <= print_best_time;
            end if;
        when print_average_time =>
            op <= "000";
            if BTNC = '1' and t = 999 then
                next_state <= dot_3;
             elsif BTND = '1' then
                next_state <= print_best_time;
                op <= "100";
            elsif BTNU = '1' then
                next_state <= print_worst_time;
                op <= "001";
            else
                next_state <= print_average_time;
            end if;
        when others =>
            next_state <= current_state;
    end case;
end process;

OUTPUT_DECODE: process(current_state, COUNT_1,COUNT_2,COUNT_3,COUNT_4)
begin
    case (current_state) is
        when dot_3 =>
            counter_en <= '0';
            counter_rst <= '1';
            message <= X"aaaaaFFF"; -- to modify to show three dots. Hex representation 
        when dot_2 =>
            counter_en <= '0';
            counter_rst <= '0';
            message <= X"aaaaaaFF"; -- to modify to show two dots
        when dot_1 =>
            counter_en <= '0';
            counter_rst <= '0';
            message <= X"aaaaaaaF"; -- to modify to show one dots
        when counting =>
            counter_en <= '1';
            counter_rst <= '0';
            message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
            message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1; -- Decade counter counts
        when print_current_time =>
            counter_en <= '0';
            counter_rst <= '0';
            CURRENT_TIME <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
            message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
            message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
            
        when print_best_time =>
            counter_en <= '0';
            counter_rst <= '0';
            CURRENT_TIME <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
            message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
            message(15 downto 0) <= x"2222";
            --DISPLAY SHORTEST TIME
        when print_worst_time =>
            counter_en <= '0';
            counter_rst <= '0';
            CURRENT_TIME <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
            message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
            message(15 downto 0) <= result;
            --DISPLAY LONGEST TIME
        when print_average_time =>
            counter_en <= '0';
            counter_rst <= '0';
            -- Put sum in A
            -- Put run_count in B
            -- Tell ALU to divide
            message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
            message(15 downto 0) <= x"4444";
        when others =>
            counter_en <= '0';
            counter_rst <= '0';
            message <= X"aaaaaaaa";
    end case;
end process;

TIMER: process (CLK)
begin
    if(rising_edge(CLK)) then
        if current_state /= next_state then
            t <= 0;
        elsif t/= T1-1 then
            t <= t + 1;
        end if;
    end if;
end process;


end Behavioral;

