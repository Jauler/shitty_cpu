library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY decoder IS
	port(
		-- reset
		reset : in std_logic;

		-- clock
		clk : IN std_logic;

		-- busses
		data_bus : INOUT std_logic_vector(7 downto 0);
		addr_bus : INOUT std_logic_vector(7 downto 0);

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
		data_mux_sel : IN std_logic_vector(1 downto 0);
		data_mux_en : IN std_logic;
		addr_mux_sel : IN std_logic_vector(1 downto 0);
		addr_mux_en : IN std_logic
	);
END ENTITY;

ARCHITECTURE decoder OF decoder IS
	SIGNAL subinstr : std_logic_vector(4 downto 0);
	SIGNAL program_counter : std_logic_vector(7 downto 0);
	SIGNAL instruction_l : std_logic_vector(7 downto 0);
	SIGNAL instruction_h : std_logic_vector(7 downto 0);
BEGIN
	step : PROCESS (clk)
	BEGIN
		-- TODO: refactor into proper state machine
		IF reset = '0' THEN
			IF subinstr = 0 THEN
				addr_bus <= program_counter;
				mem_ce <= '1';
				mem_oe <= '1';
			END IF;
			IF subinstr = 1 THEN
				instruction_l <= data_bus;
			END IF;
			IF subinstr = 2 THEN
				addr_bus <= program_counter + 1;
			END IF;
			IF subinstr = 3 THEN
				instruction_h <= data_bus;
			END IF;
			IF subinstr = 4 THEN
				addr_bus <= "ZZZZZZZZ";
				mem_ce <= '0';
				mem_oe <= '0';
			END IF;




			-- move data from instruction_h to reg a
			IF instruction_l = "00000001" AND subinstr = 4 THEN
				data_bus <= instruction_h;
				reg_a_we <= '1';
			END IF;
			IF instruction_l = "00000001" AND subinstr = 5 THEN
				data_bus <= "ZZZZZZZZ";
				reg_a_we <= '0';
			END IF;




			-- move data from instruction_h to reg b
			IF instruction_l = "00000010" AND subinstr = 4 THEN
				data_bus <= instruction_h;
				reg_b_we <= '1';
			END IF;
			IF instruction_l = "00000010" AND subinstr = 5 THEN
				data_bus <= "ZZZZZZZZ";
				reg_b_we <= '0';
			END IF;




			-- jmp instruction
			IF instruction_l = "00000011" AND subinstr = 4 THEN
				program_counter <= instruction_h;
			END IF;



			-- increment program counter if not jumped
			IF instruction_l /= "00000011" AND subinstr = "1111" THEN
				program_counter <= program_counter + 2;
			END IF;

			-- Track subinstruction
			subinstr <= subinstr + 1;
		ELSE
			-- reset logic
			subinstr <= (others => '0');
			program_counter <= (others => '0');
			instruction_l <= (others => '0');
			instruction_h <= (others => '0');

			data_bus <= (others => 'Z');
			addr_bus <= (others => 'Z');

			mem_ce <= '0';
			mem_oe <= '0';
			mem_we <= '0';

			reg_a_we <= '0';
			reg_b_we <= '0';
		END IF;
	END PROCESS;
END;
