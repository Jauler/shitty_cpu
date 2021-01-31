library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY movInstructionTest IS
END ENTITY;

ARCHITECTURE movInstructionTest OF movInstructionTest IS
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

	mem1 : ENTITY work.tb_memory port map(
		ce => mem_ce,
		we => mem_we,
		oe => mem_oe,
		data => mem_data,
		addr => mem_addr
		);

	cpu1 : ENTITY work.cpu port map(
		reset => reset,
		clk => clk,
		mem_data => mem_data,
		mem_addr => mem_addr,
		mem_ce => mem_ce,
		mem_oe => mem_oe,
		mem_we => mem_we
	);

	test : PROCESS(clk)
	BEGIN
		reset <= '1' after 20 ns;
	END PROCESS;
END ARCHITECTURE;




