`timescale 1ns/1ps

module tb_cordic;

    //==== 1. Khai báo tín hiệu ====
    logic i_clk = 0;
    logic i_reset = 0;
    
    // Inputs
    logic [31:0] i_x;
    logic [31:0] i_y;
    logic [31:0] i_z;

    // Outputs
    logic [31:0] o_x;
    logic [31:0] o_y;

    //==== 2. Kết nối DUT ====
    cordic dut (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_x(i_x),
        .i_y(i_y),
        .i_z(i_z),
        .o_x(o_x),
        .o_y(o_y)
    );

    //==== 3. Tạo xung Clock ====
    initial begin
        i_clk = 0;
        forever #1 i_clk = ~i_clk;
    end

    //==== 4. Kịch bản kiểm tra ====
    initial begin
        $dumpfile("cordic_wave.vcd"); 
        $dumpvars(0, tb_cordic);

        i_reset = 0;
        i_x = 32'h0; i_y = 32'h0; i_z = 32'h0;

        #4 i_reset = 1; 

        repeat_test_cases();

        #20;
        $finish;
    end

    //==== 5. Task chạy test ====
    task repeat_test_cases;
        integer i;
        reg [31:0] test_angles [0:359];
        begin
            // Các góc mẫu (Floating Point)
        test_angles[0] = 32'h00000000; // 0 degrees
        test_angles[1] = 32'h3c8efa35; // 1 degrees
        test_angles[2] = 32'h3d0efa35; // 2 degrees
        test_angles[3] = 32'h3d567750; // 3 degrees
        test_angles[4] = 32'h3d8efa35; // 4 degrees
        test_angles[5] = 32'h3db2b8c2; // 5 degrees
        test_angles[6] = 32'h3dd67750; // 6 degrees
        test_angles[7] = 32'h3dfa35dd; // 7 degrees
        test_angles[8] = 32'h3e0efa35; // 8 degrees
        test_angles[9] = 32'h3e20d97c; // 9 degrees
        test_angles[10] = 32'h3e32b8c2; // 10 degrees
        test_angles[11] = 32'h3e449809; // 11 degrees
        test_angles[12] = 32'h3e567750; // 12 degrees
        test_angles[13] = 32'h3e685696; // 13 degrees
        test_angles[14] = 32'h3e7a35dd; // 14 degrees
        test_angles[15] = 32'h3e860a92; // 15 degrees
        test_angles[16] = 32'h3e8efa35; // 16 degrees
        test_angles[17] = 32'h3e97e9d8; // 17 degrees
        test_angles[18] = 32'h3ea0d97c; // 18 degrees
        test_angles[19] = 32'h3ea9c91f; // 19 degrees
        test_angles[20] = 32'h3eb2b8c2; // 20 degrees
        test_angles[21] = 32'h3ebba866; // 21 degrees
        test_angles[22] = 32'h3ec49809; // 22 degrees
        test_angles[23] = 32'h3ecd87ac; // 23 degrees
        test_angles[24] = 32'h3ed67750; // 24 degrees
        test_angles[25] = 32'h3edf66f3; // 25 degrees
        test_angles[26] = 32'h3ee85696; // 26 degrees
        test_angles[27] = 32'h3ef1463a; // 27 degrees
        test_angles[28] = 32'h3efa35dd; // 28 degrees
        test_angles[29] = 32'h3f0192c0; // 29 degrees
        test_angles[30] = 32'h3f060a92; // 30 degrees
        test_angles[31] = 32'h3f0a8263; // 31 degrees
        test_angles[32] = 32'h3f0efa35; // 32 degrees
        test_angles[33] = 32'h3f137207; // 33 degrees
        test_angles[34] = 32'h3f17e9d8; // 34 degrees
        test_angles[35] = 32'h3f1c61aa; // 35 degrees
        test_angles[36] = 32'h3f20d97c; // 36 degrees
        test_angles[37] = 32'h3f25514d; // 37 degrees
        test_angles[38] = 32'h3f29c91f; // 38 degrees
        test_angles[39] = 32'h3f2e40f1; // 39 degrees
        test_angles[40] = 32'h3f32b8c2; // 40 degrees
        test_angles[41] = 32'h3f373094; // 41 degrees
        test_angles[42] = 32'h3f3ba866; // 42 degrees
        test_angles[43] = 32'h3f402037; // 43 degrees
        test_angles[44] = 32'h3f449809; // 44 degrees
        test_angles[45] = 32'h3f490fdb; // 45 degrees
        test_angles[46] = 32'h3f4d87ac; // 46 degrees
        test_angles[47] = 32'h3f51ff7e; // 47 degrees
        test_angles[48] = 32'h3f567750; // 48 degrees
        test_angles[49] = 32'h3f5aef21; // 49 degrees
        test_angles[50] = 32'h3f5f66f3; // 50 degrees
        test_angles[51] = 32'h3f63dec5; // 51 degrees
        test_angles[52] = 32'h3f685696; // 52 degrees
        test_angles[53] = 32'h3f6cce68; // 53 degrees
        test_angles[54] = 32'h3f71463a; // 54 degrees
        test_angles[55] = 32'h3f75be0b; // 55 degrees
        test_angles[56] = 32'h3f7a35dd; // 56 degrees
        test_angles[57] = 32'h3f7eadaf; // 57 degrees
        test_angles[58] = 32'h3f8192c0; // 58 degrees
        test_angles[59] = 32'h3f83cea9; // 59 degrees
        test_angles[60] = 32'h3f860a92; // 60 degrees
        test_angles[61] = 32'h3f88467b; // 61 degrees
        test_angles[62] = 32'h3f8a8263; // 62 degrees
        test_angles[63] = 32'h3f8cbe4c; // 63 degrees
        test_angles[64] = 32'h3f8efa35; // 64 degrees
        test_angles[65] = 32'h3f91361e; // 65 degrees
        test_angles[66] = 32'h3f937207; // 66 degrees
        test_angles[67] = 32'h3f95adf0; // 67 degrees
        test_angles[68] = 32'h3f97e9d8; // 68 degrees
        test_angles[69] = 32'h3f9a25c1; // 69 degrees
        test_angles[70] = 32'h3f9c61aa; // 70 degrees
        test_angles[71] = 32'h3f9e9d93; // 71 degrees
        test_angles[72] = 32'h3fa0d97c; // 72 degrees
        test_angles[73] = 32'h3fa31565; // 73 degrees
        test_angles[74] = 32'h3fa5514d; // 74 degrees
        test_angles[75] = 32'h3fa78d36; // 75 degrees
        test_angles[76] = 32'h3fa9c91f; // 76 degrees
        test_angles[77] = 32'h3fac0508; // 77 degrees
        test_angles[78] = 32'h3fae40f1; // 78 degrees
        test_angles[79] = 32'h3fb07cda; // 79 degrees
        test_angles[80] = 32'h3fb2b8c2; // 80 degrees
        test_angles[81] = 32'h3fb4f4ab; // 81 degrees
        test_angles[82] = 32'h3fb73094; // 82 degrees
        test_angles[83] = 32'h3fb96c7d; // 83 degrees
        test_angles[84] = 32'h3fbba866; // 84 degrees
        test_angles[85] = 32'h3fbde44e; // 85 degrees
        test_angles[86] = 32'h3fc02037; // 86 degrees
        test_angles[87] = 32'h3fc25c20; // 87 degrees
        test_angles[88] = 32'h3fc49809; // 88 degrees
        test_angles[89] = 32'h3fc6d3f2; // 89 degrees
        test_angles[90] = 32'h3fc90fdb; // 90 degrees
        test_angles[91] = 32'h3fcb4bc3; // 91 degrees
        test_angles[92] = 32'h3fcd87ac; // 92 degrees
        test_angles[93] = 32'h3fcfc395; // 93 degrees
        test_angles[94] = 32'h3fd1ff7e; // 94 degrees
        test_angles[95] = 32'h3fd43b67; // 95 degrees
        test_angles[96] = 32'h3fd67750; // 96 degrees
        test_angles[97] = 32'h3fd8b338; // 97 degrees
        test_angles[98] = 32'h3fdaef21; // 98 degrees
        test_angles[99] = 32'h3fdd2b0a; // 99 degrees
        test_angles[100] = 32'h3fdf66f3; // 100 degrees
        test_angles[101] = 32'h3fe1a2dc; // 101 degrees
        test_angles[102] = 32'h3fe3dec5; // 102 degrees
        test_angles[103] = 32'h3fe61aad; // 103 degrees
        test_angles[104] = 32'h3fe85696; // 104 degrees
        test_angles[105] = 32'h3fea927f; // 105 degrees
        test_angles[106] = 32'h3fecce68; // 106 degrees
        test_angles[107] = 32'h3fef0a51; // 107 degrees
        test_angles[108] = 32'h3ff1463a; // 108 degrees
        test_angles[109] = 32'h3ff38222; // 109 degrees
        test_angles[110] = 32'h3ff5be0b; // 110 degrees
        test_angles[111] = 32'h3ff7f9f4; // 111 degrees
        test_angles[112] = 32'h3ffa35dd; // 112 degrees
        test_angles[113] = 32'h3ffc71c6; // 113 degrees
        test_angles[114] = 32'h3ffeadaf; // 114 degrees
        test_angles[115] = 32'h400074cc; // 115 degrees
        test_angles[116] = 32'h400192c0; // 116 degrees
        test_angles[117] = 32'h4002b0b5; // 117 degrees
        test_angles[118] = 32'h4003cea9; // 118 degrees
        test_angles[119] = 32'h4004ec9d; // 119 degrees
        test_angles[120] = 32'h40060a92; // 120 degrees
        test_angles[121] = 32'h40072886; // 121 degrees
        test_angles[122] = 32'h4008467b; // 122 degrees
        test_angles[123] = 32'h4009646f; // 123 degrees
        test_angles[124] = 32'h400a8263; // 124 degrees
        test_angles[125] = 32'h400ba058; // 125 degrees
        test_angles[126] = 32'h400cbe4c; // 126 degrees
        test_angles[127] = 32'h400ddc41; // 127 degrees
        test_angles[128] = 32'h400efa35; // 128 degrees
        test_angles[129] = 32'h40101829; // 129 degrees
        test_angles[130] = 32'h4011361e; // 130 degrees
        test_angles[131] = 32'h40125412; // 131 degrees
        test_angles[132] = 32'h40137207; // 132 degrees
        test_angles[133] = 32'h40148ffb; // 133 degrees
        test_angles[134] = 32'h4015adf0; // 134 degrees
        test_angles[135] = 32'h4016cbe4; // 135 degrees
        test_angles[136] = 32'h4017e9d8; // 136 degrees
        test_angles[137] = 32'h401907cd; // 137 degrees
        test_angles[138] = 32'h401a25c1; // 138 degrees
        test_angles[139] = 32'h401b43b6; // 139 degrees
        test_angles[140] = 32'h401c61aa; // 140 degrees
        test_angles[141] = 32'h401d7f9e; // 141 degrees
        test_angles[142] = 32'h401e9d93; // 142 degrees
        test_angles[143] = 32'h401fbb87; // 143 degrees
        test_angles[144] = 32'h4020d97c; // 144 degrees
        test_angles[145] = 32'h4021f770; // 145 degrees
        test_angles[146] = 32'h40231565; // 146 degrees
        test_angles[147] = 32'h40243359; // 147 degrees
        test_angles[148] = 32'h4025514d; // 148 degrees
        test_angles[149] = 32'h40266f42; // 149 degrees
        test_angles[150] = 32'h40278d36; // 150 degrees
        test_angles[151] = 32'h4028ab2b; // 151 degrees
        test_angles[152] = 32'h4029c91f; // 152 degrees
        test_angles[153] = 32'h402ae713; // 153 degrees
        test_angles[154] = 32'h402c0508; // 154 degrees
        test_angles[155] = 32'h402d22fc; // 155 degrees
        test_angles[156] = 32'h402e40f1; // 156 degrees
        test_angles[157] = 32'h402f5ee5; // 157 degrees
        test_angles[158] = 32'h40307cda; // 158 degrees
        test_angles[159] = 32'h40319ace; // 159 degrees
        test_angles[160] = 32'h4032b8c2; // 160 degrees
        test_angles[161] = 32'h4033d6b7; // 161 degrees
        test_angles[162] = 32'h4034f4ab; // 162 degrees
        test_angles[163] = 32'h403612a0; // 163 degrees
        test_angles[164] = 32'h40373094; // 164 degrees
        test_angles[165] = 32'h40384e88; // 165 degrees
        test_angles[166] = 32'h40396c7d; // 166 degrees
        test_angles[167] = 32'h403a8a71; // 167 degrees
        test_angles[168] = 32'h403ba866; // 168 degrees
        test_angles[169] = 32'h403cc65a; // 169 degrees
        test_angles[170] = 32'h403de44e; // 170 degrees
        test_angles[171] = 32'h403f0243; // 171 degrees
        test_angles[172] = 32'h40402037; // 172 degrees
        test_angles[173] = 32'h40413e2c; // 173 degrees
        test_angles[174] = 32'h40425c20; // 174 degrees
        test_angles[175] = 32'h40437a15; // 175 degrees
        test_angles[176] = 32'h40449809; // 176 degrees
        test_angles[177] = 32'h4045b5fd; // 177 degrees
        test_angles[178] = 32'h4046d3f2; // 178 degrees
        test_angles[179] = 32'h4047f1e6; // 179 degrees
        test_angles[180] = 32'h40490fdb; // 180 degrees
        test_angles[181] = 32'h404a2dcf; // 181 degrees
        test_angles[182] = 32'h404b4bc3; // 182 degrees
        test_angles[183] = 32'h404c69b8; // 183 degrees
        test_angles[184] = 32'h404d87ac; // 184 degrees
        test_angles[185] = 32'h404ea5a1; // 185 degrees
        test_angles[186] = 32'h404fc395; // 186 degrees
        test_angles[187] = 32'h4050e18a; // 187 degrees
        test_angles[188] = 32'h4051ff7e; // 188 degrees
        test_angles[189] = 32'h40531d72; // 189 degrees
        test_angles[190] = 32'h40543b67; // 190 degrees
        test_angles[191] = 32'h4055595b; // 191 degrees
        test_angles[192] = 32'h40567750; // 192 degrees
        test_angles[193] = 32'h40579544; // 193 degrees
        test_angles[194] = 32'h4058b338; // 194 degrees
        test_angles[195] = 32'h4059d12d; // 195 degrees
        test_angles[196] = 32'h405aef21; // 196 degrees
        test_angles[197] = 32'h405c0d16; // 197 degrees
        test_angles[198] = 32'h405d2b0a; // 198 degrees
        test_angles[199] = 32'h405e48ff; // 199 degrees
        test_angles[200] = 32'h405f66f3; // 200 degrees
        test_angles[201] = 32'h406084e7; // 201 degrees
        test_angles[202] = 32'h4061a2dc; // 202 degrees
        test_angles[203] = 32'h4062c0d0; // 203 degrees
        test_angles[204] = 32'h4063dec5; // 204 degrees
        test_angles[205] = 32'h4064fcb9; // 205 degrees
        test_angles[206] = 32'h40661aad; // 206 degrees
        test_angles[207] = 32'h406738a2; // 207 degrees
        test_angles[208] = 32'h40685696; // 208 degrees
        test_angles[209] = 32'h4069748b; // 209 degrees
        test_angles[210] = 32'h406a927f; // 210 degrees
        test_angles[211] = 32'h406bb073; // 211 degrees
        test_angles[212] = 32'h406cce68; // 212 degrees
        test_angles[213] = 32'h406dec5c; // 213 degrees
        test_angles[214] = 32'h406f0a51; // 214 degrees
        test_angles[215] = 32'h40702845; // 215 degrees
        test_angles[216] = 32'h4071463a; // 216 degrees
        test_angles[217] = 32'h4072642e; // 217 degrees
        test_angles[218] = 32'h40738222; // 218 degrees
        test_angles[219] = 32'h4074a017; // 219 degrees
        test_angles[220] = 32'h4075be0b; // 220 degrees
        test_angles[221] = 32'h4076dc00; // 221 degrees
        test_angles[222] = 32'h4077f9f4; // 222 degrees
        test_angles[223] = 32'h407917e8; // 223 degrees
        test_angles[224] = 32'h407a35dd; // 224 degrees
        test_angles[225] = 32'h407b53d1; // 225 degrees
        test_angles[226] = 32'h407c71c6; // 226 degrees
        test_angles[227] = 32'h407d8fba; // 227 degrees
        test_angles[228] = 32'h407eadaf; // 228 degrees
        test_angles[229] = 32'h407fcba3; // 229 degrees
        test_angles[230] = 32'h408074cc; // 230 degrees
        test_angles[231] = 32'h408103c6; // 231 degrees
        test_angles[232] = 32'h408192c0; // 232 degrees
        test_angles[233] = 32'h408221ba; // 233 degrees
        test_angles[234] = 32'h4082b0b5; // 234 degrees
        test_angles[235] = 32'h40833faf; // 235 degrees
        test_angles[236] = 32'h4083cea9; // 236 degrees
        test_angles[237] = 32'h40845da3; // 237 degrees
        test_angles[238] = 32'h4084ec9d; // 238 degrees
        test_angles[239] = 32'h40857b98; // 239 degrees
        test_angles[240] = 32'h40860a92; // 240 degrees
        test_angles[241] = 32'h4086998c; // 241 degrees
        test_angles[242] = 32'h40872886; // 242 degrees
        test_angles[243] = 32'h4087b780; // 243 degrees
        test_angles[244] = 32'h4088467b; // 244 degrees
        test_angles[245] = 32'h4088d575; // 245 degrees
        test_angles[246] = 32'h4089646f; // 246 degrees
        test_angles[247] = 32'h4089f369; // 247 degrees
        test_angles[248] = 32'h408a8263; // 248 degrees
        test_angles[249] = 32'h408b115e; // 249 degrees
        test_angles[250] = 32'h408ba058; // 250 degrees
        test_angles[251] = 32'h408c2f52; // 251 degrees
        test_angles[252] = 32'h408cbe4c; // 252 degrees
        test_angles[253] = 32'h408d4d46; // 253 degrees
        test_angles[254] = 32'h408ddc41; // 254 degrees
        test_angles[255] = 32'h408e6b3b; // 255 degrees
        test_angles[256] = 32'h408efa35; // 256 degrees
        test_angles[257] = 32'h408f892f; // 257 degrees
        test_angles[258] = 32'h40901829; // 258 degrees
        test_angles[259] = 32'h4090a724; // 259 degrees
        test_angles[260] = 32'h4091361e; // 260 degrees
        test_angles[261] = 32'h4091c518; // 261 degrees
        test_angles[262] = 32'h40925412; // 262 degrees
        test_angles[263] = 32'h4092e30d; // 263 degrees
        test_angles[264] = 32'h40937207; // 264 degrees
        test_angles[265] = 32'h40940101; // 265 degrees
        test_angles[266] = 32'h40948ffb; // 266 degrees
        test_angles[267] = 32'h40951ef5; // 267 degrees
        test_angles[268] = 32'h4095adf0; // 268 degrees
        test_angles[269] = 32'h40963cea; // 269 degrees
        test_angles[270] = 32'h4096cbe4; // 270 degrees
        test_angles[271] = 32'h40975ade; // 271 degrees
        test_angles[272] = 32'h4097e9d8; // 272 degrees
        test_angles[273] = 32'h409878d3; // 273 degrees
        test_angles[274] = 32'h409907cd; // 274 degrees
        test_angles[275] = 32'h409996c7; // 275 degrees
        test_angles[276] = 32'h409a25c1; // 276 degrees
        test_angles[277] = 32'h409ab4bb; // 277 degrees
        test_angles[278] = 32'h409b43b6; // 278 degrees
        test_angles[279] = 32'h409bd2b0; // 279 degrees
        test_angles[280] = 32'h409c61aa; // 280 degrees
        test_angles[281] = 32'h409cf0a4; // 281 degrees
        test_angles[282] = 32'h409d7f9e; // 282 degrees
        test_angles[283] = 32'h409e0e99; // 283 degrees
        test_angles[284] = 32'h409e9d93; // 284 degrees
        test_angles[285] = 32'h409f2c8d; // 285 degrees
        test_angles[286] = 32'h409fbb87; // 286 degrees
        test_angles[287] = 32'h40a04a81; // 287 degrees
        test_angles[288] = 32'h40a0d97c; // 288 degrees
        test_angles[289] = 32'h40a16876; // 289 degrees
        test_angles[290] = 32'h40a1f770; // 290 degrees
        test_angles[291] = 32'h40a2866a; // 291 degrees
        test_angles[292] = 32'h40a31565; // 292 degrees
        test_angles[293] = 32'h40a3a45f; // 293 degrees
        test_angles[294] = 32'h40a43359; // 294 degrees
        test_angles[295] = 32'h40a4c253; // 295 degrees
        test_angles[296] = 32'h40a5514d; // 296 degrees
        test_angles[297] = 32'h40a5e048; // 297 degrees
        test_angles[298] = 32'h40a66f42; // 298 degrees
        test_angles[299] = 32'h40a6fe3c; // 299 degrees
        test_angles[300] = 32'h40a78d36; // 300 degrees
        test_angles[301] = 32'h40a81c30; // 301 degrees
        test_angles[302] = 32'h40a8ab2b; // 302 degrees
        test_angles[303] = 32'h40a93a25; // 303 degrees
        test_angles[304] = 32'h40a9c91f; // 304 degrees
        test_angles[305] = 32'h40aa5819; // 305 degrees
        test_angles[306] = 32'h40aae713; // 306 degrees
        test_angles[307] = 32'h40ab760e; // 307 degrees
        test_angles[308] = 32'h40ac0508; // 308 degrees
        test_angles[309] = 32'h40ac9402; // 309 degrees
        test_angles[310] = 32'h40ad22fc; // 310 degrees
        test_angles[311] = 32'h40adb1f6; // 311 degrees
        test_angles[312] = 32'h40ae40f1; // 312 degrees
        test_angles[313] = 32'h40aecfeb; // 313 degrees
        test_angles[314] = 32'h40af5ee5; // 314 degrees
        test_angles[315] = 32'h40afeddf; // 315 degrees
        test_angles[316] = 32'h40b07cda; // 316 degrees
        test_angles[317] = 32'h40b10bd4; // 317 degrees
        test_angles[318] = 32'h40b19ace; // 318 degrees
        test_angles[319] = 32'h40b229c8; // 319 degrees
        test_angles[320] = 32'h40b2b8c2; // 320 degrees
        test_angles[321] = 32'h40b347bd; // 321 degrees
        test_angles[322] = 32'h40b3d6b7; // 322 degrees
        test_angles[323] = 32'h40b465b1; // 323 degrees
        test_angles[324] = 32'h40b4f4ab; // 324 degrees
        test_angles[325] = 32'h40b583a5; // 325 degrees
        test_angles[326] = 32'h40b612a0; // 326 degrees
        test_angles[327] = 32'h40b6a19a; // 327 degrees
        test_angles[328] = 32'h40b73094; // 328 degrees
        test_angles[329] = 32'h40b7bf8e; // 329 degrees
        test_angles[330] = 32'h40b84e88; // 330 degrees
        test_angles[331] = 32'h40b8dd83; // 331 degrees
        test_angles[332] = 32'h40b96c7d; // 332 degrees
        test_angles[333] = 32'h40b9fb77; // 333 degrees
        test_angles[334] = 32'h40ba8a71; // 334 degrees
        test_angles[335] = 32'h40bb196b; // 335 degrees
        test_angles[336] = 32'h40bba866; // 336 degrees
        test_angles[337] = 32'h40bc3760; // 337 degrees
        test_angles[338] = 32'h40bcc65a; // 338 degrees
        test_angles[339] = 32'h40bd5554; // 339 degrees
        test_angles[340] = 32'h40bde44e; // 340 degrees
        test_angles[341] = 32'h40be7349; // 341 degrees
        test_angles[342] = 32'h40bf0243; // 342 degrees
        test_angles[343] = 32'h40bf913d; // 343 degrees
        test_angles[344] = 32'h40c02037; // 344 degrees
        test_angles[345] = 32'h40c0af32; // 345 degrees
        test_angles[346] = 32'h40c13e2c; // 346 degrees
        test_angles[347] = 32'h40c1cd26; // 347 degrees
        test_angles[348] = 32'h40c25c20; // 348 degrees
        test_angles[349] = 32'h40c2eb1a; // 349 degrees
        test_angles[350] = 32'h40c37a15; // 350 degrees
        test_angles[351] = 32'h40c4090f; // 351 degrees
        test_angles[352] = 32'h40c49809; // 352 degrees
        test_angles[353] = 32'h40c52703; // 353 degrees
        test_angles[354] = 32'h40c5b5fd; // 354 degrees
        test_angles[355] = 32'h40c644f8; // 355 degrees
        test_angles[356] = 32'h40c6d3f2; // 356 degrees
        test_angles[357] = 32'h40c762ec; // 357 degrees
        test_angles[358] = 32'h40c7f1e6; // 358 degrees
        test_angles[359] = 32'h40c880e0; // 359 degrees

            for (i = 0; i < 360; i = i + 1) begin
                @(posedge i_clk);
                
                // Input vector (1.0, 0.0)
                i_x = 32'h3f800000; 
                i_y = 32'h00000000; 
                i_z = test_angles[i];

                // Chờ pipeline (ví dụ 24 cycles)
                repeat (24) @(posedge i_clk);

                $display("\n==== TEST CASE %0d ====", i);
                // IN THEO ĐỊNH DẠNG: 1_8_23 bits
                $display("Angle: %b_%b_%b  (Hex: %h)", 
                         test_angles[i][31], test_angles[i][30:23], test_angles[i][22:0], test_angles[i]);
                                  
                $display("Sin  : %b_%b_%b  (Hex: %h)", 
                         o_y[31], o_y[30:23], o_y[22:0], o_y);
                
                $display("Cos  : %b_%b_%b  (Hex: %h)", 
                         o_x[31], o_x[30:23], o_x[22:0], o_x);
            end
        end
    endtask

endmodule
