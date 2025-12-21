`timescale 1ns/1ps

module tb_fft;

    // --- Signals Inputs ---
    logic i_clk = 0;
    logic i_reset = 0;
    logic i_valid_in = 0;
    logic [31:0] i_data_real = 0;
    logic [31:0] i_data_imag = 0;

    // --- Signals Outputs ---
    logic o_valid_out;
    logic [31:0] o_data_a_real, o_data_a_imag;
    logic [31:0] o_data_b_real, o_data_b_imag;

    // [CẤU HÌNH]: Bộ nhớ chứa đủ 2 Frames (2048 mẫu)
    logic [31:0] raw_data_mem [0:2047];

    // =========================================================
    // Clock 50MHz (Period = 20 ns)
    // =========================================================
    always #10 i_clk = ~i_clk;

    // Instantiate DUT
    fft dut (.*);

    // =========================================================
    // 1. Khối Driver: Nạp đủ 2 Frames (2048 mẫu)
    // =========================================================
    initial begin
        // Đọc file input
        $readmemh("/home/nguyendinhhuy/rtl/cordic-based-fft/scripts/test_fft/fft_input_2frames_1024.txt", raw_data_mem);

        // Dump sóng
        $dumpfile("fft_wave_2frames.vcd");
        $dumpvars(0, tb_fft);

        // Reset hệ thống
        i_reset = 0;
        #50 i_reset = 1;
        @(posedge i_clk);

        // Nạp đủ 2048 mẫu (2 Frames liên tục)
        $display("--- [Time %0t] Start Feeding 2048 Samples (2 Frames) at 50MHz ---", $time);
        
        for (int j = 0; j < 2048; j++) begin
            @(posedge i_clk);
            i_valid_in  <= 1;
            i_data_real <= raw_data_mem[j];
            i_data_imag <= 32'h0;
            
            if (j == 0)    $display("--- [INFO] Inputting Frame 1 (0-1023) ---");
            if (j == 1024) $display("--- [INFO] Inputting Frame 2 (1024-2047) ---");
        end

        // Ngừng nạp dữ liệu chính
        i_valid_in <= 0;

        // Nạp Dummy Data để đẩy kết quả ra (Flush Pipeline)
        $display("--- [Time %0t] Feeding Dummy Data to Flush Pipeline ---", $time);
        for (int k = 0; k < 128; k++) begin 
            @(posedge i_clk);
            i_valid_in  <= 1; 
            i_data_real <= 0;
            i_data_imag <= 0;
        end
        i_valid_in <= 0; 

        // Timeout an toàn
        #1000000; 
        $display("--- [TIMEOUT] Simulation stop because output took too long! ---");
        $finish;
    end

    // =========================================================
    // 2. Khối Monitor: Nhận đủ 1024 cặp (2 Frames)
    // =========================================================
    int pair_cnt = 0;

    always @(posedge i_clk) begin
        if (o_valid_out) begin
            
            // In kết quả ra màn hình
            $display("[%0t ns] Pair %0d | A_Re: %h | B_Re: %h | (Imag A: %h, B: %h)",
                     $time, pair_cnt,
                     o_data_a_real, o_data_b_real,
                     o_data_a_imag, o_data_b_imag);

            // Tăng biến đếm
            pair_cnt++;

            // [THÊM] Thông báo khi xong Frame 1 (512 cặp đầu tiên)
            if (pair_cnt == 512) begin
                $display("---------------------------------------------------------------");
                $display("--- [INFO] Finished receiving Frame 1 (512 pairs)           ---");
                $display("---        Continuing to Frame 2...                         ---");
                $display("---------------------------------------------------------------");
            end

            // [SỬA] Dừng khi nhận đủ 2 Frames (1024 cặp)
            if (pair_cnt == 1024) begin
                $display("---------------------------------------------------------------");
                $display("--- [SUCCESS] Received 1024 pairs (Frame 1 & 2 Output Done) ---");
                $display("---           Simulation Stopped as Requested.              ---");
                $display("---------------------------------------------------------------");
                $finish; 
            end
        end
    end

endmodule
