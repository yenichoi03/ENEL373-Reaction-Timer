----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2024 22:23:11
-- Design Name: 
-- Module Name: ALU_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is

signal op_en, op_done : std_logic := '0';
signal op : std_logic_vector (2 downto 0) := "001"; -- 001 for add, 010 for divide, 100 for compare
signal A, B, R : std_logic_vector (15 downto 0) := x"1111";

begin

op_en <= '1' after 1ns;

inst_ALU : entity work.ALU(Behavioral)
port map (op_en => op_en, op_done => op_done, op => op, A=>A, B=>B, R=>R);

end Behavioral;
