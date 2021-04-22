library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_register is
	port(
		reset  : in std_logic;
		clk    : in std_logic;
		we     : in std_logic;
		data   : in std_logic_vector(7 downto 0);
		output : out std_logic_vector(7 downto 0)
	);
end entity;

architecture cpu_register_arch of cpu_register is
begin
	step : process (reset, clk)
	begin
		if reset = '0' then
			output <= (others => '0');
		elsif rising_edge(clk) and we = '1' then
			output <= data;
		end if;
	end process;
end;
