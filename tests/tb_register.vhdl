library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity tb_register is
end entity;

architecture tb_register_arch of tb_register is
	signal reset  : std_logic := '0';
	signal we     : std_logic := '0';
	signal data   : std_logic_vector(7 downto 0) := x"00";
	signal output : std_logic_vector(7 downto 0) := x"00";

begin
	dut : entity work.cpu_register port map(
		reset => reset,
		we => we,
		data => data,
		output => output
	);

	test : process
	begin
		wait for 1 ns;
		assert output = x"00" report "Wrong output with reset" severity failure;

		wait for 1 ns;
		reset <= '1';

		wait for 1 ns;
		assert output = x"00" report "Wrong output with reset" severity failure;

		wait for 1 ns;
		data <= x"05";

		wait for 1 ns;
		assert output = x"00" report "Wrong output without we" severity failure;

		wait for 1 ns;
		we <= '1';

		wait for 1 ns;
		assert output = x"05" report "Wrong output" severity failure;

		wait for 1 ns;
		data <= x"85";

		wait for 1 ns;
		assert output = x"05" report "Wrong output after input change" severity failure;

		wait for 1 ns;
		we <= '0';

		wait for 1 ns;
		assert output = x"05" report "Wrong output after falling we" severity failure;

		wait for 1 ns;
		we <= '1';

		wait for 1 ns;
		assert output = x"85" report "Wrong output after rising we" severity failure;

		finish;
	end process;
end architecture;


