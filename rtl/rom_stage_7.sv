module rom_stage_7 (
    input logic         i_clk,
    input logic [5:0]   i_addr,   
    output logic [31:0] o_data
);

logic [31:0] rom [0:63];

initial begin
    rom[ 0] = 32'h00000000; // 0
    rom[ 1] = 32'hbd490fdb; // -1 * pi/64
    rom[ 2] = 32'hbdc90fdb; // -2
    rom[ 3] = 32'hbe16cbe4; // -3
    rom[ 4] = 32'hbe490fdb; // -4 * pi/64 (-pi/16)
    rom[ 5] = 32'hbe7b53d1; // -5
    rom[ 6] = 32'hbe96cbe4; // -6
    rom[ 7] = 32'hbeafeddf; // -7
    rom[ 8] = 32'hbec90fdb; // -8 * pi/64 (-pi/8)
    rom[ 9] = 32'hbee231d6; // -9
    rom[10] = 32'hbefb53d1; // -10
    rom[11] = 32'hbf0a3ae6; // -11
    rom[12] = 32'hbf16cbe4; // -12
    rom[13] = 32'hbf235ce2; // -13
    rom[14] = 32'hbf2feddf; // -14
    rom[15] = 32'hbf3c7edd; // -15
    rom[16] = 32'hbf490fdb; // -16 * pi/64 (-pi/4)
    rom[17] = 32'hbf55a0d8; // -17
    rom[18] = 32'hbf6231d6; // -18
    rom[19] = 32'hbf6ec2d4; // -19
    rom[20] = 32'hbf7b53d1; // -20
    rom[21] = 32'hbf83f267; // -21
    rom[22] = 32'hbf8a3ae6; // -22
    rom[23] = 32'hbf908365; // -23
    rom[24] = 32'hbf96cbe4; // -24
    rom[25] = 32'hbf9d1463; // -25
    rom[26] = 32'hbfa35ce2; // -26
    rom[27] = 32'hbfa9a560; // -27
    rom[28] = 32'hbfafeddf; // -28
    rom[29] = 32'hbfb6365e; // -29
    rom[30] = 32'hbfbc7edd; // -30
    rom[31] = 32'hbfc2c75c; // -31
    rom[32] = 32'hbfc90fdb; // -32 * pi/64 (-pi/2)
    rom[33] = 32'hbfcf5859; // -33
    rom[34] = 32'hbfd5a0d8; // -34
    rom[35] = 32'hbfdbe957; // -35
    rom[36] = 32'hbfe231d6; // -36
    rom[37] = 32'hbfe87a55; // -37
    rom[38] = 32'hbfeec2d4; // -38
    rom[39] = 32'hbff50b52; // -39
    rom[40] = 32'hbffb53d1; // -40
    rom[41] = 32'hc000ce28; // -41
    rom[42] = 32'hc003f267; // -42
    rom[43] = 32'hc00716a7; // -43
    rom[44] = 32'hc00a3ae6; // -44
    rom[45] = 32'hc00d5f26; // -45
    rom[46] = 32'hc0108365; // -46
    rom[47] = 32'hc013a7a5; // -47
    rom[48] = 32'hc016cbe4; // -48 * pi/64 (-3pi/4)
    rom[49] = 32'hc019f023; // -49
    rom[50] = 32'hc01d1463; // -50
    rom[51] = 32'hc02038a2; // -51
    rom[52] = 32'hc0235ce2; // -52
    rom[53] = 32'hc0268121; // -53
    rom[54] = 32'hc029a560; // -54
    rom[55] = 32'hc02cc9a0; // -55
    rom[56] = 32'hc02feddf; // -56
    rom[57] = 32'hc033121f; // -57
    rom[58] = 32'hc036365e; // -58
    rom[59] = 32'hc0395a9e; // -59
    rom[60] = 32'hc03c7edd; // -60
    rom[61] = 32'hc03fa31c; // -61
    rom[62] = 32'hc042c75c; // -62
    rom[63] = 32'hc045eb9b; // -63
end

always @(posedge i_clk) begin
    o_data <= rom[i_addr];
end

endmodule
