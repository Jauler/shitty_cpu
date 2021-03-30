library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;
use work.tb_memory_type_pkg.all;

entity tb_cpu_increment is
end entity;

architecture tb_cpu_increment_arch of tb_cpu_increment is
	signal reset : std_logic := '0';
	signal clk : std_logic := '0';
	signal mem_we : std_logic := '0';
	signal mem_data : std_logic_vector(7 downto 0) := x"00";
	signal data_bus : std_logic_vector(7 downto 0) := x"00";
	signal addr_bus : std_logic_vector(7 downto 0) := x"00";
	signal mem_contents : mem_type;

	signal initial_memory : mem_type := (
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
		data_out => mem_data,
		data_in => data_bus,
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

		wait for 2000 ns;
		assert mem_contents(129) = x"03" report "Memory contents was not incremented" severity failure;

		finish;
	end process;
end architecture;


