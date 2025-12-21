import sys

# ==========================================
# CẤU HÌNH
# ==========================================
INPUT_FILE = "fft_table_2048.txt"
OUTPUT_FILE = "fft_bit_reversed_pairs.txt"
NUM_BITS = 10  # Theo yêu cầu của bạn: 10 bit (0 -> 1023)

# ==========================================
# HÀM XỬ LÝ
# ==========================================

def reverse_bits(num, width):
    """Đảo ngược thứ tự bit của một số nguyên."""
    # 1. Chuyển sang chuỗi binary (ví dụ: 1 -> '0000000001')
    binary = format(num, f'0{width}b')
    # 2. Đảo ngược chuỗi (-> '1000000000')
    reversed_binary = binary[::-1]
    # 3. Chuyển lại sang số nguyên (-> 512)
    return int(reversed_binary, 2), binary, reversed_binary

def load_data(filename):
    """Đọc file bảng dữ liệu và lưu vào dictionary {index: hex_value}"""
    data_map = {}
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
            
        print(f"Đang đọc file {filename}...")
        for line in lines:
            # Bỏ qua các dòng kẻ hoặc header
            if "|" not in line or "IDX" in line or "---" in line:
                continue
                
            parts = line.split('|')
            if len(parts) >= 4:
                try:
                    idx = int(parts[0].strip())
                    # Lấy cột Hex (cột cuối cùng)
                    hex_val = parts[3].strip()
                    data_map[idx] = hex_val
                except ValueError:
                    continue
        return data_map
    except FileNotFoundError:
        print(f"Lỗi: Không tìm thấy file '{filename}'. Hãy chắc chắn bạn đã tạo nó ở bước trước.")
        sys.exit(1)

# ==========================================
# CHƯƠNG TRÌNH CHÍNH
# ==========================================

# 1. Tải dữ liệu
data = load_data(INPUT_FILE)
total_indices = 2**NUM_BITS # 10 bit -> 1024

print(f"Tìm kiếm các cặp đảo bit cho {NUM_BITS} bit (0 -> {total_indices-1})...")

results = []

# 2. Vòng lặp tìm cặp
# Header cho file kết quả
header_str = f"{'IDX':<5} | {'Bin (Original)':<12} | {'Hex Orig':<10} <--> {'IDX Rev':<7} | {'Bin (Reversed)':<12} | {'Hex Rev':<10}"
results.append("-" * 80)
results.append(header_str)
results.append("-" * 80)

for i in range(total_indices):
    # Tính vị trí đảo bit
    rev_i, bin_orig, bin_rev = reverse_bits(i, NUM_BITS)
    
    # Lấy dữ liệu Hex từ file đã đọc (nếu có)
    hex_orig = data.get(i, "N/A")
    hex_rev  = data.get(rev_i, "N/A")
    
    # Format dòng kết quả
    # Ví dụ: 1 (00..01) <--> 512 (10..00)
    row = f"{i:<5} | {bin_orig:<12} | {hex_orig:<10} <--> {rev_i:<7} | {bin_rev:<12} | {hex_rev:<10}"
    results.append(row)

# 3. Xuất kết quả
with open(OUTPUT_FILE, 'w') as f:
    for line in results:
        f.write(line + "\n")
        # In mẫu 20 dòng đầu ra màn hình để xem trước
        if results.index(line) < 25: 
            print(line)

print("-" * 80)
print(f"Đã xuất toàn bộ danh sách cặp vào file: {OUTPUT_FILE}")
