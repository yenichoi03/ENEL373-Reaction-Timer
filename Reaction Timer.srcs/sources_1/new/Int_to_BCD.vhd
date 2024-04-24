----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2024 17:18:40
-- Design Name: 
-- Module Name: Int_to_BCD - Behavioral
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

--library UNISIM;
--use UNISIM.VComponents.all;

entity Int_to_BCD is
    Port ( int_result : in integer;
           bcd_result : out std_logic_vector(15 downto 0));
end Int_to_BCD;

architecture Behavioral of Int_to_BCD is
    signal int_vector: std_logic_vector(3 downto 0):= (others => '0');
    signal nibble: std_logic_vector(3 downto 0) := (others => '0');
     
begin
    process (int_result) is
    begin 
    int_vector <= std_logic_vector(to_unsigned(int_result, int_vector'length));
    nibble <= 

    end process;
end Behavioral;
