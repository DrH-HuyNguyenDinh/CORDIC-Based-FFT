module fft (
    input logic         i_clk, i_reset,
    input logic         i_valid_in,
    input logic  [31:0] i_data_real,
    input logic  [31:0] i_data_imag,

    output logic        o_valid_out,
    output logic [31:0] o_data_a_real, o_data_a_imag,
    output logic [31:0] o_data_b_real, o_data_b_imag
);

// =========================================================
// 1. SIGNAL DECLARATION
// =========================================================

// --- Link 1: Reordering -> Stage 1 ---
logic        w_valid_s0_s1, r_valid_s0_s1;
logic [31:0] w_data_real_s0_s1, w_data_imag_s0_s1;
logic [31:0] r_data_real_s0_s1, r_data_imag_s0_s1;

// --- Link 2: Stage 1 -> Stage 2 ---
logic        w_valid_s1_s2, r_valid_s1_s2;
logic [31:0] w_a_real_s1_s2, w_a_imag_s1_s2, w_b_real_s1_s2, w_b_imag_s1_s2;
logic [31:0] r_a_real_s1_s2, r_a_imag_s1_s2, r_b_real_s1_s2, r_b_imag_s1_s2;

// --- Link 3: Stage 2 -> Stage 3 ---
logic        w_valid_s2_s3, r_valid_s2_s3;
logic [31:0] w_a_real_s2_s3, w_a_imag_s2_s3, w_b_real_s2_s3, w_b_imag_s2_s3;
logic [31:0] r_a_real_s2_s3, r_a_imag_s2_s3, r_b_real_s2_s3, r_b_imag_s2_s3;

// --- Link 4: Stage 3 -> Stage 4 ---
logic        w_valid_s3_s4, r_valid_s3_s4;
logic [31:0] w_a_real_s3_s4, w_a_imag_s3_s4, w_b_real_s3_s4, w_b_imag_s3_s4;
logic [31:0] r_a_real_s3_s4, r_a_imag_s3_s4, r_b_real_s3_s4, r_b_imag_s3_s4;

// --- Link 5: Stage 4 -> Stage 5 ---
logic        w_valid_s4_s5, r_valid_s4_s5;
logic [31:0] w_a_real_s4_s5, w_a_imag_s4_s5, w_b_real_s4_s5, w_b_imag_s4_s5;
logic [31:0] r_a_real_s4_s5, r_a_imag_s4_s5, r_b_real_s4_s5, r_b_imag_s4_s5;

// --- Link 6: Stage 5 -> Stage 6 ---
logic        w_valid_s5_s6, r_valid_s5_s6;
logic [31:0] w_a_real_s5_s6, w_a_imag_s5_s6, w_b_real_s5_s6, w_b_imag_s5_s6;
logic [31:0] r_a_real_s5_s6, r_a_imag_s5_s6, r_b_real_s5_s6, r_b_imag_s5_s6;

// --- Link 7: Stage 6 -> Stage 7 ---
logic        w_valid_s6_s7, r_valid_s6_s7;
logic [31:0] w_a_real_s6_s7, w_a_imag_s6_s7, w_b_real_s6_s7, w_b_imag_s6_s7;
logic [31:0] r_a_real_s6_s7, r_a_imag_s6_s7, r_b_real_s6_s7, r_b_imag_s6_s7;

// --- Link 8: Stage 7 -> Stage 8 ---
logic        w_valid_s7_s8, r_valid_s7_s8;
logic [31:0] w_a_real_s7_s8, w_a_imag_s7_s8, w_b_real_s7_s8, w_b_imag_s7_s8;
logic [31:0] r_a_real_s7_s8, r_a_imag_s7_s8, r_b_real_s7_s8, r_b_imag_s7_s8;

// --- Link 9: Stage 8 -> Stage 9 ---
logic        w_valid_s8_s9, r_valid_s8_s9;
logic [31:0] w_a_real_s8_s9, w_a_imag_s8_s9, w_b_real_s8_s9, w_b_imag_s8_s9;
logic [31:0] r_a_real_s8_s9, r_a_imag_s8_s9, r_b_real_s8_s9, r_b_imag_s8_s9;

// --- Link 10: Stage 9 -> Stage 10 ---
logic        w_valid_s9_s10, r_valid_s9_s10;
logic [31:0] w_a_real_s9_s10, w_a_imag_s9_s10, w_b_real_s9_s10, w_b_imag_s9_s10;
logic [31:0] r_a_real_s9_s10, r_a_imag_s9_s10, r_b_real_s9_s10, r_b_imag_s9_s10;

