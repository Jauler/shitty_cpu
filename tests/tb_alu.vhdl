library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity tb_alu is
end entity;

architecture tb_alu_arch of tb_alu is
	signal reset  : std_logic := '0';
	signal clk    : std_logic := '0';
	signal we     : std_logic := '0';
	signal in1    : std_logic_vector(7 downto 0) := x"00";
	signal in2    : std_logic_vector(7 downto 0) := x"00";
	signal sum    : std_logic_vector(7 downto 0) := x"00";
	signal zero   : std_logic;
begin
	dut : entity work.alu port map(
		reset => reset,
		clk => clk,
		we => we,
		in1 => in1,
		in2 => in2,
		sum => sum,
		zero => zero
	);

	test : process
	begin
		wait for 1 ns;
		assert sum = x"00" report "Wrong sum when disabled" severity failure;
		assert zero = '0' report "Wrong zero signal when disabled";

		wait for 1 ns;
		reset <= '1';
		wait for 1 ns;
		clk <= '1';
		wait for 1 ns;
		clk <= '0';

		wait for 1 ns;
		in1 <= x"01";
		in2 <= x"02";
		wait for 1 ns;
		assert sum = x"00" report "Wrong sum when clk and we unchanged" severity failure;
		assert zero = '0' report "Wrong zero signal when clk and we unchanged";

		wait for 1 ns;
		we <= '1';
		wait for 1 ns;
		clk <= '1';
		wait for 1 ns;
		clk <= '0';

		wait for 1 ns;
		assert sum = x"03" report "Wrong sum" severity failure;
		assert zero = '0' report "Wrong zero signal";

		wait for 1 ns;
		we <= '0';
		wait for 1 ns;
		clk <= '1';
		wait for 1 ns;
		clk <= '0';

		wait for 1 ns;
		assert sum = x"03" report "Wrong sum when after we falling edge" severity failure;
		assert zero = '0' report "Wrong zero signal after we falling edge";

		wait for 1 ns;
		in1 <= x"ff";
		in2 <= x"01";
		wait for 1 ns;
		clk <= '1';
		wait for 1 ns;
		clk <= '0';

		wait for 1 ns;
		assert sum = x"03" report "Wrong sum when after input changed but no rising we" severity failure;
		assert zero = '0' report "Wrong zero signal after input changed but no rising we";

		wait for 1 ns;
		we <= '1';
		wait for 1 ns;
		clk <= '1';
		wait for 1 ns;
		clk <= '0';

		wait for 1 ns;
		assert sum = x"00" report "Wrong second sum" severity failure;
		assert zero = '1' report "Wrong second zero";

		finish;
	end process;
end architecture;


