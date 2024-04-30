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


entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is

signal op : std_logic_vector (2 downto 0) := "101"; -- 001 for add, 010 for divide, 100 for compare
signal ALU_en : std_logic := '1';
signal A, B : integer := 1;
signal C : integer := 4;
signal R : integer := 0;

begin

op <= "010" after 1ns;

inst_ALU : entity work.ALU(Behavioral)
port map (op => op, A=>A, B=>B, C=>C, R=>R, ALU_en => ALU_en);

end Behavioral;
