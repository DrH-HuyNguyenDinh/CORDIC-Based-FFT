import re
import struct
import numpy as np
import matplotlib.pyplot as plt

# ==========================================
# 1. CẤU HÌNH
# ==========================================
INPUT_FILE = "/home/nguyendinhhuy/rtl/cordic-based-fft/sim/output_fft.txt"
FS = 100_000                   # 100 kHz
N_FFT = 1024                   # 1024 điểm/frame
PAIRS_PER_FRAME = 512          # 512 cặp/frame

# ==========================================
# 2. HÀM HỖ TRỢ
# ==========================================
def hex_to_float(hex_str):
    try:
        clean_hex = hex_str.strip().lower().replace("32'h", "").replace("0x", "").replace("_", "")
        if len(clean_hex) != 8: return 0.0
        return struct.unpack('!f', bytes.fromhex(clean_hex))[0]
    except Exception: return 0.0

def load_fft_data_continuous(filename):
    data_buffer = [] 
    regex = r"Pair\s+(\d+).*A_Re:\s*([0-9a-fA-F]+).*B_Re:\s*([0-9a-fA-F]+).*Imag A:\s*([0-9a-fA-F]+).*B:\s*([0-9a-fA-F]+)"
    current_frame = np.zeros(N_FFT, dtype=complex)
    pair_count_global = 0
    
    try:
        with open(filename, 'r') as f:
            for line in f:
                match = re.search(regex, line)
                if match:
                    a_re = hex_to_float(match.group(2))
                    b_re = hex_to_float(match.group(3))
                    a_im = hex_to_float(match.group(4))
                    b_im = hex_to_float(match.group(5))
                    
                    local_pair_idx = pair_count_global % PAIRS_PER_FRAME
                    current_frame[local_pair_idx] = complex(a_re, a_im)
                    current_frame[local_pair_idx + 512] = complex(b_re, b_im)
                    
                    pair_count_global += 1
                    
                    if pair_count_global % PAIRS_PER_FRAME == 0:
                        data_buffer.extend(current_frame)
                        current_frame = np.zeros(N_FFT, dtype=complex)
                        
        print(f"-> Đã đọc {pair_count_global} cặp.")
        return np.array(data_buffer)
    except FileNotFoundError: return None

def analyze_and_plot_peaks(data):
    # Tính biên độ
    magnitude = np.abs(data) / N_FFT * 2
    
    # Tạo trục X tùy chỉnh để hiển thị Tần số
    indices = np.arange(len(data))
    
    plt.figure(figsize=(14, 7))
    plt.plot(indices, magnitude, color='#2c3e50', linewidth=1.2, label="Biên độ FFT")
    
    # --- TỰ ĐỘNG DÒ TÌM VÀ CHÚ THÍCH CÁC ĐỈNH CAO ---
    # Độ phân giải tần số
    df = FS / N_FFT # ~97.6 Hz
    
    # Tìm giá trị lớn nhất trong toàn bộ dữ liệu để đặt ngưỡng tương đối
    global_max = np.max(magnitude)
    threshold = global_max * 0.3  # Chỉ xét các đỉnh cao > 30% đỉnh lớn nhất toàn cục
                                  # Bạn có thể chỉnh số 0.3 này tùy theo độ nhiễu
    
    print("\n=== KẾT QUẢ PHÂN TÍCH ĐỈNH TÍN HIỆU ===")
    
    # Duyệt qua từng điểm dữ liệu (trừ điểm đầu và cuối)
    for i in range(1, len(magnitude)-1):
        # Điều kiện là đỉnh cục bộ (lớn hơn 2 điểm bên cạnh) VÀ vượt ngưỡng threshold
        if magnitude[i] > threshold and magnitude[i] > magnitude[i-1] and magnitude[i] > magnitude[i+1]:
            
            # Xác định Index i thuộc Frame nào và Index cục bộ trong Frame đó
            frame_idx = i // N_FFT
            local_idx = i % N_FFT
            
            # Chỉ quan tâm nửa đầu của mỗi Frame (0 - N_FFT/2) vì nửa sau là tần số âm (gương)
            if local_idx < N_FFT / 2:
                # Tính tần số
                freq_hz = local_idx * df
                freq_khz = freq_hz / 1000
                
                # In ra console
                print(f"-> Phát hiện đỉnh tại Index {i} (Frame {frame_idx+1}): {freq_khz:.2f} kHz (Biên độ: {magnitude[i]:.4f})")
                
                # Vẽ chú thích lên đồ thị
                plt.annotate(f"{freq_khz:.2f} kHz", 
                             xy=(i, magnitude[i]), 
                             xytext=(i, magnitude[i] + global_max*0.1),
                             arrowprops=dict(facecolor='red', shrink=0.05),
                             ha='center', fontsize=9, fontweight='bold', color='red')

    # --- TRANG TRÍ ---
    plt.title(f"PHÂN TÍCH TỰ ĐỘNG CÁC ĐỈNH TÍN HIỆU (Fs={FS/1000} kHz)", fontsize=14)
    plt.ylabel("Biên độ", fontsize=12)
    plt.xlabel("Index (0-1023: Frame 1 | 1024-2047: Frame 2)", fontsize=12)
    
    # Kẻ vạch phân chia Frame
    for i in range(N_FFT, len(data), N_FFT):
        plt.axvline(x=i, color='green', linestyle='--', alpha=0.6)
        plt.text(i, global_max, f" FRAME BOUNDARY ", color='green', ha='center', va='bottom', backgroundcolor='white')
    
    plt.grid(True, alpha=0.3)
    plt.xlim(0, len(data))
    
    plt.tight_layout()
    plt.savefig("fft_peaks_analysis.png")
    print(f"\n-> Đã lưu biểu đồ phân tích vào 'fft_peaks_analysis.png'")
    plt.show()

# ==========================================
# 3. MAIN
# ==========================================
if __name__ == "__main__":
    data = load_fft_data_continuous(INPUT_FILE)
    if data is not None:
        analyze_and_plot_peaks(data)
