library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY decoder IS
	port(
		-- reset
		reset : IN std_logic;

		-- clock
		clk : IN std_logic;

		-- memory control
		mem_ce : OUT std_logic;
		mem_oe : OUT std_logic;
		mem_we : OUT std_logic;

		-- register control
		reg_pc_we : OUT std_logic;
		reg_operand_we : OUT std_logic;
		reg_instruction_we : OUT std_logic;
		reg_a_we : OUT std_logic;
		reg_b_we : OUT std_logic;

		-- some register's value
		instruction     : IN std_logic_vector(7 downto 0);
		program_counter : IN std_logic_vector(7 downto 0);

		-- ALU
		alu_zero : IN std_logic;
		alu_we   : OUT std_logic;

		-- muxes control
		data_mux_sel : OUT std_logic_vector(2 downto 0);
		data_mux_en : OUT std_logic;
		addr_mux_sel : OUT std_logic_vector(2 downto 0);
		addr_mux_en : OUT std_logic;

		-- Input into muxes from decoder
		data_bus_out : OUT std_logic_vector(7 downto 0);
		addr_bus_out : OUT std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE decoder_arch OF decoder IS
	CONSTANT INSTR_REG_TO_REG  : std_logic_vector(1 downto 0) := "00";
	CONSTANT INSTR_MEM_TO_REG  : std_logic_vector(1 downto 0) := "01";
	CONSTANT INSTR_REG_TO_MEM  : std_logic_vector(1 downto 0) := "10";
	CONSTANT INSTR_CONDITIONAL : std_logic_vector(1 downto 0) := "11";

	TYPE states IS (FETCH_I_SETUP, FETCH_I_START_WRITE, FETCH_I_WRITE, FETCH_I_END_WRITE, FETCH_I_CLEANUP,
			FETCH_O_SETUP, FETCH_O_START_WRITE, FETCH_O_WRITE, FETCH_O_END_WRITE, FETCH_O_CLEANUP,
			EXECUTE_SETUP, EXECUTE_START_WRITE, EXECUTE_WRITE, EXECUTE_END_WRITE, EXECUTE_CLEANUP,
			INCREMENT_SETUP, INCREMENT_START_WRITE, INCREMENT_WRITE, INCREMENT_END_WRITE, INCREMENT_CLEANUP
			);

	SIGNAL state : States;
BEGIN
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '0') THEN
			state <= FETCH_I_SETUP;
			mem_ce <= '0';
			mem_oe <= '0';
			mem_we <= '0';

			reg_pc_we <= '0';
			reg_operand_we <= '0';
			reg_instruction_we <= '0';
			reg_a_we <= '0';
			reg_b_we <= '0';

			data_mux_en <= '0';
			data_mux_sel <= "000";
			addr_mux_en <= '0';
			addr_mux_sel <= "000";

		ELSIF (rising_edge(clk)) THEN
			CASE state IS

			-- read instruction byte into register
			WHEN FETCH_I_SETUP =>
				mem_ce <= '1';
				mem_oe <= '1';
				mem_we <= '0';
				addr_bus_out <= program_counter;
				addr_mux_sel <= "110"; -- decoder addr out into addr bus
				addr_mux_en <= '1';
				state <= FETCH_I_START_WRITE;
			WHEN FETCH_I_START_WRITE =>
				reg_instruction_we <= '1';
				state <= FETCH_I_WRITE;
			WHEN FETCH_I_WRITE =>
				state <= FETCH_I_END_WRITE;
			WHEN FETCH_I_END_WRITE =>
				reg_instruction_we <= '0';
				state <= FETCH_I_CLEANUP;
			WHEN FETCH_I_CLEANUP =>
				mem_ce <= '0';
				mem_oe <= '0';
				mem_we <= '0';
				addr_mux_en <= '0';
				state <= FETCH_O_SETUP;

			-- All instructions contains operand
			-- byte... Even if it is not used :D
			-- Lets read that byte into operand
			-- register
			WHEN FETCH_O_SETUP =>
				mem_ce <= '1';
				mem_oe <= '1';
				mem_we <= '0';
				addr_bus_out <= std_logic_vector(unsigned(program_counter) + 1);
				addr_mux_sel <= "110"; -- decoder addr out into addr bus
				addr_mux_en <= '1';
				state <= FETCH_O_START_WRITE;
			WHEN FETCH_O_START_WRITE =>
				reg_operand_we <= '1';
				state <= FETCH_O_WRITE;
			WHEN FETCH_O_WRITE =>
				state <= FETCH_O_END_WRITE;
			WHEN FETCH_O_END_WRITE =>
				reg_operand_we <= '0';
				state <= FETCH_O_CLEANUP;
			WHEN FETCH_O_CLEANUP =>
				mem_ce <= '0';
				mem_oe <= '0';
				mem_we <= '0';
				addr_mux_en <= '0';
				state <= EXECUTE_SETUP;


			-- Execute instruction
			WHEN EXECUTE_SETUP =>
				-- setup control signals to output
				-- required data onto data and/or
				-- address bus according to instruction
				-- type
				CASE instruction (7 downto 6) IS
				WHEN INSTR_REG_TO_REG =>
					data_mux_en <= '1';
					data_mux_sel <= instruction (2 downto 0);
				WHEN INSTR_MEM_TO_REG =>
					addr_mux_sel <= instruction (2 downto 0);
					addr_mux_en <= '1';
					mem_ce <= '1';
					mem_oe <= '1';
					mem_we <= '0';
				WHEN INSTR_REG_TO_MEM =>
					data_mux_sel <= instruction (2 downto 0);
					data_mux_en <= '1';
					addr_mux_sel <= instruction (5 downto 3);
					addr_mux_en <= '1';
				WHEN INSTR_CONDITIONAL =>
					IF alu_zero = '1' THEN
						data_mux_sel <= "011"; -- operand value into data bus
						data_mux_en <= '1';
					END IF;
				WHEN others =>
				END CASE;
				state <= EXECUTE_START_WRITE;
			WHEN EXECUTE_START_WRITE =>
				CASE instruction (7 downto 6) IS
				WHEN INSTR_REG_TO_REG =>
					CASE instruction (4 downto 3) IS
					WHEN "00" => reg_a_we <= '1';
					WHEN "01" => reg_b_we <= '1';
					WHEN "10" => alu_we <= '1';
					WHEN "11" => reg_pc_we <= '1';
					WHEN others =>
					END CASE;
				WHEN INSTR_MEM_TO_REG =>
					CASE instruction (4 downto 3) IS
					WHEN "00" => reg_a_we <= '1';
					WHEN "01" => reg_b_we <= '1';
					WHEN "10" => alu_we <= '1';
					WHEN "11" => reg_pc_we <= '1';
					WHEN others =>
					END CASE;
				WHEN INSTR_REG_TO_MEM =>
					mem_ce <= '1';
					mem_oe <= '0';
					mem_we <= '1';
				WHEN INSTR_CONDITIONAL =>
					IF alu_zero = '1' THEN
						reg_pc_we <= '1';
					END IF;
				WHEN others =>
				END CASE;
				state <= EXECUTE_WRITE;
			WHEN EXECUTE_WRITE =>
				state <= EXECUTE_END_WRITE;
			WHEN EXECUTE_END_WRITE =>
				reg_pc_we <= '0';
				reg_b_we <= '0';
				reg_a_we <= '0';
				mem_we <= '0';
				reg_pc_we <= '0';
				alu_we <= '0';
				state <= EXECUTE_CLEANUP;
			WHEN EXECUTE_CLEANUP =>
				mem_ce <= '0';
				mem_oe <= '0';
				data_mux_en <= '0';
				addr_mux_en <= '0';
				state <= INCREMENT_SETUP;

			-- Increment program counter by 2
			WHEN INCREMENT_SETUP =>
				-- Increment PC by 2
				data_bus_out <= std_logic_vector(unsigned(program_counter) + 2);
				data_mux_sel <= "101"; -- decoder data into data bus
				data_mux_en <= '1';
				state <= INCREMENT_START_WRITE;
			WHEN INCREMENT_START_WRITE =>
				reg_pc_we <= '1';
				state <= INCREMENT_WRITE;
			WHEN INCREMENT_WRITE =>
				state <= INCREMENT_END_WRITE;
			WHEN INCREMENT_END_WRITE =>
				reg_pc_we <= '0';
				state <= INCREMENT_CLEANUP;
			WHEN INCREMENT_CLEANUP =>
				data_mux_en <= '0';
				state <= FETCH_I_SETUP;

			END CASE;
		END IF;
	END PROCESS;
END;
