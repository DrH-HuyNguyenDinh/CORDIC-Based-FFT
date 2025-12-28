module rom_stage_4 (
    input logic         i_clk,
    input logic [2:0]   i_addr,   
    output logic [31:0] o_data
);

logic [31:0] rom [0:7];

initial begin
    rom[0] = 32'h00000000; // 0
    rom[1] = 32'hbec90fdb; // -pi/8  (-22.5 deg)
    rom[2] = 32'hbf490fdb; // -pi/4  (-45 deg)
    rom[3] = 32'hbf9687b9; // -3pi/8 (-67.5 deg)
    rom[4] = 32'hbfc90fdb; // -pi/2  (-90 deg)
    rom[5] = 32'hbfeb17eb; // -5pi/8 (-112.5 deg)
    rom[6] = 32'hc016cbe4; // -3pi/4 (-135 deg)
    rom[7] = 32'hc033745d; // -7pi/8 (-157.5 deg)
end

always @(posedge i_clk) begin
    o_data <= rom[i_addr];
end

endmodule
