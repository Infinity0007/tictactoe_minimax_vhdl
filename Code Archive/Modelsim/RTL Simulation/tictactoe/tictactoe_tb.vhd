library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commonpackage.all;

entity tictactoe_tb is
end entity;

architecture sim of tictactoe_tb is
    component tictactoe is
        port(
            -- inputs
            CLOCK_50 : in std_logic;
            human_board : in board_type;
            KEY : in std_logic;
            --outputs
            led_ind : out std_logic;
            state_out : out states;
            board_out : out board_type
        );
    end component;
	 -- IP Block
		component ram IS
			PORT
			(
				address		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
				clock		: IN STD_LOGIC  ;
				data		: IN STD_LOGIC_VECTOR (17 DOWNTO 0);
				wren		: IN STD_LOGIC ;
				q		: OUT STD_LOGIC_VECTOR (17 DOWNTO 0)
			);
		END component;

    signal clk,wren : std_logic := '0';
    signal human_board : board_type := (others => (none,none,none));
    signal clear_input : std_logic := '1';
    signal current_board : board_type;
    signal led_ind : std_logic;
    signal state : states;
	 signal data,q_ip : std_logic_vector(17 downto 0) := (others => '0');
	 signal address : std_logic_vector(4 downto 0) := (others => '0');
begin
    dut : tictactoe port map(clk,human_board,clear_input,led_ind,state,current_board);
	 dutip : ram port map(address,clk,data,wren,q_ip);
	 
    clk <= not clk after 10 ns;

    process(clk) is
        variable flag,flag_1,flagwr : std_logic := '0';
        variable flag_0,flag_2 : integer := 0;
		  variable a : integer;
		  
    begin
        if(rising_edge(clk)) then

            if(led_ind = '1') then
                -- 1. Human Input
                if(flag_0 = 0) then
                    flag := '0';
                    for i in 0 to 2 loop
                        for j in 0 to 2 loop
                            if(flag = '0') then
                                if(current_board(i)(j) = none) then -- Look for the first empty place on board
                                    human_board(i)(j) <= you;
                                    flag := '1';
                                end if;
                            end if;
                        end loop;
                    end loop;
                -- 2. Human Input
					 -- Here the inputs are predefined and it(human) plays these move successively
                elsif(flag_0 = 1) then
                    if(flag = '0') then
                        if(flag_2 = 0) then
                            human_board(0)(2) <= you; 
                        elsif(flag_2 = 1) then
                            human_board(2)(0) <= you;
                        elsif(flag_2 = 2) then
                            human_board(0)(0) <= you;
								
                        end if;
                        flag_2 := flag_2 + 1;
                        flag := '1'; 
                    else 
                        flag := '0';
                    end if;
                end if;
                clear_input <= '1';
            end if;

            if(state = complete) then
                -- Clear for next Game
                if(flag_1 = '0') then
                    clear_input <= '0';
                    human_board <= (others => (none,none,none));
                    flag := '0';
                    flag_0 := 1;
                    flag_1 := '1';
						  
                end if;
            end if;   
            
        end if;
		  -- IP Block
		 if(falling_edge(clk)) then
		 				wren <= '0';
			if(state = complete) then				
				  a := 17;
				  for i in 0 to 2 loop
						for j in 0 to 2 loop
							 if(current_board(i)(j) = me) then
								  data(a) <= '1';
								  a := a - 1;
								  data(a) <= '0';
								  a := a - 1;
							 elsif(current_board(i)(j) = you) then
								  data(a) <= '0';
								  a := a - 1;
								  data(a) <= '1';
								  a := a - 1;
							 else
								  data(a) <= '1';
								  a := a - 1;
								  data(a) <= '1';
								  a := a - 1;
							 end if;
						end loop;
				  end loop;
					 address <= "00000";
					 if(flagwr = '0') then
						wren <= '1';
						flagwr := '1';
					end if;
					 
            end if;   
		 end if;
    end process;
end architecture;