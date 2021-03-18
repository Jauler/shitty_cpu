library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;
use work.tb_memory_type_pkg.all;

entity tb_cpu_conditional is
end entity;

architecture tb_cpu_conditional_arch of tb_cpu_conditional is
	signal reset : std_logic := '0';
	signal clk : std_logic := '0';
	signal mem_ce : std_logic := '0';
	signal mem_oe : std_logic := '0';
	signal mem_we : std_logic := '0';
	signal data_bus : std_logic_vector(7 downto 0) := x"00";
	signal addr_bus : std_logic_vector(7 downto 0) := x"00";
	signal mem_contents : mem_type;

	signal initial_memory : mem_type := (
		0 => "01000011", -- MOVE A, [0x80]
		1 => x"80",

		2 => "01001011", -- MOVE B, [0x81]
		3 => x"81",

		4 => "00010000", -- ADD
		5 => x"00",

		6 => "11000000", -- JZ 0x0A (0x0A + 0x02 == 0x0C)
		7 => x"0A",

		8 => "00000011", -- MOVE A, 0x01
		9 => x"01",

		10 => "00011011", -- J 0x0C (0x0C + 0x02 == 0x0E)
		11 => x"0E",

		12 => "00000011", -- MOVE A, 0x02
		13 => x"02",

		14 => "10011000", -- MOVE [0x90], A
		15 => x"90",



		16 => "01000011", -- MOVE A, [0x82]
		17 => x"82",

		18 => "01001011", -- MOVE B, [0x83]
		19 => x"83",

		20 => "00010000", -- ADD
		21 => x"00",

		22 => "11000000", -- JZ 0x1A (0x1A + 0x02 == 0x1C)
		23 => x"1A",

		24 => "00000011", -- MOVE A, 0x01
		25 => x"01",

		26 => "00011011", -- J 0x1C (0x1C + 0x02 == 0x1E)
		27 => x"1C",

		28 => "00000011", -- MOVE A, 0x02
		29 => x"02",

		30 => "10011000", -- MOVE [0x91], A
		31 => x"91",

		32 => "00011011", -- J 0x1E (0x1E + 0x02 == 0x20)
		33 => x"1E",




		-- data
		128 => x"FF",
		129 => x"01",

		130 => x"FF",
		131 => x"00",

		others=>"00000000");

begin
	clk1 : entity work.tb_clock port map(
		clk => clk
	);

	mem1 : entity work.tb_memory
	generic map (
		initial_contents => initial_memory
	)
	port map (
		ce => mem_ce,
		we => mem_we,
		oe => mem_oe,
		data => data_bus,
		addr => addr_bus,
		contents => mem_contents
	);

	dut : entity work.cpu port map(
		reset => reset,
		clk => clk,
		mem_ce => mem_ce,
		mem_oe => mem_oe,
		mem_we => mem_we,
		data_bus => data_bus,
		addr_bus => addr_bus
	);

	test : process
	begin
		wait for 20 ns;
		reset <= '1';

		wait for 3000 ns;
		assert mem_contents(144) = x"02" report "Wrong value in first JZ test" severity failure;
		assert mem_contents(145) = x"01" report "Wrong value in second JZ test" severity failure;

		finish;
	end process;
end architecture;


