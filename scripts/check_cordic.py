import struct
import re
import math
import sys
import os

# ==========================================
#               CẤU HÌNH KIỂM TRA
# ==========================================
DEFAULT_INPUT_FILE = "tb_cordic.txt"

# Ngưỡng sai số cho phép (%): Ví dụ 0.1%
# Nếu sai số nhỏ hơn mức này -> PASS
MAX_PERCENT_ERROR = 0.5 

# Ngưỡng xử lý số gần 0 (Absolute Tolerance)
# Khi giá trị lý thuyết < 1e-6, ta không tính % mà tính sai số tuyệt đối
ZERO_THRESHOLD = 1e-6 
ABS_TOLERANCE  = 1e-4 

# ==========================================

# --- XỬ LÝ THAM SỐ DÒNG LỆNH ---
if len(sys.argv) > 1:
    INPUT_FILE = sys.argv[1]
else:
    print(f"Warning: No input file provided. Using default: {DEFAULT_INPUT_FILE}")
    INPUT_FILE = DEFAULT_INPUT_FILE

# --- HÀM HỖ TRỢ ---
def hex_to_float(hex_str):
    try:
        byte_data = bytes.fromhex(hex_str)
        return struct.unpack('>f', byte_data)[0]
    except ValueError:
        return 0.0

# Regex tìm dữ liệu
pattern = re.compile(r"(Angle|Sin\s*|Cos\s*).*\(Hex:\s*([0-9a-fA-F]+)\)")

# Biến toàn cục
current_angle_rad = 0.0
total_checks = 0
total_pass = 0
max_error_seen = 0.0

print(f"----------------------------------------------------------------")
print(f" LOG CHECKER: PERCENTAGE ERROR TEST")
print(f" File: {INPUT_FILE}")
print(f" Max Allowed Error: {MAX_PERCENT_ERROR}%")
print(f"----------------------------------------------------------------\n")

try:
    with open(INPUT_FILE, 'r') as f:
        lines = f.readlines()
except FileNotFoundError:
    print(f"Error: File '{INPUT_FILE}' not found.")
    sys.exit(1)

found_data = False

for line in lines:
    if "==== TEST CASE" in line:
        print(f"\n{'-'*20} {line.strip()} {'-'*20}")
        continue

    match = pattern.search(line)
    if match:
        found_data = True
        label = match.group(1).strip()
        hex_val = match.group(2)
        dec_val = hex_to_float(hex_val)

        # --- 1. Xử lý Angle (Chỉ lưu lại, không check lỗi) ---
        if label == "Angle":
            current_angle_rad = dec_val
            deg = math.degrees(current_angle_rad)
            print(f"Angle: {dec_val:.6f} rad (~{deg:.1f} deg)")

        # --- 2. Xử lý Sin/Cos (Tính toán sai số) ---
        elif label in ["Sin", "Cos"]:
            total_checks += 1
            
            # Tính giá trị lý thuyết (Ideal)
            if label == "Sin":
                ideal = math.sin(current_angle_rad)
            else:
                ideal = math.cos(current_angle_rad)

            # Tính chênh lệch tuyệt đối
            diff = abs(dec_val - ideal)
            
            status = ""
            error_msg = ""
            current_pct_err = 0.0

            # --- LOGIC KIỂM TRA SAI SỐ ---
            
            # Trường hợp 1: Giá trị lý thuyết quá nhỏ (gần bằng 0)
            # Không thể tính % (chia cho 0), nên dùng sai số tuyệt đối
            if abs(ideal) < ZERO_THRESHOLD:
                if diff < ABS_TOLERANCE:
                    status = "[PASS]"
                    error_msg = f"Abs Diff: {diff:.6f} (Target < {ABS_TOLERANCE})"
                else:
                    status = "[FAIL]"
                    error_msg = f"Abs Diff: {diff:.6f} (Too High!)"
            
            # Trường hợp 2: Giá trị bình thường -> Tính % sai số
            else:
                current_pct_err = (diff / abs(ideal)) * 100.0
                
                # Cập nhật sai số lớn nhất từng thấy
                if current_pct_err > max_error_seen:
                    max_error_seen = current_pct_err

                if current_pct_err <= MAX_PERCENT_ERROR:
                    status = "[PASS]"
                else:
                    status = "[FAIL]"
                
                error_msg = f"Err: {current_pct_err:.4f}%"

            if status == "[PASS]":
                total_pass += 1

            # In kết quả
            # Format: Label | Measured | Ideal | Status | Error Info
            print(f"{label:<5}: {dec_val:10.6f} | Ideal: {ideal:10.6f} | {status} | {error_msg}")

if not found_data:
    print("\nWARNING: No data found. Check Verilog log format.")
else:
    print(f"\n================================================================")
    print(f" SUMMARY REPORT")
    print(f"================================================================")
    print(f" Total Checks : {total_checks}")
    print(f" Passed       : {total_pass}")
    print(f" Failed       : {total_checks - total_pass}")
    print(f" Max % Error  : {max_error_seen:.5f}%")
    print(f"================================================================")
    
    if (total_checks - total_pass) > 0:
        print("RESULT: FAILED ❌")
        sys.exit(1) # Trả về exit code 1 để Makefile biết là lỗi
    else:
        print("RESULT: SUCCESS ✅")
        sys.exit(0)
