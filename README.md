# 32-bit Floating-Point and Fixed-Point CORDIC-Based 1024-Point FFT Processor <img src="https://flagcdn.com/w40/vn.png" alt="Vietnam Flag" /> # <img width="39.6065574" height="40" alt="image" src="https://github.com/user-attachments/assets/1c6d938b-55cf-4f6e-b5e5-4482c5753911" /> 


## 📌 Overview

This repository contains the RTL source code (SystemVerilog) for a **1024-point Radix-2 Fast Fourier Transform (FFT)** processor utilizing **IEEE 754 Single Precision Floating-Point (32-bit)** and **Fixed-Point Q16.16 (32-bit)** arithmetic.

This design prioritizes high precision and a wide dynamic range, effectively mitigating the overflow issues often associated with fixed-point implementations. A key feature is the use of a **CORDIC** algorithm to perform complex phase rotations, thereby eliminating the need for expensive hardware multipliers.

This project was developed as a Capstone Project 2 at **Ho Chi Minh City University of Technology (HCMUT)**.

## ⚙️ Key Specifications

* **FFT Size:** 1024 points.
* **Architecture:** 10-Stage Pipeline (Decimation-In-Time).
* **Data Format:** IEEE 754 Floating-Point 32-bit and Fixed-Point Q16.16
* **Sampling Frequency (Fs):** 100 kHz.
* **Rotation Algorithm:** CORDIC (Vector Rotation Mode).
* **Memory:** 32-bit Dual-Port RAM (Parallel Real/Imaginary processing).

## 🏗 System Architecture

The system is designed with a **Fully Pipelined** architecture to maximize throughput:

1.  **Input Buffer:** Implements a Ping-Pong RAM mechanism with a Bit-Reversal address generator to handle continuous input data reordering.

<img width="2179" height="1123" alt="image" src="https://github.com/user-attachments/assets/3bacdd10-ee76-4294-94e9-b83460e5546f" />

3.  **Butterfly Unit:** Executes standard floating-point addition and subtraction operations.
5.  **CORDIC Rotator:** Replaces complex multipliers by performing vector rotation based on coordinates `(x, y)` and angle `z`.

<img width="3950" height="1645" alt="image" src="https://github.com/user-attachments/assets/c375d195-3350-49ed-adc4-d16a952d7365" />

6.  **Pipeline Storage:** Dual-Port RAMs are placed between stages to store intermediate calculation results.

<img width="3250" height="1210" alt="image" src="https://github.com/user-attachments/assets/99732430-b8e4-40ac-ac0f-59e7b650796b" />

<img width="3091" height="1251" alt="image" src="https://github.com/user-attachments/assets/6ee1c84c-77b3-48cc-a54c-d512440b1a7b" />

<img width="2996" height="1431" alt="image" src="https://github.com/user-attachments/assets/b3fc49b7-8f67-4841-a6a0-df31c28f9a17" />

## 🧪 Verification & Experimental Results

To ensure hardware accuracy, the verification process relies on a **Python Co-Simulation** model:

1.  **Stimulus Generation:**
    Input data is generated using a Python script to simulate a realistic signal containing:
    * Sine waves at **2 kHz** and **10 kHz**.
    * A single-tone noise interference at **24.6 kHz**.
    * Additive White Gaussian Noise.
    This data is quantized into 32-bit Hex format for the Testbench.

2.  **Verification Method:**
    The output frequency spectrum from the RTL Core is compared directly against the reference result calculated by Python's `numpy.fft` library (Golden Reference).

**Results:**
The figure below demonstrates a perfect match between the Python model and the Hardware Core. The RTL Core accurately resolves the **2 kHz and 10 kHz** frequency components and correctly identifies the **24.6 kHz** noise peak with precise magnitude.

<p align="center">
  Input data:
    <img width="1400" height="800" alt="fft_python" src="https://github.com/user-attachments/assets/50dac5e5-f008-4ca6-b5b6-1f5e9e204584" />
  Floating-Point Output:
    <img width="1400" height="700" alt="fft_peaks_analysis" src="https://github.com/user-attachments/assets/70a55c75-6a80-4e34-8b4f-d007a1061352" />
  Fixed-Point Output:
    <img width="1907" height="944" alt="fft_final_fixed_point" src="https://github.com/user-attachments/assets/a5a9c52a-193f-40fb-98e8-a23149564498" />
</p>

**Note:** Simulation may takes over an hour for Floating-Point.
