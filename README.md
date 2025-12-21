# 32-bit Floating-Point CORDIC-Based 1024-Point FFT Processor <img width="35" height="1701" alt="image" src="https://github.com/user-attachments/assets/03c893a9-9bea-4d26-b10c-aeb074b9aa2d" />


## 📌 Overview

This repository contains the RTL source code (SystemVerilog) for a **1024-point Radix-2 Fast Fourier Transform (FFT)** processor utilizing **IEEE 754 Single Precision Floating-Point (32-bit)** arithmetic.

This design prioritizes high precision and a wide dynamic range, effectively mitigating the overflow issues often associated with fixed-point implementations. A key feature is the use of a **Floating-Point CORDIC** algorithm to perform complex phase rotations, thereby eliminating the need for expensive hardware multipliers.

This project was developed as a Capstone Project 2 at **Ho Chi Minh City University of Technology (HCMUT)**.

## ⚙️ Key Specifications

* **FFT Size:** 1024 points.
* **Architecture:** 10-Stage Pipeline (Decimation-In-Time).
* **Data Format:** IEEE 754 Floating-Point 32-bit.
* **Sampling Frequency (Fs):** 100 kHz.
* **Rotation Algorithm:** CORDIC (Vector Rotation Mode).
* **Memory:** 32-bit Dual-Port RAM (Parallel Real/Imaginary processing).

## 🏗 System Architecture

The system is designed with a **Fully Pipelined** architecture to maximize throughput:

1.  **Input Buffer:** Implements a Ping-Pong RAM mechanism with a Bit-Reversal address generator to handle continuous input data reordering.
2.  **Butterfly Unit:** Executes standard floating-point addition and subtraction operations.
3.  **CORDIC Rotator:** Replaces complex multipliers by performing vector rotation based on coordinates `(x, y)` and angle `z`.
4.  **Pipeline Storage:** Dual-Port RAMs are placed between stages to store intermediate calculation results.

## 🧪 Verification & Experimental Results

To ensure hardware accuracy, the verification process relies on a **Python Co-Simulation** model:

1.  **Stimulus Generation:**
    Input data is generated using a Python script to simulate a realistic signal containing:
    * Sine waves at **2 kHz** and **10 kHz**.
    * A single-tone noise interference at **24.6 kHz**.
    * Additive White Gaussian Noise.
    This data is quantized into 32-bit Hex (IEEE 754) format for the Testbench.

2.  **Verification Method:**
    The output frequency spectrum from the RTL Core is compared directly against the reference result calculated by Python's `numpy.fft` library (Golden Reference).

**Results:**
The figure below demonstrates a perfect match between the Python model and the Hardware Core. The RTL Core accurately resolves the **2 kHz and 10 kHz** frequency components and correctly identifies the **24.6 kHz** noise peak with precise magnitude.

<p align="center">
  <img src="https://github.com/user-attachments/assets/457bf45e-2865-4886-90a3-c77cd536392f" alt="FFT Result Verification" width="100%"/>
</p>

## 📂 Directory Structure

```text
cordic-based-fft/
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
