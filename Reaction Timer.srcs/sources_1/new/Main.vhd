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
           BTNC, BTNU, BTND, BTNL, BTNR : in STD_LOGIC;
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

--SIGNALS--

-- Clock Signals --

signal disp_bound : STD_LOGIC_VECTOR (27 downto 0) := x"0000111";
signal fsm_bound : STD_LOGIC_VECTOR (27 downto 0) := x"000C350";
signal disp_clk, fsm_clk : STD_LOGIC := '0';

-- Display Signals --

signal current_disp : STD_LOGIC_VECTOR (2 downto 0) := "000";
signal current_bcd : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal message : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal dp_out : STD_LOGIC := '0';
signal seg_out : STD_LOGIC_VECTOR (0 to 7);

-- Timing Signals --
signal COUNT_1,COUNT_2,COUNT_3,COUNT_4 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal ones_to_tens, tens_to_hunds, hunds_to_mils, mils_to_beyond : STD_LOGIC :=  '0';
signal enable, reset,global_rst : STD_LOGIC := '0';

-- Arithmetic Signals --
signal op      : STD_LOGIC_VECTOR (2 downto 0);
signal CURRENT_TIME, RESULT : STD_LOGIC_VECTOR (15 downto 0);
signal A, B, C, R : integer;

--COMPONENT DECLARATIONS--

component clock_divider is
        Port ( CLK : in STD_LOGIC;
               UPPERBOUND : in STD_LOGIC_VECTOR (27 downto 0);
               SLOWCLK : out STD_LOGIC);
    end component;
    
component display_counter is -- Display selector
        Port ( CLK : in STD_LOGIC;
               COUNT : out std_logic_vector (2 downto 0));
    end component;

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

component bcd_to_7seg is
        port ( BCD : in STD_LOGIC_VECTOR (3 downto 0);
               DP : in STD_LOGIC;
               SEG : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
   
component FSM is
Port ( CLK, RST: in STD_LOGIC;
           BTNC, BTNU, BTND, BTNL, BTNR  : in STD_LOGIC := '0';
           op : out STD_LOGIC_VECTOR(2 downto 0) := "000";
           CURRENT_TIME : out STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
           RESULT : in STD_LOGIC_VECTOR(15 downto 0);                               
           COUNT_1,COUNT_2,COUNT_3,COUNT_4 : in STD_LOGIC_VECTOR (3 downto 0);  -- uses one segment of the 7 segment display 
           counter_en, counter_rst : out STD_LOGIC := '0'; 
           message : out STD_LOGIC_VECTOR (31 downto 0) := x"aaaaaaaa" );       -- each nibble of message represent one character or digit on a 7 segment display.
end component;
    
component register_16bit is
    Port ( CLK : in STD_LOGIC; 
           D_IN : in STD_LOGIC_VECTOR (15 downto 0);
           D_OUT : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
component ALU is
    Port (op : in STD_LOGIC_VECTOR(2 downto 0);     -- Selects which operation to perform
          A: in integer;      -- time
          B: in integer;    --time
          C: in integer;     -- time
          R: out integer);
    end component;
   
component decade_counter is
        Port ( EN : in STD_LOGIC;                               --An input signal to enable the counter 
               RESET : in STD_LOGIC;                            --An input signal to reset the counter
               INCREMENT : in STD_LOGIC;                        --The "clock" input signal to count edges from
               COUNT : out STD_LOGIC_VECTOR (3 downto 0);       --An output with the current count
               TICK : out STD_LOGIC); 
    end component;



begin  

DP <= not dp_out;
CA <= not seg_out(0);
CB <= not seg_out(1);
CC <= not seg_out(2);
CD <= not seg_out(3);
CE <= not seg_out(4);
CF <= not seg_out(5);
CG <= not seg_out(6);

--DISPLAY MODULES--

disp_clk_divider : clock_divider port map (CLK => CLK100MHZ, UPPERBOUND => disp_bound, SLOWCLK => disp_clk);

disp_select : display_counter port map(CLK => disp_clk, COUNT => current_disp);
anode_decoder : decoder port map(DISPLAY_SELECTED => current_disp, ANODE => AN);
disp_mux : mux port map (DISPLAY_SEL => current_disp, MESSAGE => message, BCD => current_bcd, DP => dp_out);
cathode_decoder : bcd_to_7seg port map (BCD => current_bcd, DP => dp_out, SEG => seg_out);

--FUNCTIONALITY MODULES--

fsm_clk_divider : clock_divider port map (CLK => CLK100MHZ, UPPERBOUND => fsm_bound, SLOWCLK => fsm_clk);
fsm_block : FSM port map (BTNC => BTNC, BTNU => BTNU,BTND => BTND,BTNL => BTNL, BTNR => BTNR, CLK => fsm_clk, RST => global_rst, RESULT => RESULT, CURRENT_TIME => CURRENT_TIME, COUNT_1 => COUNT_1, COUNT_2 => COUNT_2, COUNT_3 => COUNT_3, COUNT_4 => COUNT_4, COUNTER_EN => enable, COUNTER_RST => reset, MESSAGE => message);

--register_A : register_16bit port map(CLK => op_en, D_in => A_in, D_out => A_out);
--register_B : register_16bit port map(CLK => op_en, D_in => B_in, D_out => B_out);
ALU_block : ALU port map(op =>op, A => A, B =>B, C =>C, R =>R);
--register_R : register_16bit port map(CLK => op_done, D_in => R_in, D_out => R_out);

ones : decade_counter port map (EN => enable, RESET => reset, INCREMENT => fsm_clk, COUNT => COUNT_1, TICK => ones_to_tens);
tens : decade_counter port map (EN => enable, RESET => reset, INCREMENT => ones_to_tens, COUNT => COUNT_2, TICK => tens_to_hunds);
hunds : decade_counter port map (EN => enable, RESET => reset, INCREMENT => tens_to_hunds, COUNT => COUNT_3, TICK => hunds_to_mils);
mils : decade_counter port map (EN => enable, RESET => reset, INCREMENT => hunds_to_mils, COUNT => COUNT_4, TICK => mils_to_beyond);





end Behavioral;
