library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY tb_loopTest IS
END ENTITY;

ARCHITECTURE tb_loopTest_arch OF tb_loopTest IS
	SIGNAL reset : std_logic := '1';

	SIGNAL clk : std_logic := '0';

	SIGNAL mem_ce : std_logic;
	SIGNAL mem_oe : std_logic;
	SIGNAL mem_we : std_logic;
	SIGNAL mem_data : std_logic_vector(7 downto 0);
	SIGNAL mem_addr : std_logic_vector(7 downto 0);

	SIGNAL cycle_count : std_logic_vector(7 downto 0) := (others => '0');
BEGIN
	clk1 : ENTITY work.tb_clock port map(
		clk => clk
	);

	cpu1 : ENTITY work.cpu port map(
		reset => reset,
		clk => clk,
		data_bus => mem_data,
		addr_bus => mem_addr,
		mem_ce => mem_ce,
		mem_oe => mem_oe,
		mem_we => mem_we
	);

	mem1 : ENTITY work.tb_memory port map(
		ce => mem_ce,
		we => mem_we,
		oe => mem_oe,
		data => mem_data,
		addr => mem_addr
		);

	test : PROCESS(clk)
	BEGIN
		reset <= '0' after 20 ns;
	END PROCESS;
END ARCHITECTURE;




