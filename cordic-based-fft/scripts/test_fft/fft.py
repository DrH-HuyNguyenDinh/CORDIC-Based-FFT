import numpy as np
import matplotlib.pyplot as plt
import struct

# ==========================================
# 1. CẤU HÌNH TÍN HIỆU
# ==========================================
fs = 100_000            # Tần số lấy mẫu: 100 kHz
points_per_frame = 1024 # Số điểm mỗi sóng (cho 1 lần FFT 1024 điểm)
num_frames = 2          # Số lượng sóng (2 sóng)
total_points = points_per_frame * num_frames # Tổng: 2048 điểm

np.random.seed(42)      # Cố định nhiễu

# Tạo trục thời gian (0 đến ~20.48ms)
t = np.arange(total_points) / fs

# --- TẠO 2 SÓNG NỐI TIẾP (Mỗi sóng 1024 điểm) ---

# Giai đoạn 1: 0 -> 1023 (2 kHz)
t1 = t[:points_per_frame]
sig_frame1 = 1.0 * np.sin(2 * np.pi * 2_000 * t1)

# Giai đoạn 2: 1024 -> 2047 (10 kHz)
t2 = t[points_per_frame:]
sig_frame2 = 0.5 * np.sin(2 * np.pi * 10_000 * t2)

# Nối 2 sóng lại (Concatenate)
sig_clean = np.concatenate((sig_frame1, sig_frame2))

# --- THÊM NHIỄU ---
# Nhiễu giao thoa 24.6 kHz chạy xuyên suốt
interference = 0.3 * np.sin(2 * np.pi * 24_600 * t)
# Nhiễu trắng
noise = np.random.normal(0, 0.2, total_points)

# -> TÍN HIỆU TỔNG HỢP (2048 điểm)
signal = sig_clean + interference + noise

# ==========================================
# 2. XỬ LÝ VÀ GHI FILE
# ==========================================
def float_to_hex(f):
    h = hex(struct.unpack('<I', struct.pack('<f', f))[0])[2:].zfill(8)
    return h

file_name = "fft_input_2frames_1024.txt"

print(f"Đang xử lý {total_points} điểm dữ liệu (2 Frames x 1024)...")

# Ghi toàn bộ 2048 điểm vào file (Mỗi dòng 1 mã Hex)
with open(file_name, "w") as f_out:
    for i in range(total_points):
        val_hex = float_to_hex(signal[i])
        f_out.write(f"{val_hex}\n")

print(f"-> Đã ghi file hex: {file_name}")
print(f"   (Gồm 2048 dòng: 1024 dòng đầu là Wave 1, 1024 dòng sau là Wave 2)")

# ==========================================
# 3. VẼ ĐỒ THỊ KIỂM TRA
# ==========================================
# Tính FFT (Trên toàn bộ 2048 điểm để xem tổng quan phổ)
fft_values = np.fft.fft(signal)
frequencies = np.fft.fftfreq(total_points, 1/fs) / 1e3 # kHz
magnitude = np.abs(fft_values) * 2 / total_points

plt.figure(figsize=(14, 8))

# --- HÌNH 1: MIỀN THỜI GIAN ---
plt.subplot(2, 1, 1)
plt.plot(t * 1e3, signal, color='#2c3e50', linewidth=1, label='Signal Input')
# Vẽ vạch ngăn cách 2 Frame
plt.axvline(x=t[points_per_frame]*1e3, color='red', linestyle='--', linewidth=2)
plt.text(5.0, 2.5, "FRAME 1 (1024 pts)\nFreq: 2 kHz", color='green', fontweight='bold', ha='center')
plt.text(15.0, 2.5, "FRAME 2 (1024 pts)\nFreq: 10 kHz", color='green', fontweight='bold', ha='center')

plt.title(f"INPUT SIGNAL (2 FRAMES - TỔNG {total_points} ĐIỂM)")
plt.xlabel("Thời gian (ms)")
plt.ylabel("Biên độ")
plt.grid(True, alpha=0.3)

# --- HÌNH 2: MIỀN TẦN SỐ (Tổng hợp) ---
plt.subplot(2, 1, 2)
plt.plot(frequencies[:total_points//2], magnitude[:total_points//2], color='#8e44ad')
plt.title("PHỔ TẦN SỐ (Hiển thị cả 2 thành phần tần số của 2 Frame)")
plt.xlabel("Tần số (kHz)")
plt.ylabel("Biên độ")
plt.xlim(0, 50)
plt.grid(True, alpha=0.3)

# Annotate
plt.annotate('2 kHz (Frame 1)', xy=(2, 0.8), xytext=(2, 1.0), arrowprops=dict(facecolor='green', shrink=0.05))
plt.annotate('10 kHz (Frame 2)', xy=(10, 0.4), xytext=(10, 0.6), arrowprops=dict(facecolor='green', shrink=0.05))
plt.annotate('24.6 kHz (Noise)', xy=(24.6, 0.25), xytext=(25, 0.4), arrowprops=dict(facecolor='red', shrink=0.05))

plt.tight_layout()
plt.show()
