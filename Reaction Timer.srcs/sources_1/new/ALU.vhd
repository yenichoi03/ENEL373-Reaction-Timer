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
          A: in STD_LOGIC_VECTOR(15 downto 0);      -- The BCD input from register A
          B: in STD_LOGIC_VECTOR(15 downto 0);      -- The BCD input from register B
          R: out STD_LOGIC_VECTOR(15 downto 0));    -- The BCD output 
end ALU;

architecture Behavioral of ALU is

begin
process(op_en)
begin
if(rising_edge(op_en)) then
    if(op = "001") then
        R <= to_integer(A) + to_integer(B);
        op_done <= '1';
    elsif(op = "010") then
        R <= std_logic_vector(unsigned(B) - unsigned(A));
        op_done <= '1';
        --Subtract B from A
        --Put result in R
    elsif(op = "011") then
        --Divide reg A by reg B and put result in reg R
    elsif(op = "110") then      -- make (op = "100")
        --Compare A and B
        --Put bigger value in R
        if (A > B) then
            R <= A;
        elsif (B > A) then
            R <= B;
        
    elsif(op = "111") then      -- make (op = "101")
        --Compare A and B
        --Put smaller value in R
        if (A < B) then
            R <= A;
        elsif (B < A) then
            R <= B;
    else
        op_done <= '0';
    end if;
end if;

end process (op_en);


end Behavioral;
