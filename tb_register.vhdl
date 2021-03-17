library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

ENTITY tb_register IS
END ENTITY;

ARCHITECTURE tb_register_arch OF tb_register IS
	SIGNAL reset  : std_logic := '0';
	SIGNAL clk    : std_logic := '0';
	SIGNAL we     : std_logic := '0';
	SIGNAL data   : std_logic_vector(7 downto 0) := x"00";
	SIGNAL output : std_logic_vector(7 downto 0) := x"00";

BEGIN
	dut : ENTITY work.cpu_register port map(
		reset => reset,
		clk => clk,
		we => we,
		data => data,
		output => output
	);

	test : PROCESS
	BEGIN
		wait for 1 ns;
		assert output = x"00" report "Wrong output with reset" severity failure;

		wait for 1 ns;
		reset <= '1';

		wait for 1 ns;
		assert output = x"00" report "Wrong output with reset" severity failure;

		wait for 1 ns;
		data <= x"05";

		wait for 1 ns;
		assert output = x"00" report "Wrong output without we and rising clk" severity failure;

		wait for 1 ns;
		we <= '1';

		wait for 1 ns;
		assert output = x"00" report "Wrong output without rising clk" severity failure;

		wait for 1 ns;
		clk <= '1';

		wait for 1 ns;
		assert output = x"05" report "Wrong output" severity failure;

		wait for 1 ns;
		data <= x"85";

		wait for 1 ns;
		assert output = x"05" report "Wrong output after input change" severity failure;

		wait for 1 ns;
		clk <= '0';

		wait for 1 ns;
		assert output = x"05" report "Wrong output after falling clk" severity failure;

		wait for 1 ns;
		clk <= '1';

		wait for 1 ns;
		assert output = x"85" report "Wrong output after falling clk" severity failure;

		wait for 1 ns;
		clk <= '0';
		we <= '0';
		data <= x"aa";

		wait for 1 ns;
		assert output = x"85" report "Wrong output after second falling clk" severity failure;

		wait for 1 ns;
		clk <= '1';

		wait for 1 ns;
		assert output = x"85" report "Wrong output on disabled we" severity failure;

		finish;
	END PROCESS;
END ARCHITECTURE;


