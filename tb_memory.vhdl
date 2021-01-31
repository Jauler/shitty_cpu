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
	SIGNAL mem : mem_type := (
		0 => "00000001",
		1 => "00001010",
		2 => "00000010",
		3 => "00000101",
		4 => "00000011",
		5 => "00000000",
		others=>"00000000");
BEGIN
	storage : PROCESS(ce, we, oe, addr)
	BEGIN
		IF ce = '1' AND we = '1' AND oe = '0' THEN
			mem(to_integer(unsigned(addr))) <= data;
		ELSIF ce = '1' AND we = '0' AND oe = '1' THEN
			data <= mem(to_integer(unsigned(addr)));
		ELSE
			data <= (others => 'Z');
		END IF;
	END PROCESS;
END ARCHITECTURE;
