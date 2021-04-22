library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	port(
		reset  : in std_logic;
		we     : in std_logic;
		inc    : in std_logic;
		data   : in std_logic_vector(7 downto 0);
		output : out std_logic_vector(7 downto 0)
	);
end entity;

architecture counter_arch of counter is
begin
	step : process(reset, we, inc)
	begin
		if reset = '0' then
			output <= (others => '0');
		elsif rising_edge(we) then
			output <= data;
		elsif rising_edge(inc) then
			output <= std_logic_vector(unsigned(output) + 1);
		end if;
	end process;
end;



