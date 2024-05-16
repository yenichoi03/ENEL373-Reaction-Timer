----------------------------------------------------------------------------------
-- Title: Main
-- Authors: EWB, YYC, & MWD
-- Date: 2024
-- Description: This is the top level structural module for implementation of a
--              reaction timer on the Nexys-4 DDR FPGA board
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
    Port ( CLK100MHZ : in STD_LOGIC;                     -- System clock signal
           BTNC, BTNU, BTND, BTNL, BTNR : in STD_LOGIC;  -- Button inputs
           AN: out STD_LOGIC_VECTOR (7 downto 0);        -- 7 Segment display anodes
           CA: out STD_LOGIC;                            -- 7 Segment display cathodes
           CB: out STD_LOGIC;
           CC: out STD_LOGIC;
           CD: out STD_LOGIC;
           CE: out STD_LOGIC;
           CF: out STD_LOGIC;
           CG: out STD_LOGIC;
           DP: out STD_LOGIC);
end main;

architecture Structural of main is

----------------------------------------------------------------------------------
-- SIGNAL DECLARATIONS
----------------------------------------------------------------------------------

-- Clock Signals --

signal disp_bound : STD_LOGIC_VECTOR (27 downto 0) := x"00249F0";
signal fsm_bound : STD_LOGIC_VECTOR (27 downto 0) := x"000C350";
signal disp_clk, fsm_clk : STD_LOGIC := '0';

-- Display Signals --

signal current_disp : STD_LOGIC_VECTOR (2 downto 0) := "000";
signal current_bcd : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal message : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal dp_out : STD_LOGIC := '0';
signal seg_out : STD_LOGIC_VECTOR (0 to 7);

-- Timer Signals --
signal count_1,count_2,count_3,count_4 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal ones_to_tens, tens_to_hunds, hunds_to_mils, mils_to_beyond : STD_LOGIC :=  '0';
signal enable, reset,global_rst : STD_LOGIC := '0';
signal random : integer range 0 to 5000;

-- Arithmetic Signals --
signal op : STD_LOGIC_VECTOR (2 downto 0);
signal alu_en, shift_en, shift_rst  : STD_LOGIC;
signal current_time, result : STD_LOGIC_VECTOR (15 downto 0);
signal a, b, c, r : integer range 0 to 9999;

----------------------------------------------------------------------------------
--COMPONENT DECLARATIONS
----------------------------------------------------------------------------------

component clock_divider is 
        Port ( CLK : in STD_LOGIC;                              -- Original frequency clock input
               UPPERBOUND : in STD_LOGIC_VECTOR (27 downto 0);  -- Number of rising clock edges per output clock edge
               SLOWCLK : out STD_LOGIC);                        -- Reduced frequency output clock signal
    end component;
    
component display_counter is 
        Port ( CLK : in STD_LOGIC;                              -- Clock in controls frequency displays are cycled
               COUNT : out std_logic_vector (2 downto 0));      -- Outputs the currently active display
    end component;

component mux is
    Port ( DISPLAY_SEL : in STD_LOGIC_VECTOR (2 downto 0);       -- Selects which of the 8 displays is active
           MESSAGE : in STD_LOGIC_VECTOR (31 downto 0);          -- Overall message to be displayed 
           BCD : out STD_LOGIC_VECTOR (3 downto 0);              -- Character to be displayed on the selected display
           DP : out STD_LOGIC);                                  -- High if decimal point should be displayed on selected display
    end component;
    
component decoder is
    Port ( DISPLAY_SEL : in STD_LOGIC_VECTOR (2 downto 0);   -- Selects which of the 8 displays is active
           ANODE : out STD_LOGIC_VECTOR (7 downto 0));       -- Activates corresponding anode
end component;

component bcd_to_7seg is
        port ( BCD : in STD_LOGIC_VECTOR (3 downto 0);           -- 4 bit binary coded decimal value
               DP : in STD_LOGIC;                                -- High if decimal point should display 
               SEG : out STD_LOGIC_VECTOR (7 downto 0));         -- 7 segment display cathode values
  end component;
    
component decade_counter is
        Port ( EN : in STD_LOGIC;                                 -- An input signal to enable the counter 
               RESET : in STD_LOGIC;                              -- An input signal to reset the counter
               INCREMENT : in STD_LOGIC;                          -- The "clock" input signal to count edges from
               COUNT : out STD_LOGIC_VECTOR (3 downto 0);         --An output with the current count between 0 and 9
               TICK : out STD_LOGIC);                             -- Toggles every 0-9 cycle
    end component;
    
component PRNG is 
        Port (  CLK : in std_logic;                               -- Clock input
                RANDOM : out integer range 0 to 5000);            -- Pseudo random integer output 
        end component;  
    
component shift_reg is
  Port ( time_in : in STD_LOGIC_VECTOR( 15 downto 0);             -- The next value to be added to the register
           A, B, C : out INTEGER range 0 to 9999;                 -- The 3 values currently in the shift register
           shift_en, reset: in STD_LOGIC);                        -- Input shifts into the register when shift_en is high
                                                                  -- All values are set to zero when reset is high
    end component;
    
