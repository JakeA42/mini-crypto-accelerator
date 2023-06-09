

module aes_round #(
	parameter last_round = '0
) (
	input clk_i,
	input rst_i,
	input decrypt,
	input [127:0] key_i,
	input [127:0] block_i,
	output [127:0] block_o
);
    // for 10 rounds
        // state = sub_bytes(state)
        // state = shift_rows(state)
        // state = mix_columns(state)
        // state = add_round_key(state)

    // state = sub_bytes(state)
    // state = shift_rows(state)
    // state = add_round_key(state) 
	logic [127:0] block_
	

endmodule