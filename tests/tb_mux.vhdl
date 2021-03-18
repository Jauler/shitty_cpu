library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity tb_mux is
end entity;

architecture tb_mux_arch of tb_mux is
	signal in1 : std_logic_vector(7 downto 0) := x"01";
	signal in2 : std_logic_vector(7 downto 0) := x"02";
	signal in3 : std_logic_vector(7 downto 0) := x"03";
	signal in4 : std_logic_vector(7 downto 0) := x"04";
	signal in5 : std_logic_vector(7 downto 0) := x"05";
	signal in6 : std_logic_vector(7 downto 0) := x"06";
	signal in7 : std_logic_vector(7 downto 0) := x"07";
	signal in8 : std_logic_vector(7 downto 0) := x"08";

	signal en : std_logic := '0';
	signal sel : std_logic_vector(2 downto 0) := "000";

	signal output : std_logic_vector(7 downto 0);
begin
	dut : entity work.mux port map(
		in1 => in1,
		in2 => in2,
		in3 => in3,
		in4 => in4,
		in5 => in5,
		in6 => in6,
		in7 => in7,
		in8 => in8,
		en => en,
		sel => sel,
		output => output);

	test : process
	begin
		en <= '0';
		wait for 1 ns;
		assert output = "LLLLLLLL" report "Wrong output with disabled en" severity failure;

		for i in 0 to 7 loop
			wait for 1 ns;
			en <= '1';
			sel <= std_logic_vector(to_unsigned(i, 3));
			wait for 1 ns;
			assert output = std_logic_vector(to_unsigned(i + 1, 8)) report "Wrong output" severity failure;
		end loop;

		finish;
	end process;
end architecture;


