----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2024 22:06:02
-- Design Name: 
-- Module Name: register_16bit - Behavioral
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

entity register_16bit is
    Port ( CLK : in STD_LOGIC; 
           D_IN : in STD_LOGIC_VECTOR (15 downto 0);
           D_OUT : out STD_LOGIC_VECTOR (15 downto 0));
end register_16bit;

architecture Behavioral of register_16bit is

begin
process(CLK)
begin
    if rising_edge(CLK) then
        D_OUT <= D_IN;
    end if;
end process;

end Behavioral;
