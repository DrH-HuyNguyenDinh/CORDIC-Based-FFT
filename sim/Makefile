# Variables
IVERILOG = iverilog
VVP = vvp
SURFER = surfer
SIM_DIR = sim
OUTPUT = cordic
VCD_FILE = cordic_wave.vcd
TEXT_OUTPUT = tb_cordic.txt
RTL_DIR = ../rtl
DV_DIR = ../dv
FILELIST = rtl_files.f

# Python verification variables
PYTHON_CMD = python3
PYTHON_SCRIPT = check_cordic.py
CHECK_OUTPUT = tb_cordic_check.txt

# Testbench file
DV_SOURCES = $(DV_DIR)/tb_cordic.sv
DV_FILE = tb_cordic

# Default target
all: create_filelist build run

# Build, run and create wave
all_wave: create_filelist build run wave

# ---------------------------------------------------------
# Create file list target
# ---------------------------------------------------------
create_filelist:
	@echo "------------------------------------------------"
	@echo "Searching for .sv files in $(RTL_DIR)..."
	@echo "------------------------------------------------"
	@find $(RTL_DIR) -name "*.sv" | sort | tee $(FILELIST)
	@echo "------------------------------------------------"
	@echo "File list generated at: $(FILELIST)"
	@echo "------------------------------------------------"

# Build target
build: $(OUTPUT)

# Rule to compile the Verilog sources
$(OUTPUT): $(DV_SOURCES)
	@if [ ! -f $(FILELIST) ]; then \
		echo "File list not found. Running create_filelist..."; \
		make create_filelist; \
	fi
	$(IVERILOG) -o $@ -c $(FILELIST) $(DV_SOURCES) -s $(DV_FILE) -g2012

# Run target
# Chạy mô phỏng và lưu log vào TEXT_OUTPUT (tb_cordic.txt)
run: build
	$(VVP) $(OUTPUT) | tee $(TEXT_OUTPUT)

# ---------------------------------------------------------
# Simulation + Python Verification Target
# ---------------------------------------------------------
sim_python: run
	@echo "------------------------------------------------"
	@echo "Running Python Verification..."
	@echo "Reading log from: $(TEXT_OUTPUT)"
	@echo "Writing check result to: $(CHECK_OUTPUT)"
	@echo "------------------------------------------------"
	$(PYTHON_CMD) $(PYTHON_SCRIPT) > $(CHECK_OUTPUT)
	@echo "Verification Complete!"
	@echo "Results saved in $(CHECK_OUTPUT)"
	@echo "------------------------------------------------"
	@cat $(CHECK_OUTPUT)

# Wave target
wave: 
	$(SURFER) $(VCD_FILE)

# Clean up
clean:
	rm -f $(OUTPUT) $(VCD_FILE) $(TEXT_OUTPUT) $(FILELIST) $(CHECK_OUTPUT)

# Help
help:
	@echo " make create_filelist : Find .sv files, PRINT them, and save to $(FILELIST)"
	@echo " make build           : Compile the design"
	@echo " make run             : Run simulation and save log to $(TEXT_OUTPUT)"
	@echo " make sim_python      : Run sim, verify with Python, save to $(CHECK_OUTPUT)"
	@echo " make wave            : Open waveform"
	@echo " make all             : Update list, build, and run"
	@echo " make clean           : Remove simulation and log files"
