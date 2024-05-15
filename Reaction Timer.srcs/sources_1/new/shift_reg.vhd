----------------------------------------------------------------------------------
-- Title: Shift Register
-- Authors: EWB, YYC, & MWD
-- Date: 2024
-- Description: This component stores 3 integer values at a time
--              Incoming BCD values are converted to integers and shift into the register on the rising edge of shift enable  
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift_reg is
  Port ( time_in : in STD_LOGIC_VECTOR( 15 downto 0);             -- The next value to be added to the register
           A, B, C : out INTEGER range 0 to 9999;                 -- The 3 values currently in the shift register
           shift_en, reset: in STD_LOGIC);                        -- Input shifts into the register when shift_en is high
                                                                  -- All values are set to zero when reset is high
end shift_reg;

architecture Behavioral of shift_reg is

signal new_time : INTEGER range 0 to 9999:= 0;
signal thous, hunds, tens, ones, part_a, part_b : INTEGER range 0 to 9999:= 0;
signal A_temp, B_temp, C_temp : Integer range 0 to 9999:= 0;

begin

thous <= TO_INTEGER(UNSIGNED(time_in(15 downto 12)))*1000;  -- Converts BCD input to integer to be stored
hunds <= TO_INTEGER(UNSIGNED(time_in(11 downto 8)))*100;
tens <= TO_INTEGER(UNSIGNED(time_in(7 downto 4)))*10;
ones <= TO_INTEGER(UNSIGNED(time_in(3 downto 0)))*1;

shift: process(shift_en, reset)

begin

if(rising_edge(shift_en))then
    A_temp <= thous + hunds + tens + ones;
    C_temp <= B_temp;
    B_temp <= A_temp;
end if;

if(reset = '1') then -- Clears the register
C_temp <= 0;
B_temp <= 0;
A_temp <= 0;
end if;

end process shift;

A <= A_temp;
B <= B_temp;
C <= C_temp;

end Behavioral;