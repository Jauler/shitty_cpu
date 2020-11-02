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
	SIGNAL cpu_bus : std_logic_vector(7 downto 0);

	SIGNAL clk: std_logic;
	COMPONENT clock IS
		port(
			clk : OUT std_logic
		);
	END COMPONENT;

	SIGNAL reg_a_set : std_logic;
	SIGNAL reg_a_en  : std_logic;
	COMPONENT cpu_register IS
		port(
			output : OUT std_logic_vector(7 downto 0);
			input  : IN std_logic_vector(7 downto 0);
			set    : IN std_logic;
			clk    : IN std_logic;
			en     : IN std_logic
		);
	END COMPONENT;

	SIGNAL counter : std_logic_vector(7 downto 0) := "00000000";

BEGIN
	clk1 : clock port map (clk => clk);

	register_a : cpu_register port map (
			clk => clk,
			input => cpu_bus,
			output => cpu_bus,
			en => reg_a_en,
			set => reg_a_set);

END ARCHITECTURE;


