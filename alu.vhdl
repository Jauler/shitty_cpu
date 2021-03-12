library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY alu IS
	PORT(
		clk    : IN std_logic;
		in1    : IN std_logic_vector(7 downto 0);
		in2    : IN std_logic_vector(7 downto 0);
		sum    : OUT std_logic_vector(7 downto 0);
		zero   : OUT std_logic
	);
END ENTITY;

ARCHITECTURE alu_arch OF alu IS
BEGIN
	step : PROCESS(in1, in2)
	BEGIN
		IF unsigned(in1) + unsigned(in2) = "00000000" THEN
			zero <= '1';
		ELSE
			zero <= '0';
		END IF;
		sum <= std_logic_vector(unsigned(in1) + unsigned(in2));
	END PROCESS;
END;
