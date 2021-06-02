-- All minimaxelemt Components 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commonpackage.all;

package minimaxelemtpkg is
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

    component minimaxelemt_2 is
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

    component minimaxelemt_3 is
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

    component minimaxelemt_4 is
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

    component minimaxelemt_5 is
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

    component minimaxelemt_6 is
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

    component minimaxelemt_7 is
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

    component minimaxelemt_8 is
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

    component minimaxelemt_9 is
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
end minimaxelemtpkg;