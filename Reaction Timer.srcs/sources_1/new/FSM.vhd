----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 10:20:50
-- Design Name: 
-- Module Name: FSM - Behavioral
-- Project Name: 
-- Target Devices: 
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
           counter_en, prng_en, alu_en, shift_en, shift_rst : out STD_LOGIC := '0'; 
           prng_rst : out std_logic := '1';
           message : out STD_LOGIC_VECTOR (31 downto 0) := x"aaaaaaaa" ;       -- each nibble of message represent one character or digit on a 7 segment display.
           random1, random2, random3 : in integer range 0 to 5000);
end FSM;

architecture Behavioral of FSM is

    type state is (dot_3, dot_2, dot_1, counting, print_current_time, print_best_time, print_worst_time, print_average_time, clear_time_data, error, idle);
    constant Time1: natural := 5001;
    constant Time2: natural := 1000;
    signal t1: natural range 0 to (Time1 -1);
    signal t2: natural range 0 to (Time2 -1);
    signal current_state, next_state : state := idle;
    signal best_time : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
    signal worst_time : STD_LOGIC_VECTOR(15 downto 0) := x"FFFF";
    signal clear_time : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal sum : STD_LOGIC_VECTOR(47 downto 0) := x"000000000000";
    signal r_time1 : INTEGER range 0 to 5000 := 1200; -- insert the random number that is generated here
    signal r_time2 : INTEGER range 0 to 5000 := 800;
    signal r_time3 : INTEGER range 0 to 5000 := 1000;
    
           
begin

    STATE_REGISTER: process(CLK, RST)
    
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                current_state <= idle;
            else
                current_state <= next_state;
            end if;
        end if;
end process;

NEXT_STATE_DECODE: process (current_state, BTNC, BTNU, BTND, BTNL, BTNR)

begin 
    case (current_state) is
        when idle =>
            if BTNC = '1' then
                next_state <= dot_3;
            else
                next_state <= idle;
            end if;
        when dot_3 =>
            if t1 = r_time3 then
                next_state <= dot_2;
            elsif BTNC = '1' and t2 = 300 then
                next_state <= error;
            else
                next_state <= dot_3;
            end if;
            
        when dot_2 =>
            if t1 = r_time2 then
                next_state <= dot_1;
            elsif BTNC = '1' then
                next_state <= error;
            else
                next_state <= dot_2;
            end if;
        when dot_1 =>
            if t1 = r_time1 then
                next_state <= counting;
            elsif BTNC = '1' then
                next_state <= error;
            else
                next_state <= dot_1;
            end if;
        when counting => 
            if BTNC = '1' then
                next_state <= print_current_time;
            else
                next_state <= counting;
            end if;            
        when print_current_time =>
            if BTNC = '1' and t2 = 999 then
                next_state <= dot_3;
            elsif BTNU = '1' then
                next_state <= print_worst_time;
            elsif BTND = '1' then
                next_state <= print_best_time;
            elsif BTNR = '1' then
                next_state <= print_average_time;
            elsif BTNL = '1' then
                next_state <= clear_time_data;
            else
                next_state <= print_current_time;
            end if;
            
        when print_worst_time =>
            if BTNC = '1' and t2 = 999 then
                next_state <= dot_3;
            elsif BTND = '1' then
                next_state <= print_best_time;
            elsif BTNR = '1' then
                next_state <= print_average_time;
            elsif BTNL = '1' then
                next_state <= clear_time_data;
            else
                next_state <= print_worst_time;
            end if;
        when print_best_time =>
            if BTNC = '1' and t2 = 999 then
                next_state <= dot_3;
            elsif BTNU = '1' then
                next_state <= print_worst_time;
             elsif BTNR = '1' then
                next_state <= print_average_time;
             elsif BTNL = '1' then
                next_state <= clear_time_data;
            else
                next_state <= print_best_time;
            end if;
        when print_average_time =>
            if BTNC = '1' and t2 = 999 then
                next_state <= dot_3;
             elsif BTND = '1' then
                next_state <= print_best_time;
            elsif BTNU = '1' then
                next_state <= print_worst_time;
            elsif BTNL = '1' then
                next_state <= clear_time_data;
            else
                next_state <= print_average_time;
            end if;
        when clear_time_data =>
            if BTNC = '1' and t2 = 999 then
                next_state <= dot_3;
            else
                next_state <= clear_time_data;
            end if;
        when error =>
            if BTNC = '1' and t2 = 999 then
                next_state <= dot_3;
            else
                next_state <= error;
            end if;
        when others => 
            next_state <= current_state;
    end case;
end process;