// --- Link 11: Stage 10 -> Output ---
logic        w_valid_s10_out;
logic [31:0] w_a_real_s10_out, w_a_imag_s10_out, w_b_real_s10_out, w_b_imag_s10_out;


// =========================================================
// 2. LOGIC & INSTANTIATION
// =========================================================

// STEP A: INPUT REORDERING
input_reordering u_reorder (
    .i_clk(i_clk), .i_reset(i_reset),
    .i_valid_in(i_valid_in), .i_data_real(i_data_real), .i_data_imag(i_data_imag),
    .o_valid_out(w_valid_s0_s1), .o_data_real(w_data_real_s0_s1), .o_data_imag(w_data_imag_s0_s1)
);

// PIPELINE 1
always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin r_valid_s0_s1 <= 0; r_data_real_s0_s1 <= 0; r_data_imag_s0_s1 <= 0; end
    else begin r_valid_s0_s1 <= w_valid_s0_s1; r_data_real_s0_s1 <= w_data_real_s0_s1; r_data_imag_s0_s1 <= w_data_imag_s0_s1; end
end

// STAGE 1
stage_1 u_stage1 (
    .i_clk(i_clk), .i_reset(i_reset), .i_valid_in(r_valid_s0_s1), .i_data_real(r_data_real_s0_s1), .i_data_imag(r_data_imag_s0_s1),
    .o_valid_out(w_valid_s1_s2), .o_data_a_real(w_a_real_s1_s2), .o_data_a_imag(w_a_imag_s1_s2), .o_data_b_real(w_b_real_s1_s2), .o_data_b_imag(w_b_imag_s1_s2)
);

// PIPELINE 2
always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin r_valid_s1_s2 <= 0; r_a_real_s1_s2 <= 0; r_a_imag_s1_s2 <= 0; r_b_real_s1_s2 <= 0; r_b_imag_s1_s2 <= 0; end
    else begin r_valid_s1_s2 <= w_valid_s1_s2; r_a_real_s1_s2 <= w_a_real_s1_s2; r_a_imag_s1_s2 <= w_a_imag_s1_s2; r_b_real_s1_s2 <= w_b_real_s1_s2; r_b_imag_s1_s2 <= w_b_imag_s1_s2; end
end

// STAGE 2
stage_2 u_stage2 (
    .i_clk(i_clk), .i_reset(i_reset), .i_valid_in(r_valid_s1_s2), .i_data_a_real(r_a_real_s1_s2), .i_data_a_imag(r_a_imag_s1_s2), .i_data_b_real(r_b_real_s1_s2), .i_data_b_imag(r_b_imag_s1_s2),
    .o_valid_out(w_valid_s2_s3), .o_data_a_real(w_a_real_s2_s3), .o_data_a_imag(w_a_imag_s2_s3), .o_data_b_real(w_b_real_s2_s3), .o_data_b_imag(w_b_imag_s2_s3)
);

// PIPELINE 3
always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin r_valid_s2_s3 <= 0; r_a_real_s2_s3 <= 0; r_a_imag_s2_s3 <= 0; r_b_real_s2_s3 <= 0; r_b_imag_s2_s3 <= 0; end
    else begin r_valid_s2_s3 <= w_valid_s2_s3; r_a_real_s2_s3 <= w_a_real_s2_s3; r_a_imag_s2_s3 <= w_a_imag_s2_s3; r_b_real_s2_s3 <= w_b_real_s2_s3; r_b_imag_s2_s3 <= w_b_imag_s2_s3; end
end

// STAGE 3
stage_3 u_stage3 (
    .i_clk(i_clk), .i_reset(i_reset), .i_valid_in(r_valid_s2_s3), .i_data_a_real(r_a_real_s2_s3), .i_data_a_imag(r_a_imag_s2_s3), .i_data_b_real(r_b_real_s2_s3), .i_data_b_imag(r_b_imag_s2_s3),
    .o_valid_out(w_valid_s3_s4), .o_data_a_real(w_a_real_s3_s4), .o_data_a_imag(w_a_imag_s3_s4), .o_data_b_real(w_b_real_s3_s4), .o_data_b_imag(w_b_imag_s3_s4)
);

// PIPELINE 4
always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin r_valid_s3_s4 <= 0; r_a_real_s3_s4 <= 0; r_a_imag_s3_s4 <= 0; r_b_real_s3_s4 <= 0; r_b_imag_s3_s4 <= 0; end
    else begin r_valid_s3_s4 <= w_valid_s3_s4; r_a_real_s3_s4 <= w_a_real_s3_s4; r_a_imag_s3_s4 <= w_a_imag_s3_s4; r_b_real_s3_s4 <= w_b_real_s3_s4; r_b_imag_s3_s4 <= w_b_imag_s3_s4; end
