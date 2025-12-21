module input_reordering (
    input logic         i_clk, i_reset,
    input logic         i_valid_in,
    input logic  [31:0] i_data_real, i_data_imag,

    output logic        o_valid_out,
    output logic [31:0] o_data_real, o_data_imag
);

logic [9:0] wr_cnt, wr_cnt1, rd_cnt, rd_cnt1, rd_addr_rev;
logic current_bank_write;
logic buffer_full_flag;

logic read_enable_internal; 
logic reading_bank;          
logic reading_bank_pipeline; 

logic we_ram1, we_ram2;
logic [31:0] ram1_out_real, ram1_out_imag;
logic [31:0] ram2_out_real, ram2_out_imag;

inversion_sequence inversionsequence (.i_seq_addr(rd_cnt), .o_rev_addr(rd_addr_rev));
fullAdder10b fa1 (.a(wr_cnt), .b(10'b1), .cin(1'b0), .sum(wr_cnt1));
fullAdder10b fa2 (.a(rd_cnt), .b(10'b1), .cin(1'b0), .sum(rd_cnt1));

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        wr_cnt             <= 0;
        current_bank_write <= 0;
        buffer_full_flag   <= 0;
    end else if (i_valid_in) begin
        if (&wr_cnt) begin
            wr_cnt             <= 0;
            current_bank_write <= ~current_bank_write; 
            buffer_full_flag   <= 1;
        end else begin
            wr_cnt             <= wr_cnt1;
        end
    end
end

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        rd_cnt               <= 0;
        read_enable_internal <= 0;
        reading_bank         <= 0; 
    end else if (buffer_full_flag) begin
        read_enable_internal <= 1;

        if (read_enable_internal) begin
            if (&rd_cnt) begin
                rd_cnt       <= 0;
                reading_bank <= ~reading_bank; 
            end else begin
                rd_cnt       <= rd_cnt1;
            end
        end
    end
end

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        o_valid_out           <= 0;
        reading_bank_pipeline <= 0;
    end else begin
        o_valid_out           <= read_enable_internal;
        reading_bank_pipeline <= reading_bank; 
    end
end

always @(*) begin
    we_ram1 = 1'b0;
    we_ram2 = 1'b0;
    if (i_valid_in) begin
        if (~current_bank_write) we_ram1 = 1'b1;
        else                     we_ram2 = 1'b1;
    end
end

dual_port_ram u_ram1_real (.i_clk(i_clk), 
                           .i_addr_a(wr_cnt),      .i_data_a(i_data_real), .i_we_a(we_ram1), 
                           .i_addr_b(rd_addr_rev), .i_data_b(32'b0),       .i_we_b(1'b0), 

                           .o_data_b(ram1_out_real));
dual_port_ram u_ram1_imag (.i_clk(i_clk), 
                           .i_addr_a(wr_cnt),      .i_data_a(i_data_imag), .i_we_a(we_ram1), 
                           .i_addr_b(rd_addr_rev), .i_data_b(32'b0),       .i_we_b(1'b0), 

                           .o_data_b(ram1_out_imag));

dual_port_ram u_ram2_real (.i_clk(i_clk), 
                           .i_addr_a(wr_cnt),      .i_data_a(i_data_real), .i_we_a(we_ram2), 
                           .i_addr_b(rd_addr_rev), .i_data_b(32'b0),       .i_we_b(1'b0), 

                           .o_data_b(ram2_out_real));
dual_port_ram u_ram2_imag (.i_clk(i_clk), 
                           .i_addr_a(wr_cnt),      .i_data_a(i_data_imag), .i_we_a(we_ram2), 
                           .i_addr_b(rd_addr_rev), .i_data_b(32'b0),       .i_we_b(1'b0), 

                           .o_data_b(ram2_out_imag));

always @(*) begin
    if (~reading_bank_pipeline) begin
        o_data_real = ram1_out_real;
        o_data_imag = ram1_out_imag;
    end else begin
        o_data_real = ram2_out_real;
        o_data_imag = ram2_out_imag;
    end
end

endmodule
