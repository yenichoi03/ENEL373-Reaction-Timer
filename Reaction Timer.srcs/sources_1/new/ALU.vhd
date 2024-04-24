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
          op_en : in STD_LOGIC;                     -- Enable/disable ALU functions 
          op_done : out STD_LOGIC;                  -- Indicates if ALU operation is finished (Where would this output go?)
          A: in integer;      -- time
          B: in integer;    --time
          C: in integer;     -- time
          R: out integer);    -- result
end ALU;

architecture Behavioral of ALU is

begin
process(op)
variable result : integer := 0;
variable num_runs : integer := 0;
begin

if(op = "000") then --worst time
    result := 0;
    if(A > result) then 
        result := A;
    end if;
    if (B > result) then 
        result := B;
    end if;
    if (C > result) then
        result := C;
    end if;
elsif(op = "111") then --best time
    result := 99999;
     if(A < result) then 
        result := A;
    end if;
    if (B < result) then 
        result := B;
    end if;
    if (C < result) then
        result := C;
    end if;
elsif(op = "010") then -- average
    if(not(A = 0)) then 
        num_runs := num_runs + 1;
    end if;
    if(not(B = 0)) then 
        num_runs := num_runs + 1;
    end if;
    if(not(B = 0)) then 
        num_runs := num_runs + 1;
    end if;
    result := (A+B+C)/num_runs;
end if;
R <= result;

end process;



end Behavioral;
