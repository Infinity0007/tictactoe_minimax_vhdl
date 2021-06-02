-- Level 2 entity, called by level 3 or in case of two empty places, returns score and position 
-- score is used by level3 for its operation 
-- level 2 implies turn for 'O'

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commonpackage.all;

entity minimaxelemt_2 is
    port(
        -- inputs
        clk : in std_logic;
        current_board : in board_type;
        check_present : in std_logic;
        -- output
        score : out integer;
        done_out : out std_logic;
        bestmove_i : out integer;
        bestmove_j : out integer;
        state_out : out states
    );
end entity;
architecture rtl of minimaxelemt_2 is
    component minimaxelemt_1 is
        port(
            -- inputs
            clk : in std_logic;
            current_board : in board_type;
            check_present : in std_logic;
            -- output 
            score : out integer;
            done_out : out std_logic;
            bestmove_i : out integer;
            bestmove_j : out integer;
            state_out : out states 
        );
    end component;
signal score_current : integer;
signal best_score : integer := 1024;
signal board : board_type;
signal check_next : std_logic := '0';
signal state_next : states;
signal busy_present,done_present : std_logic;
signal state : states := ready;
type index is array (0 to 3) of integer;
signal guess_index : index;
signal done_next : std_logic; 
shared variable n : integer;
signal flag : std_logic;
begin
-- Min
    state_out <= state;
    score <= best_score;
    done_out <= done_present;
    dut : minimaxelemt_1 port map(clk,board,check_next,score_current,done_next,open,open,state_next);
    process(clk) is
    variable temp : integer;
    begin
        if(rising_edge(clk)) then
            if(state = ready) then
                if(check_present = '1' and busy_present = '0') then	--check_present( handshake signal), when set to 1; indicates start of operation and enters state = start
                    busy_present <= '1';
                    done_present <= '0';
                    best_score <= 1024;		-- Minimize function
                    state <= start;
                    flag <= '0';
                else
                    busy_present <= '0';
                    done_present <= '0';
                    state <= ready;
                end if;
            elsif(state = start) then		-- start state will be entered twice for two empty places
                board <= current_board;    
                if(flag = '0') then
                    n := 0;
                    for i in 0 to 2 loop
                        for j in 0 to 2 loop
                                if(current_board(i)(j) = none) then		-- looks for empty places on board. Their index is stored in guess_index
                                    guess_index(n) <= i;				-- There will be 2 empty places
                                    n := n+1;
                                    guess_index(n) <= j;
                                    n := n+1;
                                end if;
                        end loop;
                    end loop;
                    flag <= '1';		-- flag variable is used because this is a one time activity ( empty place searching )
                    n := n-1;			-- start state will be entered twice
                end if;		
                if(flag = '1') then
                    if(n>0) then
                        board(guess_index(n-1))(guess_index(n)) <= you;		-- There are two empty places. These places are filled with 'O' one at a time 
                        n := n-2;
                        state <= current_check;		-- Proceeds to current_check state
                    else
                        state <= complete;		-- when all empty places are checked, it will enter state = complete
                    end if;

                end if;
            elsif(state = current_check) then
                temp := current_situation(board,'0');	-- For the updated board ( one newly filled position and one empty place ), the temp (score) is calculated
                if (temp = 1 or temp = -1) then
                    if(temp < best_score) then		-- If temp is 1 or -1, we directly assign this value to the newly filled postion and go back to state = start
                        best_score <= temp;			-- At the same time, we check for minimum score and assign it to best position if found
                        bestmove_i <= guess_index(n+1);
                        bestmove_j <= guess_index(n+2);
                    end if;
                    state <= start;
                else
                    state <= fetch;			-- If temp is not 1 or -1 , it enters fetch state and calls minimaxelemt_1 with the board having one empty place
                end if;
            elsif(state = fetch) then
                check_next <= '1';		-- check_next ( check_present for minimaxelemt_1 ) is set high and tells minimaxelemt_1 to start its operation
                state <= fetch_wait;	-- enters fetch_wait state
            elsif(state = fetch_wait) then		-- In fetch_wait, it waits for minimaxelemt_1 to complete its operation
                if (state_next = complete) then		-- If completed, state_next ( state_out of minimaxelemt_1 ) = complete. 
                    check_next <= '0';
                    state <= fetch_result;
                else state <= fetch_wait;
                end if;
            elsif(state = fetch_result) then
                if(done_next = '1') then
                    --Min decision
                    if(score_current < best_score) then		-- uses the score given by minimaxelemt_1 to minimize 
                        best_score <= score_current;
                        bestmove_i <= guess_index(n+1);
                        bestmove_j <= guess_index(n+2);
                    end if;
                    state <= start;
                else
                    state <= fetch_result;
                end if;
            elsif(state = complete) then		
                busy_present <= '0';			-- In this state, minimaxelemt_2 has done its operation
                done_present <= '1';
                state <= ready;
            else
                state <= ready;
            end if;
        end if;
    end process; 
end architecture;