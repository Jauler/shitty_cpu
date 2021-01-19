library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY alu IS
	PORT(
		clk    : IN std_logic;
		in1    : IN std_logic_vector(7 downto 0);
		in2    : IN std_logic_vector(7 downto 0);
		sum    : OUT std_logic_vector(7 downto 0);
		zero   : OUT std_logic
	);
END ENTITY;

ARCHITECTURE alu OF alu IS
BEGIN
	step : PROCESS(in1, in2)
	BEGIN
		IF rising_edge(clk) THEN
			IF in1 + in2 = "00000000" THEN
				zero <= '1';
			ELSE
				zero <= '0';
			END IF;
			sum <= in1 + in2;
		END IF;
	END PROCESS;
END;
