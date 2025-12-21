module rom_stage_5 (
    input logic         i_clk,
    input logic [3:0]   i_addr,   
    output logic [31:0] o_data
);

logic [31:0] rom [0:15];

initial begin
    rom[0]  = 32'h00000000; // 0 deg
    rom[1]  = 32'hbe490fdb; // -11.25 deg
    rom[2]  = 32'hbec90fdb; // -22.50 deg
    rom[3]  = 32'hbf16cbe4; // -33.75 deg
    rom[4]  = 32'hbf490fdb; // -45.00 deg
    rom[5]  = 32'hbf7b53d1; // -56.25 deg
    rom[6]  = 32'hbf96cbe4; // -67.50 deg
    rom[7]  = 32'hbfafeddf; // -78.75 deg
    rom[8]  = 32'hbfc90fdb; // -90.00 deg
    rom[9]  = 32'hbfe231d6; // -101.25 deg
    rom[10] = 32'hbffb53d1; // -112.50 deg
    rom[11] = 32'hc00a3ae6; // -123.75 deg
    rom[12] = 32'hc016cbe4; // -135.00 deg
    rom[13] = 32'hc0235ce2; // -146.25 deg
    rom[14] = 32'hc02feddf; // -157.50 deg
    rom[15] = 32'hc03c7edd; // -168.75 deg
end

always @(posedge i_clk) begin
    o_data <= rom[i_addr];
end

endmodule
