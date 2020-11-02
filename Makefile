
SRC  = cpu.vhdl
SRC += register.vhdl
SRC += clock.vhdl

all: run

analyze: $(SRC)
	@echo "Analyzing..."
	ghdl -a --ieee=synopsys $(SRC)

elaborate: analyze
	@echo "Elaborating..."
	ghdl -e --ieee=synopsys cpu

run: elaborate
	@echo "Running... Press CTRL-C to stop"
	ghdl -r --ieee=synopsys cpu --wave=wave.ghw
