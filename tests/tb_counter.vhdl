library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity tb_counter is
end entity;

architecture tb_counter_arch of tb_counter is
	signal reset  : std_logic := '0';
	signal we     : std_logic := '0';
	signal inc    : std_logic := '0';
	signal data   : std_logic_vector(7 downto 0) := x"00";
	signal output : std_logic_vector(7 downto 0) := x"00";

begin
	dut : entity work.counter port map(
		reset => reset,
		we => we,
		inc => inc,
		data => data,
		output => output
	);

	test : process
	begin
		wait for 1 ns;
		assert output = x"00" report "wrong output with reset" severity failure;

		wait for 1 ns;
		reset <= '1';

		wait for 1 ns;
		assert output = x"00" report "wrong output with reset" severity failure;

		wait for 1 ns;
		data <= x"05";

		wait for 1 ns;
		assert output = x"00" report "wrong output without we" severity failure;

		wait for 1 ns;
		we <= '1';

		wait for 1 ns;
		assert output = x"05" report "wrong output" severity failure;

		wait for 1 ns;
		data <= x"85";

		wait for 1 ns;
		assert output = x"05" report "wrong output after input change" severity failure;

		wait for 1 ns;
		we <= '0';

		wait for 1 ns;
		assert output = x"05" report "wrong output after falling we" severity failure;

		wait for 1 ns;
		inc <= '1';

		wait for 1 ns;
		assert output = x"06" report "wrong output after increment" severity failure;

		wait for 1 ns;
		inc <= '0';

		wait for 1 ns;
		assert output = x"06" report "wrong output after inc falling" severity failure;

		finish;
	end process;
end architecture;


