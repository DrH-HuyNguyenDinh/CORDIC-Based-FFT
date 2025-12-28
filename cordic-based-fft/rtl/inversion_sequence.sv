module inversion_sequence (
	input logic [9:0] i_seq_addr,
	output logic [9:0] o_rev_addr
);

assign o_rev_addr = {i_seq_addr[0], i_seq_addr[1], i_seq_addr[2], i_seq_addr[3], i_seq_addr[4],
                     i_seq_addr[5], i_seq_addr[6], i_seq_addr[7], i_seq_addr[8], i_seq_addr[9]};
endmodule
