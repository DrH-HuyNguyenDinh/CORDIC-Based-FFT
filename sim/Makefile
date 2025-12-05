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

# ==== SỬA LỖI TẠI ĐÂY ====
# Tên thư mục là "scripts" (số nhiều), không phải "script"
SCRIPT_DIR = ../scripts

# Python verification variables
PYTHON_CMD = python3
# Trỏ đúng vào file
PYTHON_SCRIPT = $(SCRIPT_DIR)/check_cordic.py
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
run: build
	$(VVP) $(OUTPUT) | tee $(TEXT_OUTPUT)

# ---------------------------------------------------------
# Simulation + Python Verification Target
# ---------------------------------------------------------
sim_python: run
	@echo "------------------------------------------------"
	@echo "Running Python Verification..."
	@echo "Script location: $(PYTHON_SCRIPT)"
	@echo "Input Log file : $(TEXT_OUTPUT)"
	@echo "Writing check result to: $(CHECK_OUTPUT)"
	@echo "------------------------------------------------"
	# Truyền $(TEXT_OUTPUT) vào làm tham số
	$(PYTHON_CMD) $(PYTHON_SCRIPT) $(TEXT_OUTPUT) > $(CHECK_OUTPUT)
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
	@echo " make sim_python      : Run sim, verify with Python using $(PYTHON_SCRIPT)"
	@echo " make wave            : Open waveform"
	@echo " make all             : Update list, build, and run"
	@echo " make clean           : Remove simulation and log files"
