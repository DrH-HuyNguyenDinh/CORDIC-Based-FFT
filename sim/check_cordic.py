import struct
import re
import math
import sys

# Tên file log đầu vào (khớp với biến TEXT_OUTPUT trong Makefile)
INPUT_FILE = "tb_cordic.txt"

# Hàm chuyển đổi Hex string sang Float 32-bit
def hex_to_float(hex_str):
    try:
        byte_data = bytes.fromhex(hex_str)
        return struct.unpack('>f', byte_data)[0]
    except ValueError:
        return 0.0

# Regex để tìm dòng có chứa Hex
pattern = re.compile(r"(Angle|Sin\s*|Cos\s*).*\(Hex:\s*([0-9a-fA-F]+)\)")

# Biến lưu trữ góc hiện tại
current_angle_rad = 0.0

try:
    with open(INPUT_FILE, 'r') as f:
        lines = f.readlines()
except FileNotFoundError:
    print(f"Error: File {INPUT_FILE} not found. Please run simulation first.")
    sys.exit(1)

print(f"Processing data from {INPUT_FILE}...\n")

for line in lines:
    if "==== TEST CASE" in line:
        print(f"\n{line.strip()}")
        continue
    
    match = pattern.search(line)
    if match:
        label = match.group(1).strip()
        hex_val = match.group(2)
        dec_val = hex_to_float(hex_val)
        
        # Xử lý theo từng loại label
        if label == "Angle":
            current_angle_rad = dec_val
            print(f"{label:<5}: {dec_val:.9f} (Hex: {hex_val})")
        
        elif label == "Sin":
            ideal_sin = math.sin(current_angle_rad)
            diff = abs(dec_val - ideal_sin)
            
            if abs(ideal_sin) > 1e-9:
                percent_err = (diff / abs(ideal_sin)) * 100
                err_str = f"{percent_err:.4f}%"
            else:
                err_str = "N/A (Ideal~0)"
                
            print(f"{label:<5}: {dec_val:.9f} | Ideal: {ideal_sin:.9f} | Diff: {diff:.9f} | Error: {err_str}")

        elif label == "Cos":
            ideal_cos = math.cos(current_angle_rad)
            diff = abs(dec_val - ideal_cos)
            
            if abs(ideal_cos) > 1e-9:
                percent_err = (diff / abs(ideal_cos)) * 100
                err_str = f"{percent_err:.4f}%"
            else:
                err_str = "N/A (Ideal~0)"
                
            print(f"{label:<5}: {dec_val:.9f} | Ideal: {ideal_cos:.9f} | Diff: {diff:.9f} | Error: {err_str}")
