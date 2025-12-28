module stage_7 (
    input logic         i_clk, i_reset,

    input logic         i_valid_in,
    input logic  [31:0] i_data_a_real, i_data_a_imag,
    input logic  [31:0] i_data_b_real, i_data_b_imag,

    output logic        o_valid_out,
    output logic [31:0] o_data_a_real, o_data_a_imag,
    output logic [31:0] o_data_b_real, o_data_b_imag
);

logic [5:0] rom_addr; 

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        rom_addr <= 6'd0;
    end else if (i_valid_in) begin
        rom_addr <= rom_addr + 6'h1; 
    end
end

logic [31:0] cordic_angle;
rom_stage_7 u_rom (     
    .i_clk(i_clk),
    .i_addr(rom_addr),
    .o_data(cordic_angle)
);

logic [31:0] reg_a_r, reg_a_i, reg_b_r, reg_b_i;
logic        reg_valid;

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        reg_a_r <= 0; reg_a_i <= 0;
        reg_b_r <= 0; reg_b_i <= 0;
        reg_valid <= 0;
    end else begin
        reg_a_r <= i_data_a_real; reg_a_i <= i_data_a_imag;
        reg_b_r <= i_data_b_real; reg_b_i <= i_data_b_imag;
        reg_valid <= i_valid_in;
    end
end

logic [31:0] rot_b_r, rot_b_i;
logic [31:0] delayed_a_r, delayed_a_i;

cordic u_cordic (
    .i_clk(i_clk), .i_reset(i_reset),
    .i_x(reg_b_r), .i_y(reg_b_i),
    .i_z(cordic_angle),
    .o_x(rot_b_r), .o_y(rot_b_i)
);

delay_23 u_delay_ar (.i_clk(i_clk), .i_reset(i_reset), .i_data(reg_a_r), .o_data(delayed_a_r));
delay_23 u_delay_ai (.i_clk(i_clk), .i_reset(i_reset), .i_data(reg_a_i), .o_data(delayed_a_i));

logic [22:0] val_shift;
logic        cordic_valid;

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) val_shift <= 0;
    else          val_shift <= {val_shift[21:0], reg_valid};
end
assign cordic_valid = val_shift[22];

logic [31:0] btf_sum_real, btf_sum_imag;
logic [31:0] btf_sub_real, btf_sub_imag;

butterfly u_btf_s7 (    
    .i_clk(i_clk),      .i_reset(i_reset),
    .i_A_real(delayed_a_r), .i_A_imag(delayed_a_i),
    .i_B_real(rot_b_r),     .i_B_imag(rot_b_i),
    .o_A_new_real(btf_sum_real), .o_A_new_imag(btf_sum_imag),
    .o_B_new_real(btf_sub_real), .o_B_new_imag(btf_sub_imag)
);

logic btf_valid;
always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) btf_valid <= 0;
    else          btf_valid <= cordic_valid;
end

logic       bank_sel;
logic [9:0] sample_counter, sample_counter2;
logic       ram_we;
logic [9:0] ram_wr_addr_A, ram_wr_addr_B;
logic [9:0] wr_cnt, wr_cnt1;
logic       read_enable;

fullAdder10b fa_samp (.a(sample_counter), .b(10'd2), .cin(1'b0), .sum(sample_counter2));
fullAdder10b fa_wr   (.a(wr_cnt), .b(10'd1), .cin(1'b0), .sum(wr_cnt1));

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset)          wr_cnt <= 0;
    else if (cordic_valid) wr_cnt <= wr_cnt1;
end

assign ram_we = btf_valid;

