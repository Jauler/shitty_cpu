library ieee;
use ieee.std_logic_1164.all;

ENTITY cpu_register IS
	port(
		output : OUT std_logic_vector(7 downto 0);
		input  : IN std_logic_vector(7 downto 0);
		set    : IN std_logic;
		clk    : IN std_logic;
		en     : IN std_logic
	);
END ENTITY;

ARCHITECTURE cpu_register OF cpu_register IS
	SIGNAL value : std_logic_vector(7 downto 0) := "00000000";
BEGIN
	step : PROCESS (clk, en)
	BEGIN
		IF en = '1' THEN
			output <= value;
		ELSE
			output <= "ZZZZZZZZ";
		END IF;

		IF set = '1' AND rising_edge(clk) THEN
			value <= input;
		END IF;
	END PROCESS;
END;
