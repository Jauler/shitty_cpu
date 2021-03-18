library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
	port(
		in1 : in std_logic_vector(7 downto 0);
		in2 : in std_logic_vector(7 downto 0);
		in3 : in std_logic_vector(7 downto 0);
		in4 : in std_logic_vector(7 downto 0);
		in5 : in std_logic_vector(7 downto 0);
		in6 : in std_logic_vector(7 downto 0);
		in7 : in std_logic_vector(7 downto 0);
		in8 : in std_logic_vector(7 downto 0);

		en   : in std_logic;
		sel  : in std_logic_vector(2 downto 0);

		output : out std_logic_vector(7 downto 0)
	);
end entity;

architecture mux_arch of mux is
	signal intermediate : std_logic_vector(7 downto 0);
begin
	process(en, sel, in1, in2, in3, in4, in5, in6, in7, in8, intermediate)
	begin
		case sel is
			when "000" => intermediate <= in1;
			when "001" => intermediate <= in2;
			when "010" => intermediate <= in3;
			when "011" => intermediate <= in4;
			when "100" => intermediate <= in5;
			when "101" => intermediate <= in6;
			when "110" => intermediate <= in7;
			when "111" => intermediate <= in8;
			when others => intermediate <= (others => '0');
		end case;
		case en is
			when '1' => output <= intermediate;
			when others => output <= (others => 'L');
		end case;
	end process;
end architecture;
