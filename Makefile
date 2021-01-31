
SRC  = mux.vhdl
SRC += register.vhdl
SRC += alu.vhdl
SRC += decoder.vhdl
SRC += cpu.vhdl

SRC += tb_memory.vhdl
SRC += tb_clock.vhdl
SRC += tb_movInstructionTest.vhdl

FLAGS  = --ieee=synopsys
FLAGS += -fexplicit --std=02

all: run

analyze: $(SRC)
	@echo "Analyzing..."
	ghdl -a $(FLAGS) $(SRC)

elaborate: analyze
	@echo "Elaborating..."
	ghdl -e $(FLAGS) cpu

run: elaborate
	@echo "Running... Press CTRL-C to stop"
	ghdl -r $(FLAGS) cpu --wave=wave.ghw
