library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commonpackage.all;
use work.minimaxelemtpkg.all;

entity tictactoe is
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
end tictactoe;

architecture rtl of tictactoe is
    
    signal state : states := ready;
    signal board : board_type := (others => (none,none,none)); --(none,none,none,none,none,none,none,none,none);
    signal old_board : board_type;
    signal current_depth : integer := 9;
    signal check_next : std_logic_vector(8 downto 0) := (others => '0');
    type integerarray is array(8 downto 0) of integer;
    signal bestmove_i,bestmove_j : integerarray;
    type    statearray is array(8 downto 0) of states;
    signal state_next : statearray;
    signal done_next : std_logic_vector(8 downto 0);
    
begin
    board_out <= board;
    state_out <= state;
    dut_0 : minimaxelemt_1 port map(CLOCK_50,board,check_next(0),open,done_next(0),bestmove_i(0),bestmove_j(0),state_next(0));
    dut_1 : minimaxelemt_2 port map(CLOCK_50,board,check_next(1),open,done_next(1),bestmove_i(1),bestmove_j(1),state_next(1));
    dut_2 : minimaxelemt_3 port map(CLOCK_50,board,check_next(2),open,done_next(2),bestmove_i(2),bestmove_j(2),state_next(2));
    dut_3 : minimaxelemt_4 port map(CLOCK_50,board,check_next(3),open,done_next(3),bestmove_i(3),bestmove_j(3),state_next(3));
    dut_4 : minimaxelemt_5 port map(CLOCK_50,board,check_next(4),open,done_next(4),bestmove_i(4),bestmove_j(4),state_next(4));
    dut_5 : minimaxelemt_6 port map(CLOCK_50,board,check_next(5),open,done_next(5),bestmove_i(5),bestmove_j(5),state_next(5));
    dut_6 : minimaxelemt_7 port map(CLOCK_50,board,check_next(6),open,done_next(6),bestmove_i(6),bestmove_j(6),state_next(6));
    dut_7 : minimaxelemt_8 port map(CLOCK_50,board,check_next(7),open,done_next(7),bestmove_i(7),bestmove_j(7),state_next(7));
    dut_8 : minimaxelemt_9 port map(CLOCK_50,board,check_next(8),open,done_next(8),bestmove_i(8),bestmove_j(8),state_next(8));

    process(CLOCK_50) is
    variable temp : integer;
    begin
        if(rising_edge(CLOCK_50)) then
            if(state = ready) then
                board <= (others => (none,none,none));
                current_depth <= 9;
                check_next <= (others => '0');
                led_ind <= '0';
                state <= turn_ai;				-- First turn of ai
            elsif(state = turn_ai) then
                check_next(current_depth-1) <= '1';		-- Appropriate minimaxelemt called
                state <= fetch_wait;
            elsif(state = fetch_wait) then			-- wait till minimaxelemt completes it operation
                if(state_next(current_depth-1) = complete) then
                    check_next(current_depth - 1) <= '0';
                    state <= fetch_result;
                else
                    state <= fetch_wait;
                end if;
            elsif(state = fetch_result) then
                if(done_next(current_depth - 1) = '1') then		-- Retrieving the best move from minimaxelemt and placing it on board for 'X'
                    -- best move available
                    if(current_depth rem 2 = 0 ) then
                        board(bestmove_i(current_depth-1))(bestmove_j(current_depth-1)) <= you;		-- Even current_depth means 'O'
                    else
                        board(bestmove_i(current_depth-1))(bestmove_j(current_depth-1)) <= me;		-- Odd current_depth means 'X'
                    end if;
                    state <= current_check;
                end if;
            elsif(state = current_check) then
                    if(current_depth rem 2 = 0 ) then
                        temp := current_situation(board,'0');
                    else
                        temp := current_situation(board,'1');
                    end if;
                    if (temp = 1) then
                        report "Win";		-- Win for X ( ai )
                        state <= complete;
                    elsif(temp = -1 ) then
                        report "Loss";		-- Loss for X ( ai )
                        state <= complete;
                    else
                        if(current_depth = 1) then	-- All places filled on board and tie
                            state <= complete;
                            report "Tie";
                        elsif(current_depth rem 2 = 0) then		-- If empty places are remaining, go to turn_human if present turn was turn_ai or vice versa
                            state <= turn_ai;
                            current_depth <= current_depth - 1;
                        else
                            state <= turn_human;
                            current_depth <= current_depth - 1;
                            old_board <= human_board;
                        end if;
                    end if;
            elsif(state = turn_human) then
                led_ind <= '1';			-- led_ind will be high indicating human to play its turn
                if(old_board /= human_board) then
                    for i in 0 to 2 loop	-- Look for changes in human_board and assign 'O' to the board for that particular position
                        for j in 0 to 2 loop
                            if(old_board(i)(j) /= human_board(i)(j)) then		
                                board(i)(j) <= you;
                            end if;
                        end loop;
                    end loop;
                    led_ind <= '0';
                    state <= current_check;
                else
                    state <= turn_human;
                end if;
            elsif(state = complete) then
                if(KEY = '0') then		-- Used to restart the game
                    state <= ready;
                else
                    state <= complete;
                end if;
            end if;
        end if;
    end process;
end architecture;