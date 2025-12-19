# 32-bit Floating-Point CORDIC-Based 1024-Point FFT Processor

## 📌 Overview

This repository contains the RTL implementation of a **1024-point Radix-2 Fast Fourier Transform (FFT)** processor using **IEEE 754 Single Precision Floating-Point** arithmetic.

Unlike traditional fixed-point implementations, this design provides a **high dynamic range** and eliminates common overflow issues. It utilizes a **Floating-Point CORDIC (COordinate Rotation DIgital Computer)** algorithm for twiddle factor multiplication, avoiding the need for massive floating-point hardware multipliers.

This project is part of my **Capstone Project 2** at [University Name].

## 🏗 Architecture

The design follows a **Pipelined Architecture** (Decimation-In-Time) consisting of 10 stages for a 1024-point FFT.

### Key Components:

1. **Input Buffer (Ping-Pong RAM):**
* Handles continuous data streaming using a Ping-Pong buffer scheme.
* Performs **Bit-Reversal** addressing (Inversion Sequence) to reorder input data.
* Uses standard **32-bit memory blocks** for storage.


2. **Floating-Point Butterfly Unit:**
* Performs the core Radix-2 operations (`A ± B`) using 32-bit floating-point adders/subtractors.


3. **Floating-Point CORDIC Rotator:**
* Operates in **Vector Rotation Mode** to perform complex multiplication.
* Accepts 32-bit IEEE 754 inputs `(x, y)` and rotation angle `z`.


4. **Dual-Port RAMs:**
* Used between stages to store intermediate results.
* **Configuration:** Standard **32-bit data width**.
* *Note:* Real and Imaginary components are processed and stored separately (using parallel RAM instances) to fit within standard FPGA Block RAM configurations (M10K).


5. **Address Generation Unit (AGU):**
* Calculates read/write addresses and ROM lookup indices for rotation angles.



*(Note: Upload your diagram to the 'docs' folder)*

## ⚙️ Features

* **Points (N):** 1024
* **Algorithm:** Radix-2 Decimation-In-Time (DIT).
* **Data Format:** **IEEE 754 Single Precision Floating-Point (32-bit)**.
* Processing: Parallel 32-bit Real and 32-bit Imaginary datapaths.


* **Memory:** 32-bit width Dual-Port RAMs.
* **Pipeline Stages:** 10 stages.
* **Optimization:** Multiplier-less complex rotation using CORDIC.

## 🧪 Verification Strategy

The project employs a Python-based verification flow to ensure the correctness of the complex Floating-Point arithmetic and addressing logic.

### 1. Stimulus Generation

A Python script (`fft_gen.py`) generates realistic test signals, including:

* **Multi-tone signals:** Mixing 1MHz and 5MHz sine waves.
* **Interference & Noise:** Adding 12.3MHz interference and White Gaussian Noise.
* **Output:** The script exports quantization-ready data in **32-bit Hex (IEEE 754)** format for the Verilog testbench.

### 2. Golden Reference Model

For the **Input Reordering** block, a reference model (`find_bit_reverse_pairs.py`) calculates the expected bit-reversed indices for 1024 points.

* **Logic:** Maps input index `00_0000_0001` (1)  `10_0000_0000` (512).
* **Output:** A golden table mapping every input address to its expected data content.

### 3. Automated Checking

The verification script (`check_reordering.py`) automatically compares the **RTL Simulation Output** against the **Golden Reference**.

* Parses the simulation log (`output_input_reordering.txt`).
* Validates data integrity line-by-line.
* Reports PASS/FAIL status for all 1024 points.

## 🛠️ How to Run

### Prerequisites

* **Simulator:** Icarus Verilog, ModelSim, or Questasim.
* **Python 3:** Required libraries: `numpy`, `matplotlib`.

### Steps

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/cordic-fft-fp.git
cd cordic-fft-fp

```


2. **Generate Test Data & Golden Model:**
```bash
# Generate noisy sine wave and FFT golden reference
python3 scripts/test_fft/fft_gen.py

# Generate Bit-Reversal Golden Table
python3 scripts/test_fft/find_bit_reverse_pairs.py

```


3. **Run RTL Simulation:**
```bash
cd sim
make run_reordering  # Or run your specific make target

```


4. **Verify Results:**
```bash
cd ..
python3 scripts/check_reordering.py

```


*Example Output:*
```text
SUCCESS: All 1024 checked values MATCHED! ✅

```



## 📂 Directory Structure

```text
cordic-fft-fp/
.
├── dv
│   ├── tb_cordic.sv
│   └── tb_input_reordering.sv
├── rtl
│   ├── butterfly.sv
│   ├── comparator.sv
│   ├── cordic.sv
│   ├── delay_23.sv
│   ├── dual_port_ram.sv
│   ├── fpu_add_sub.sv
│   ├── fullAdder32b.sv
│   ├── input_reordering.sv
│   ├── inversion_sequence.sv
│   ├── mux4to1.sv
│   ├── rom_stage_10.sv
│   ├── rom_stage_2.sv
│   ├── rom_stage_3.sv
│   ├── rom_stage_4.sv
│   ├── rom_stage_5.sv
│   ├── rom_stage_6.sv
│   ├── rom_stage_7.sv
│   ├── rom_stage_8.sv
│   ├── rom_stage_9.sv
│   └── stage_1.sv
├── scripts
│   ├── check_cordic.py
│   ├── check_reordering.py
│   ├── dmem_init_file.txt
│   └── test_fft
│       ├── fft.png
│       ├── fft.py
│       ├── fft_bit_reversed_pairs.txt
│       ├── fft_raw_2048.txt
│       ├── fft_table_2048.txt
│       └── find_bit_reverse_pairs.py
└── sim
    ├── Makefile
    ├── input_reordering_sim
    ├── input_reordering_wave.vcd
    ├── output_input_reordering.txt
    └── rtl_files.f
```

## 📝 Future Work

* [ ] Complete integration of all 10 FFT stages.
* [ ] Implement full automated checking for the final FFT output.
* [ ] Synthesis and Timing Analysis on **Cyclone V FPGA**.
* [ ] Error analysis (SQNR) between Floating-Point CORDIC and Ideal FFT.

---

*Maintained by Nguyen Dinh Huy.*
