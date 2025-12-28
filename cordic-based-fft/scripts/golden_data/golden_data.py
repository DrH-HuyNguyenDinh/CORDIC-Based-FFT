import math
import struct
import cmath
import os

# --- CẤU HÌNH ---
INPUT_FILE = '/home/nguyendinhhuy/rtl/cordic-based-fft/scripts/test_fft/fft_input_2frames_1024.txt'
OUTPUT_FILE = 'fft_final_output.txt' # Tên file kết quả

def hex_to_float(hex_str):
    """Chuyển Hex string sang Float."""
    try:
        clean_hex = hex_str.strip().split()[-1]
        return struct.unpack('!f', bytes.fromhex(clean_hex))[0]
    except Exception:
        return 0.0

def float_to_hex(f_val):
    """Chuyển Float sang Hex string (32-bit)."""
    try:
        return struct.pack('!f', f_val).hex()
    except OverflowError:
        return "ffffffff"

def bit_reverse_copy(arr, n):
    """Sắp xếp đảo bit đầu vào."""
    result = [0] * n
    num_bits = int(math.log2(n))
    for i in range(n):
        rev_i = 0
        temp = i
        for _ in range(num_bits):
            rev_i = (rev_i << 1) | (temp & 1)
            temp >>= 1
        result[rev_i] = arr[i]
    return result

def calculate_fft(signal_data):
    """Thực hiện FFT và trả về kết quả cuối cùng."""
    N = len(signal_data)
    num_stages = int(math.log2(N))
    
    # 1. Bit Reversal (Input)
    A = [complex(x, 0.0) for x in bit_reverse_copy(signal_data, N)]
    
    # 2. Butterfly Loop (10 Stages)
    for stage in range(1, num_stages + 1):
        m = 1 << stage
        half_m = m >> 1
        omega_m = cmath.exp(-2j * math.pi / m) # Twiddle Factor
        
        for k in range(0, N, m):
            omega = 1.0 + 0j
            for j in range(k, k + half_m):
                t = omega * A[j + half_m]
                u = A[j]
                A[j] = u + t
                A[j + half_m] = u - t
                omega *= omega_m
    return A

def main():
    if not os.path.exists(INPUT_FILE):
        print(f"Lỗi: Không tìm thấy file {INPUT_FILE}")
        return

    # Đọc dữ liệu
    raw_data = []
    with open(INPUT_FILE, 'r') as f:
        for line in f:
            if line.strip():
                raw_data.append(hex_to_float(line))

    FFT_SIZE = 1024
    num_signals = len(raw_data) // FFT_SIZE

    print(f"Đã đọc {len(raw_data)} điểm. Tìm thấy {num_signals} frame(s).")

    # Tính toán và Ghi file
    with open(OUTPUT_FILE, 'w') as f_out:
        for s in range(num_signals):
            print(f"Processing Signal {s+1}...")
            
            # Lấy data frame hiện tại
            chunk = raw_data[s*FFT_SIZE : (s+1)*FFT_SIZE]
            
            # Tính FFT
            result = calculate_fft(chunk)
            
            # Ghi header
            f_out.write(f"\n{'='*30} SIGNAL {s+1} FINAL OUTPUT {'='*30}\n")
            f_out.write(f"{'Idx':<4} | {'Hex(Real)':<10} | {'Real (Float)':<12} | {'Hex(Imag)':<10} | {'Imag (Float)':<12}\n")
            f_out.write("-" * 60 + "\n")
            
            # Ghi kết quả từng dòng
            for i, val in enumerate(result):
                h_re = float_to_hex(val.real)
                h_im = float_to_hex(val.imag)
                f_out.write(f"{i:<4} | {h_re:<10} | {val.real:<12.5f} | {h_im:<10} | {val.imag:<12.5f}\n")

    print(f"Hoàn tất! Kết quả đã lưu vào: {os.path.abspath(OUTPUT_FILE)}")

if __name__ == "__main__":
    main()
