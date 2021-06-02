library ieee;
use ieee.std_logic_1164.all;

entity tictactoe_tb is
end entity;

architecture sim of tictactoe_tb is
component tictactoe_game is
	port(
		clk : in std_logic;
		LEDR : out std_logic_vector(17 downto 0)
	);
end component;
signal clk : std_logic := '0';
signal LEDR : std_logic_vector(17 downto 0);
begin
	dut : tictactoe_game port map(clk,LEDR);
	clk <= not clk after 10 ns;
end architecture;