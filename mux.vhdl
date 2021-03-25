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

		sel  : in std_logic_vector(2 downto 0);

		output : out std_logic_vector(7 downto 0)
	);
end entity;

architecture mux_arch of mux is
begin
	process(sel, in1, in2, in3, in4, in5, in6, in7, in8)
	begin
		case sel is
			when "000" => output <= in1;
			when "001" => output <= in2;
			when "010" => output <= in3;
			when "011" => output <= in4;
			when "100" => output <= in5;
			when "101" => output <= in6;
			when "110" => output <= in7;
			when "111" => output <= in8;
			when others => output <= (others => '0');
		end case;
	end process;
end architecture;
