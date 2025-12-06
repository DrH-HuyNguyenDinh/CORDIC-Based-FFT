# 32-bit Floating-Point CORDIC-Based 1024-Point FFT Processor

![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)
![Language](https://img.shields.io/badge/Language-Verilog%2FSystemVerilog-blue)
![Platform](https://img.shields.io/badge/Platform-FPGA%20%28Cyclone%20V%29-green)
![Data Format](https://img.shields.io/badge/Data-IEEE%20754%20Floating%20Point-orange)

## 📌 Overview
This repository contains the RTL implementation of a **1024-point Radix-2 Fast Fourier Transform (FFT)** processor using **IEEE 754 Single Precision Floating-Point** arithmetic.

Unlike traditional fixed-point implementations, this design provides a **high dynamic range** and eliminates common overflow issues. It utilizes a **Floating-Point CORDIC (COordinate Rotation DIgital Computer)** algorithm for twiddle factor multiplication, avoiding the need for massive floating-point hardware multipliers.

This project is part of my **Capstone Project 2** at [University Name].

## 🏗 Architecture

The design follows a **Pipelined Architecture** (Decimation-In-Time) consisting of 10 stages for a 1024-point FFT.

### Key Components:
1.  **Input Buffer (Ping-Pong RAM):**
    -   Handles continuous data streaming using a Ping-Pong buffer scheme.
    -   Performs **Bit-Reversal** addressing (Inversion Sequence) to reorder input data.
    -   Uses standard **32-bit memory blocks** for storage.
2.  **Floating-Point Butterfly Unit:**
    -   Performs the core Radix-2 operations (`A ± B`) using 32-bit floating-point adders/subtractors.
3.  **Floating-Point CORDIC Rotator:**
    -   Operates in **Vector Rotation Mode** to perform complex multiplication.
    -   Accepts 32-bit IEEE 754 inputs `(x, y)` and rotation angle `z`.
4.  **Dual-Port RAMs:**
    -   Used between stages to store intermediate results.
    -   **Configuration:** Standard **32-bit data width**. 
    -   *Note:* Real and Imaginary components are processed and stored separately (using parallel RAM instances) to fit within standard FPGA Block RAM configurations (M10K).
5.  **Address Generation Unit (AGU):**
    -   Calculates read/write addresses and ROM lookup indices for rotation angles.

![Block Diagram](docs/block_diagram.png)
*(Note: Upload your diagram to the 'docs' folder)*

## ⚙️ Features
-   **Points (N):** 1024
-   **Algorithm:** Radix-2 Decimation-In-Time (DIT).
-   **Data Format:** **IEEE 754 Single Precision Floating-Point (32-bit)**.
    -   Processing: Parallel 32-bit Real and 32-bit Imaginary datapaths.
-   **Memory:** 32-bit width Dual-Port RAMs.
-   **Pipeline Stages:** 10 stages.
-   **Optimization:** Multiplier-less complex rotation using CORDIC.

## 📂 Directory Structure

```text
cordic-fft-fp/
├── dv
│   └── tb_cordic.sv
├── rtl
│   ├── butterfly.sv
│   ├── comparator.sv
│   ├── cordic.sv
│   ├── dual_port_ram.sv
│   ├── fpu_add_sub.sv
│   ├── fullAdder32b.sv
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
│   └── check_cordic.py
└── sim
    ├── Makefile
    ├── cordic
    ├── cordic_wave.vcd
    ├── rtl_files.f
    ├── tb_cordic.txt
    └── tb_cordic_check.txt
