library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
	port(
		-- reset
		reset : in std_logic;

		-- clock
		clk : in std_logic;

		-- memory control
		mem_ce : out std_logic;
		mem_oe : out std_logic;
		mem_we : out std_logic;

		-- register control
		reg_pc_we : out std_logic;
		reg_operand_we : out std_logic;
		reg_instruction_we : out std_logic;
		reg_a_we : out std_logic;
		reg_b_we : out std_logic;

		-- some register's value
		instruction     : in std_logic_vector(7 downto 0);
		program_counter : in std_logic_vector(7 downto 0);

		-- ALU
		alu_zero : in std_logic;
		alu_we   : out std_logic;

		-- muxes control
		data_mux_sel : out std_logic_vector(2 downto 0);
		data_mux_en : out std_logic;
		addr_mux_sel : out std_logic_vector(2 downto 0);
		addr_mux_en : out std_logic;

		-- Input into muxes from decoder
		data_bus_out : out std_logic_vector(7 downto 0);
		addr_bus_out : out std_logic_vector(7 downto 0)
	);
end entity;

architecture decoder_arch of decoder is
	constant INSTR_REG_TO_REG  : std_logic_vector(1 downto 0) := "00";
	constant INSTR_MEM_TO_REG  : std_logic_vector(1 downto 0) := "01";
	constant INSTR_REG_TO_MEM  : std_logic_vector(1 downto 0) := "10";
	constant INSTR_CONDITIONAL : std_logic_vector(1 downto 0) := "11";

	type states is (FETCH_I_SETUP, FETCH_I_START_WRITE, FETCH_I_WRITE, FETCH_I_END_WRITE, FETCH_I_CLEANUP,
			FETCH_O_SETUP, FETCH_O_START_WRITE, FETCH_O_WRITE, FETCH_O_END_WRITE, FETCH_O_CLEANUP,
			EXECUTE_SETUP, EXECUTE_START_WRITE, EXECUTE_WRITE, EXECUTE_END_WRITE, EXECUTE_CLEANUP,
			INCREMENT_SETUP, INCREMENT_START_WRITE, INCREMENT_WRITE, INCREMENT_END_WRITE, INCREMENT_CLEANUP
			);

	signal state : States;
