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

BEGIN
	clk1 : clock port map (clk => clk);

END ARCHITECTURE;