OUTPUT_DECODE: process(current_state, COUNT_1,COUNT_2,COUNT_3,COUNT_4, random1, random2, random3)
begin
    case (current_state) is
        when idle =>
            CURRENT_TIME <= x"0000";
            alu_en <= '0';
            shift_en <= '0';
            shift_rst <= '0';
            r_time3 <= random3;
            op <= "000";
            counter_en <= '0';
            prng_en <= '1';
            message <= X"aaaaaFFF"; -- to modify to show three dots. Hex representation 
        when dot_3 =>
            CURRENT_TIME <= x"0000";
            alu_en <= '0';
            shift_en <= '0';
            shift_rst <= '0';
            r_time1 <= random1;
            op <= "000";
            counter_en <= '0';
            prng_en <= '0';
            message <= X"aaaaaFFF"; -- to modify to show three dots. Hex representation 
            
        when dot_2 =>
            CURRENT_TIME <= x"0000";
            alu_en <= '0';
            shift_en <= '0';
            shift_rst <= '0';
            r_time3 <= random3;
            op <= "000";
            counter_en <= '0';
            prng_en <= '0';
            message <= X"aaaaaaFF"; -- to modify to show two dots

        when dot_1 =>
            CURRENT_TIME <= x"0000";
            alu_en <= '0';
            shift_en <= '0';
            shift_rst <= '0';
            r_time2 <= random2;
            op <= "000";
            counter_en <= '0';
            prng_en <= '0';
            message <= X"aaaaaaaF"; -- to modify to show one dots

        when counting =>
            CURRENT_TIME <= x"0000";
            alu_en <= '0';
            shift_en <= '0';
            shift_rst <= '0';
            op <= "000";
            counter_en <= '1';
            prng_en <= '1';
            message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
            message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1; -- Decade counter counts
            
        when print_current_time =>
            CURRENT_TIME <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
            alu_en <= '0';
            shift_en <= '1';
            shift_rst <= '0';
            op <= "000";
            counter_en <= '0';
            prng_en <= '0';
            message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
            message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1; -- DISPLAY MOST RECENT TIME
        when print_best_time =>
            CURRENT_TIME <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
            alu_en <= '1';
            shift_en <= '0';
            shift_rst <= '0';
            op <= "100";
            counter_en <= '0';
            prng_en <= '0';
            message(31 downto 16) <= "1010" & "1010" & "1101" & "1010" ;
            message(15 downto 0) <= result; --DISPLAY SHORTEST TIME
        when print_worst_time =>
            CURRENT_TIME <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
            alu_en <= '1';
            shift_en <= '0';
            shift_rst <= '0';
            op <= "001";
            counter_en <= '0';
            prng_en <= '0';
            message(31 downto 16) <= "1010" & "1010" & "0101" & "1010" ;
            message(15 downto 0) <= result; --DISPLAY LONGEST TIME
        when print_average_time =>
            CURRENT_TIME <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
            alu_en <= '1';
            shift_en <= '0';
            shift_rst <= '0';
            op <= "010";
            counter_en <= '0';
            prng_en <= '0';
            message(31 downto 16) <= "1010" & "1010" & "1100" & "1010" ;
            message(15 downto 0) <= result; -- DISPLAY AVG TIME
        when clear_time_data =>
            CURRENT_TIME <= x"0000";
            alu_en <= '0';
            shift_en <= '0';
            shift_rst <= '1';
            op <= "000";
            counter_en <= '0';
            prng_en <= '0';
            message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
            message(15 downto 0) <= x"aEEE";            
        when error =>
            CURRENT_TIME <= x"0000";
            alu_en <= '0';
            shift_en <= '0';
            shift_rst <= '0';
            op <= "000";
            counter_en <= '0';
            prng_en <= '1';
            message <= x"aaa3EEBE"; -- display error
        when others =>
            CURRENT_TIME <= x"0000";
            alu_en <= '0';
            shift_en <= '0';
            shift_rst <= '0';
            op <= "000";
            counter_en <= '0';
            prng_en <= '0';
            message <= X"aaaaaaaa";
    end case;
    
end process;



TIMER1: process(CLK)

begin
    if(rising_edge(CLK)) then
        if current_state /= next_state then
            t1 <= 0;
        elsif t1/= (Time1-1) then
            t1 <= t1 + 1;
        end if;
    end if;
end process;

TIMER2: process(CLK)
begin
    if(rising_edge(CLK)) then
        if current_state /= next_state then
            t2 <= 0;
        elsif t2/= (Time2-1) then
            t2 <= t2 + 1;
        end if;
    end if;
end process;

end Behavioral;

