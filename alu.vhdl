library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY alu IS
	PORT(
		reset  : IN std_logic;
		clk    : IN std_logic;
		we     : IN std_logic;
		in1    : IN std_logic_vector(7 downto 0);
		in2    : IN std_logic_vector(7 downto 0);
		sum    : OUT std_logic_vector(7 downto 0);
		zero   : OUT std_logic
	);
END ENTITY;

ARCHITECTURE alu_arch OF alu IS
BEGIN
	step : PROCESS(clk, reset)
	BEGIN
		IF reset = '0' THEN
			sum <= (others => '0');
			zero <= '0';
		ELSIF rising_edge(clk) AND we = '1' THEN
			IF unsigned(in1) + unsigned(in2) = "00000000" THEN
				zero <= '1';
			ELSE
				zero <= '0';
			END IF;
			sum <= std_logic_vector(unsigned(in1) + unsigned(in2));
		END IF;
	END PROCESS;
END;
