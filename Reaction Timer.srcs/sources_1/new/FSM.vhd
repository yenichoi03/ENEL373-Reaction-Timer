----------------------------------------------------------------------------------
-- Title: Reaction Timer Finite State Machine
-- Author: EWB, YYC, & MWD
-- Date: 2024
-- Description: This component controls the current state and outputs of the reaction timer
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
    Port ( CLK, RST: in STD_LOGIC;                                              -- Clock in and global reset  
           BTNC, BTNU, BTND, BTNL, BTNR  : in STD_LOGIC := '0';                 -- External button inputs
           OP : out STD_LOGIC_VECTOR(2 downto 0) := "000";                      -- ALU op code
           CURRENT_TIME : out STD_LOGIC_VECTOR(15 downto 0) := (others => '0'); -- Most recent reaction time
           RESULT : in STD_LOGIC_VECTOR(15 downto 0);                           -- ALU output    
           COUNT_1, COUNT_2, COUNT_3, COUNT_4 : in STD_LOGIC_VECTOR (3 downto 0);  -- Each digit of the measured time
           COUNTER_EN, COUNTER_RST : out STD_LOGIC := '0';                      -- Enable and reset the counters for timing
           ALU_EN : out STD_LOGIC := '0';                                       -- Enable the ALU
           SHIFT_EN, SHIFT_RST : out STD_LOGIC := '0';                          -- Enable and reset for the shift register of reaction times
           MESSAGE : out STD_LOGIC_VECTOR (31 downto 0) := x"aaaaaaaa" ;        -- each nibble of message represent one character or digit on a 7 segment display.
           RANDOM : in INTEGER range 0 to 5000);                                -- An always changing pseudorandom number
end FSM;

