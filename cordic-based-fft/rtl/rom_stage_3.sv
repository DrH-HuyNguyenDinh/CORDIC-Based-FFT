module rom_stage_3 (
    input logic           i_clk,
    input logic [1:0]     i_addr,   
    output logic [31:0]   o_data   
);

logic [31:0] rom [0:3];

initial begin
	rom[0] = 32'h00000000;
    rom[1] = 32'hbf490fdb;
    rom[2] = 32'hbfc90fdb;
    rom[3] = 32'hc016cbe4;
end

always @(posedge i_clk) begin
	o_data <= rom[i_addr];
end

endmodule
