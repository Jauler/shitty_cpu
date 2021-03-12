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
		0 => "01000011", -- MOVE A, [0x81]
		1 => x"81",

		2 => "00001011", -- MOVE B, 0x01
		3 => x"01",

		4 => "00010000", -- ADD
		5 => x"00",

		6 => "00001111", -- MOV B, ACC
		7 => x"00",

		8 => "10011001", -- MOVE [0x81], B
		9 => x"81",

		10 => "01000011", -- MOVE A, [0x80]
		11 => x"80",

		12 => "00001011", -- MOVE B, 0xFF
		13 => x"FF",

		14 => "00010000", -- ADD
		15 => x"00",

		16 => "00000111", -- MOV A, ACC
		17 => x"00",

		18 => "11000000", -- JZ 0x00 (0xFE + 0x02 == 0x00)
		19 => x"FE",

		20 => "00011011", -- J 0x0E (0x0C + 0x02 == 0x0E)
		21 => x"0C",

		-- data
		128 => x"0B",
		129 => x"02",

		others=>"00000000");
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
END ARCHITECTURE;