architecture Behavioral of FSM is

    type state is (dot_3, dot_2, dot_1, counting, buffering, print_current_time, print_best_time, print_worst_time, print_average_time, clear_time_data, error, idle);
    
    signal current_state, next_state : state := idle;
    constant T1: natural := 5001;
    signal t: natural range 0 to T1 -1;
  
    signal r_time1 : INTEGER range 0 to 5000 := 900; -- initial values for time between dots, replaced by random values
    signal r_time2 : INTEGER range 0 to 5000 := 1200;
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

    NEXT_STATE_DECODE: process (current_state, t, BTNC, BTNU, BTND, BTNL, BTNR)

    begin 
        case (current_state) is
            when idle =>
                if BTNC = '1' then
                    next_state <= dot_3;
                else
                    next_state <= idle;
                end if;
            when dot_3 =>
                if t = r_time3 then
                    next_state <= dot_2;
                elsif BTNC = '1' and t > 333 then
                    next_state <= error;
                else
                    next_state <= dot_3;
                end if;
                
            when dot_2 =>
                if t = r_time2 then
                    next_state <= dot_1;
                elsif BTNC = '1' then
                    next_state <= error;
                else
                    next_state <= dot_2;
                end if;
            when dot_1 =>
                if t = r_time1 then
                    next_state <= counting;
                elsif BTNC = '1' then
                    next_state <= error;
                else
                    next_state <= dot_1;
                end if;
            when counting => 
                if BTNC = '1' then
                    next_state <= buffering;
                else
                    next_state <= counting;
                end if;
            when buffering =>
                if t>666 then
                    next_state <=print_current_time;
                else
                    next_state <= buffering;
                end if;
                        
            when print_current_time =>
                if BTNC = '1' and t > 999  then
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
                if BTNC = '1' and t > 999 then
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
                if BTNC = '1' and t > 999 then
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
                if BTNC = '1' and t > 999 then
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
                if BTNC = '1' and t > 999 then
                    next_state <= dot_3;
                else
                    next_state <= clear_time_data;
                end if;
            when error =>
                if BTNC = '1' and t > 666 then
                    next_state <= dot_3;
                else
                    next_state <= error;
                end if;
            when others => 
                next_state <= current_state;
        end case;
    end process;

    OUTPUT_DECODE: process(current_state, COUNT_1,COUNT_2,COUNT_3,COUNT_4, random)
    begin
        case (current_state) is
            when idle =>
                CURRENT_TIME <= x"0000";
                alu_en <= '0';
                shift_en <= '0';
                shift_rst <= '0';
                r_time3 <= random;
                op <= "000";
                counter_en <= '0';
                counter_rst <= '0';
                message <= X"aaaaaFFF"; -- displays 3 dots 
            when dot_3 =>
                CURRENT_TIME <= x"0000";
                alu_en <= '0';
                shift_en <= '0';
                shift_rst <= '0';
                r_time1 <= random;
                op <= "000";
                counter_en <= '0';
                counter_rst <= '1';
                message <= X"aaaaaFFF"; -- displays 3 dots
                
            when dot_2 =>
                CURRENT_TIME <= x"0000";
                alu_en <= '0';
                shift_en <= '0';
                shift_rst <= '0';
                r_time3 <= random;
                op <= "000";
                counter_en <= '0';
                counter_rst <= '0';
                message <= X"aaaaaaFF"; -- displays 2 dots
    
            when dot_1 =>
                CURRENT_TIME <= x"0000";
                alu_en <= '0';
                shift_en <= '0';
                shift_rst <= '0';
                r_time2 <= random;
                op <= "000";
                counter_en <= '0';
                counter_rst <= '0';
                message <= X"aaaaaaaF"; -- displays 1 dot
    
            when counting =>
                CURRENT_TIME <= x"0000";
                alu_en <= '0';
                shift_en <= '0';
                shift_rst <= '0';
                op <= "000";
                counter_en <= '1';
                counter_rst <= '0';
                message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
                message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1; -- Displays live time           
            when buffering =>
                CURRENT_TIME <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
                alu_en <= '0';
                shift_en <= '0';
                shift_rst <= '0';
                op <= "000";
                counter_en <= '0';
                counter_rst <= '0';
                message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
                message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1; -- Displays final time
            when print_current_time =>
                shift_en <= '1';
                CURRENT_TIME <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
                alu_en <= '0';
                shift_rst <= '0';
                op <= "000";
                counter_en <= '0';
                counter_rst <= '0';
                message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
                message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1; -- Displays most recent final time
            when print_best_time =>
                CURRENT_TIME <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
                alu_en <= '1';
                shift_en <= '0';
                shift_rst <= '0';
                op <= "100";
                counter_en <= '0';
                counter_rst <= '0';
                message(31 downto 16) <= "1010" & "1010" & "1101" & "1010" ;
                message(15 downto 0) <= result;                                --Displays shortest time
            when print_worst_time =>
                CURRENT_TIME <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
                alu_en <= '1';
                shift_en <= '0';
                shift_rst <= '0';
                op <= "001";
                counter_en <= '0';
                counter_rst <= '0';
                message(31 downto 16) <= "1010" & "1010" & "0101" & "1010" ;
                message(15 downto 0) <= result;                                 --Displays longest time
            when print_average_time =>
                CURRENT_TIME <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
                alu_en <= '1';
                shift_en <= '0';
                shift_rst <= '0';
                op <= "010";
                counter_en <= '0';
                counter_rst <= '0';
                message(31 downto 16) <= "1010" & "1010" & "1100" & "1010" ;
                message(15 downto 0) <= result;                                 -- Displays average time
            when clear_time_data =>
                CURRENT_TIME <= x"0000";
                alu_en <= '0';
                shift_en <= '0';
                shift_rst <= '1';
                op <= "000";
                counter_en <= '0';
                counter_rst <= '0';
                message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
                message(15 downto 0) <= x"aBBB";                               -- Displays reset code            
            when error =>
                CURRENT_TIME <= x"0000";
                alu_en <= '0';
                shift_en <= '0';
                shift_rst <= '0';
                op <= "000";
                counter_en <= '0';
                counter_rst <= '0';
                message <= x"aaaaa333";                                        -- Displays error code
            when others =>
                CURRENT_TIME <= x"0000";
                alu_en <= '0';
                shift_en <= '0';
                shift_rst <= '0';
                op <= "000";
                counter_en <= '0';
                counter_rst <= '0';
                message <= X"aaaaaaaa";
        end case;
        
    end process;

    TIMER: process (CLK) --This timer is used for button debouncing
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

