library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY cpu IS
	port(
		input : IN std_logic_vector(7 downto 0);
		output : OUT std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE cpu OF cpu IS
	SIGNAL addr_bus : std_logic_vector(7 downto 0) := "ZZZZZZZZ";
	SIGNAL data_bus : std_logic_vector(7 downto 0) := "ZZZZZZZZ";

	SIGNAL clk: std_logic;
	COMPONENT clock IS
		port(
			clk : OUT std_logic
		);
	END COMPONENT;

	SIGNAL mem_ce : std_logic := '0';
	SIGNAL mem_oe : std_logic := '0';
	SIGNAL mem_we : std_logic := '0';
	COMPONENT memory IS
		port(
			data : INOUT std_logic_vector(7 downto 0);
			addr : IN std_logic_vector(7 downto 0);
			ce   : IN std_logic;
			we   : IN std_logic;
			oe   : IN std_logic);
	END COMPONENT;

	SIGNAL reg_a_we : std_logic := '0';
	SIGNAL reg_a_out: std_logic_vector(7 downto 0) := "00000000";
	SIGNAL reg_b_we : std_logic := '0';
	SIGNAL reg_b_out: std_logic_vector(7 downto 0) := "00000000";
	COMPONENT reg IS
		port(
			clk    : IN std_logic;
			we     : IN std_logic;
			data   : IN std_logic_vector(7 downto 0);
			output : OUT std_logic_vector(7 downto 0) := "00000000"
		);
	END COMPONENT;

	SIGNAL alu_out    : std_logic_vector(7 downto 0);
	SIGNAL alu_zero   : std_logic;
	COMPONENT alu IS
		port(
			clk    : IN std_logic;
			in1    : IN std_logic_vector(7 downto 0);
			in2    : IN std_logic_vector(7 downto 0);
			sum    : OUT std_logic_vector(7 downto 0);
			zero   : OUT std_logic
		);
	END COMPONENT;

	SIGNAL data_mux_sel : std_logic_vector(1 downto 0) := "00";
	SIGNAL data_mux_en  : std_logic;
	SIGNAL addr_mux_sel : std_logic_vector(1 downto 0) := "00";
	SIGNAL addr_mux_en  : std_logic;
	COMPONENT mux IS
		port(
			in1 : IN std_logic_vector(7 downto 0) := "00000000";
			in2 : IN std_logic_vector(7 downto 0) := "00000000";
			in3 : IN std_logic_vector(7 downto 0) := "00000000";

			en   : IN std_logic;
			sel  : IN std_logic_vector(1 downto 0);

			output : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	COMPONENT decoder IS
		port(
			-- clock
			clk : IN std_logic;

			-- busses
			data_bus : INOUT std_logic_vector(7 downto 0) := "ZZZZZZZZ";
			addr_bus : INOUT std_logic_vector(7 downto 0) := "ZZZZZZZZ";

			-- memory control
			mem_ce : OUT std_logic;
			mem_oe : OUT std_logic;
			mem_we : OUT std_logic;

			-- register control
			reg_a_we : OUT std_logic;
			reg_b_we : OUT std_logic;

			-- ALU
			alu_zero : IN std_logic;

			-- muxes control
			data_mux_sel : IN std_logic_vector(1 downto 0) := "00";
			data_mux_en : IN std_logic;
			addr_mux_sel : IN std_logic_vector(1 downto 0) := "00";
			addr_mux_en : IN std_logic;
		);
	END COMPONENT;

BEGIN
	clk1 : clock port map (clk => clk);

	reg1 : reg port map(
		clk => clk,
		we => reg_a_we,
		data => data_bus,
		output => reg_a_out);

	reg2 : reg port map(
		clk => clk,
		we => reg_b_we,
		data => data_bus,
		output => reg_b_out);

	alu1 : alu port map(
		clk => clk,
		in1 => reg_a_out,
		in2 => reg_b_out,
		sum => alu_out,
		zero => alu_zero);

	mem1 : memory port map(
		data => data_bus,
		addr => addr_bus,
		ce => mem_ce,
		oe => mem_oe,
		we => mem_we);

	data_mux1 : mux port map(
		in1 => reg_a_out,
		in2 => reg_b_out,
		in3 => alu_out,
		en => data_mux_en,
		sel => data_mux_sel,
		output => data_bus);

	addr_mux1 : mux port map(
		in1 => reg_a_out,
		in2 => reg_b_out,
		in3 => alu_out,
		en => addr_mux_en,
		sel => addr_mux_sel,
		output => addr_bus);

	decoder1 : decoder port map(
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


