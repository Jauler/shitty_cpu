library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

ENTITY tb_alu IS
END ENTITY;

ARCHITECTURE tb_alu_arch OF tb_alu IS
	SIGNAL reset  : std_logic := '0';
	SIGNAL clk    : std_logic := '0';
	SIGNAL we     : std_logic := '0';
	SIGNAL in1    : std_logic_vector(7 downto 0) := x"00";
	SIGNAL in2    : std_logic_vector(7 downto 0) := x"00";
	SIGNAL sum    : std_logic_vector(7 downto 0) := x"00";
	SIGNAL zero   : std_logic;
BEGIN
	dut : ENTITY work.alu port map(
		reset => reset,
		clk => clk,
		we => we,
		in1 => in1,
		in2 => in2,
		sum => sum,
		zero => zero
	);

	test : PROCESS
	BEGIN
		wait for 1 ns;
		assert sum = x"00" report "Wrong sum when disabled" severity failure;
		assert zero = '0' report "Wrong zero signal when disabled";

		wait for 1 ns;
		reset <= '1';

		wait for 1 ns;
		in1 <= x"01";
		in2 <= x"02";
		wait for 1 ns;
		assert sum = x"00" report "Wrong sum when clk and we unchanged" severity failure;
		assert zero = '0' report "Wrong zero signal when clk and we unchanged";

		wait for 1 ns;
		we <= '1';

		wait for 1 ns;
		assert sum = x"00" report "Wrong sum when clk unchanged" severity failure;
		assert zero = '0' report "Wrong zero signal when clk unchanged";

		wait for 1 ns;
		clk <= '1';

		wait for 1 ns;
		assert sum = x"03" report "Wrong sum" severity failure;
		assert zero = '0' report "Wrong zero signal";

		wait for 1 ns;
		clk <= '0';

		wait for 1 ns;
		assert sum = x"03" report "Wrong sum when after clk falling edge" severity failure;
		assert zero = '0' report "Wrong zero signal after clk falling edge";

		wait for 1 ns;
		in1 <= x"ff";
		in2 <= x"01";

		wait for 1 ns;
		assert sum = x"03" report "Wrong sum when after input changed but no rising clk" severity failure;
		assert zero = '0' report "Wrong zero signal after input changed but no rising clk";

		wait for 1 ns;
		clk <= '1';

		wait for 1 ns;
		assert sum = x"00" report "Wrong second sum" severity failure;
		assert zero = '1' report "Wrong second zero";

		finish;
	END PROCESS;
END ARCHITECTURE;


