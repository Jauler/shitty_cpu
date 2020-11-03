library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY alu IS
	PORT(
		in1    : IN std_logic_vector(7 downto 0);
		in2    : IN std_logic_vector(7 downto 0);
		en     : IN std_logic;
		zero   : OUT std_logic;
		result : OUT std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE alu OF alu IS
BEGIN
	step : PROCESS(in1, in2, en)
	VARIABLE sum : std_logic_vector(7 downto 0);
	BEGIN
		IF en = '1' THEN
			sum := in1 + in2;
			IF sum = "00000000" THEN
				zero <= '1';
			ELSE
				zero <= '0';
			END IF;
			result <= sum;
		ELSE
			zero <= 'Z';
			result <= "ZZZZZZZZ";
		END IF;
	END PROCESS;
END;
