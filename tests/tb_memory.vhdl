library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tb_memory_type_pkg is
	type mem_type is array (255 downto 0) of std_logic_vector(7 downto 0);
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_memory_type_pkg.mem_type;

entity tb_memory is
	generic (
		initial_contents : mem_type
	);
	port(
		ce : in std_logic;
		we : in std_logic;
		oe : in std_logic;
		data : inout std_logic_vector(7 downto 0);
		addr : in std_logic_vector(7 downto 0);
		contents : out mem_type := initial_contents
	);
end entity;

architecture tb_memory_arch of tb_memory is
	signal mem : mem_type := initial_contents;
begin
	storage : process(ce, we, oe, addr)
	begin
		if ce = '1' and we = '1' and oe = '0' then
			mem(to_integer(unsigned(addr))) <= data;
		elsif ce = '1' and we = '0' and oe = '1' then
			data <= mem(to_integer(unsigned(addr)));
		end if;

		if ce = '0' or oe = '0' then
			data <= (others => 'L');
		end if;
	end process;

	contents <= mem;
end architecture;
