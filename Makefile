
SRC  = mux.vhdl
SRC += register.vhdl
SRC += alu.vhdl
SRC += decoder.vhdl
SRC += cpu.vhdl

SRC += tests/tb_memory.vhdl
SRC += tests/tb_clock.vhdl
SRC += tests/tb_mux.vhdl
SRC += tests/tb_alu.vhdl
SRC += tests/tb_register.vhdl
SRC += tests/tb_cpu_increment.vhdl
SRC += tests/tb_cpu_conditional.vhdl

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
