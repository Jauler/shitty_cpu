library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port(
		reset  : in std_logic;
		clk    : in std_logic;
		we     : in std_logic;
		in1    : in std_logic_vector(7 downto 0);
		in2    : in std_logic_vector(7 downto 0);
		sum    : out std_logic_vector(7 downto 0);
		zero   : out std_logic
	);
end entity;

architecture alu_arch of alu is
begin
	step : process(reset, clk)
	begin
		if reset = '0' then
			sum <= (others => '0');
			zero <= '0';
		elsif rising_edge(clk) and we = '1' then
			if unsigned(in1) + unsigned(in2) = "00000000" then
				zero <= '1';
			else
				zero <= '0';
			end if;
			sum <= std_logic_vector(unsigned(in1) + unsigned(in2));
		end if;
	end process;
end;
