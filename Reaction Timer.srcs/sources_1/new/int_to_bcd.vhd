----------------------------------------------------------------------------------
-- Title: Integer to BCD Converter
-- Author: EWB, YYC, & MWD
-- Date: 2024
-- Description: This component decodes a 4 bit input code into an 8 bit output which activates the 7 segment display cathodes
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity int_to_BCD is
    Port ( INT_RESULT : in integer range 0 to 5000;               -- Integer input from the ALU result
           BCD_RESULT : out std_logic_vector(15 downto 0));       -- BCD output to be displayed
end int_to_BCD;

architecture Behavioral of int_to_BCD is

begin

    process(int_result)
    variable mils, hunds, tens, ones: INTEGER := 0;
        begin
        mils := int_result/1000;
        hunds := (int_result - mils*1000)/100;
        tens := (int_result - mils*1000 - hunds*100)/10;
        ones := (int_result - mils*1000 - hunds*100 - tens*10);
        bcd_result <= STD_LOGIC_VECTOR(to_unsigned(mils, 4)) & STD_LOGIC_VECTOR(to_unsigned(hunds, 4)) & STD_LOGIC_VECTOR(to_unsigned(tens, 4)) & STD_LOGIC_VECTOR(to_unsigned(ones, 4));
    end process;
    
end Behavioral;
