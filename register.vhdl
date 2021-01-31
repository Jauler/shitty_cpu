library ieee;
use ieee.std_logic_1164.all;

ENTITY cpu_register IS
	port(
		reset  : IN std_logic;
		clk    : IN std_logic;
		we     : IN std_logic;
		data   : IN std_logic_vector(7 downto 0);
		output : OUT std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE cpu_register OF cpu_register IS
BEGIN
	reset_register : PROCESS (reset)
	BEGIN
		IF RESET = '1' THEN
			output <= (others => '0');
		END IF;
	END PROCESS;

	step : PROCESS (clk)
	BEGIN
		IF rising_edge(clk) AND we = '1' THEN
			output <= data;
		END IF;
	END PROCESS;
END;
