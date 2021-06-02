-- Level 8 entity, called by level 9 or in case of eight empty places, returns score and position 
-- score is used by level9 for its operation 
-- level 8 implies turn for 'O'


-- Min
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commonpackage.all;

entity minimaxelemt_8 is
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
architecture rtl of minimaxelemt_8 is
    component minimaxelemt_7 is -- blockdependent
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
signal best_score : integer := 1024; -- Min
signal board : board_type;
signal check_next : std_logic := '0';
signal state_next : states;
signal busy_present,done_present : std_logic;
signal state : states := ready;
type index is array (0 to 15) of integer; --blockdependent
signal guess_index : index;
signal done_next : std_logic; 
shared variable n : integer;
signal flag : std_logic;
begin
-- Max
    state_out <= state;
    score <= best_score;
    done_out <= done_present;
    dut : minimaxelemt_7 port map(clk,board,check_next,score_current,done_next,open,open,state_next); --blockdependent
    process(clk) is
    variable temp : integer;
    begin
        if(rising_edge(clk)) then
            if(state = ready) then
                if(check_present = '1' and busy_present = '0') then
                    busy_present <= '1';
                    done_present <= '0';
                    best_score <= 1024;--Min
                    state <= start;
                    flag <= '0';
                else
                    busy_present <= '0';
                    done_present <= '0';
                    state <= ready;
                end if;
            elsif(state = start) then
                board <= current_board;    
                if(flag = '0') then
                    n := 0;
                    for i in 0 to 2 loop
                        for j in 0 to 2 loop
                                if(current_board(i)(j) =none) then -- or current_board(i)(j) = 'U'
                                    guess_index(n) <= i;
                                    n := n+1;
                                    guess_index(n) <= j;
                                    n := n+1;
                                end if;
                        end loop;
                    end loop;
                    flag <= '1';
                    n := n-1;
                end if;
                if(flag = '1') then
                    if(n>0) then
                        board(guess_index(n-1))(guess_index(n)) <= you; -- Min
                        n := n-2;
                        state <= current_check;
                    else
                        state <= complete;
                    end if;

                end if;
            elsif(state = current_check) then
                temp := current_situation(board,'0'); -- Min
                if (temp = 1 or temp = -1) then
                -- Min
                    if(temp < best_score) then -- Min
                        best_score <= temp;
                        bestmove_i <= guess_index(n+1);
                        bestmove_j <= guess_index(n+2);
                    end if;
                    state <= start;
                else
                    state <= fetch;
                end if;
            elsif(state = fetch) then
                check_next <= '1';
                state <= fetch_wait;
            elsif(state = fetch_wait) then
                if (state_next = complete) then
                    check_next <= '0';
                    state <= fetch_result;
                else state <= fetch_wait;
                end if;
            elsif(state = fetch_result) then
                if(done_next = '1') then
                    --Min decision
                    if(score_current < best_score) then -- Min
                        best_score <= score_current;
                        bestmove_i <= guess_index(n+1);
                        bestmove_j <= guess_index(n+2);
                    end if;
                    state <= start;
                else
                    state <= fetch_result;
                end if;
            elsif(state = complete) then
                busy_present <= '0';
                done_present <= '1';
                state <= ready;
            else
                state <= ready;
            end if;
        end if;
    end process; 
end architecture;