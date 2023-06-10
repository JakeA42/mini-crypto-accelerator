

module aes_round #(
	parameter last_round = '0
) (
	input clk_i,
	input rst_i,
	input decrypt,
	input [127:0] key_i,
	input [127:0] block_i,
	output logic [127:0] block_o
);
    // for 10 rounds
        // state = sub_bytes(state)
        // state = shift_rows(state)
        // state = mix_columns(state)
        // state = add_round_key(state)

    // state = sub_bytes(state)
    // state = shift_rows(state)
    // state = add_round_key(state)

	function [127:0] transpose (input [127:0] a);
		transpose = {
			a[127:120], a[95:88], a[63:56], a[31:24],
			a[119:112], a[87:80], a[55:48], a[23:16],
			a[111:104], a[79:72], a[47:40], a[15: 8],
			a[103: 96], a[71:64], a[39:32], a[ 7: 0]
		};
	endfunction

	logic inv;
	assign inv = !decrypt;

	logic [127:0] sb_in, sb_out;
	logic [127:0] sr_in, sr_out;
	logic [127:0] mc_in, mc_out;
	logic [127:0] ark_in, ark_out;

	always_comb begin
		if (decrypt) begin
			ark_in = block_i;
			mc_in = transpose(ark_out);
			sr_in = mc_out;
			sb_in = transpose(sr_out);
			block_o = sb_out;
		end else begin
			sb_in = block_i;
			sr_in = transpose(sb_out);
			mc_in = sr_out;
			ark_in = transpose(mc_out);
			block_o = ark_out;
		end
	end

	sub_bytes sb (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.fwd_ninv_i(inv),
		.in_state(sb_in),
		.out_state(sb_out)
	);
	
	shift_rows sr (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.fwd_ninv_i(inv),
		.in_state(sr_in),
		.out_state(sr_out)
	);

	generate
		if (last_round) begin
			assign mc_out = mc_in;
		end else begin
			mix_columns mc (
				.clk_i(clk_i),
				.rst_i(rst_i),
				.fwd_ninv_i(inv),
				.block_i(mc_in),
				.block_o(mc_out)
			);
		end
	endgenerate

	always_ff @(posedge clk_i) begin
		if (rst_i)
			ark_out <= '0;
		else
			ark_out <= ark_in ^ key_i;
	end	

endmodule