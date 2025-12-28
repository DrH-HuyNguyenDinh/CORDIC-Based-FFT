module stage_1 (
    input logic         i_clk, i_reset,

    input logic         i_valid_in,
    input logic  [31:0] i_data_real,
    input logic  [31:0] i_data_imag,

    output logic        o_valid_out,
    output logic [31:0] o_data_a_real, o_data_a_imag,
    output logic [31:0] o_data_b_real, o_data_b_imag
);

logic [31:0] reg_A_real, reg_A_imag;
logic        waiting_for_B;
logic [9:0]  wr_cnt, wr_cnt1;     
logic [9:0]  addr_wr_A;   

logic [31:0] btf_A_real, btf_A_real1, btf_B_real, btf_B_real1;
logic        btf_valid;  

logic       bank_sel;
logic [9:0] sample_counter, sample_counter2;
logic       ram_we;
logic [9:0] ram_wr_addr_A, ram_wr_addr_B;
logic       read_enable; 

logic [9:0] rd_cnt, rd_cnt1;
logic       read_strobe1, read_strobe; 
logic [9:0] ram_rd_addr_A, ram_rd_addr_B;

logic [31:0] r0_ar, r0_ai, r0_br, r0_bi;
logic [31:0] r1_ar, r1_ai, r1_br, r1_bi;

logic [31:0] r0_ar1, r0_ai1, r0_br1, r0_bi1;
logic [31:0] r1_ar1, r1_ai1, r1_br1, r1_bi1;

logic [31:0] r0_ar2, r0_ai2, r0_br2, r0_bi2;
logic [31:0] r1_ar2, r1_ai2, r1_br2, r1_bi2;

logic [9:0] addr_b0_a, addr_b0_b;
logic [9:0] addr_b1_a, addr_b1_b;

logic we_b0, we_b1;

fullAdder10b fa1 (.a(wr_cnt), .b(10'b1), .cin(1'b0), .sum(wr_cnt1));

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        waiting_for_B <= 1'b0;
        btf_valid     <= 1'b0;
        wr_cnt        <= 10'd0;
        addr_wr_A     <= 10'd0;
    end else if (i_valid_in) begin
        if (~waiting_for_B) begin
            reg_A_real    <= i_data_real;
            reg_A_imag    <= i_data_imag;
            addr_wr_A     <= {wr_cnt[8:0], 1'b0}; 
            waiting_for_B <= 1'b1;
            btf_valid     <= 1'b0;
        end else begin
            waiting_for_B <= 1'b0;
            btf_valid     <= 1'b1;
            wr_cnt        <= wr_cnt1;
        end
    end else begin
        btf_valid <= 1'b0;
    end
end

butterfly u_btf (.i_clk(i_clk),             .i_reset(i_reset),
                 .i_A_real(reg_A_real),     .i_A_imag(reg_A_imag),
                 .i_B_real(i_data_real),    .i_B_imag(i_data_imag),

                 .o_A_new_real(btf_A_real1), .o_B_new_real(btf_B_real1));

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        btf_A_real <= 32'b0;
        btf_B_real <= 32'b0;
    end else begin
        btf_A_real <= btf_A_real1;
        btf_B_real <= btf_B_real1;
    end
end 

fullAdder10b fa2 (.a(sample_counter), .b(10'd2), .cin(1'b0), .sum(sample_counter2));

always_ff @(posedge i_clk) begin
    ram_we        <= btf_valid;
    ram_wr_addr_A <= addr_wr_A;       
    ram_wr_addr_B <= addr_wr_A | 10'd1;
end

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        bank_sel       <= 1'b0;
        sample_counter <= 10'd0;
        read_enable    <= 1'b0;
    end else if (ram_we) begin
        if ((&sample_counter[9:1]) & ~sample_counter[0]) begin // sample_counter == 1022
            sample_counter <= 10'd0;
            bank_sel       <= ~bank_sel; 
            read_enable    <= 1'b1;      
        end else begin
            sample_counter <= sample_counter2;
        end
    end
end

fullAdder10b fa3 (.a(rd_cnt), .b(10'b1), .cin(1'b0), .sum(rd_cnt1));

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        rd_cnt      <= 10'd0;
    end else if (read_enable & ram_we) begin
        rd_cnt      <= rd_cnt1;
    end
end

assign read_strobe1 = read_enable & ram_we;

assign o_valid_out = read_strobe1;

// rd_cnt: 0 (000) -> A=0 (0000), B=2 (0010)
// rd_cnt: 1 (001) -> A=1 (0001), B=3 (0011)
assign ram_rd_addr_A = {rd_cnt[8:1], 1'b0, rd_cnt[0]};
assign ram_rd_addr_B = {rd_cnt[8:1], 1'b1, rd_cnt[0]};

always @(*) begin
    if (~bank_sel) begin
        we_b0 = ram_we;
        we_b1 = 1'b0;
    end else begin
        we_b0 = 1'b0;
        we_b1 = ram_we;
    end
end 

always @(*) begin
    if (~bank_sel) begin
        addr_b0_a = ram_wr_addr_A;
        addr_b0_b = ram_wr_addr_B;
        
        addr_b1_a = ram_rd_addr_A;
        addr_b1_b = ram_rd_addr_B;
    end else begin
        addr_b0_a = ram_rd_addr_A;
        addr_b0_b = ram_rd_addr_B;
        
        addr_b1_a = ram_wr_addr_A;
        addr_b1_b = ram_wr_addr_B;
    end
end

dual_port_ram ram_real_b0 (
    .i_clk(i_clk),
    .i_we_a(we_b0), .i_addr_a(addr_b0_a), .i_data_a(btf_A_real), .o_data_a(r0_ar),
    .i_we_b(we_b0), .i_addr_b(addr_b0_b), .i_data_b(btf_B_real), .o_data_b(r0_br)
);

dual_port_ram ram_imag_b0 (
    .i_clk(i_clk),
    .i_we_a(we_b0), .i_addr_a(addr_b0_a), .i_data_a(32'b0), .o_data_a(r0_ai),
    .i_we_b(we_b0), .i_addr_b(addr_b0_b), .i_data_b(32'b0), .o_data_b(r0_bi)
);

dual_port_ram ram_real_b1 (
    .i_clk(i_clk),
    .i_we_a(we_b1), .i_addr_a(addr_b1_a), .i_data_a(btf_A_real), .o_data_a(r1_ar),
    .i_we_b(we_b1), .i_addr_b(addr_b1_b), .i_data_b(btf_B_real), .o_data_b(r1_br)
);

dual_port_ram ram_imag_b1 (
    .i_clk(i_clk),
    .i_we_a(we_b1), .i_addr_a(addr_b1_a), .i_data_a(32'b0), .o_data_a(r1_ai),
    .i_we_b(we_b1), .i_addr_b(addr_b1_b), .i_data_b(32'b0), .o_data_b(r1_bi)
);

logic bank_sel_out;

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset)
        bank_sel_out <= 1'b0;
    else
        bank_sel_out <= bank_sel;
end

always @(*) begin
    if (~bank_sel_out) begin
        o_data_a_real = r1_ar; o_data_a_imag = r1_ai;
        o_data_b_real = r1_br; o_data_b_imag = r1_bi;
    end else begin
        o_data_a_real = r0_ar; o_data_a_imag = r0_ai;
        o_data_b_real = r0_br; o_data_b_imag = r0_bi;
    end
end

endmodule
