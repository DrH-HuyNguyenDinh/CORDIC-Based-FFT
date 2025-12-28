import struct
import re
import cmath

# --- CẤU HÌNH INPUT/OUTPUT ---
GOLDEN_FILE = '/home/nguyendinhhuy/rtl/cordic-based-fft/scripts/golden_data/fft_final_output.txt'
CORE_FILE = '/home/nguyendinhhuy/rtl/cordic-based-fft/sim/output_fft.txt'
REPORT_FILE = 'fft_comparison_result.txt'

TOTAL_POINTS = 2048

def hex_to_float(hex_str):
    """Chuyển chuỗi Hex 32-bit (Big Endian) sang Float."""
    try:
        clean_hex = hex_str.strip()
        if not clean_hex or 'x' in clean_hex.lower():
            return 0.0
        return struct.unpack('!f', bytes.fromhex(clean_hex))[0]
    except:
        return 0.0

def read_golden_data(filename):
    """Đọc file Golden: Tự động đếm dòng để xử lý việc Index reset."""
    data = [0j] * TOTAL_POINTS
    counter = 0 # Biến đếm tự tăng, không phụ thuộc vào cột Idx trong file
    
    print(f"[INFO] Đang đọc Golden File: {filename}")
    
    try:
        with open(filename, 'r') as f:
            for line in f:
                line = line.strip()
                # Bỏ qua dòng trống, dòng kẻ ngang, dòng tiêu đề cột
                if not line or line.startswith('-') or line.startswith('Idx') or line.startswith('='):
                    continue
                
                # Nếu gặp dòng SIGNAL header (vd: "SIGNAL 2 FINAL OUTPUT"), bỏ qua
                if "SIGNAL" in line:
                    continue

                parts = [p.strip() for p in line.split('|')]
                
                # Format mong đợi: Idx | Hex(Re) | Re | Hex(Im) | Im
                if len(parts) >= 5:
                    try:
                        # Chỉ lấy dữ liệu Hex để convert cho chính xác
                        re_hex = parts[1]
                        im_hex = parts[3]
                        
                        val = complex(hex_to_float(re_hex), hex_to_float(im_hex))
                        
                        if counter < TOTAL_POINTS:
                            data[counter] = val
                            counter += 1
                        else:
                            # Nếu file dài hơn 2048 dòng, dừng lại
                            break
                    except ValueError:
                        continue
                        
    except FileNotFoundError:
        print(f"[ERROR] Không tìm thấy file Golden: {filename}")
        
    print(f"[INFO] Golden Data: Đã nạp {counter}/{TOTAL_POINTS} điểm.")
    return data

def read_core_data(filename):
    """Đọc file Core Output."""
    data_buffer = [0j] * TOTAL_POINTS
    
    # Regex bắt dòng: Pair <k> | A_Re: ...
    pattern = re.compile(r"Pair\s+(\d+)\s+\|\s+A_Re:\s+([0-9a-fA-F]+)\s+\|\s+B_Re:\s+([0-9a-fA-F]+)\s+\|\s+\(Imag\s+A:\s+([0-9a-fA-F]+),\s+B:\s+([0-9a-fA-F]+)\)")
    
    pairs_found = 0
    
    try:
        with open(filename, 'r') as f:
            for line in f:
                match = pattern.search(line)
                if match:
                    pair_idx = int(match.group(1))
                    
                    val_a = complex(hex_to_float(match.group(2)), hex_to_float(match.group(4)))
                    val_b = complex(hex_to_float(match.group(3)), hex_to_float(match.group(5)))

                    # Logic Mapping (Giả định index Pair chạy liên tục 0 -> 1023 trong simulation)
                    frame_idx = pair_idx // 512
                    offset = pair_idx % 512
                    
                    global_idx_a = (frame_idx * 1024) + offset
                    global_idx_b = global_idx_a + 512
                    
                    if global_idx_a < TOTAL_POINTS:
                        data_buffer[global_idx_a] = val_a
                    if global_idx_b < TOTAL_POINTS:
                        data_buffer[global_idx_b] = val_b
                        
                    pairs_found += 1
                    
    except FileNotFoundError:
        print(f"[ERROR] Không tìm thấy Core File: {filename}")

    print(f"[INFO] Core Data: Tìm thấy {pairs_found} cặp -> {pairs_found*2} điểm.")
    return data_buffer

def compare_signals():
    gold = read_golden_data(GOLDEN_FILE)
    core = read_core_data(CORE_FILE)

    # Header cho file text output
    # Thêm cột 'Note' để dễ debug dòng nào bị lỗi lớn
    header = f"{'Idx':<6} | {'Gold_Re':<12} | {'Gold_Im':<12} | {'Core_Re':<12} | {'Core_Im':<12} | {'Diff':<12} | {'Err(%)':<10} | {'Note'}"
    separator = "-" * len(header)
    
    lines = [header, separator]

    total_error = 0
    valid_points_count = 0
    max_error = 0

    for i in range(TOTAL_POINTS):
        g = gold[i]
        c = core[i]
        
        note = ""
        err_pct = 0.0
        diff = 0.0

        # Kiểm tra dữ liệu rỗng/thiếu
        is_gold_zero = (g == 0j)
        is_core_zero = (c == 0j)

        if is_gold_zero and is_core_zero:
            note = "PAD/ZERO"
        elif is_gold_zero and not is_core_zero:
             diff = abs(c)
             err_pct = 100.0
             note = "GOLD_MISS" # Golden = 0 mà Core có data
        elif not is_gold_zero and is_core_zero:
             diff = abs(g)
             err_pct = 100.0
             note = "CORE_MISS" # Core = 0 mà Golden có data
        else:
            # So sánh chính
            diff = abs(g - c)
            mag_g = abs(g)
            
            if mag_g > 1e-9: # Ngưỡng nhỏ để tránh chia cho 0
                err_pct = (diff / mag_g) * 100.0
            else:
                err_pct = 0.0 if diff < 1e-9 else 100.0
            
            total_error += err_pct
            max_error = max(max_error, err_pct)
            valid_points_count += 1
            
            if err_pct > 10.0: # Đánh dấu các dòng sai số > 10%
                note = "HIGH_ERR"

        # Format dòng output
        line = f"{i:<6} | {g.real:<12.5f} | {g.imag:<12.5f} | {c.real:<12.5f} | {c.imag:<12.5f} | {diff:<12.5f} | {err_pct:<10.2f} | {note}"
        lines.append(line)

    # Xuất file
    with open(REPORT_FILE, 'w') as f:
        f.write('\n'.join(lines))

    # Tính toán thống kê
    avg_error = total_error / valid_points_count if valid_points_count > 0 else 0.0

    print(f"\n--- KẾT QUẢ SO SÁNH (2048 ĐIỂM) ---")
    print(f"File báo cáo: {REPORT_FILE}")
    print(f"Số điểm hợp lệ (Valid Points): {valid_points_count}/{TOTAL_POINTS}")
    print(f"Sai số trung bình: {avg_error:.4f}%")
    print(f"Sai số lớn nhất: {max_error:.4f}%")
    
    if valid_points_count < TOTAL_POINTS:
        print("[LƯU Ý] Có điểm dữ liệu bị thiếu (CORE_MISS hoặc GOLD_MISS). Xem cột Note trong file báo cáo.")

if __name__ == "__main__":
    compare_signals()
