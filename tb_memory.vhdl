library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE tb_memory_type_pkg IS
	TYPE mem_type IS array (255 downto 0) of std_logic_vector(7 downto 0);
END PACKAGE;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_memory_type_pkg.mem_type;

ENTITY tb_memory IS
	generic (
		initial_contents : mem_type
	);
	port(
		ce : IN std_logic;
		we : IN std_logic;
		oe : IN std_logic;
		data : INOUT std_logic_vector(7 downto 0);
		addr : IN std_logic_vector(7 downto 0);
		contents : OUT mem_type := initial_contents
	);
END ENTITY;

ARCHITECTURE tb_memory_arch OF tb_memory IS
	SIGNAL mem : mem_type := initial_contents;
BEGIN
	storage : PROCESS(ce, we, oe, addr)
	BEGIN
		IF ce = '1' AND we = '1' AND oe = '0' THEN
			mem(to_integer(unsigned(addr))) <= data;
		ELSIF ce = '1' AND we = '0' AND oe = '1' THEN
			data <= mem(to_integer(unsigned(addr)));
		END IF;

		IF ce = '0' OR oe = '0' THEN
			data <= (others => 'L');
		END IF;
	END PROCESS;

	contents <= mem;
END ARCHITECTURE;
