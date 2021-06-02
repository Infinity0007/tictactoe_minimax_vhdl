-- Level 1 entity, called by level 2 or in case of one empty place, returns score and position 
-- score is used by level2 for its operation 
-- level 1 implies turn for 'X'

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commonpackage.all;

entity minimaxelemt_1 is
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

architecture rtl of minimaxelemt_1 is
     
	signal score_buffer : integer;
    signal state : states := ready;
    signal busy,done : std_logic := '0';
begin
    state_out <= state;
    score <= score_buffer;
    done_out <= done;
    process(clk) is
        variable board : board_type;
        variable bestscore : integer;
    begin
        if(rising_edge(clk)) then
            if(state = ready) then
                if(check_present = '1' and busy = '0') then		--check_present( handshake signal), when set to 1; indicates start of operation and enters state = start
                    busy <= '1';
                    done <= '0';		-- done = 1 and state = complete implies end of opertaion
                    state <= start;
                else 
                    busy <= '0';
                    done <= '0';
                    state <= ready;
                end if;
            elsif(state = start) then
                board(0) := current_board(0);
                board(1) := current_board(1);
                board(2) := current_board(2);
                for i in 0 to 2 loop
                    for j in 0 to 2 loop
                        if(current_board(i)(j) = none ) then 		-- looks for empty place on board
                            board(i)(j) := me;
                            bestmove_i <= i;		-- The corresponding empty place is filled with 'X' and its index is stored in bestmove_i, bestmove_j
                            bestmove_j <= j;
                        end if; 
                    end loop; 
                end loop;
                bestscore := current_situation(board,'1');		--For the updated position, new score is calculated and proceeds to state = complete
                if (bestscore=-1024) then
                    bestscore := 0;		-- score = 0 for tie
                end if;
                score_buffer <= bestscore;
                state <= complete;
            elsif(state = complete) then		-- In this state, done ( handshake signal ) is set to 1; indicating end of operation 
                done <= '1';
                busy <= '0';
                state <= ready;		-- enters the ready state again
            else state <= ready;
            end if;
            
        end if;
    end process;
end architecture;