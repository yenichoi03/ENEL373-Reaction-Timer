----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2024 13:18:38
-- Design Name: 
-- Module Name: ALU - Behavioral
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


entity ALU is
    Port (op : in STD_LOGIC_VECTOR(2 downto 0);     -- Selects which operation to perform
          ALU_en : in STD_LOGIC; --activates ALU
          A: in integer;      -- time
          B: in integer;    --time
          C: in integer;     -- time
          R: out integer:= 1111);    -- result
end ALU;

architecture Behavioral of ALU is

begin
    process(ALU_en)
    variable result : integer := 0000;
--    variable aa : integer := 100;
--    variable bb : integer := 500;
--    variable cc : integer := 300;
    
    begin

    if(ALU_en ='1') then
        if(op = "001") then --worst time
            result := 0;
            if(a > result) then 
                result := a;
            end if;
            if (a > result) then 
                result := a;
            end if;
            if (c > result) then
                result := c;
            end if;
        elsif(op = "100") then --best time
            result := 99999;
             if(a < result) then 
                result := a;
            end if;
            if (b < result) then 
                result := b;
            end if;
            if (c < result) then
                result := c;
            end if;
        elsif(op = "010") then -- average
            if(a = 0 and B = 0 and c = 0) then 
               result := 0;
            elsif(A=0 xor  b= 0 xor c =0) then
            result := (a+b+c)/2;
            elsif(((a =0) and (b= 0))or ((a=0) and (c = 0)) or ((b=0) and (c=0))) then
            result := (a+b+c);
            else
            result := (a+b+c)/3;
            end if;
        end if;
       
    end if;
        R <= result;

end process;



end Behavioral;
