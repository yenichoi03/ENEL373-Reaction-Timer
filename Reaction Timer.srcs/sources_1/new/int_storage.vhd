----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2024 17:07:18
-- Design Name: 
-- Module Name: int_storage - Behavioral
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

entity int_storage is
    Port ( New_time : in std_logic_vector (15 downto 0);
            time_a, time_b, time_c : out integer );
end int_storage;

architecture Behavioral of int_storage is
    
    signal temp_new, temp_a, temp_b, temp_c : integer;
    signal oldest : std_logic_vector (2 downto 0);
    signal ones, tens, hunds, thous : INTEGER ;
      
begin
    process(New_time) is
    begin
        thous <= TO_INTEGER(UNSIGNED(New_time(15 downto 12)));
        hunds <= TO_INTEGER(UNSIGNED(New_time(11 downto 8)));
        tens <= TO_INTEGER(UNSIGNED(New_time(7 downto 4)));
        ones <= TO_INTEGER(UNSIGNED(New_time(3 downto 0)));
        
        temp_new <= ones + tens * 10 + hunds * 100 + thous * 1000;
    end process;
end Behavioral;