end

// STAGE 4
stage_4 u_stage4 (
    .i_clk(i_clk), .i_reset(i_reset), .i_valid_in(r_valid_s3_s4), .i_data_a_real(r_a_real_s3_s4), .i_data_a_imag(r_a_imag_s3_s4), .i_data_b_real(r_b_real_s3_s4), .i_data_b_imag(r_b_imag_s3_s4),
    .o_valid_out(w_valid_s4_s5), .o_data_a_real(w_a_real_s4_s5), .o_data_a_imag(w_a_imag_s4_s5), .o_data_b_real(w_b_real_s4_s5), .o_data_b_imag(w_b_imag_s4_s5)
);

// PIPELINE 5
always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin r_valid_s4_s5 <= 0; r_a_real_s4_s5 <= 0; r_a_imag_s4_s5 <= 0; r_b_real_s4_s5 <= 0; r_b_imag_s4_s5 <= 0; end
    else begin r_valid_s4_s5 <= w_valid_s4_s5; r_a_real_s4_s5 <= w_a_real_s4_s5; r_a_imag_s4_s5 <= w_a_imag_s4_s5; r_b_real_s4_s5 <= w_b_real_s4_s5; r_b_imag_s4_s5 <= w_b_imag_s4_s5; end
end

// STAGE 5
stage_5 u_stage5 (
    .i_clk(i_clk), .i_reset(i_reset), .i_valid_in(r_valid_s4_s5), .i_data_a_real(r_a_real_s4_s5), .i_data_a_imag(r_a_imag_s4_s5), .i_data_b_real(r_b_real_s4_s5), .i_data_b_imag(r_b_imag_s4_s5),
    .o_valid_out(w_valid_s5_s6), .o_data_a_real(w_a_real_s5_s6), .o_data_a_imag(w_a_imag_s5_s6), .o_data_b_real(w_b_real_s5_s6), .o_data_b_imag(w_b_imag_s5_s6)
);

// PIPELINE 6
always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin r_valid_s5_s6 <= 0; r_a_real_s5_s6 <= 0; r_a_imag_s5_s6 <= 0; r_b_real_s5_s6 <= 0; r_b_imag_s5_s6 <= 0; end
    else begin r_valid_s5_s6 <= w_valid_s5_s6; r_a_real_s5_s6 <= w_a_real_s5_s6; r_a_imag_s5_s6 <= w_a_imag_s5_s6; r_b_real_s5_s6 <= w_b_real_s5_s6; r_b_imag_s5_s6 <= w_b_imag_s5_s6; end
end

// STAGE 6
stage_6 u_stage6 (
    .i_clk(i_clk), .i_reset(i_reset), .i_valid_in(r_valid_s5_s6), .i_data_a_real(r_a_real_s5_s6), .i_data_a_imag(r_a_imag_s5_s6), .i_data_b_real(r_b_real_s5_s6), .i_data_b_imag(r_b_imag_s5_s6),
    .o_valid_out(w_valid_s6_s7), .o_data_a_real(w_a_real_s6_s7), .o_data_a_imag(w_a_imag_s6_s7), .o_data_b_real(w_b_real_s6_s7), .o_data_b_imag(w_b_imag_s6_s7)
);

// PIPELINE 7
always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin r_valid_s6_s7 <= 0; r_a_real_s6_s7 <= 0; r_a_imag_s6_s7 <= 0; r_b_real_s6_s7 <= 0; r_b_imag_s6_s7 <= 0; end
    else begin r_valid_s6_s7 <= w_valid_s6_s7; r_a_real_s6_s7 <= w_a_real_s6_s7; r_a_imag_s6_s7 <= w_a_imag_s6_s7; r_b_real_s6_s7 <= w_b_real_s6_s7; r_b_imag_s6_s7 <= w_b_imag_s6_s7; end
end

// STAGE 7
stage_7 u_stage7 (
    .i_clk(i_clk), .i_reset(i_reset), .i_valid_in(r_valid_s6_s7), .i_data_a_real(r_a_real_s6_s7), .i_data_a_imag(r_a_imag_s6_s7), .i_data_b_real(r_b_real_s6_s7), .i_data_b_imag(r_b_imag_s6_s7),
    .o_valid_out(w_valid_s7_s8), .o_data_a_real(w_a_real_s7_s8), .o_data_a_imag(w_a_imag_s7_s8), .o_data_b_real(w_b_real_s7_s8), .o_data_b_imag(w_b_imag_s7_s8)
);

