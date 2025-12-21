module rom_stage_8 (
    input logic         i_clk,
    input logic [6:0]   i_addr,   // [THAY ĐỔI]: 7 bit cho 128 góc
    output logic [31:0] o_data
);

logic [31:0] rom [0:127];

initial begin
    rom[  0] = 32'h80000000; // k=0: -0.0000 deg
    rom[  1] = 32'hbcc90fdb; // k=1: -1.4062 deg
    rom[  2] = 32'hbd490fdb; // k=2: -2.8125 deg
    rom[  3] = 32'hbd96cbe4; // k=3: -4.2188 deg
    rom[  4] = 32'hbdc90fdb; // k=4: -5.6250 deg
    rom[  5] = 32'hbdfb53d1; // k=5: -7.0312 deg
    rom[  6] = 32'hbe16cbe4; // k=6: -8.4375 deg
    rom[  7] = 32'hbe2feddf; // k=7: -9.8438 deg
    rom[  8] = 32'hbe490fdb; // k=8: -11.2500 deg
    rom[  9] = 32'hbe6231d6; // k=9: -12.6562 deg
    rom[ 10] = 32'hbe7b53d1; // k=10: -14.0625 deg
    rom[ 11] = 32'hbe8a3ae6; // k=11: -15.4687 deg
    rom[ 12] = 32'hbe96cbe4; // k=12: -16.8750 deg
    rom[ 13] = 32'hbea35ce2; // k=13: -18.2812 deg
    rom[ 14] = 32'hbeafeddf; // k=14: -19.6875 deg
    rom[ 15] = 32'hbebc7edd; // k=15: -21.0938 deg
    rom[ 16] = 32'hbec90fdb; // k=16: -22.5000 deg
    rom[ 17] = 32'hbed5a0d8; // k=17: -23.9062 deg
    rom[ 18] = 32'hbee231d6; // k=18: -25.3125 deg
    rom[ 19] = 32'hbeeec2d4; // k=19: -26.7188 deg
    rom[ 20] = 32'hbefb53d1; // k=20: -28.1250 deg
    rom[ 21] = 32'hbf03f267; // k=21: -29.5312 deg
    rom[ 22] = 32'hbf0a3ae6; // k=22: -30.9375 deg
    rom[ 23] = 32'hbf108365; // k=23: -32.3438 deg
    rom[ 24] = 32'hbf16cbe4; // k=24: -33.7500 deg
    rom[ 25] = 32'hbf1d1463; // k=25: -35.1562 deg
    rom[ 26] = 32'hbf235ce2; // k=26: -36.5625 deg
    rom[ 27] = 32'hbf29a560; // k=27: -37.9688 deg
    rom[ 28] = 32'hbf2feddf; // k=28: -39.3750 deg
    rom[ 29] = 32'hbf36365e; // k=29: -40.7812 deg
    rom[ 30] = 32'hbf3c7edd; // k=30: -42.1875 deg
    rom[ 31] = 32'hbf42c75c; // k=31: -43.5938 deg
    rom[ 32] = 32'hbf490fdb; // k=32: -45.0000 deg
    rom[ 33] = 32'hbf4f5859; // k=33: -46.4062 deg
    rom[ 34] = 32'hbf55a0d8; // k=34: -47.8125 deg
    rom[ 35] = 32'hbf5be957; // k=35: -49.2188 deg
    rom[ 36] = 32'hbf6231d6; // k=36: -50.6250 deg
    rom[ 37] = 32'hbf687a55; // k=37: -52.0312 deg
    rom[ 38] = 32'hbf6ec2d4; // k=38: -53.4375 deg
    rom[ 39] = 32'hbf750b52; // k=39: -54.8438 deg
    rom[ 40] = 32'hbf7b53d1; // k=40: -56.2500 deg
    rom[ 41] = 32'hbf80ce28; // k=41: -57.6562 deg
    rom[ 42] = 32'hbf83f267; // k=42: -59.0625 deg
    rom[ 43] = 32'hbf8716a7; // k=43: -60.4688 deg
    rom[ 44] = 32'hbf8a3ae6; // k=44: -61.8750 deg
    rom[ 45] = 32'hbf8d5f26; // k=45: -63.2812 deg
    rom[ 46] = 32'hbf908365; // k=46: -64.6875 deg
    rom[ 47] = 32'hbf93a7a5; // k=47: -66.0938 deg
    rom[ 48] = 32'hbf96cbe4; // k=48: -67.5000 deg
    rom[ 49] = 32'hbf99f023; // k=49: -68.9062 deg
    rom[ 50] = 32'hbf9d1463; // k=50: -70.3125 deg
    rom[ 51] = 32'hbfa038a2; // k=51: -71.7188 deg
    rom[ 52] = 32'hbfa35ce2; // k=52: -73.1250 deg
    rom[ 53] = 32'hbfa68121; // k=53: -74.5312 deg
    rom[ 54] = 32'hbfa9a560; // k=54: -75.9375 deg
    rom[ 55] = 32'hbfacc9a0; // k=55: -77.3438 deg
    rom[ 56] = 32'hbfafeddf; // k=56: -78.7500 deg
    rom[ 57] = 32'hbfb3121f; // k=57: -80.1562 deg
    rom[ 58] = 32'hbfb6365e; // k=58: -81.5625 deg
    rom[ 59] = 32'hbfb95a9e; // k=59: -82.9688 deg
    rom[ 60] = 32'hbfbc7edd; // k=60: -84.3750 deg
    rom[ 61] = 32'hbfbfa31c; // k=61: -85.7812 deg
    rom[ 62] = 32'hbfc2c75c; // k=62: -87.1875 deg
    rom[ 63] = 32'hbfc5eb9b; // k=63: -88.5938 deg
    rom[ 64] = 32'hbfc90fdb; // k=64: -90.0000 deg
    rom[ 65] = 32'hbfcc341a; // k=65: -91.4062 deg
    rom[ 66] = 32'hbfcf5859; // k=66: -92.8125 deg
    rom[ 67] = 32'hbfd27c99; // k=67: -94.2188 deg
    rom[ 68] = 32'hbfd5a0d8; // k=68: -95.6250 deg
    rom[ 69] = 32'hbfd8c518; // k=69: -97.0312 deg
    rom[ 70] = 32'hbfdbe957; // k=70: -98.4375 deg
    rom[ 71] = 32'hbfdf0d97; // k=71: -99.8438 deg
    rom[ 72] = 32'hbfe231d6; // k=72: -101.2500 deg
    rom[ 73] = 32'hbfe55615; // k=73: -102.6562 deg
    rom[ 74] = 32'hbfe87a55; // k=74: -104.0625 deg
    rom[ 75] = 32'hbfeb9e94; // k=75: -105.4688 deg
    rom[ 76] = 32'hbfeec2d4; // k=76: -106.8750 deg
    rom[ 77] = 32'hbff1e713; // k=77: -108.2812 deg
    rom[ 78] = 32'hbff50b52; // k=78: -109.6875 deg
    rom[ 79] = 32'hbff82f92; // k=79: -111.0938 deg
    rom[ 80] = 32'hbffb53d1; // k=80: -112.5000 deg
    rom[ 81] = 32'hbffe7811; // k=81: -113.9062 deg
    rom[ 82] = 32'hc000ce28; // k=82: -115.3125 deg
    rom[ 83] = 32'hc0026048; // k=83: -116.7188 deg
    rom[ 84] = 32'hc003f267; // k=84: -118.1250 deg
    rom[ 85] = 32'hc0058487; // k=85: -119.5312 deg
    rom[ 86] = 32'hc00716a7; // k=86: -120.9375 deg
    rom[ 87] = 32'hc008a8c7; // k=87: -122.3437 deg
    rom[ 88] = 32'hc00a3ae6; // k=88: -123.7500 deg
    rom[ 89] = 32'hc00bcd06; // k=89: -125.1563 deg
    rom[ 90] = 32'hc00d5f26; // k=90: -126.5625 deg
    rom[ 91] = 32'hc00ef145; // k=91: -127.9688 deg
    rom[ 92] = 32'hc0108365; // k=92: -129.3750 deg
    rom[ 93] = 32'hc0121585; // k=93: -130.7812 deg
    rom[ 94] = 32'hc013a7a5; // k=94: -132.1875 deg
    rom[ 95] = 32'hc01539c4; // k=95: -133.5938 deg
    rom[ 96] = 32'hc016cbe4; // k=96: -135.0000 deg
    rom[ 97] = 32'hc0185e04; // k=97: -136.4062 deg
    rom[ 98] = 32'hc019f023; // k=98: -137.8125 deg
    rom[ 99] = 32'hc01b8243; // k=99: -139.2188 deg
    rom[100] = 32'hc01d1463; // k=100: -140.6250 deg
    rom[101] = 32'hc01ea683; // k=101: -142.0312 deg
    rom[102] = 32'hc02038a2; // k=102: -143.4375 deg
    rom[103] = 32'hc021cac2; // k=103: -144.8438 deg
    rom[104] = 32'hc0235ce2; // k=104: -146.2500 deg
    rom[105] = 32'hc024ef01; // k=105: -147.6562 deg
    rom[106] = 32'hc0268121; // k=106: -149.0625 deg
    rom[107] = 32'hc0281341; // k=107: -150.4688 deg
    rom[108] = 32'hc029a560; // k=108: -151.8750 deg
    rom[109] = 32'hc02b3780; // k=109: -153.2812 deg
    rom[110] = 32'hc02cc9a0; // k=110: -154.6875 deg
    rom[111] = 32'hc02e5bc0; // k=111: -156.0938 deg
    rom[112] = 32'hc02feddf; // k=112: -157.5000 deg
    rom[113] = 32'hc0317fff; // k=113: -158.9062 deg
    rom[114] = 32'hc033121f; // k=114: -160.3125 deg
    rom[115] = 32'hc034a43e; // k=115: -161.7188 deg
    rom[116] = 32'hc036365e; // k=116: -163.1250 deg
    rom[117] = 32'hc037c87e; // k=117: -164.5312 deg
    rom[118] = 32'hc0395a9e; // k=118: -165.9375 deg
    rom[119] = 32'hc03aecbd; // k=119: -167.3438 deg
    rom[120] = 32'hc03c7edd; // k=120: -168.7500 deg
    rom[121] = 32'hc03e10fd; // k=121: -170.1562 deg
    rom[122] = 32'hc03fa31c; // k=122: -171.5625 deg
    rom[123] = 32'hc041353c; // k=123: -172.9688 deg
    rom[124] = 32'hc042c75c; // k=124: -174.3750 deg
    rom[125] = 32'hc044597c; // k=125: -175.7812 deg
    rom[126] = 32'hc045eb9b; // k=126: -177.1875 deg
    rom[127] = 32'hc0477dbb; // k=127: -178.5938 deg
end

always @(posedge i_clk) begin
    o_data <= rom[i_addr];
end

endmodule
