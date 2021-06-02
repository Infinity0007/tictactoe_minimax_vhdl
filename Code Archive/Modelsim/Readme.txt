Use RTL simulation for better analysis of signals and states of the system.
For RTL simulation, tictactoe is the top-level entity and tictactoe_tb is the testbench.
Run for 120 ms

For gate level simulation, there were some package errors related to work library 
because of their supposed invisibililty. Hence, we had to create tictactoe_game as 
another top-level entity which instantiates our usual tictactoe entity; and the 
corresponding testbench tictactoe_tb. It takes a lot of time to stimulate.
Run for 50 ns