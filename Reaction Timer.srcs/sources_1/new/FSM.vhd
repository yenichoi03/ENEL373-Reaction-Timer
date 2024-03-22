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

entity FSM is
    Port ( CLK, RST: in STD_LOGIC;
           BTN : in STD_LOGIC := '0';                                  -- This is also used as a reset as well
           COUNT_1,COUNT_2,COUNT_3,COUNT_4 : in STD_LOGIC_VECTOR (3 downto 0);  -- uses one segment of the 7 segment display 
--           NUM : out STD_LOGIC_VECTOR (3 downto 0):= "0000";        --What is this?
           counter_en, counter_rst : out STD_LOGIC := '0'; 
           message : out STD_LOGIC_VECTOR (31 downto 0) := x"aaaaaaaa" );       -- each nibble of message represent one character or digit on a 7 segment display.
end FSM;

architecture Behavioral of FSM is

    type state is (dot_3, dot_2, dot_1, counting, printing);
    
    signal current_state, next_state : state := dot_3;
--    signal RST : STD_LOGIC := '0';
--    signal COUNT : STD_LOGIC := '0';
--    signal Counter_en : STD_LOGIC := '0';
--    signal Counter_rst : STD_LOGIC := '1';                  

    constant T1: natural := 1000;
    signal t: natural range 0 to T1 -1;                 

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

NEXT_STATE_DECODE: process (current_state, t, BTN)
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
            if BTN = '1' then
                next_state <= printing;
            else
                next_state <= counting;
            end if;
        when printing =>
            if BTN = '1' and t = 999 then
                next_state <= dot_3;
            else
                next_state <= printing;
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
--            NUM <= "0001";
            message <= X"aaaaaFFF"; -- to modify to show three dots. Hex representation 
        when dot_2 =>
            counter_en <= '0';
            counter_rst <= '0';
--            NUM <= "0010";
            message <= X"aaaaaaFF"; -- to modify to show two dots
        when dot_1 =>
            counter_en <= '0';
            counter_rst <= '0';
--            NUM <= "0011";
            message <= X"aaaaaaaF"; -- to modify to show one dots
        when counting =>
            counter_en <= '1';
            counter_rst <= '0';
--            NUM <= "0100"; 
            message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
            message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1; -- Decade counter counts 
        when printing =>
            counter_en <= '0';
            counter_rst <= '0';
--            NUM <= "0101";
            message(31 downto 16) <= "1010" & "1010" & "1010" & "1010" ;
            message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
        when others =>
            counter_en <= '0';
            counter_rst <= '0';
--            NUM <= "1111";
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

