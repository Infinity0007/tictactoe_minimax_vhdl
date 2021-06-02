-- contains definition of symbols;	"me" implies 'X',	"you" implies 'O',	"none" implies '_'
-- function "current situation"; takes board and player_typ as input;  returns score 
-- "player_typ = 1" corresponds to 'X',	"player_typ = 0" corresponds to 'O',     
--  Score, 1 implies win, -1 implies lose,  (-1024) or 0 implies tie  for 'X'


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package commonpackage is
type  boardvar is (me,you,none);
type boardvararr is array (0 to 2) of boardvar;
    type board_type is array(0 to 2) of boardvararr;
    
    type states is (ready,start,complete,fetch,fetch_wait,fetch_result,current_check,turn_ai,turn_human);
    function current_situation (board : board_type; player_typ : std_logic) return integer;
end package commonpackage;

package body commonpackage is
    function current_situation (board : board_type; player_typ : std_logic) return integer is
        variable score_current,best_score : integer;
    begin
        if(player_typ = '1') then -- Max = 1
            best_score := -1024;
            score_current := -1024;
        else  -- Min = 0
            best_score := 1024;
            score_current := 1024; 
        end if;
        for i in 0 to 7 loop
            case i is
                when 0 =>		-- Checking row(0)
                    if (board(0)(0)=me and  board(0)(1)=me and board(0)(2)=me) then
                        score_current := 1;
                    elsif(board(0)(0) = you and board(0)(1)=you and board(0)(2)=you) then
                        score_current := -1;
                    end if;
                when 1 => 		-- Checking row(1)
                    if (board(1)(0)=me and  board(1)(1)=me and board(1)(2)=me) then
                        score_current := 1;
                    elsif(board(1)(0) = you and board(1)(1)=you and board(1)(2)=you) then
                        score_current := -1;
                    end if;
                when 2 =>		-- Checking row(2)
                    if (board(2)(0)=me and  board(2)(1)=me and board(2)(2)=me) then   --1=me
                        score_current := 1;
                    elsif(board(2)(0) = you and board(2)(1)=you and board(2)(2)=you) then
                        score_current := -1;
                    end if;
                when 3 =>		-- Checking column(0)
                    if (board(0)(0)=me and board(1)(0)=me and board(2)(0)=me) then
                        score_current := 1;
                    elsif (board(0)(0)=you and board(1)(0)=you and board(2)(0)=you) then
                        score_current := -1;
                    end if;
                when 4 =>			-- Checking column(1)
                    if (board(0)(1)=me and board(1)(1)=me and board(2)(1)=me) then
                        score_current := 1;
                    elsif (board(0)(1)=you and board(1)(1)=you and board(2)(1)=you) then
                        score_current := -1;
                    end if;
                when 5 =>			-- Checking column(1)
                    if (board(0)(2)=me and board(1)(2)=me and board(2)(2)=me) then
                        score_current := 1;
                    elsif (board(0)(2)=you and board(1)(2)=you and board(2)(2)=you) then
                        score_current := -1;
                    end if;
                when 6 =>			-- Checking diagonal 
                    if (board(0)(0)=me and board(1)(1)=me and board(2)(2)=me) then
                        score_current := 1;
                    elsif (board(0)(0)=you and board(1)(1)=you and board(2)(2)=you) then
                        score_current := -1;
                    end if;
                when 7 =>			-- Checking diagonal 
                    if (board(0)(2)=me and board(1)(1)=me and board(2)(0)=me) then
                        score_current := 1;
                    elsif (board(0)(2)=you and board(1)(1)=you and board(2)(0)=you) then
                        score_current := -1;
                    end if;
                when others =>
                    report "ERROR Get Result";
            end case;
            if(player_typ = '1') then --Max
                if(score_current > best_score) then
                    best_score := score_current;
                end if;
            else
                if(score_current < best_score) then
                    best_score := score_current;
                end if;
            end if;
        end loop;
        return best_score;
    end function;
end commonpackage;