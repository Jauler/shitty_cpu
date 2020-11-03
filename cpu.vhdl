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

	SIGNAL alu_out  : std_logic_vector(7 downto 0);
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

	SIGNAL counter : std_logic_vector(7 downto 0) := "00000000";

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

	alu_a : alu port map(
		in1 => reg_a_value,
		in2 => reg_b_value,
		en => alu_en,
		result => alu_out,
		zero => alu_zero);


	test : PROCESS(clk)
	VARIABLE current_counter : std_logic_vector(7 downto 0) := "00000000";
	BEGIN
		IF rising_edge(clk) THEN
			current_counter := counter + 1;
			counter <= current_counter;
		END IF;
		IF current_counter = 3 THEN
			alu_en <= '1';
		END IF;
		IF current_counter = 4 THEN
			alu_en <= '0';
		END IF;
		IF current_counter = 5 THEN
			cpu_bus <= X"03";
			reg_a_set <= '1';
		END IF;
		IF current_counter = 6 THEN
			reg_a_set <= '0';
			cpu_bus <= X"02";
			reg_b_set <= '1';
		END IF;
		IF current_counter = 7 THEN
			reg_b_set <= '0';
			alu_en <= '1';
		END IF;
		IF current_counter = 8 THEN
			reg_b_set <= '0';
			alu_en <= '0';
		END IF;
	END PROCESS;

END ARCHITECTURE;


