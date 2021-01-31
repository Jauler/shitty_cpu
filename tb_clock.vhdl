library ieee;
use ieee.std_logic_1164.all;

ENTITY clock IS
	port(
		clk : OUT std_logic := '0'
	);
END ENTITY;

ARCHITECTURE clock OF clock IS
BEGIN
	clk_generator : PROCESS
	BEGIN
		clk <= '0';
		WAIT FOR 5 ns;
		clk <= '1';
		WAIT FOR 5 ns;
	END PROCESS;
END ARCHITECTURE;
