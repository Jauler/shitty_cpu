library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;
use work.tb_memory_type_pkg.all;

ENTITY tb_cpu_increment IS
END ENTITY;

ARCHITECTURE tb_cpu_increment_arch OF tb_cpu_increment IS
	SIGNAL reset : std_logic := '0';
	SIGNAL clk : std_logic := '0';
	SIGNAL mem_ce : std_logic := '0';
	SIGNAL mem_oe : std_logic := '0';
	SIGNAL mem_we : std_logic := '0';
	SIGNAL data_bus : std_logic_vector(7 downto 0) := x"00";
	SIGNAL addr_bus : std_logic_vector(7 downto 0) := x"00";
	SIGNAL mem_contents : mem_type;

	SIGNAL initial_memory : mem_type := (
		0 => "01000011", -- MOVE A, [0x81]
		1 => x"81",

		2 => "00001011", -- MOVE B, 0x01
		3 => x"01",

		4 => "00010000", -- ADD
		5 => x"00",

		6 => "00001111", -- MOV B, ACC
		7 => x"00",

		8 => "10011001", -- MOVE [0x81], B
		9 => x"81",

		10 => "00011011", -- J 0x0E (0x08 + 0x02 == 0x0A)
		11 => x"08",

		-- data
		128 => x"0B",
		129 => x"02",

		others=>"00000000");

BEGIN
	clk1 : ENTITY work.tb_clock port map(
		clk => clk
	);

	mem1 : ENTITY work.tb_memory
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

	dut : ENTITY work.cpu port map(
		reset => reset,
		clk => clk,
		mem_ce => mem_ce,
		mem_oe => mem_oe,
		mem_we => mem_we,
		data_bus => data_bus,
		addr_bus => addr_bus
	);

	test : PROCESS
	BEGIN
		wait for 20 ns;
		reset <= '1';

		wait for 2000 ns;
		assert mem_contents(129) = x"03" report "Memory contents was not incremented" severity failure;

		finish;
	END PROCESS;
END ARCHITECTURE;