begin
	process (clk, reset)
	begin
		if (reset = '0') then
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

		elsif (rising_edge(clk)) then
			case state is

			-- read instruction byte into register
			when FETCH_I_SETUP =>
				mem_ce <= '1';
				mem_oe <= '1';
				mem_we <= '0';
				addr_bus_out <= program_counter;
				addr_mux_sel <= "110"; -- decoder addr out into addr bus
				addr_mux_en <= '1';
				state <= FETCH_I_START_WRITE;
			when FETCH_I_START_WRITE =>
				reg_instruction_we <= '1';
				state <= FETCH_I_WRITE;
			when FETCH_I_WRITE =>
				state <= FETCH_I_END_WRITE;
			when FETCH_I_END_WRITE =>
				reg_instruction_we <= '0';
				state <= FETCH_I_CLEANUP;
			when FETCH_I_CLEANUP =>
				mem_ce <= '0';
				mem_oe <= '0';
				mem_we <= '0';
				addr_mux_en <= '0';
				state <= FETCH_O_SETUP;

			-- All instructions contains operand
			-- byte... Even if it is not used :D
			-- Lets read that byte into operand
			-- register
			when FETCH_O_SETUP =>
				mem_ce <= '1';
				mem_oe <= '1';
				mem_we <= '0';
				addr_bus_out <= std_logic_vector(unsigned(program_counter) + 1);
				addr_mux_sel <= "110"; -- decoder addr out into addr bus
				addr_mux_en <= '1';
				state <= FETCH_O_START_WRITE;
			when FETCH_O_START_WRITE =>
				reg_operand_we <= '1';
				state <= FETCH_O_WRITE;
			when FETCH_O_WRITE =>
				state <= FETCH_O_END_WRITE;
			when FETCH_O_END_WRITE =>
				reg_operand_we <= '0';
				state <= FETCH_O_CLEANUP;
			when FETCH_O_CLEANUP =>
				mem_ce <= '0';
				mem_oe <= '0';
				mem_we <= '0';
				addr_mux_en <= '0';
				state <= EXECUTE_SETUP;


			-- Execute instruction
			when EXECUTE_SETUP =>
				-- setup control signals to output
				-- required data onto data and/or
				-- address bus according to instruction
				-- type
				case instruction (7 downto 6) is
				when INSTR_REG_TO_REG =>
					data_mux_en <= '1';
					data_mux_sel <= instruction (2 downto 0);
				when INSTR_MEM_TO_REG =>
					addr_mux_sel <= instruction (2 downto 0);
					addr_mux_en <= '1';
					mem_ce <= '1';
					mem_oe <= '1';
					mem_we <= '0';
				when INSTR_REG_TO_MEM =>
					data_mux_sel <= instruction (2 downto 0);
					data_mux_en <= '1';
					addr_mux_sel <= instruction (5 downto 3);
					addr_mux_en <= '1';
				when INSTR_CONDITIONAL =>
					if alu_zero = '1' then
						data_mux_sel <= "011"; -- operand value into data bus
						data_mux_en <= '1';
					end if;
				when others =>
				end case;
				state <= EXECUTE_START_WRITE;
			when EXECUTE_START_WRITE =>
				case instruction (7 downto 6) is
				when INSTR_REG_TO_REG =>
					case instruction (4 downto 3) is
					when "00" => reg_a_we <= '1';
					when "01" => reg_b_we <= '1';
					when "10" => alu_we <= '1';
					when "11" => reg_pc_we <= '1';
					when others =>
					end case;
				when INSTR_MEM_TO_REG =>
					case instruction (4 downto 3) is
					when "00" => reg_a_we <= '1';
					when "01" => reg_b_we <= '1';
					when "10" => alu_we <= '1';
					when "11" => reg_pc_we <= '1';
					when others =>
					end case;
				when INSTR_REG_TO_MEM =>
					mem_ce <= '1';
					mem_oe <= '0';
					mem_we <= '1';
				when INSTR_CONDITIONAL =>
					if alu_zero = '1' then
						reg_pc_we <= '1';
					end if;
				when others =>
				end case;
				state <= EXECUTE_WRITE;
			when EXECUTE_WRITE =>
				state <= EXECUTE_END_WRITE;
			when EXECUTE_END_WRITE =>
				reg_pc_we <= '0';
				reg_b_we <= '0';
				reg_a_we <= '0';
				mem_we <= '0';
				reg_pc_we <= '0';
				alu_we <= '0';
				state <= EXECUTE_CLEANUP;
			when EXECUTE_CLEANUP =>
				mem_ce <= '0';
				mem_oe <= '0';
				data_mux_en <= '0';
				addr_mux_en <= '0';
				state <= INCREMENT_SETUP;

			-- Increment program counter by 2
			when INCREMENT_SETUP =>
				-- Increment PC by 2
				data_bus_out <= std_logic_vector(unsigned(program_counter) + 2);
				data_mux_sel <= "101"; -- decoder data into data bus
				data_mux_en <= '1';
				state <= INCREMENT_START_WRITE;
			when INCREMENT_START_WRITE =>
				reg_pc_we <= '1';
				state <= INCREMENT_WRITE;
			when INCREMENT_WRITE =>
				state <= INCREMENT_END_WRITE;
			when INCREMENT_END_WRITE =>
				reg_pc_we <= '0';
				state <= INCREMENT_CLEANUP;
			when INCREMENT_CLEANUP =>
				data_mux_en <= '0';
				state <= FETCH_I_SETUP;

			end case;
		end if;
	end process;
end;
