library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
	port(
		-- reset
		reset : in std_logic;

		-- clock
		clk : in std_logic;

		-- instruction register
		instruction : in std_logic_vector(7 downto 0);

		-- memory control
		mem_we : out std_logic;

		-- register control
		reg_pc_we : out std_logic;
		reg_pc_inc : out std_logic;
		reg_operand_we : out std_logic;
		reg_instruction_we : out std_logic;
		reg_a_we : out std_logic;
		reg_b_we : out std_logic;

		-- ALU
		alu_zero : in std_logic;
		alu_we   : out std_logic;

		-- muxes control
		data_mux_sel : out std_logic_vector(2 downto 0);
		addr_mux_sel : out std_logic_vector(2 downto 0)
	);
end entity;

architecture controller_arch of controller is
	constant INSTR_REG_TO_REG  : std_logic_vector(1 downto 0) := "00";
	constant INSTR_MEM_TO_REG  : std_logic_vector(1 downto 0) := "01";
	constant INSTR_REG_TO_MEM  : std_logic_vector(1 downto 0) := "10";
	constant INSTR_CONDITIONAL : std_logic_vector(1 downto 0) := "11";

	constant MUX_REG_A   : std_logic_vector(2 downto 0) := "000";
	constant MUX_REG_B   : std_logic_vector(2 downto 0) := "001";
	constant MUX_ALU     : std_logic_vector(2 downto 0) := "010";
	constant MUX_OPERAND : std_logic_vector(2 downto 0) := "011";
	constant MUX_PC      : std_logic_vector(2 downto 0) := "100";
	constant MUX_MEMORY  : std_logic_vector(2 downto 0) := "101";

	type states is (FETCH_I_TO_BUS, FETCH_I_FROM_BUS,
			FETCH_O_TO_BUS, FETCH_O_FROM_BUS,
			EXECUTE_TO_BUS, EXECUTE_FROM_BUS
			);

	signal state : States;
begin
	process (clk, reset)
	begin
		if (reset = '0') then
			state <= FETCH_I_TO_BUS;
			mem_we <= '0';

			reg_pc_we <= '0';
			reg_pc_inc <= '0';
			reg_operand_we <= '0';
			reg_instruction_we <= '0';
			reg_a_we <= '0';
			reg_b_we <= '0';

			alu_we <= '0';

			data_mux_sel <= "000";
			addr_mux_sel <= "000";

		elsif (rising_edge(clk)) then
			case state is

			-- read instruction byte into register
			when FETCH_I_TO_BUS =>
				-- reset everything that might be left
				-- from instruction execution
				mem_we <= '0';
				reg_pc_we <= '0';
				reg_pc_inc <= '0';
				reg_operand_we <= '0';
				reg_instruction_we <= '0';
				reg_a_we <= '0';
				reg_b_we <= '0';
				alu_we <= '0';

				-- read instruction at PC from memory onto data bus
				addr_mux_sel <= MUX_PC;
				data_mux_sel <= MUX_MEMORY;
				state <= FETCH_I_FROM_BUS;
			when FETCH_I_FROM_BUS =>
				reg_instruction_we <= '1';
				reg_pc_inc <= '1';
				state <= FETCH_O_TO_BUS;

			-- All instructions contains operand
			-- byte... Even if it is not used :D
			-- Lets read that byte into operand
			-- register
			when FETCH_O_TO_BUS =>
				-- reset instruction fetch
				reg_instruction_we <= '0';
				reg_pc_inc <= '0';

				addr_mux_sel <= MUX_PC;
				data_mux_sel <= MUX_MEMORY;
				state <= FETCH_O_FROM_BUS;
			when FETCH_O_FROM_BUS =>
				reg_operand_we <= '1';
				reg_pc_inc <= '1';
				state <= EXECUTE_TO_BUS;


			-- Execute instruction
			when EXECUTE_TO_BUS =>
				-- reset everything that is left from operand fetch
				reg_operand_we <= '0';
				reg_pc_inc <= '0';

				-- Select by instruction type (2 MSB bits)
				case instruction (7 downto 6) is
				when INSTR_REG_TO_REG =>
					-- register to register,
					-- Select value source
					data_mux_sel <= instruction (5 downto 3);
				when INSTR_MEM_TO_REG =>
					-- Memory to register,
					-- Select address source
					addr_mux_sel <= instruction (5 downto 3);
					data_mux_sel <= MUX_MEMORY;
					mem_we <= '0';
				when INSTR_REG_TO_MEM =>
					-- Memory to register
					-- Select address source and value source
					addr_mux_sel <= instruction (5 downto 3);
					data_mux_sel <= instruction (2 downto 0);
					mem_we <= '1';
				when INSTR_CONDITIONAL =>
					-- Put operand onto bus in case we
					-- will need to write it into PC
					data_mux_sel <= MUX_OPERAND; -- operand value into data bus
				when others =>
				end case;
				state <= EXECUTE_FROM_BUS;
			when EXECUTE_FROM_BUS =>

				-- Select by instruction type (2 MSB bits)
				case instruction (7 downto 6) is
				when INSTR_REG_TO_REG =>
					-- register to register
					-- Write into destination, use the same
					-- encoding for register selection as for
					-- muxes, even though not all values are
					-- possible
					case instruction (2 downto 0) is
					when MUX_REG_A => reg_a_we <= '1';
					when MUX_REG_B => reg_b_we <= '1';
					when MUX_ALU => alu_we <= '1';
					when MUX_PC => reg_pc_we <= '1';
					when others =>
					end case;
				when INSTR_MEM_TO_REG =>
					-- Same as REG_TO_REG, as data is already
					-- on the bus
					case instruction (2 downto 0) is
					when MUX_REG_A => reg_a_we <= '1';
					when MUX_REG_B => reg_b_we <= '1';
					when MUX_ALU => alu_we <= '1';
					when MUX_PC => reg_pc_we <= '1';
					when others =>
					end case;
				when INSTR_REG_TO_MEM =>
					mem_we <= '0';
				when INSTR_CONDITIONAL =>
					if alu_zero = '1' then
						reg_pc_we <= '1';
					end if;
				when others =>
				end case;
				state <= FETCH_I_TO_BUS;
			end case;
		end if;
	end process;
end;
