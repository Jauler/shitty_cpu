library ieee;
use ieee.std_logic_1164.all;

ENTITY mux IS
	port(
		in1 : IN std_logic_vector(7 downto 0) := "00000000";
		in2 : IN std_logic_vector(7 downto 0) := "00000000";
		in3 : IN std_logic_vector(7 downto 0) := "00000000";

		en   : IN std_logic;
		sel  : IN std_logic_vector(1 downto 0);

		output : OUT std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE mux OF mux IS
BEGIN
	step : PROCESS(in1, in2, in3, en, sel)
	BEGIN
		IF en = '1' THEN
			IF sel = "00" THEN
				output <= in1;
			ELSIF sel = "01" THEN
				output <= in2;
			ELSIF sel = "10" THEN
				output <= in3;
			ELSE
				output <= "00000000";
			END IF;
		ELSE
			output <= "ZZZZZZZZ";
		END IF;
	END PROCESS;
END ARCHITECTURE;
