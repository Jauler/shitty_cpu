library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;
use work.tb_memory_type_pkg.all;

entity tb_cpu_mmgpio is
end entity;

architecture tb_cpu_mmgpio_arch of tb_cpu_mmgpio is
	signal reset : std_logic := '0';
	signal clk : std_logic := '0';
	signal mem_we : std_logic := '0';
	signal mem_data : std_logic_vector(7 downto 0) := x"00";
	signal data_bus : std_logic_vector(7 downto 0) := x"00";
	signal addr_bus : std_logic_vector(7 downto 0) := x"00";
	signal mem_contents : mem_type;

	signal initial_memory : mem_type := (

0 => x"03",
1 => x"ff",
2 => x"98",
3 => x"fc",
4 => x"03",
5 => x"08",
6 => x"0b",
7 => x"27",
8 => x"10",
9 => x"00",
10 => x"4a",
11 => x"00",
12 => x"99",
13 => x"fd",
14 => x"0b",
15 => x"ff",
16 => x"10",
17 => x"00",
18 => x"02",
19 => x"00",
20 => x"c0",
21 => x"fe",
22 => x"98",
23 => x"80",
24 => x"03",
25 => x"0a",
26 => x"0b",
27 => x"ff",
28 => x"10",
29 => x"00",
30 => x"02",
31 => x"00",
32 => x"c0",
33 => x"22",
34 => x"1b",
35 => x"1a",
36 => x"43",
37 => x"80",
38 => x"1b",
39 => x"04",
40 => x"80",
41 => x"40",
42 => x"20",
43 => x"10",
44 => x"08",
45 => x"04",
46 => x"02",
47 => x"01",

		others=>"00000000"
	);

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

		wait for 80000 ns;
		finish;
	end process;
end architecture;
