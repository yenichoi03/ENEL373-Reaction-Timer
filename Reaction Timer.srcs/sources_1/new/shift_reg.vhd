library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift_reg is
    Port ( time_in : in STD_LOGIC_VECTOR (15 downto 0);
           A,B,C : out INTEGER range 0 to 9999:=0;
           shift_en, reset : in STD_LOGIC);
end shift_reg;


architecture Behavioral of shift_reg is

signal new_time : INTEGER range 0 to 9999:= 0;
signal thous, hunds, tens, ones, part_a, part_b : INTEGER range 0 to 9999:= 0;
signal A_temp, B_temp, C_temp : Integer range 0 to 9999:= 0;

begin

thous <= TO_INTEGER(UNSIGNED(time_in(15 downto 12)))*1000;
hunds <= TO_INTEGER(UNSIGNED(time_in(11 downto 8)))*100;
tens <= TO_INTEGER(UNSIGNED(time_in(7 downto 4)))*10;
ones <= TO_INTEGER(UNSIGNED(time_in(3 downto 0)))*1;

process(shift_en, reset)

begin
if(falling_edge(shift_en))then
    A_temp <= thous + hunds + tens + ones;
    C_temp <= B_temp;
    B_temp <= A_temp;

end if;

if(reset = '1') then
C_temp <= 0;
B_temp <= 0;
A_temp <= 0;
end if;

end process;

A <= A_temp;
B <= B_temp;
C <= C_temp;

end Behavioral;

--architecture Behavioral of shift_reg is

--signal new_time : INTEGER := 0;
--signal thous, hunds, tens, ones : INTEGER := 0;
    
--begin

--thous <= TO_INTEGER(UNSIGNED(time_in(15 downto 12)))*1000;
--hunds <= TO_INTEGER(UNSIGNED(time_in(11 downto 8)))*100;
--tens <= TO_INTEGER(UNSIGNED(time_in(7 downto 4)))*10;
--ones <= TO_INTEGER(UNSIGNED(time_in(3 downto 0)))*1;

 

--process(shift_en)

--begin
--new_time <= thous + hunds + tens + ones;
--if(rising_edge(shift_en)) then
--    A <= new_time;
--    B <= A_prev;
--    C <= B_prev;
--end if;

--end process;


--end Behavioral;