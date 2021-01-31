library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY cpu IS
	port(
		-- reset
		reset : IN std_logic;

		-- clock
		clk: IN std_logic;

		-- Memory interface
		mem_data : INOUT std_logic_vector(7 downto 0);
		mem_addr : OUT std_logic_vector(7 downto 0);
		mem_ce : OUT std_logic;
		mem_oe : OUT std_logic;
		mem_we : OUT std_logic
	);
END ENTITY;

ARCHITECTURE cpu OF cpu IS
	-- internal busses
	SIGNAL addr_bus : std_logic_vector(7 downto 0);
	SIGNAL data_bus : std_logic_vector(7 downto 0);

	-- internal busses multiplexers control
	SIGNAL data_mux_sel : std_logic_vector(1 downto 0);
	SIGNAL data_mux_en  : std_logic;
	SIGNAL addr_mux_sel : std_logic_vector(1 downto 0);
	SIGNAL addr_mux_en  : std_logic;

	-- register signals
	SIGNAL reg_a_we : std_logic;
	SIGNAL reg_a_out: std_logic_vector(7 downto 0);
	SIGNAL reg_b_we : std_logic;
	SIGNAL reg_b_out: std_logic_vector(7 downto 0);

	-- ALU outputs
	SIGNAL alu_out    : std_logic_vector(7 downto 0);
	SIGNAL alu_zero   : std_logic;

BEGIN
	reg1 : ENTITY work.cpu_register port map(
		reset => reset,
		clk => clk,
		we => reg_a_we,
		data => data_bus,
		output => reg_a_out);

	reg2 : ENTITY work.cpu_register port map(
		reset => reset,
		clk => clk,
		we => reg_b_we,
		data => data_bus,
		output => reg_b_out);

	alu1 : ENTITY work.alu port map(
		clk => clk,
		in1 => reg_a_out,
		in2 => reg_b_out,
		sum => alu_out,
		zero => alu_zero);

	data_mux1 : ENTITY work.mux port map(
		in1 => reg_a_out,
		in2 => reg_b_out,
		in3 => alu_out,
		in4 => mem_data,
		en => data_mux_en,
		sel => data_mux_sel,
		output => data_bus);

	addr_mux1 : ENTITY work.mux port map(
		in1 => reg_a_out,
		in2 => reg_b_out,
		in3 => alu_out,
		in4 => (others => 'Z'), -- unused
		en => addr_mux_en,
		sel => addr_mux_sel,
		output => addr_bus);

	decoder1 : ENTITY work.decoder port map(
		reset => reset,
		clk => clk,
		data_bus => data_bus,
		addr_bus => addr_bus,
		mem_ce => mem_ce,
		mem_oe => mem_oe,
		mem_we => mem_we,
		reg_a_we => reg_a_we,
		reg_b_we => reg_b_we,
		alu_zero => alu_zero,
		data_mux_sel => data_mux_sel,
		data_mux_en => data_mux_en,
		addr_mux_sel => addr_mux_sel,
		addr_mux_en => addr_mux_en);
END ARCHITECTURE;

