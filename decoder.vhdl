library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

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

		-- instruction register value
		instruction : IN std_logic_vector(7 downto 0);

		-- ALU
		alu_zero : IN std_logic;

		-- muxes control
		data_mux_sel : OUT std_logic_vector(2 downto 0);
		data_mux_en : OUT std_logic;
		addr_mux_sel : OUT std_logic_vector(2 downto 0);
		addr_mux_en : OUT std_logic
	);
END ENTITY;

ARCHITECTURE decoder_arch OF decoder IS
	TYPE states IS (FETCH_I, FETCH_O, DECODE, EXECUTE, INCREMENT);

	SIGNAL state : States;
BEGIN
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN
			state <= FETCH_I;
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

		-- Now we set all signals on falling edge
		-- Therefore the signals will be stable on
		-- rising edge. Where most of the components
		-- make their actions.
		ELSIF (rising_edge(clk)) THEN
			CASE state IS

			-- read instruction byte into register
			WHEN FETCH_I =>
				-- clear signals from increment stage
				data_mux_en <= '0';
				reg_pc_we <= '0';

				-- configure memory to read instruction byte
				mem_ce <= '1';
				mem_oe <= '1';
				mem_we <= '0';
				addr_mux_sel <= "100"; -- PC into addr bus
				addr_mux_en <= '1';
				reg_instruction_we <= '1';
				state <= FETCH_O;

			-- All instructions contains operand
			-- byte... Even if it is not used :D
			-- Lets setup memory, to read that
			-- byte
			WHEN FETCH_O =>
				reg_instruction_we <= '0';

				mem_ce <= '1';
				mem_oe <= '1';
				mem_we <= '0';
				addr_mux_sel <= "101"; -- PC+1 into addr bus
				addr_mux_en <= '1';
				reg_operand_we <= '1';
				state <= DECODE;

			WHEN DECODE =>
				reg_operand_we <= '0';
				mem_ce <= '0';
				mem_oe <= '0';
				mem_we <= '0';
				addr_mux_en <= '0';
				reg_operand_we <= '0';

				-- setup data according to instruction type
				CASE instruction (7 downto 6) IS

				-- direct (aka register to register) instruction
				WHEN "00" =>
					data_mux_en <= '1';
					data_mux_sel <= instruction (2 downto 0);

				-- memory to register instruction
				WHEN "01" =>
					mem_ce <= '1';
					mem_oe <= '1';
					mem_we <= '0';
					addr_mux_sel <= instruction (2 downto 0);
					addr_mux_en <= '1';

				-- register to memory instruction
				WHEN "10" =>
					data_mux_sel <= instruction (2 downto 0);
					data_mux_en <= '1';

					addr_mux_sel <= instruction (5 downto 3);
					addr_mux_en <= '1';

					mem_ce <= '1';
					mem_oe <= '0';
					mem_we <= '1';


				-- conditional jump instruction
				WHEN "11" =>
					IF alu_zero = '1' THEN
						data_mux_sel <= "011";
						data_mux_en <= '1';
					END IF;

				WHEN others =>
				END CASE;

				state <= EXECUTE;

			WHEN EXECUTE =>
				-- Data bus value has been configured in decode
				-- stage. Now we need to configure write of this
				-- data.

				-- setup data according to instruction type
				CASE instruction (7 downto 6) IS
				WHEN "00" =>
					reg_pc_we <= instruction(5);
					reg_b_we <= instruction(4);
					reg_a_we <= instruction(3);

				WHEN "01" =>
					reg_pc_we <= instruction(5);
					reg_b_we <= instruction(4);
					reg_a_we <= instruction(3);

				WHEN "10" =>
					mem_ce <= '0';
					mem_oe <= '0';
					mem_we <= '0';

				WHEN "11" =>
					IF alu_zero = '1' THEN
						reg_pc_we <= '1';
					END IF;

				WHEN others =>
				END CASE;

				state <= INCREMENT;

			WHEN INCREMENT =>
				-- Clear all control signals
				mem_ce <= '0';
				mem_oe <= '0';
				mem_we <= '0';
				reg_operand_we <= '0';
				reg_instruction_we <= '0';
				reg_a_we <= '0';
				reg_b_we <= '0';
				addr_mux_en <= '0';
				addr_mux_sel <= "000";

				-- Increment PC by 2
				data_mux_sel <= "110";
				data_mux_en <= '1';
				reg_pc_we <= '1';
				state <= FETCH_I;
			END CASE;
		END IF;
	END PROCESS;
END;
