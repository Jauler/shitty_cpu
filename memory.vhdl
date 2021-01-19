library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY memory IS
 	port(
		ce : IN std_logic;
		we : IN std_logic;
		oe : IN std_logic;
		data : INOUT std_logic_vector(7 downto 0);
		addr : IN std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE memory OF memory IS
	TYPE mem_type is array (255 downto 0) of std_logic_vector(7 downto 0);
	SIGNAL mem : mem_type;
BEGIN
	storage : PROCESS(ce, we, oe)
	BEGIN
		IF ce = '1' THEN
			IF we = '0' AND oe = '0' THEN
				data <= "ZZZZZZZZ";
			ELSIF we = '0' AND oe = '1' THEN
				mem(to_integer(unsigned(addr))) <= data;
			ELSIF we = '1' AND oe = '0' THEN
				data <= mem(to_integer(unsigned(addr)));
			ELSIF we = '1' AND oe = '1' THEN
				data <= "ZZZZZZZZ";
			END IF;
		ELSE
			data <= "ZZZZZZZZ";
		END IF;
	END PROCESS;
END ARCHITECTURE;
