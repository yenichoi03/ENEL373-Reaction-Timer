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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port (op : in STD_LOGIC_VECTOR(2 downto 0);
          op_en : in STD_LOGIC;
          op_done : out STD_LOGIC;
          A: in STD_LOGIC_VECTOR(15 downto 0);
          B: in STD_LOGIC_VECTOR(15 downto 0);
          R: out STD_LOGIC_VECTOR(15 downto 0));
end ALU;

architecture Behavioral of ALU is

begin
process(op_en)
begin
if(rising_edge(op_en)) then
    if(op = "001") then
        R <= std_logic_vector(unsigned(A) + unsigned(B));
        op_done <= '1';
    elsif(op = "010") then
        --Divide reg A by reg B and put result in reg R
    elsif(op = "100") then
        --Compare A and B
        --Put (others => '1') in R if A is greater than B, otherwise put (others => '0')
    else
        op_done <= '0';
    end if;
end if;

end process;


end Behavioral;
