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
	SIGNAL cpu_bus : std_logic_vector(7 downto 0) := "ZZZZZZZZ";

	SIGNAL clk: std_logic;
	COMPONENT clock IS
		port(
			clk : OUT std_logic
		);
	END COMPONENT;

	SIGNAL reg_a_set   : std_logic := '0';
	SIGNAL reg_a_en    : std_logic := '0';
	SIGNAL reg_a_value : std_logic_vector(7 downto 0);
	SIGNAL reg_b_set   : std_logic := '0';
	SIGNAL reg_b_en    : std_logic := '0';
	SIGNAL reg_b_value : std_logic_vector(7 downto 0);
	COMPONENT cpu_register IS
		port(
			output : OUT std_logic_vector(7 downto 0);
			value  : OUT std_logic_vector(7 downto 0);
			input  : IN std_logic_vector(7 downto 0);
			set    : IN std_logic;
			en     : IN std_logic
		);
	END COMPONENT;

	SIGNAL alu_zero : std_logic;
	SIGNAL alu_en   : std_logic := '0';
	COMPONENT alu IS
	PORT(
		in1    : IN std_logic_vector(7 downto 0);
		in2    : IN std_logic_vector(7 downto 0);
		en     : IN std_logic;
		zero   : OUT std_logic;
		result : OUT std_logic_vector(7 downto 0)
	);
	END COMPONENT;

	SIGNAL mem_en : std_logic := '0';
	SIGNAL mem_rw : std_logic := '0';
	SIGNAL mem_addr : std_logic_vector(3 downto 0) := "0000";
	COMPONENT memory IS
		port(
			data : INOUT std_logic_vector(7 downto 0);
			addr : IN std_logic_vector(3 downto 0);
			rw   : IN std_logic;
			en   : IN std_logic
		);
	END COMPONENT;

	SIGNAL program_counter: std_logic_vector(7 downto 0) := "00000000";

BEGIN
	clk1 : clock port map (clk => clk);

	register_a : cpu_register port map (
			input => cpu_bus,
			output => cpu_bus,
			value => reg_a_value,
			en => reg_a_en,
			set => reg_a_set);

	register_b : cpu_register port map (
			input => cpu_bus,
			output => cpu_bus,
			value => reg_b_value,
			en => reg_b_en,
			set => reg_b_set);

	alu1 : alu port map(
		in1 => reg_a_value,
		in2 => reg_b_value,
		en => alu_en,
		result => cpu_bus,
		zero => alu_zero);

	mem1 : memory port map(
		data => cpu_bus,
		addr =>  mem_addr,
		en => mem_en,
		rw => mem_rw);

	test : PROCESS(clk)
	VARIABLE current_counter : std_logic_vector(7 downto 0) := "00000000";
	BEGIN
		IF rising_edge(clk) THEN
			current_counter := program_counter + 1;
			program_counter <= current_counter;
		END IF;
		IF current_counter = 3 THEN
			mem_rw <= '0';
			mem_addr <= "0000";
			cpu_bus <= x"AB";
			mem_en <= '1';
		END IF;
		IF current_counter = 4 THEN
			mem_rw <= '0';
			mem_addr <= "0001";
			cpu_bus <= x"BB";
			mem_en <= '1';
		END IF;
		IF current_counter = 5 THEN
			mem_rw <= '0';
			mem_addr <= "0010";
			cpu_bus <= x"BC";
			mem_en <= '1';
		END IF;
		IF current_counter = 6 THEN
			mem_rw <= '1';
			mem_addr <= "0000";
			cpu_bus <= "ZZZZZZZZ";
			mem_en <= '1';
		END IF;
		IF current_counter = 7 THEN
			mem_rw <= '1';
			mem_addr <= "0001";
			cpu_bus <= "ZZZZZZZZ";
			mem_en <= '1';
		END IF;
		IF current_counter = 7 THEN
			mem_en <= '0';
		END IF;
		IF current_counter = 8 THEN
			mem_addr <= "0010";
			mem_en <= '1';
		END IF;
	END PROCESS;

END ARCHITECTURE;


