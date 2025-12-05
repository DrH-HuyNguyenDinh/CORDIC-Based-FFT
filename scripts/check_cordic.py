import struct
import re
import math
import sys
import os

# --- CẤU HÌNH ---
DEFAULT_INPUT_FILE = "tb_cordic.txt"

# --- XỬ LÝ THAM SỐ DÒNG LỆNH ---
# Makefile sẽ truyền tên file log vào đây (sys.argv[1])
if len(sys.argv) > 1:
    INPUT_FILE = sys.argv[1]
else:
    print(f"Warning: No input file provided. Using default: {DEFAULT_INPUT_FILE}")
    INPUT_FILE = DEFAULT_INPUT_FILE

# --- HÀM HỖ TRỢ ---
# Hàm chuyển đổi Hex string sang Float 32-bit
def hex_to_float(hex_str):
    try:
        byte_data = bytes.fromhex(hex_str)
        return struct.unpack('>f', byte_data)[0]
    except ValueError:
        return 0.0

# Regex để tìm dòng có chứa Hex
# Cần Verilog output dạng: "Label: ... (Hex: 3f800000)"
pattern = re.compile(r"(Angle|Sin\s*|Cos\s*).*\(Hex:\s*([0-9a-fA-F]+)\)")

# Biến lưu trữ góc hiện tại
current_angle_rad = 0.0

print(f"Processing data from: {INPUT_FILE}")
print(f"Current Directory   : {os.getcwd()}\n")

try:
    with open(INPUT_FILE, 'r') as f:
        lines = f.readlines()
except FileNotFoundError:
    print(f"Error: File '{INPUT_FILE}' not found.")
    print(f"Make sure you ran the simulation first (make run).")
    sys.exit(1)

# Biến cờ để kiểm tra xem có tìm thấy dữ liệu không
found_data = False

for line in lines:
    if "==== TEST CASE" in line:
        print(f"\n{line.strip()}")
        continue

    match = pattern.search(line)
    if match:
        found_data = True
        label = match.group(1).strip()
        hex_val = match.group(2)
        dec_val = hex_to_float(hex_val)

        # Xử lý theo từng loại label
        if label == "Angle":
            current_angle_rad = dec_val
            print(f"{label:<5}: {dec_val:.6f} (Hex: {hex_val})")

        elif label == "Sin":
            ideal_sin = math.sin(current_angle_rad)
            diff = abs(dec_val - ideal_sin)

            if abs(ideal_sin) > 1e-9:
                percent_err = (diff / abs(ideal_sin)) * 100
                err_str = f"{percent_err:.4f}%"
            else:
                # Nếu giá trị lý thuyết gần bằng 0
                if diff < 1e-5:
                    err_str = "OK (Ideal~0)"
                else:
                    err_str = "FAIL (Should be 0)"

            print(f"{label:<5}: {dec_val:.6f} | Ideal: {ideal_sin:.6f} | Diff: {diff:.6f} | Error: {err_str}")

        elif label == "Cos":
            ideal_cos = math.cos(current_angle_rad)
            diff = abs(dec_val - ideal_cos)

            if abs(ideal_cos) > 1e-9:
                percent_err = (diff / abs(ideal_cos)) * 100
                err_str = f"{percent_err:.4f}%"
            else:
                if diff < 1e-5:
                    err_str = "OK (Ideal~0)"
                else:
                    err_str = "FAIL (Should be 0)"

            print(f"{label:<5}: {dec_val:.6f} | Ideal: {ideal_cos:.6f} | Diff: {diff:.6f} | Error: {err_str}")

if not found_data:
    print("\nWARNING: No matching data found in log file.")
    print("Please check your Verilog $display format.")
    print("Expected format example: 'Angle: 0.785 (Hex: 3f490fdb)'")
