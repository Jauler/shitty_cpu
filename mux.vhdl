library ieee;
use ieee.std_logic_1164.all;

ENTITY mux IS
	port(
		in1 : IN std_logic_vector(7 downto 0);
		in2 : IN std_logic_vector(7 downto 0);
		in3 : IN std_logic_vector(7 downto 0);

		en   : IN std_logic;
		sel  : IN std_logic_vector(1 downto 0);

		output : OUT std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE mux_arch OF mux IS
	SIGNAL intermediate : std_logic_vector(7 downto 0);
BEGIN
	PROCESS(en, sel, in1, in2, in3)
	BEGIN
		CASE sel IS
			WHEN "00" => intermediate <= in1;
			WHEN "01" => intermediate <= in2;
			WHEN "10" => intermediate <= in3;
			WHEN others => intermediate <= (others => '0');
		END CASE;
		CASE en IS
			WHEN '1' => output <= intermediate;
			WHEN others => output <= (others => 'Z');
		END CASE;
	END PROCESS;
END ARCHITECTURE;
