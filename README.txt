This Git Repo contains VHDL files for Group 17's Reaction Timer Project:

* Source code for our top level structural module main.vhd (inside sources_1)
* Source code for all other behavioural sub modules (inside sources_1)
* Test benches for our ALU and shift register modules (inside sim_1)
* Constraints file (inside constrs_1)

The program prompts the user with three decimal points on a seven-segment array that turn off sequentially. Once off, a timer starts until the centre push button is pressed. After pressing the button, the elapsed time displays on the array. Pushing BTNC again restarts the sequence for another test. Pressing before the last decimal point goes out shows an error. Outside a test, BTNR shows the average time, BTNU the longest, BTND the shortest, and BTNL clears data. An additional project extension introduces random delays between decimal point turn-offs so that the user cannot preempt the last decimal point turning off.
