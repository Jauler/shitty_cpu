library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY memory IS
 	port(
		data : INOUT std_logic_vector(7 downto 0);
		addr : IN std_logic_vector(3 downto 0);
		rw   : IN std_logic;
		en   : IN std_logic
	);
END ENTITY;

ARCHITECTURE memory OF memory IS
	TYPE mem_type is array (7 downto 0) of std_logic_vector(7 downto 0);
	SIGNAL mem : mem_type;
BEGIN
	step : PROCESS(en, rw, addr, data)
	BEGIN
		IF en = '1' AND rw = '1' THEN
			data <= mem(to_integer(unsigned(addr)));
		ELSIF en = '1' AND rw = '0' THEN
			mem(to_integer(unsigned(addr))) <= data;
		ELSIF en = '0' THEN
			data <= "ZZZZZZZZ";
		END IF;
	END PROCESS;
END ARCHITECTURE;
