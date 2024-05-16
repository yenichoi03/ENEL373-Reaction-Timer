----------------------------------------------------------------------------------
-- Title: Arithmetic Logic Unit
-- Authors: EWB, YYC, & MWD
-- Date: 2024
-- Description: This simple ALU performs 3 arithmetic operations for reacting time statistics
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
     Port (OP : in STD_LOGIC_VECTOR(2 downto 0);                  -- Code selects whether the ALU will output: best time, worst time, or average time
          ALU_EN : in STD_LOGIC;                                  -- ALU performs arithmetic when this input is high
          CLK : in STD_LOGIC;                                     -- Clock in 
          A: in integer range 0 to 9999;                          -- Newest reaction time
          B: in integer range 0 to 9999;                          -- Middle reaction time
          C: in integer range 0 to 9999;                          -- Oldest reaction time
          R: out integer range 0 to 9999 := 1111);                -- Result from arithmetic operation
end ALU;

architecture Behavioral of ALU is

begin
    
    arithmetic: process(CLK)
    variable result : integer range 0 to 9999; 
    begin
        if(ALU_en = '1' and rising_edge(CLK)) then
            if(op = "001") then --worst time, BTNU
                result := 0;
                if(a > result) then 
                    result := a;
                end if;
                if(b > result) then 
                    result := b;
                end if;
                if (c > result) then
                    result := c;
                end if;
            elsif(op = "100") then --best time, BTND
                result := 9999;
                 if(a < result) then
                    if(not(a=0)) then 
                        result := a;
                    end if;
                end if;
                if (b < result) then
                    if(not(b=0)) then  
                        result := b;
                    end if;
                end if;
                if (c < result) then
                    if(not(c=0)) then 
                    result := c;
                    end if;
                end if;
            elsif(op = "010") then -- average time, BTNL
                if(a = 0 and B = 0 and c = 0) then 
                   result := 0;
                elsif(A=0 xor  b= 0 xor c =0) then  -- empty values should not be included in the average
                result := (a+b+c)/2;
                elsif(((a =0) and (b= 0))or ((a=0) and (c = 0)) or ((b=0) and (c=0))) then
                result := (a+b+c);
                else
                result := (a+b+c)/3;
                end if;
            end if;
        end if;
        R <= result;
    end process arithmetic;

end Behavioral;
