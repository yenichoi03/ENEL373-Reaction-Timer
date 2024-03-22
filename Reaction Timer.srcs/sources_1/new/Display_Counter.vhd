----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2024 17:17:02
-- Design Name: 
-- Module Name: Display_Counter - Behavioral
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

entity Display_Counter is
    Port ( CLK : in STD_LOGIC;
           COUNT : out std_logic_vector (2 downto 0));
end Display_Counter;

architecture Behavioral of Display_Counter is
    signal count_tmp: std_logic_vector (2 downto 0) := (others => '0');
begin

    COUNT <= count_tmp;
    process (CLK)
    begin

        if count_tmp = "111" then
            count_tmp <= "000";
        
        elsif rising_edge(CLK) then
                count_tmp <= std_logic_vector(unsigned(count_tmp) + 1);
        end if;
    end process;
    
end Behavioral;
