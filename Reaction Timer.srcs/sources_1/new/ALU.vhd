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
    variable num_runs : integer := 3;
    variable aa : integer := 100;
    variable bb : integer := 0;
    variable cc : integer := 300;
    
    begin

    if(ALU_en ='1') then
        if(op = "001") then --worst time
            result := 0;
            if(aa > result) then 
                result := aa;
            end if;
            if (Bb > result) then 
                result := Bb;
            end if;
            if (Cc > result) then
                result := Cc;
            end if;
        elsif(op = "100") then --best time
            result := 99999;
             if(Aa < result) then 
                result := Aa;
            end if;
            if (Bb < result) then 
                result := Bb;
            end if;
            if (cC < result) then
                result := cc;
            end if;
        elsif(op = "010") then -- average
            if(Aa = 0 and Bb = 0 and Cc = 0) then 
               result := 0;
            elsif(Aa=0 xor  Bb= 0 xor Cc =0) then
            result := (Aa+bB+cC)/2;
            elsif(((Aa =0) and (Bb= 0))or ((Aa=0) and (Cc = 0)) or ((Bb=0) and (Cc=0))) then
            result := (Aa+bB+cC);
            else
            result := (Aa+bB+cC)/3;
            end if;
        end if;
       
    end if;
        R <= result;

end process;



end Behavioral;