component ALU is
     Port (OP : in STD_LOGIC_VECTOR(2 downto 0);                  -- Code selects whether the ALU will output: best time, worst time, or average time
          ALU_EN : in STD_LOGIC;                                  -- ALU performs arithmetic when this input is high
          clk : in STD_LOGIC;                                     -- Clock in 
          A: in integer range 0 to 9999;                          -- Newest reaction time
          B: in integer range 0 to 9999;                          -- Middle reaction time
          C: in integer range 0 to 9999;                          -- Oldest reaction time
          R: out integer range 0 to 9999 := 1111);                -- Result from arithmetic operation
    end component;
    
component int_to_bcd is
    Port ( INT_RESULT : in integer range 0 to 5000;               -- Integer input from the ALU result
           BCD_RESULT : out std_logic_vector(15 downto 0));       -- BCD output to be displayed
end component;  
    
component FSM is
    Port ( clk, rst: in STD_LOGIC;                                              -- Clock in and global reset  
           BTNC, BTNU, BTND, BTNL, BTNR  : in STD_LOGIC := '0';                 -- External button inputs
           op : out STD_LOGIC_VECTOR(2 downto 0) := "000";                      -- ALU op code
           current_time : out STD_LOGIC_VECTOR(15 downto 0) := (others => '0'); -- Most recent reaction time
           result : in STD_LOGIC_VECTOR(15 downto 0);                           -- ALU output    
           count_1,count_2,count_3,count_4 : in STD_LOGIC_VECTOR (3 downto 0);  -- Each digit of the measured time
           counter_en, counter_rst : out STD_LOGIC := '0';                      -- Enable and reset the counters for timing
           alu_en : out STD_LOGIC := '0';                                       -- Enable the ALU
           shift_en, shift_rst : out STD_LOGIC := '0';                          -- Enable and reset for the shift register of reaction times
           message : out STD_LOGIC_VECTOR (31 downto 0) := x"aaaaaaaa" ;        -- each nibble of message represent one character or digit on a 7 segment display.
           random : in INTEGER range 0 to 5000);                                -- An always changing pseudorandom number
end component;
     
begin

-- Active low 7 segment display cathodes
DP <= not dp_out;
CA <= not seg_out(0);
CB <= not seg_out(1);
CC <= not seg_out(2);
CD <= not seg_out(3);
CE <= not seg_out(4);
CF <= not seg_out(5);
CG <= not seg_out(6);

-- Display Components --
disp_clk_divider : clock_divider port map (CLK => CLK100MHZ, UPPERBOUND => disp_bound, SLOWCLK => disp_clk);
display_select : display_counter port map(CLK => disp_clk, COUNT => current_disp);
display_mux : mux port map (DISPLAY_SEL => current_disp, MESSAGE => message, BCD => current_bcd, DP => dp_out);
anode_decoder : decoder port map(DISPLAY_SEL => current_disp, ANODE => AN);
cathode_decoder : bcd_to_7seg port map (BCD => current_bcd, DP => dp_out, SEG => seg_out);

-- Timer Components --
ones : decade_counter port map (EN => enable, RESET => reset, INCREMENT => fsm_clk, COUNT => count_1, TICK => ones_to_tens);
tens : decade_counter port map (EN => enable, RESET => reset, INCREMENT => ones_to_tens, COUNT => count_2, TICK => tens_to_hunds);
hunds : decade_counter port map (EN => enable, RESET => reset, INCREMENT => tens_to_hunds, COUNT => count_3, TICK => hunds_to_mils);
mils : decade_counter port map (EN => enable, RESET => reset, INCREMENT => hunds_to_mils, COUNT => count_4, TICK => mils_to_beyond);

number_generator : PRNG port map (CLK => disp_clk, RANDOM => random); 

-- Arithmetic Components --
reaction_time_storage : shift_reg port map (RESET => shift_rst, SHIFT_EN => shift_en, A=>a, B=>b, C=>c, TIME_IN => current_time);
ALU_block : ALU port map(OP =>op,CLK => fsm_clk, ALU_EN => alu_en, A => a, B =>b, C =>c, R =>r);
result_to_bcd : int_to_bcd port map(INT_RESULT => r, BCD_RESULT => result);

-- State Machine Components --
fsm_clk_divider : clock_divider port map (CLK => CLK100MHZ, UPPERBOUND => fsm_bound, SLOWCLK => fsm_clk);
fsm_block : FSM port map ( CLK => fsm_clk, RST => global_rst,
                           BTNC => BTNC, BTNU => BTNU,BTND => BTND, BTNL => BTNL, BTNR => BTNR, 
                           OP => op, 
                           CURRENT_TIME => current_time, RESULT => result,
                           COUNT_1 => count_1, COUNT_2 => count_2, COUNT_3 => count_3, COUNT_4 => count_4,
                           COUNTER_EN => enable, COUNTER_RST => reset,
                           ALU_EN => alu_en,   
                           SHIFT_RST => shift_rst, SHIFT_EN => shift_en,
                           MESSAGE => message, 
                           RANDOM => random);

end Structural;























