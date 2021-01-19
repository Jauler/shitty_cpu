library ieee;
use ieee.std_logic_1164.all;

ENTITY decoder IS
	port(
		-- clock
		clk : IN std_logic;

		-- busses
		data_bus : INOUT std_logic_vector(7 downto 0) := "ZZZZZZZZ";
		addr_bus : INOUT std_logic_vector(7 downto 0) := "ZZZZZZZZ";

		-- memory control
		mem_ce : OUT std_logic;
		mem_oe : OUT std_logic;
		mem_we : OUT std_logic;

		-- register control
		reg_a_we : OUT std_logic;
		reg_b_we : OUT std_logic;

		-- ALU
		alu_zero : IN std_logic;

		-- muxes control
		data_mux_sel : IN std_logic_vector(1 downto 0) := "00";
		data_mux_en : IN std_logic;
		addr_mux_sel : IN std_logic_vector(1 downto 0) := "00";
		addr_mux_en : IN std_logic;
	);
END ENTITY;

ARCHITECTURE decoder OF decoder IS
BEGIN
	step : PROCESS (clk)
	BEGIN
	END PROCESS;
END;
