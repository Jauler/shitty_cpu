library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY mux IS
	port(
		in1 : IN std_logic_vector(7 downto 0);
		in2 : IN std_logic_vector(7 downto 0);
		in3 : IN std_logic_vector(7 downto 0);
		in4 : IN std_logic_vector(7 downto 0);
		in5 : IN std_logic_vector(7 downto 0);
		in6 : IN std_logic_vector(7 downto 0);
		in7 : IN std_logic_vector(7 downto 0);
		in8 : IN std_logic_vector(7 downto 0);

		en   : IN std_logic;
		sel  : IN std_logic_vector(2 downto 0);

		output : OUT std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE mux_arch OF mux IS
	SIGNAL intermediate : std_logic_vector(7 downto 0);
BEGIN
	PROCESS(en, sel, in1, in2, in3, in4, in5, in6, in7, in8, intermediate)
	BEGIN
		CASE sel IS
			WHEN "000" => intermediate <= in1;
			WHEN "001" => intermediate <= in2;
			WHEN "010" => intermediate <= in3;
			WHEN "011" => intermediate <= in4;
			WHEN "100" => intermediate <= in5;
			WHEN "101" => intermediate <= in6;
			WHEN "110" => intermediate <= in7;
			WHEN "111" => intermediate <= in8;
			WHEN others => intermediate <= (others => '0');
		END CASE;
		CASE en IS
			WHEN '1' => output <= intermediate;
			WHEN others => output <= (others => 'L');
		END CASE;
	END PROCESS;
END ARCHITECTURE;
