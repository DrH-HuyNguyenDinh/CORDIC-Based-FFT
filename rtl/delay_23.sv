module delay_23 (
    input logic i_clk, i_reset,
    input logic [31:0] i_data,

    output logic [31:0] o_data
);

logic [31:0] data1,  data2,  data3, 
             data4,  data5,  data6, 
             data7,  data8,  data9, 
             data10, data11, data12, 
             data13, data14, data15, 
             data16, data17, data18, 
             data19, data20, data21, data22;

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        data1  <= 0;
        data2  <= 0;
        data3  <= 0;
        data4  <= 0;
        data5  <= 0;
        data6  <= 0;
        data7  <= 0;
        data8  <= 0;
        data9  <= 0;
        data10 <= 0;
        data11 <= 0;
        data12 <= 0;
        data13 <= 0;
        data14 <= 0;
        data15 <= 0;
        data16 <= 0;
        data17 <= 0;
        data18 <= 0;
        data19 <= 0;
        data20 <= 0;
        data21 <= 0;
        data22 <= 0;
        o_data <= 0;
    end else begin
        data1  <= i_data;
        data2  <= data1;
        data3  <= data2;
        data4  <= data3;
        data5  <= data4;
        data6  <= data5;
        data7  <= data6;
        data8  <= data7;
        data9  <= data8;
        data10 <= data9;
        data11 <= data10;
        data12 <= data11;
        data13 <= data12;
        data14 <= data13;
        data15 <= data14;
        data16 <= data15;
        data17 <= data16;
        data18 <= data17;
        data19 <= data18;
        data20 <= data19;
        data21 <= data20;
        data22 <= data21;
        o_data <= data22;
    end
end

endmodule
