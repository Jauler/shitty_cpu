library ieee;
use ieee.std_logic_1164.all;

ENTITY mux IS
	port(
		in1 : IN std_logic_vector(7 downto 0) := "00000000";
		in2 : IN std_logic_vector(7 downto 0) := "00000000";
		in3 : IN std_logic_vector(7 downto 0) := "00000000";
		in4 : IN std_logic_vector(7 downto 0) := "00000000";

		en   : IN std_logic;
		sel  : IN std_logic_vector(1 downto 0);

		output : OUT std_logic_vector(7 downto 0);
	);
END ENTITY;

ARCHITECTURE mux OF mux IS
BEGIN
	step : PROCESS(in1, in2, in3, in4, en, sel)
	BEGIN
		IF en = '1' THEN
			WITH sel SELECT
				output <= in1 WHEN "00",
					  in2 WHEN "01",
					  in3 WHEN "10",
					  in4 WHEN "11";

		ELSE
			output <= "ZZZZZZ";
		END IF
	END PROCESS;
END ARCHITECTURE;
