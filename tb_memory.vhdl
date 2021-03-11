library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY tb_memory IS
 	port(
		ce : IN std_logic;
		we : IN std_logic;
		oe : IN std_logic;
		data : INOUT std_logic_vector(7 downto 0);
		addr : IN std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE tb_memory_arch OF tb_memory IS
	TYPE mem_type is array (255 downto 0) of std_logic_vector(7 downto 0);
	SIGNAL mem : mem_type := (
		0 => "01001011", -- LOAD A, 0x80
		1 => "10000000",

		2 => "00010011", -- MOVE B, 0x00
		3 => "11111111",

		4 => "00001010", -- ADD A
		5 => "00000000",

		6 => "11000000", -- JZ 0x00 (0xFE + 2 == 0x00)
		7 => "11111110",

		8 => "00100011", -- J 0x04
		9 => "00000010",

		-- data
		128 => "00001011",

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
