module butterfly (
	input logic i_clk, i_reset,

	input logic [31:0] i_A_real, i_A_imag,
	input logic [31:0] i_B_real, i_B_imag,
	
	output logic [31:0] o_A_new_real, o_A_new_imag,
	output logic [31:0] o_B_new_real, o_B_new_imag
);

logic [31:0] A_new_real, A_new_imag;
logic [31:0] B_new_real, B_new_imag;

fpu_add_sub real_plus  (.i_a(i_A_real), .i_b(i_B_real), .i_control(1'b0), .o_result(A_new_real));
fpu_add_sub imag_plus  (.i_a(i_A_imag), .i_b(i_B_imag), .i_control(1'b0), .o_result(A_new_imag));

fpu_add_sub real_minus (.i_a(i_A_real), .i_b(i_B_real), .i_control(1'b1), .o_result(B_new_real));
fpu_add_sub imag_minus (.i_a(i_A_imag), .i_b(i_B_imag), .i_control(1'b1), .o_result(B_new_imag));	

always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        o_A_new_real <= 32'b0;
        o_A_new_imag <= 32'b0;

        o_B_new_real <= 32'b0;
        o_B_new_imag <= 32'b0;
    end else begin
		o_A_new_real <= A_new_real;
        o_A_new_imag <= A_new_imag;

        o_B_new_real <= B_new_real;
        o_B_new_imag <= B_new_imag;
	end
end

endmodule
