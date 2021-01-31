
SRC  = cpu.vhdl
SRC += clock.vhdl
SRC += register.vhdl
SRC += alu.vhdl
SRC += memory.vhdl
SRC += decoder.vhdl
SRC += mux.vhdl

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
