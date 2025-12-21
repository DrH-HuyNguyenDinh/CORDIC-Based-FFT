import re
import sys

# ==========================================
# CẤU HÌNH ĐƯỜNG DẪN FILE
# ==========================================
# File chuẩn (Golden Reference) do Python tạo ra
GOLDEN_FILE = "/home/nguyendinhhuy/rtl/cordic-based-fft/scripts/test_fft/fft_bit_reversed_pairs.txt"

# File output thực tế từ mô phỏng Verilog
VERILOG_OUTPUT_FILE = "/home/nguyendinhhuy/rtl/cordic-based-fft/sim/output_input_reordering.txt"

# ==========================================
# HÀM XỬ LÝ
# ==========================================

def load_golden_data(filename):
    """Đọc file chuẩn và lấy danh sách các giá trị Hex đảo bit mong muốn."""
    hex_values = []
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
            
        print(f"Loading Golden Data from: {filename}")
        for line in lines:
            # Bỏ qua dòng tiêu đề và dòng phân cách
            if "|" not in line or "IDX" in line or "---" in line:
                continue
            
            # Cấu trúc dòng: IDX | Bin Orig | Hex Orig <--> IDX Rev | Bin Rev | Hex Rev
            # Ta cần lấy cột cuối cùng (Hex Rev)
            parts = line.split('|')
            if len(parts) >= 5:
                hex_val = parts[-1].strip() # Lấy cột cuối cùng
                if hex_val:
                    hex_values.append(hex_val.lower()) # Chuyển về chữ thường để so sánh
                    
        print(f"-> Loaded {len(hex_values)} golden values.")
        return hex_values
        
    except FileNotFoundError:
        print(f"Error: Could not find golden file '{filename}'")
        sys.exit(1)

def load_verilog_output(filename):
    """Đọc file log mô phỏng và lấy các giá trị Output Data."""
    hex_values = []
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
            
        print(f"Loading Verilog Output from: {filename}")
        for line in lines:
            # Tìm dòng chứa "Output Data: XXXXXXXX"
            if "Output Data:" in line:
                # Tách lấy phần hex phía sau
                parts = line.split("Output Data:")
                if len(parts) > 1:
                    hex_val = parts[1].strip()
                    hex_values.append(hex_val.lower())
                    
        print(f"-> Loaded {len(hex_values)} verilog output values.")
        return hex_values
        
    except FileNotFoundError:
        print(f"Error: Could not find verilog output file '{filename}'")
        sys.exit(1)

# ==========================================
# MAIN CHECKER
# ==========================================

def main():
    print("========================================================")
    print("       CHECKING INPUT REORDERING RESULT")
    print("========================================================")
    
    golden_data = load_golden_data(GOLDEN_FILE)
    verilog_data = load_verilog_output(VERILOG_OUTPUT_FILE)
    
    # Kiểm tra số lượng mẫu
    if len(verilog_data) == 0:
        print("\nERROR: No data found in Verilog output file!")
        return

    # Nếu số lượng mẫu khác nhau, cảnh báo nhưng vẫn so sánh phần chung
    min_len = min(len(golden_data), len(verilog_data))
    if len(golden_data) != len(verilog_data):
        print(f"\nWARNING: Data length mismatch!")
        print(f"  Golden:  {len(golden_data)} items")
        print(f"  Verilog: {len(verilog_data)} items")
        print(f"  -> Comparing first {min_len} items only...\n")
    
    # Bắt đầu so sánh
    error_count = 0
    print("-" * 60)
    print(f"{'INDEX':<8} | {'GOLDEN':<15} | {'VERILOG':<15} | {'STATUS'}")
    print("-" * 60)
    
    for i in range(min_len):
        g_val = golden_data[i]
        v_val = verilog_data[i]
        
        if g_val == v_val:
            status = "PASS"
        else:
            status = "FAIL <--"
            error_count += 1
            
        # In kết quả (chỉ in lỗi hoặc 10 dòng đầu để check)
        if status == "FAIL <--" or i < 10:
            print(f"{i:<8} | {g_val:<15} | {v_val:<15} | {status}")
            
    print("-" * 60)
    
    # Kết luận
    if error_count == 0:
        print(f"\nSUCCESS: All {min_len} checked values MATCHED! ✅")
        if len(golden_data) != len(verilog_data):
             print("(Note: Lengths were different, but overlapping part is correct)")
    else:
        print(f"\nFAILED: Found {error_count} mismatches! ❌")

if __name__ == "__main__":
    main()
