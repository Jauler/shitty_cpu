library ieee;
use ieee.std_logic_1164.all;

entity tb_clock is
	port(
		clk : out std_logic := '0'
	);
end entity;

architecture tb_clock_arch of tb_clock is
begin
	clk_generator : process
	begin
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process;
end architecture;
