
SRC  = mux.vhdl
SRC += register.vhdl
SRC += alu.vhdl
SRC += decoder.vhdl
SRC += cpu.vhdl

SRC += tb_memory.vhdl
SRC += tb_clock.vhdl
SRC += tb_mux.vhdl
SRC += tb_alu.vhdl
SRC += tb_register.vhdl
SRC += tb_cpu_increment.vhdl
SRC += tb_cpu_conditional.vhdl

FLAGS  = --ieee=synopsys
FLAGS += -fexplicit --std=08

TESTS=tb_mux tb_alu tb_register tb_cpu_increment tb_cpu_conditional

all: analyze test

analyze:
	@echo "Analyzing..."
	ghdl -a $(FLAGS) $(SRC)

$(TESTS): analyze
	@echo "Running test $@"
	ghdl -e $(FLAGS) $@
	ghdl -r $(FLAGS) $@ --wave=$@.ghw
	@echo "Test $@ OK"

test: $(TESTS)
