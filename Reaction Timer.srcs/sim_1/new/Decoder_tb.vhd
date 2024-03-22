----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 10:25:41
-- Design Name: 
-- Module Name: Decoder_tb - Behavioral
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

entity decoder_tb is
end decoder_tb;

architecture Behavioral of decoder_tb is
    signal sim_clk : STD_LOGIC := '1';
    signal disp : STD_LOGIC_VECTOR (2 downto 0) := "001";
    signal anode : STD_LOGIC_VECTOR (7 downto 0);
    
    component display_counter is
        Port ( CLK : in STD_LOGIC;
           COUNT : out std_logic_vector (2 downto 0));
    end component;
 
    
    component decoder is
        Port ( DISPLAY_SELECTED : in STD_LOGIC_VECTOR (2 downto 0);
               ANODE : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

begin
    sim_clk <= not sim_clk after 5ns;
    disp_count: display_counter port map (CLK => sim_clk, COUNT => disp);
    dec : decoder port map(DISPLAY_SELECTED => disp, ANODE => anode);

end Behavioral;

