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
		mem_we : out std_logic;
		mem_data_in : in std_logic_vector(7 downto 0);
		mem_data_out : out std_logic_vector(7 downto 0);
		mem_addr : out std_logic_vector(7 downto 0)
	);
end entity;

architecture cpu_arch of cpu is
	-- internal busses multiplexers control
	signal data_mux_sel : std_logic_vector(2 downto 0);
	signal addr_mux_sel : std_logic_vector(2 downto 0);

	-- register signals
	signal reg_pc_inc : std_logic;
	signal reg_pc_we  : std_logic;
	signal reg_pc_out : std_logic_vector(7 downto 0);
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

	-- busses
	signal data_bus : std_logic_vector(7 downto 0);
	signal addr_bus : std_logic_vector(7 downto 0);

begin
	pc_reg1 : entity work.counter port map(
		reset => reset,
		we => reg_pc_we,
		inc => reg_pc_inc,
		data => data_bus,
		output => reg_pc_out);

	operand_reg1 : entity work.cpu_register port map(
		reset => reset,
		we => reg_operand_we,
		data => data_bus,
		output => reg_operand_out);

	instruction_reg1 : entity work.cpu_register port map(
		reset => reset,
		we => reg_instruction_we,
		data => data_bus,
		output => reg_instruction_out);

	reg1 : entity work.cpu_register port map(
		reset => reset,
		we => reg_a_we,
		data => data_bus,
		output => reg_a_out);

	reg2 : entity work.cpu_register port map(
		reset => reset,
		we => reg_b_we,
		data => data_bus,
		output => reg_b_out);

	alu1 : entity work.alu port map(
		reset => reset,
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
		in6 => mem_data_in,
		in7 => (others => '0'),
		in8 => (others => '0'),
		sel => data_mux_sel,
		output => data_bus);

	addr_mux1 : entity work.mux port map(
		in1 => reg_a_out,
		in2 => reg_b_out,
		in3 => alu_out,
		in4 => reg_operand_out,
		in5 => reg_pc_out,
		in6 => mem_data_in,
		in7 => (others => '0'),
		in8 => (others => '0'),
		sel => addr_mux_sel,
		output => addr_bus);

	controller1 : entity work.controller port map(
		reset => reset,
		clk => clk,

		-- memory and busses
		mem_we => mem_we,

		-- register control
		reg_pc_we => reg_pc_we,
		reg_pc_inc => reg_pc_inc,
		reg_instruction_we => reg_instruction_we,
		reg_operand_we => reg_operand_we,
		reg_a_we => reg_a_we,
		reg_b_we => reg_b_we,

		-- instruction register
		instruction => reg_instruction_out,

		-- alu
		alu_zero => alu_zero,
		alu_we => alu_we,

		-- muxes
		data_mux_sel => data_mux_sel,
		addr_mux_sel => addr_mux_sel
	);

	mem_addr <= addr_bus;
	mem_data_out <= data_bus;
end architecture;

