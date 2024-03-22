library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplex_tb is
end Multiplex_tb;

architecture Behavioral of Multiplex_tb is
    signal DISPLAY_SEL : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal MESSAGE : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000111111";
    signal BCD : STD_LOGIC_VECTOR (3 downto 0);
    signal DP : STD_LOGIC;
   
   
begin
    inst_mux : entity work.mux(Behavioral)
    port map(DISPLAY_SEL => DISPLAY_SEL, MESSAGE => MESSAGE, BCD => BCD, DP => DP);
   
    process (DISPLAY_SEL)is
    begin
        if DISPLAY_SEL = "111" then
            DISPLAY_SEL <= "000";
        else
            DISPLAY_SEL <= std_logic_vector(unsigned(DISPLAY_SEL) + 1) after 10 ns;
        end if;
    end process;
       
end Behavioral;