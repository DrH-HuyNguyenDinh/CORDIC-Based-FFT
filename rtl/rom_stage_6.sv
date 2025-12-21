module rom_stage_6 (
    input logic         i_clk,
    input logic [4:0]   i_addr,   
    output logic [31:0] o_data
);

logic [31:0] rom [0:31];

initial begin
    rom[0]  = 32'h00000000; // 0
    rom[1]  = 32'hbdc90fdb; // -1 * pi/32
    rom[2]  = 32'hbe490fdb; // -2 * pi/32 (-pi/16)
    rom[3]  = 32'hbe9687b9; // -3 * pi/32
    rom[4]  = 32'hbec90fdb; // -4 * pi/32 (-pi/8)
    rom[5]  = 32'hbef153d1; // -5
    rom[6]  = 32'hbf16cbe4; // -6
    rom[7]  = 32'hbf32d0c1; // -7
    rom[8]  = 32'hbf490fdb; // -8 * pi/32 (-pi/4)
    rom[9]  = 32'hbf5e2ef3; // -9
    rom[10] = 32'hbf7b53d1; // -10
    rom[11] = 32'hbf8e5c85; // -11
    rom[12] = 32'hbf96cbe4; // -12
    rom[13] = 32'hbfb504f3; // -13
    rom[14] = 32'hbfafeddf; // -14
    rom[15] = 32'hbfbe4a6e; // -15
    rom[16] = 32'hbfc90fdb; // -16 * pi/32 (-pi/2)
    rom[17] = 32'hbfd3d548; // -17
    rom[18] = 32'hbfe231d6; // -18
    rom[19] = 32'hbfecfba1; // -19
    rom[20] = 32'hbffb53d1; // -20
    rom[21] = 32'hc003e680; // -21
    rom[22] = 32'hc00a3ae6; // -22
    rom[23] = 32'hc01201dc; // -23
    rom[24] = 32'hc016cbe4; // -24 * pi/32 (-3pi/4)
    rom[25] = 32'hc01e2333; // -25
    rom[26] = 32'hc0235ce2; // -26
    rom[27] = 32'hc029fe2b; // -27
    rom[28] = 32'hc02feddf; // -28
    rom[29] = 32'hc0375a28; // -29
    rom[30] = 32'hc03c7edd; // -30
    rom[31] = 32'hc042e612; // -31
end

always @(posedge i_clk) begin
    o_data <= rom[i_addr];
end

endmodule
