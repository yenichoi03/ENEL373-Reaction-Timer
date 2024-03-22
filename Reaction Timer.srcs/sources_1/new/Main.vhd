library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( CLK100MHZ : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (7 downto 0);
           AN: out STD_LOGIC_VECTOR (7 downto 0);
           BTNC : in STD_LOGIC;
           CA: out STD_LOGIC;
           CB: out STD_LOGIC;
           CC: out STD_LOGIC;
           CD: out STD_LOGIC;
           CE: out STD_LOGIC;
           CF: out STD_LOGIC;
           CG: out STD_LOGIC;
           DP: out STD_LOGIC);
           
       --;CPU_RESETN : in STD_LOGIC
end main;

architecture Behavioral of main is

component clock_divider is
        Port ( CLK : in STD_LOGIC;
               UPPERBOUND : in STD_LOGIC_VECTOR (27 downto 0);
               SLOWCLK : out STD_LOGIC);
    end component;
    
signal disp_bound : STD_LOGIC_VECTOR (27 downto 0) := x"0000111";
signal fsm_bound : STD_LOGIC_VECTOR (27 downto 0) := x"000C350";
signal disp_clk, fsm_clk : STD_LOGIC := '0';

component display_counter is -- Display selector
        Port ( CLK : in STD_LOGIC;
               COUNT : out std_logic_vector (2 downto 0));
    end component;

signal current_disp : STD_LOGIC_VECTOR (2 downto 0) := "000";

component decoder is
        Port ( DISPLAY_SELECTED : in STD_LOGIC_VECTOR (2 downto 0);
               ANODE : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

component mux is
    Port ( DISPLAY_SEL : in STD_LOGIC_VECTOR (2 downto 0);
           MESSAGE : in STD_LOGIC_VECTOR (31 downto 0);
           BCD : out STD_LOGIC_VECTOR (3 downto 0);
           DP : out STD_LOGIC);
    end component;

signal message : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal dp_out : STD_LOGIC := '0';
signal current_bcd : STD_LOGIC_VECTOR (3 downto 0) := "0000";

component bcd_to_7seg is
        port ( BCD : in STD_LOGIC_VECTOR (3 downto 0);
               DP : in STD_LOGIC;
               SEG : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
signal seg_out : STD_LOGIC_VECTOR (0 to 7);    

component decade_counter is
        Port ( EN : in STD_LOGIC;                               --An input signal to enable the counter 
               RESET : in STD_LOGIC;                            --An input signal to reset the counter
               INCREMENT : in STD_LOGIC;                        --The "clock" input signal to count edges from
               COUNT : out STD_LOGIC_VECTOR (3 downto 0);       --An output with the current count
               TICK : out STD_LOGIC); 
    end component;
   
signal COUNT_1,COUNT_2,COUNT_3,COUNT_4 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal ones_to_tens, tens_to_hunds, hunds_to_mils, mils_to_beyond : STD_LOGIC :=  '0';

component FSM is
    Port ( CLK, RST: in STD_LOGIC;
           BTN : in STD_LOGIC := '0';                                  -- This is also used as a reset as well
           COUNT_1,COUNT_2,COUNT_3,COUNT_4 : in STD_LOGIC_VECTOR (3 downto 0);  -- uses one segment of the 7 segment display 
           counter_en, counter_rst : out STD_LOGIC := '0'; 
           message : out STD_LOGIC_VECTOR (31 downto 0));       -- each nibble of message represent one character or digit on a 7 segment display.
    end component;

signal enable, reset,global_rst   : STD_LOGIC := '0';

begin  

disp_clk_divider : clock_divider port map (CLK => CLK100MHZ, UPPERBOUND => disp_bound, SLOWCLK => disp_clk);
fsm_clk_divider : clock_divider port map (CLK => CLK100MHZ, UPPERBOUND => fsm_bound, SLOWCLK => fsm_clk);

disp_select : display_counter port map(CLK => disp_clk, COUNT => current_disp);

anode_decoder : decoder port map(DISPLAY_SELECTED => current_disp, ANODE => AN);

disp_mux : mux port map (DISPLAY_SEL => current_disp, MESSAGE => message, BCD => current_bcd, DP => dp_out);

cathode_decoder : bcd_to_7seg port map (BCD => current_bcd, DP => dp_out, SEG => seg_out);

DP <= not dp_out;
CA <= not seg_out(0);
CB <= not seg_out(1);
CC <= not seg_out(2);
CD <= not seg_out(3);
CE <= not seg_out(4);
CF <= not seg_out(5);
CG <= not seg_out(6);

ones : decade_counter port map (EN => enable, RESET => reset, INCREMENT => fsm_clk, COUNT => COUNT_1, TICK => ones_to_tens);
tens : decade_counter port map (EN => enable, RESET => reset, INCREMENT => ones_to_tens, COUNT => COUNT_2, TICK => tens_to_hunds);
hunds : decade_counter port map (EN => enable, RESET => reset, INCREMENT => tens_to_hunds, COUNT => COUNT_3, TICK => hunds_to_mils);
mils : decade_counter port map (EN => enable, RESET => reset, INCREMENT => hunds_to_mils, COUNT => COUNT_4, TICK => mils_to_beyond);


fsm_block : FSM port map (BTN => BTNC, CLK => fsm_clk, RST => global_rst, COUNT_1 => COUNT_1, COUNT_2 => COUNT_2, COUNT_3 => COUNT_3, COUNT_4 => COUNT_4, COUNTER_EN => enable, COUNTER_RST => reset, MESSAGE => message);

end Behavioral;
