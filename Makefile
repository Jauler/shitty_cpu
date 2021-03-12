
SRC  = mux.vhdl
SRC += register.vhdl
SRC += alu.vhdl
SRC += decoder.vhdl
SRC += cpu.vhdl

SRC += tb_memory.vhdl
SRC += tb_clock.vhdl
SRC += tb_loopTest.vhdl

FLAGS  = --ieee=synopsys
FLAGS += -fexplicit --std=08

ELABORATE = tb_movInstructionTest

all: run

analyze: $(SRC)
	@echo "Analyzing..."
	ghdl -a $(FLAGS) $(SRC)

elaborate: analyze
	@echo "Elaborating..."
	ghdl -e $(FLAGS) $(ELABORATE)

run: elaborate
	@echo "Running... Press CTRL-C to stop"
	ghdl -r $(FLAGS) $(ELABORATE) --wave=wave.ghw
