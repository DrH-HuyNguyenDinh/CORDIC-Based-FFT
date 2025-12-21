# 32-bit Floating-Point CORDIC-Based 1024-Point FFT Processor

## 📌 Overview

This repository contains the RTL implementation of a **1024-point Radix-2 Fast Fourier Transform (FFT)** processor using **IEEE 754 Single Precision Floating-Point** arithmetic.

Unlike traditional fixed-point implementations, this design provides a **high dynamic range** and eliminates common overflow issues. It utilizes a **Floating-Point CORDIC (COordinate Rotation DIgital Computer)** algorithm for twiddle factor multiplication, avoiding the need for massive floating-point hardware multipliers.

This project is part of my **Capstone Project 2** at VIETNAM NATIONAL UNIVERSITY HO CHI MINH CITY HO CHI MINH CITY UNIVERSITY OF TECHNOLOGY.

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




*(Note: Upload your diagram to the 'docs' folder)*

## ⚙️ Features

* **Points (N):** 1024
* **Algorithm:** Radix-2 Decimation-In-Time (DIT).
* **Data Format:** **IEEE 754 Single Precision Floating-Point (32-bit)**.
* Processing: Parallel 32-bit Real and 32-bit Imaginary datapaths.


* **Memory:** 32-bit width Dual-Port RAMs.
* **Pipeline Stages:** 10 stages.
* **Optimization:** Multiplier-less complex rotation using CORDIC.

Here is the detailed **Verification Strategy** section written in professional English. You can copy and paste this directly into your `README.md` file.

It highlights the robustness of your testing method (Python Co-Simulation) and includes the specific technical details of the signal generation and automated checking process.

---

## 🧪 Verification Strategy

This project employs a robust **Python-based Co-Verification flow** to ensure the algorithmic correctness and hardware integrity of the Floating-Point FFT processor. The verification process is divided into three main stages:

### 1. Stimulus Generation

**Script:** `scripts/test_fft/fft_gen.py`

To rigorously test the dynamic range and precision of the IEEE-754 Floating-Point units, we generate a **"chaotic" realistic signal** rather than simple pure sine waves.

* **Configuration:** Sampling Frequency () = 100 kHz, 2048 sample points.
* **Time-Variant Signal:**
*  samples: 2  kHz Sine Wave.
*  samples: 10 kHz Sine Wave.


* **Interference:** Injected a noise signal at **24.6 kHz**.
* **Noise Injection:** Added White Gaussian Noise (Mean=0, ) to simulate real-world channel conditions.

The generated data is quantized into **32-bit Hex (IEEE-754 Single Precision)** format and exported to a `.txt` file for memory initialization in the Verilog testbench.

> *Note: The Python FFT analysis confirms that despite the time-domain chaos, the frequency components (1MHz, 5MHz, and 12.3MHz) are distinctly resolvable, validating the input quality.*

### 2. Golden Reference Model

**Script:** `scripts/test_fft/find_bit_reverse_pairs.py`

For the **Input Reordering** block, the data must be permuted according to the Radix-2 DIT Bit-Reversal algorithm. A dedicated Python model generates the "Golden" truth table:

* **Logic:** For  (10-bit address width), input index  is bit-reversed to produce target index .
* **Mapping:** The model maps the data at the original index to the expected data at the reversed index.

**Example of the Golden Reference Table (`fft_bit_reversed_pairs.txt`):**

```text
IDX   | Bin (Original) | Hex Orig   <--> IDX Rev | Bin (Reversed) | Hex Rev   
--------------------------------------------------------------------------------
0     | 0000000000     | 3dcb7441   <--> 0       | 0000000000     | 3dcb7441  
1     | 0000000001     | 3ecb9058   <--> 512     | 1000000000     | 3f5c72aa  
2     | 0000000010     | 3ec95ebc   <--> 256     | 0100000000     | 3f649295  
...

```

### 3. Automated Checking

**Script:** `scripts/check_reordering.py`

After running the SystemVerilog simulation, the RTL output is captured in a log file. The automated checking script performs a bit-exact comparison between the **Simulation Output** and the **Golden Reference**.

**Process:**

1. Loads the expected bit-reversed hex values from the Golden Model.
2. Parses the simulation log (`output_input_reordering.txt`) to extract RTL output data.
3. Performs a line-by-line comparison.

**Verification Results Log:**

```text
========================================================
       CHECKING INPUT REORDERING RESULT
========================================================
Loading Golden Data from: .../scripts/test_fft/fft_bit_reversed_pairs.txt
-> Loaded 1024 golden values.
Loading Verilog Output from: .../sim/output_input_reordering.txt
-> Loaded 2121 verilog output values.

------------------------------------------------------------
INDEX    | GOLDEN          | VERILOG         | STATUS
------------------------------------------------------------
0        | 3dcb7441        | 3dcb7441        | PASS
1        | 3f5c72aa        | 3f5c72aa        | PASS
2        | 3f649295        | 3f649295        | PASS
3        | 3f039487        | 3f039487        | PASS
4        | bea6b48d        | bea6b48d        | PASS
...      | ...             | ...             | ...
1023     | 3eda0dac        | 3eda0dac        | PASS
------------------------------------------------------------

SUCCESS: All 1024 checked values MATCHED! ✅
(Note: Verilog simulation ran longer than golden data, overlapping part is correct)

```

This successful validation confirms that the hardware implementation of the Input Reordering block handles the complex Floating-Point data addressing correctly.

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
│   └── tb_fft.sv
├── rtl
│   ├── butterfly.sv
│   ├── comparator.sv
│   ├── cordic.sv
│   ├── cordic.sv:Zone.Identifier
│   ├── delay_23.sv
│   ├── dual_port_ram.sv
│   ├── fft.sv
│   ├── fpu_add_sub.sv
│   ├── fullAdder32b.sv
│   ├── input_reordering.sv
│   ├── inversion_sequence.sv
│   ├── mux4to1.sv
│   ├── rom_stage_10.sv
│   ├── rom_stage_3.sv
│   ├── rom_stage_4.sv
│   ├── rom_stage_5.sv
│   ├── rom_stage_6.sv
│   ├── rom_stage_7.sv
│   ├── rom_stage_8.sv
│   ├── rom_stage_9.sv
│   ├── stage_1.sv
│   ├── stage_10.sv
│   ├── stage_2.sv
│   ├── stage_3.sv
│   ├── stage_4.sv
│   ├── stage_5.sv
│   ├── stage_6.sv
│   ├── stage_7.sv
│   ├── stage_8.sv
│   └── stage_9.sv
├── scripts
│   ├── check_cordic.py
│   ├── check_reordering.py
│   ├── dmem_init_file.txt
│   ├── output_fft.txt:Zone.Identifier
│   ├── output_fft_stage1.txt
│   └── test_fft
│       ├── fft.py
│       ├── fft_final.py
│       ├── fft_input_2frames_1024.txt
│       ├── fft_peaks_analysis.png
│       ├── fft_python.png
│       └── find_bit_reverse_pairs.py
└── sim
    ├── Makefile
    ├── fft_sim
    ├── fft_wave_2frames.vcd
    ├── output_fft.txt
    └── rtl_files.f
```

## 📝 Final Result

<img width="1920" height="1920" alt="Output CORDIC-based FFT" src="https://github.com/user-attachments/assets/457bf45e-2865-4886-90a3-c77cd536392f" />

---

*Maintained by Nguyen Dinh Huy.*
