module dual_port_ram (
    input logic i_clk,

    input logic [9:0] i_addr_a,
    input logic [31:0] i_data_a,
    input logic i_we_a, 
    output logic [31:0] o_data_a,

    input logic [9:0] i_addr_b,
    input logic [31:0] i_data_b,
    input logic i_we_b, 
    output logic [31:0] o_data_b
);

logic [31:0] ram [0:1023];

initial begin
    $readmemh("/home/nguyendinhhuy/rtl/cordic-based-fft/scripts/dmem_init_file.txt", ram);
end

always @(posedge i_clk) begin
    if (i_we_a) begin
        ram[i_addr_a] <= i_data_a; 
    end
    else begin
        o_data_a <= ram[i_addr_a];
    end
end

always @(posedge i_clk) begin
    if (i_we_b) begin
        ram[i_addr_b] <= i_data_b;
    end
    else begin
        o_data_b <= ram[i_addr_b];
    end
end
endmodule