// PIPELINE 8
always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin r_valid_s7_s8 <= 0; r_a_real_s7_s8 <= 0; r_a_imag_s7_s8 <= 0; r_b_real_s7_s8 <= 0; r_b_imag_s7_s8 <= 0; end
    else begin r_valid_s7_s8 <= w_valid_s7_s8; r_a_real_s7_s8 <= w_a_real_s7_s8; r_a_imag_s7_s8 <= w_a_imag_s7_s8; r_b_real_s7_s8 <= w_b_real_s7_s8; r_b_imag_s7_s8 <= w_b_imag_s7_s8; end
end

// STAGE 8
stage_8 u_stage8 (
    .i_clk(i_clk), .i_reset(i_reset), .i_valid_in(r_valid_s7_s8), .i_data_a_real(r_a_real_s7_s8), .i_data_a_imag(r_a_imag_s7_s8), .i_data_b_real(r_b_real_s7_s8), .i_data_b_imag(r_b_imag_s7_s8),
    .o_valid_out(w_valid_s8_s9), .o_data_a_real(w_a_real_s8_s9), .o_data_a_imag(w_a_imag_s8_s9), .o_data_b_real(w_b_real_s8_s9), .o_data_b_imag(w_b_imag_s8_s9)
);

// PIPELINE 9
always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin r_valid_s8_s9 <= 0; r_a_real_s8_s9 <= 0; r_a_imag_s8_s9 <= 0; r_b_real_s8_s9 <= 0; r_b_imag_s8_s9 <= 0; end
    else begin r_valid_s8_s9 <= w_valid_s8_s9; r_a_real_s8_s9 <= w_a_real_s8_s9; r_a_imag_s8_s9 <= w_a_imag_s8_s9; r_b_real_s8_s9 <= w_b_real_s8_s9; r_b_imag_s8_s9 <= w_b_imag_s8_s9; end
end

// STAGE 9
stage_9 u_stage9 (
    .i_clk(i_clk), .i_reset(i_reset), .i_valid_in(r_valid_s8_s9), .i_data_a_real(r_a_real_s8_s9), .i_data_a_imag(r_a_imag_s8_s9), .i_data_b_real(r_b_real_s8_s9), .i_data_b_imag(r_b_imag_s8_s9),
    .o_valid_out(w_valid_s9_s10), .o_data_a_real(w_a_real_s9_s10), .o_data_a_imag(w_a_imag_s9_s10), .o_data_b_real(w_b_real_s9_s10), .o_data_b_imag(w_b_imag_s9_s10)
);

// PIPELINE 10
always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin r_valid_s9_s10 <= 0; r_a_real_s9_s10 <= 0; r_a_imag_s9_s10 <= 0; r_b_real_s9_s10 <= 0; r_b_imag_s9_s10 <= 0; end
    else begin r_valid_s9_s10 <= w_valid_s9_s10; r_a_real_s9_s10 <= w_a_real_s9_s10; r_a_imag_s9_s10 <= w_a_imag_s9_s10; r_b_real_s9_s10 <= w_b_real_s9_s10; r_b_imag_s9_s10 <= w_b_imag_s9_s10; end
end

// STAGE 10
stage_10 u_stage10 (
    .i_clk(i_clk), .i_reset(i_reset), .i_valid_in(r_valid_s9_s10), .i_data_a_real(r_a_real_s9_s10), .i_data_a_imag(r_a_imag_s9_s10), .i_data_b_real(r_b_real_s9_s10), .i_data_b_imag(r_b_imag_s9_s10),
    .o_valid_out(w_valid_s10_out), .o_data_a_real(w_a_real_s10_out), .o_data_a_imag(w_a_imag_s10_out), .o_data_b_real(w_b_real_s10_out), .o_data_b_imag(w_b_imag_s10_out)
);

// =========================================================
// OUTPUT LOGIC (Lấy từ Stage 10)
// =========================================================
always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        o_valid_out     <= 1'b0;
        o_data_a_real   <= 32'd0; o_data_a_imag <= 32'd0;
        o_data_b_real   <= 32'd0; o_data_b_imag <= 32'd0;
    end else begin
        // Nối Output của Module với Output của Stage 10
        o_valid_out     <= w_valid_s10_out;
        o_data_a_real   <= w_a_real_s10_out; o_data_a_imag <= w_a_imag_s10_out;
        o_data_b_real   <= w_b_real_s10_out; o_data_b_imag <= w_b_imag_s10_out;
    end
end

endmodule
