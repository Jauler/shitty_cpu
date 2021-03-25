library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
	port(
		-- reset
		reset : in std_logic;

		-- clock
		clk : in std_logic;

		-- Memory interface
		mem_ce : out std_logic;
		mem_oe : out std_logic;
		mem_we : out std_logic;

		-- busses
		data_bus : inout std_logic_vector(7 downto 0);
		addr_bus : inout std_logic_vector(7 downto 0)
	);
end entity;

architecture cpu_arch of cpu is
	-- internal busses multiplexers control
	signal data_mux_sel : std_logic_vector(2 downto 0);
	signal data_mux_en  : std_logic;
	signal addr_mux_sel : std_logic_vector(2 downto 0);
	signal addr_mux_en  : std_logic;

	-- register signals
	signal reg_pc_we : std_logic;
	signal reg_pc_out: std_logic_vector(7 downto 0);
	signal reg_operand_we : std_logic;
	signal reg_operand_out: std_logic_vector(7 downto 0);
	signal reg_instruction_we : std_logic;
	signal reg_instruction_out: std_logic_vector(7 downto 0);
	signal reg_a_we : std_logic;
	signal reg_a_out: std_logic_vector(7 downto 0);
	signal reg_b_we : std_logic;
	signal reg_b_out: std_logic_vector(7 downto 0);

	-- ALU outputs
	signal alu_out    : std_logic_vector(7 downto 0);
	signal alu_zero   : std_logic;
	signal alu_we     : std_logic;

	-- decoder outputs
	signal decoder_bus_out : std_logic_vector(7 downto 0);

begin
	pc_reg1 : entity work.cpu_register port map(
		reset => reset,
		clk => clk,
		we => reg_pc_we,
		data => data_bus,
		output => reg_pc_out);

	operand_reg1 : entity work.cpu_register port map(
		reset => reset,
		clk => clk,
		we => reg_operand_we,
		data => data_bus,
		output => reg_operand_out);

	instruction_reg1 : entity work.cpu_register port map(
		reset => reset,
		clk => clk,
		we => reg_instruction_we,
		data => data_bus,
		output => reg_instruction_out);

	reg1 : entity work.cpu_register port map(
		reset => reset,
		clk => clk,
		we => reg_a_we,
		data => data_bus,
		output => reg_a_out);

	reg2 : entity work.cpu_register port map(
		reset => reset,
		clk => clk,
		we => reg_b_we,
		data => data_bus,
		output => reg_b_out);

	alu1 : entity work.alu port map(
		reset => reset,
		clk => clk,
		we => alu_we,
		in1 => reg_a_out,
		in2 => reg_b_out,
		sum => alu_out,
		zero => alu_zero);

	data_mux1 : entity work.mux port map(
		in1 => reg_a_out,
		in2 => reg_b_out,
		in3 => alu_out,
		in4 => reg_operand_out,
		in5 => reg_pc_out,
		in6 => decoder_bus_out,
		in7 => x"00", -- unused
		in8 => alu_out,
		en => data_mux_en,
		sel => data_mux_sel,
		output => data_bus);

	addr_mux1 : entity work.mux port map(
		in1 => reg_a_out,
		in2 => reg_b_out,
		in3 => alu_out,
		in4 => reg_operand_out,
		in5 => reg_pc_out,
		in6 => decoder_bus_out,
		in7 => x"00", -- unused
		in8 => alu_out,
		en => addr_mux_en,
		sel => addr_mux_sel,
		output => addr_bus);

	decoder1 : entity work.decoder port map(
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
		program_counter => reg_pc_out,

		-- alu
		alu_zero => alu_zero,
		alu_we => alu_we,

		-- muxes
		data_mux_sel => data_mux_sel,
		data_mux_en => data_mux_en,
		addr_mux_sel => addr_mux_sel,
		addr_mux_en => addr_mux_en,

		-- decoder bus output
		decoder_bus_out => decoder_bus_out);
end architecture;

