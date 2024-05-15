----------------------------------------------------------------------------------
-- Title: bcd_to_7seg
-- Author: Ciaran Moore, modified by EWB, YYC, & MWD
-- Date: 2024
-- Description: This component decodes a 4 bit input code into an 8 bit output which activates the 7 segment display cathodes
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
                 when "0011" => seg(0 to 6) <= "1111001"; -- 3, or E for error
                 when "0100" => seg(0 to 6) <= "0110011"; -- 4
                 when "0101" => seg(0 to 6) <= "1011011"; -- 5, or S for slowest 
                 when "0110" => seg(0 to 6) <= "1011111"; -- 6 
                 when "0111" => seg(0 to 6) <= "1110000"; -- 7 
                 when "1000" => seg(0 to 6) <= "1111111"; -- 8
                 when "1001" => seg(0 to 6) <= "1110011"; -- 9
                 when "1010" => seg(0 to 6) <= "0000000"; -- blank
                 when "1011" => seg(0 to 6) <= "0000101"; -- lil r for Reset
                 when "1100" => seg(0 to 6) <= "1110111"; -- A for average
                 when "1101" => seg(0 to 6) <= "1000111"; -- F for fastest
                 when "1110" => seg(0 to 6) <= "0000000"; -- blank again
                 when "1111" => seg(0 to 6) <= "0000000"; -- dot
                 when others => seg(0 to 6) <= "0000000"; -- blank

            end case;
        end process; 
    seg(7) <= dp;
end Behavioural;


