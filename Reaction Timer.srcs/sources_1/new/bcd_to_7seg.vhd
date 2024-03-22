----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 10:19:09
-- Design Name: 
-- Module Name: bcd_to_7seg - Behavioral
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
--This enables the segments depending on binary code from Display_Counter (M2)

entity bcd_to_7seg is
     port ( bcd : in STD_LOGIC_VECTOR (3 downto 0);
            dp : in STD_LOGIC;
            seg : out STD_LOGIC_VECTOR (0 to 7));
end bcd_to_7seg;

architecture Behavioural of bcd_to_7seg is
    begin
        process (bcd) is
        begin
             case (bcd) is
                 when "0000" => seg(0 to 6) <= "1111110"; -- 0
                 when "0001" => seg(0 to 6) <= "0110000"; -- 1
                 when "0010" => seg(0 to 6) <= "1101101"; -- 2
                 when "0011" => seg(0 to 6) <= "1111001"; -- 3
                 when "0100" => seg(0 to 6) <= "0110011"; -- 4
                 when "0101" => seg(0 to 6) <= "1011011"; -- 5 
                 when "0110" => seg(0 to 6) <= "1011111"; -- 6 
                 when "0111" => seg(0 to 6) <= "1110000"; -- 7 
                 when "1000" => seg(0 to 6) <= "1111111"; -- 8
                 when "1001" => seg(0 to 6) <= "1110011"; -- 9
                 when "1010" => seg(0 to 6) <= "0000000"; -- blank
                 when "1011" => seg(0 to 6) <= "0100000"; -- max
                 when "1100" => seg(0 to 6) <= "0000001"; -- average
                 when "1101" => seg(0 to 6) <= "0010000"; -- min
                 --when "1110" => seg(0 to 6) <= 
                 --when "1111" => seg(0 to 6) <= "0000000";
                when others => seg(0 to 6) <= "0000000"; -- blank
            end case;
        end process; 
    seg(7) <= dp;
end Behavioural;

