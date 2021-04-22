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
	signal mem_we : std_logic := '0';
	signal mem_data : std_logic_vector(7 downto 0) := x"00";
	signal data_bus : std_logic_vector(7 downto 0) := x"00";
	signal addr_bus : std_logic_vector(7 downto 0) := x"00";
	signal mem_contents : mem_type;

	signal initial_memory : mem_type := (
		0 => "01011000", -- MOVE A, [0x80]
		1 => x"80",

		2 => "01011001", -- MOVE B, [0x81]
		3 => x"81",

		4 => "00000010", -- ADD
		5 => x"00",

		6 => "11000000", -- JZ 0x0C
		7 => x"0C",

		8 => "00011000", -- MOVE A, 0x01
		9 => x"01",

		10 => "00011100", -- J 0x0C
		11 => x"0C",

		12 => "00011000", -- MOVE A, 0x02
		13 => x"02",

		14 => "10011000", -- MOVE [0x90], A
		15 => x"90",



		16 => "01011000", -- MOVE A, [0x82]
		17 => x"82",

		18 => "01011001", -- MOVE B, [0x83]
		19 => x"83",

		20 => "00000010", -- ADD
		21 => x"00",

		22 => "11000000", -- JZ 0x1C
		23 => x"1C",

		24 => "00011000", -- MOVE A, 0x01
		25 => x"01",

		26 => "00011100", -- J 0x1E
		27 => x"1E",

		28 => "00011000", -- MOVE A, 0x02
		29 => x"02",

		30 => "10011000", -- MOVE [0x91], A
		31 => x"91",

		32 => "00011100", -- J 0x20
		33 => x"20",




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
		clk => clk,
		we => mem_we,
		data_in => data_bus,
		data_out => mem_data,
		addr => addr_bus,
		contents => mem_contents
	);

	dut : entity work.cpu port map(
		reset => reset,
		clk => clk,
		mem_we => mem_we,
		mem_data_in => mem_data,
		mem_data_out => data_bus,
		mem_addr => addr_bus
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