assign ram_wr_addr_A = {wr_cnt[8:6], 1'b0, wr_cnt[5:0]};
assign ram_wr_addr_B = {wr_cnt[8:6], 1'b1, wr_cnt[5:0]};

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        bank_sel       <= 0;
        sample_counter <= 0;
        read_enable    <= 0;
    end else if (ram_we) begin
        if ((&sample_counter[9:1]) & ~sample_counter[0]) begin
            sample_counter <= 0;
            bank_sel       <= ~bank_sel;
            read_enable    <= 1;
        end else begin
            sample_counter <= sample_counter2;
        end
    end
end

logic [9:0] rd_cnt, rd_cnt1;
logic       read_strobe;
logic [9:0] ram_rd_addr_A, ram_rd_addr_B;

fullAdder10b fa_rd (.a(rd_cnt), .b(10'd1), .cin(1'b0), .sum(rd_cnt1));

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        rd_cnt      <= 0;
        read_strobe <= 0;
    end else if (read_enable & ram_we) begin
        rd_cnt      <= rd_cnt1;
        read_strobe <= 1;
    end else begin
        read_strobe <= 0;
    end
end

assign ram_rd_addr_A = {rd_cnt[8:7], 1'b0, rd_cnt[6:0]};
assign ram_rd_addr_B = {rd_cnt[8:7], 1'b1, rd_cnt[6:0]};

logic we_b0, we_b1;
always @(*) begin
    if (~bank_sel) begin we_b0 = ram_we; we_b1 = 0; end 
    else           begin we_b0 = 0;      we_b1 = ram_we; end
end

logic [9:0] addr_b0_a1, addr_b0_b1;
logic [9:0] addr_b1_a1, addr_b1_b1;
logic [9:0] addr_b0_a, addr_b0_b;
logic [9:0] addr_b1_a, addr_b1_b;

always @(*) begin
    if (~bank_sel) begin
        addr_b0_a1 = ram_wr_addr_A; addr_b0_b1 = ram_wr_addr_B;
        addr_b1_a1 = ram_rd_addr_A; addr_b1_b1 = ram_rd_addr_B;
    end else begin
        addr_b0_a1 = ram_rd_addr_A; addr_b0_b1 = ram_rd_addr_B;
        addr_b1_a1 = ram_wr_addr_A; addr_b1_b1 = ram_wr_addr_B;
    end
end

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        addr_b0_a <= 0; addr_b0_b <= 0;
        addr_b1_a <= 0; addr_b1_b <= 0;
    end else begin
        addr_b0_a <= addr_b0_a1; addr_b0_b <= addr_b0_b1;
        addr_b1_a <= addr_b1_a1; addr_b1_b <= addr_b1_b1;
    end
end

logic [31:0] r0_ar, r0_ai, r0_br, r0_bi;
logic [31:0] r1_ar, r1_ai, r1_br, r1_bi;

dual_port_ram ram_real_b0 (.i_clk(i_clk), .i_we_a(we_b0), .i_addr_a(addr_b0_a), .i_data_a(btf_sum_real), .o_data_a(r0_ar), .i_we_b(we_b0), .i_addr_b(addr_b0_b), .i_data_b(btf_sub_real), .o_data_b(r0_br));
dual_port_ram ram_imag_b0 (.i_clk(i_clk), .i_we_a(we_b0), .i_addr_a(addr_b0_a), .i_data_a(btf_sum_imag), .o_data_a(r0_ai), .i_we_b(we_b0), .i_addr_b(addr_b0_b), .i_data_b(btf_sub_imag), .o_data_b(r0_bi));

dual_port_ram ram_real_b1 (.i_clk(i_clk), .i_we_a(we_b1), .i_addr_a(addr_b1_a), .i_data_a(btf_sum_real), .o_data_a(r1_ar), .i_we_b(we_b1), .i_addr_b(addr_b1_b), .i_data_b(btf_sub_real), .o_data_b(r1_br));
dual_port_ram ram_imag_b1 (.i_clk(i_clk), .i_we_a(we_b1), .i_addr_a(addr_b1_a), .i_data_a(btf_sum_imag), .o_data_a(r1_ai), .i_we_b(we_b1), .i_addr_b(addr_b1_b), .i_data_b(btf_sub_imag), .o_data_b(r1_bi));

logic valid_out, bank_sel_out, bank_sel1;
logic [31:0] mux_ar, mux_ai, mux_br, mux_bi;

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        bank_sel1 <= 0;
        bank_sel_out <= 0;
    end else begin
        bank_sel1 <= bank_sel;
        bank_sel_out <= bank_sel1;
    end
end

always @(*) begin
    if (~bank_sel_out) begin mux_ar = r1_ar; mux_ai = r1_ai; mux_br = r1_br; mux_bi = r1_bi; end
    else           begin mux_ar = r0_ar; mux_ai = r0_ai; mux_br = r0_br; mux_bi = r0_bi; end
end

logic [31:0] d1_ar, d1_ai, d1_br, d1_bi;

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        o_valid_out   <= 0; valid_out <= 0;
        o_data_a_real <= 0; o_data_a_imag <= 0;
        o_data_b_real <= 0; o_data_b_imag <= 0;
        d1_ar <= 0; d1_ai <= 0; d1_br <= 0; d1_bi <= 0;
    end else begin
        d1_ar <= mux_ar; d1_ai <= mux_ai;
        d1_br <= mux_br; d1_bi <= mux_bi;

        o_data_a_real <= d1_ar; o_data_a_imag <= d1_ai;
        o_data_b_real <= d1_br; o_data_b_imag <= d1_bi;
        valid_out     <= read_strobe;
        o_valid_out   <= valid_out;
    end
end

endmodule
