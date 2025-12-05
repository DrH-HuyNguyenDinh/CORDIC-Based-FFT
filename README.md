# 32-bit Floating-Point CORDIC-Based 1024-Point FFT Processor

![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)
![Language](https://img.shields.io/badge/Language-Verilog%2FSystemVerilog-blue)
![Platform](https://img.shields.io/badge/Platform-FPGA%20%28Cyclone%20V%29-green)
![Data Format](https://img.shields.io/badge/Data-IEEE%20754%20Floating%20Point-orange)

## 📌 Overview
This repository contains the RTL implementation of a **1024-point Radix-2 Fast Fourier Transform (FFT)** processor using **IEEE 754 Single Precision Floating-Point** arithmetic.

Unlike traditional fixed-point implementations, this design provides a **high dynamic range** and eliminates common overflow issues associated with fixed-point FFTs. It utilizes a **Floating-Point CORDIC (COordinate Rotation DIgital Computer)** algorithm for twiddle factor multiplication, avoiding the need for massive floating-point hardware multipliers.

This project is part of my **Capstone Project 2** at [University Name].

## 🏗 Architecture

The design follows a **Pipelined Architecture** (Decimation-In-Time) consisting of 10 stages for a 1024-point FFT.

### Key Components:
1.  **Input Buffer (Ping-Pong RAM):**
    -   Handles continuous data streaming.
    -   Performs **Bit-Reversal** addressing to reorder input data.
    -   Stores 32-bit Floating-Point samples (Real & Imaginary).
2.  **Floating-Point Butterfly Unit:**
    -   Performs the core Radix-2 operations (`A ± B`) using floating-point adders/subtractors.
    -   Handles alignment and normalization stages.
3.  **Floating-Point CORDIC Rotator:**
    -   Operates in **Vector Rotation Mode** to perform complex multiplication.
    -   Accepts IEEE 754 inputs `(x, y)` and rotation angle `z`.
    -   Includes pre-processing/normalization to adapt standard CORDIC iterations to floating-point data.
4.  **Dual-Port RAMs:**
    -   Stores intermediate results between pipeline stages.
    -   Configured for 64-bit width (32-bit Real + 32-bit Imaginary) per address.
5.  **Address Generation Unit (AGU):**
    -   Calculates read/write addresses and ROM lookup indices for rotation angles.

![Block Diagram](docs/block_diagram.png)
*(Note: Upload your diagram to the 'docs' folder)*

## ⚙️ Features
-   **Points (N):** 1024
-   **Algorithm:** Radix-2 Decimation-In-Time (DIT).
-   **Data Format:** **IEEE 754 Single Precision Floating-Point (32-bit)**.
    -   Input: 64-bit Complex (32-bit Real + 32-bit Imaginary).
    -   Output: 64-bit Complex (32-bit Real + 32-bit Imaginary).
-   **Precision:** High dynamic range suitable for scientific computing and DSP applications requiring high accuracy.
-   **Pipeline Stages:** 10 stages.
-   **Optimization:** Multiplier-less complex rotation using CORDIC.

## 📂 Directory Structure

```text
cordic-fft-fp/
├── rtl/                # Source Verilog/SystemVerilog files
├── tb/                 # Testbenches
├── sim/                # Simulation scripts & waveforms
