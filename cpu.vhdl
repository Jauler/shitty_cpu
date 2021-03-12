library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY cpu IS
	port(
		-- reset
		reset : IN std_logic;

		-- clock
		clk : IN std_logic;

		-- Memory interface
		mem_ce : OUT std_logic;
		mem_oe : OUT std_logic;
		mem_we : OUT std_logic;

		-- busses
		data_bus : INOUT std_logic_vector(7 downto 0);
		addr_bus : INOUT std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE cpu_arch OF cpu IS
	-- internal busses multiplexers control
	SIGNAL data_mux_sel : std_logic_vector(2 downto 0);
	SIGNAL data_mux_en  : std_logic;
	SIGNAL addr_mux_sel : std_logic_vector(2 downto 0);
	SIGNAL addr_mux_en  : std_logic;

	-- register signals
	SIGNAL reg_pc_we : std_logic;
	SIGNAL reg_pc_out: std_logic_vector(7 downto 0);
	SIGNAL reg_pcinc1_out : std_logic_vector(7 downto 0); -- PC value incremented by 1
	SIGNAL reg_pcinc2_out : std_logic_vector(7 downto 0); -- PC value incremented by 2
	SIGNAL reg_operand_we : std_logic;
	SIGNAL reg_operand_out: std_logic_vector(7 downto 0);
	SIGNAL reg_instruction_we : std_logic;
	SIGNAL reg_instruction_out: std_logic_vector(7 downto 0);
	SIGNAL reg_a_we : std_logic;
	SIGNAL reg_a_out: std_logic_vector(7 downto 0);
	SIGNAL reg_b_we : std_logic;
	SIGNAL reg_b_out: std_logic_vector(7 downto 0);

	-- ALU outputs
	SIGNAL alu_out    : std_logic_vector(7 downto 0);
	SIGNAL alu_zero   : std_logic;

BEGIN
	pc_reg1 : ENTITY work.cpu_register port map(
		reset => reset,
		clk => clk,
		we => reg_pc_we,
		data => data_bus,
		output => reg_pc_out);

	operand_reg1 : ENTITY work.cpu_register port map(
		reset => reset,
		clk => clk,
		we => reg_operand_we,
		data => data_bus,
		output => reg_operand_out);

	instruction_reg1 : ENTITY work.cpu_register port map(
		reset => reset,
		clk => clk,
		we => reg_instruction_we,
		data => data_bus,
		output => reg_instruction_out);

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
		in4 => reg_operand_out,
		in5 => reg_pc_out,
		in6 => reg_pcinc1_out,
		in7 => reg_pcinc2_out,
		in8 => (others => '0'), -- unused
		en => data_mux_en,
		sel => data_mux_sel,
		output => data_bus);

	addr_mux1 : ENTITY work.mux port map(
		in1 => reg_a_out,
		in2 => reg_b_out,
		in3 => alu_out,
		in4 => reg_operand_out,
		in5 => reg_pc_out,
		in6 => reg_pcinc1_out,
		in7 => reg_pcinc2_out,
		in8 => (others => '0'), -- unused
		en => addr_mux_en,
		sel => addr_mux_sel,
		output => addr_bus);

	decoder1 : ENTITY work.decoder port map(
		reset => reset,
		clk => clk,

		-- memory and busses
		mem_ce => mem_ce,
		mem_oe => mem_oe,
		mem_we => mem_we,

		-- register control
		reg_pc_we => reg_pc_we,
		reg_instruction_we => reg_instruction_we,
		reg_operand_we => reg_operand_we,
		reg_a_we => reg_a_we,
		reg_b_we => reg_b_we,

		-- instruction register
		instruction => reg_instruction_out,

		-- alu
		alu_zero => alu_zero,

		-- muxes
		data_mux_sel => data_mux_sel,
		data_mux_en => data_mux_en,
		addr_mux_sel => addr_mux_sel,
		addr_mux_en => addr_mux_en);

	reg_pcinc1_out <= reg_pc_out + 1;
	reg_pcinc2_out <= reg_pc_out + 2;
END ARCHITECTURE;

