# =======================================================================
# FFT Project Makefile
# Description: Automated Build and Simulation Environment
# Support: Multiple testbench modules via 'MODULE' variable
# =======================================================================

# Toolchain Variables
IVERILOG    = iverilog
VVP         = vvp
SURFER      = surfer
PYTHON_CMD  = python3

# Directory Path Variables
RTL_DIR     = ../rtl
DV_DIR      = ../dv
SIM_DIR     = ./sim_build
SCRIPT_DIR  = ../scripts

# Module Selection (Default: cordic)
# Usage: make [target] MODULE=reordering
MODULE ?= cordic

# File and Target Definitions based on selected MODULE
OUTPUT_BIN   = $(MODULE)_sim
VCD_FILE     = $(MODULE)_wave.vcd
# Sửa đổi tại đây để dump ra file txt theo tên module
LOG_FILE     = output_$(MODULE).txt
FILELIST     = rtl_files.f

# Testbench Sources
DV_SOURCES   = $(DV_DIR)/tb_$(MODULE).sv
DV_TOP_FILE  = tb_$(MODULE)

# Python Verification Variables
PYTHON_SCRIPT = $(SCRIPT_DIR)/check_$(MODULE).py
CHECK_REPORT  = tb_$(MODULE)_check.txt

# --- Default Target ---
all: create_filelist build run

# ---------------------------------------------------------
# Target: create_filelist
# Generates a list of all .sv files in the RTL directory
# ---------------------------------------------------------
create_filelist:
	@echo "------------------------------------------------"
	@echo " Generating file list from $(RTL_DIR)..."
	@echo "------------------------------------------------"
	@find $(RTL_DIR) -name "*.sv" | sort > $(FILELIST)
	@echo " File list saved to: $(FILELIST)"

# ---------------------------------------------------------
# Target: build
# Compiles the RTL and Testbench using Icarus Verilog
# ---------------------------------------------------------
build: create_filelist
	@echo "------------------------------------------------"
	@echo " Compiling Module: $(MODULE)"
	@echo "------------------------------------------------"
	$(IVERILOG) -o $(OUTPUT_BIN) -c $(FILELIST) $(DV_SOURCES) -s $(DV_TOP_FILE) -g2005-sv

# ---------------------------------------------------------
# Target: run
# Executes the simulation and pipes output to a log file
# ---------------------------------------------------------
run: build
	@echo "------------------------------------------------"
	@echo " Running Simulation..."
	@echo "------------------------------------------------"
	$(VVP) $(OUTPUT_BIN) | tee $(LOG_FILE)

# ---------------------------------------------------------
# Target: verify
# Runs Python script to validate simulation results
# ---------------------------------------------------------
verify: run
	@if [ -f $(PYTHON_SCRIPT) ]; then \
		echo "------------------------------------------------"; \
		echo " Running Python Verification..."; \
		$(PYTHON_CMD) $(PYTHON_SCRIPT) $(LOG_FILE) > $(CHECK_REPORT); \
		echo " Report saved to: $(CHECK_REPORT)"; \
		echo "------------------------------------------------"; \
		cat $(CHECK_REPORT); \
	else \
		echo " [!] No python script found for $(MODULE) at $(PYTHON_SCRIPT)"; \
	fi

# ---------------------------------------------------------
# Target: wave
# Opens the generated VCD file in Surfer/GTKWave
# ---------------------------------------------------------
wave:
	@if [ -f $(VCD_FILE) ]; then \
		$(SURFER) $(VCD_FILE); \
	else \
		echo " [!] VCD file not found. Run simulation first."; \
	fi

# ---------------------------------------------------------
# Target: clean
# Removes ALL generated artifacts, logs, wave files, and executables
# ---------------------------------------------------------
clean:
	@echo "------------------------------------------------"
	@echo " Cleaning up all simulation artifacts..."
	@echo "------------------------------------------------"
	rm -f *_sim
	rm -f *.vcd
	rm -f *.log *.txt
	rm -f *.f
	@echo " Clean completed."

# ---------------------------------------------------------
# Target: help (Giữ nguyên như cũ)
# Displays usage instructions
# ---------------------------------------------------------
help:
	@echo "======================================================================="
	@echo "                       FFT PROJECT MAKEFILE HELP                       "
	@echo "======================================================================="
	@echo " Usage: make [TARGET] MODULE=[module_name]"
	@echo ""
	@echo " Main Targets:"
	@echo "  all       : Generate filelist, compile, and run (Default)"
	@echo "  build     : Compile the selected module only"
	@echo "  run       : Run simulation and save output to .log"
	@echo "  verify    : Run simulation and verify with Python script"
	@echo "  wave      : Open waveform viewer"
	@echo "  clean     : Remove all temporary and generated files"
	@echo ""
	@echo " Available Modules Examples:"
	@echo "  cordic, reordering, stage1, stage2..."
	@echo ""
	@echo " Examples:"
	@echo "  make all MODULE=reordering"
	@echo "  make verify MODULE=cordic"
	@echo "  make wave MODULE=reordering"
	@echo "======================================================================="

.PHONY: all build run verify wave clean help create_filelist
