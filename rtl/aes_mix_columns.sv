//////////////////////////////////////////////
// 
// AES mix columns step
//
// aes_mix_columns.sv
//
// By: Jake Alt
// 30 May 2023
// 
//////////////////////////////////////////////


module aes_mix_columns (
	input clk_i,
	input rst_i,
	input fwd_ninv_i,
	input logic  [31:0] col_i
	output logic [31:0] col_o
);
	logic fwd;
	assign fwd = fwd_ninv_i;

	logic [7:0] rows [0:3];
	logic [7:0] bytes_buf [0:3];

	assign rows[0] = col_i[7:0];
	assign rows[1] = col_i[15:8];
	assign rows[2] = col_i[23:16];
	assign rows[3] = col_i[31:24];

	logic [7:0] a_1a, a_1b, a_2, a_3;

	assign a_1a = fwd ? 8'h01 : 8'h09;
	assign a_1b = fwd ? 8'h01 : 8'h0d;
	assign a_2  = fwd ? 8'h02 : 8'h0e;
	assign a_3  = fwd ? 8'h03 : 8'h0b;

	always_comb begin
		bytes_buf[0] = a_2  * rows[0] + a_3  * rows[1] + a_1b * rows[2] + a_1a * rows[3];
		bytes_buf[1] = a_1a * rows[0] + a_2  * rows[1] + a_3  * rows[2] + a_1b * rows[3];
		bytes_buf[2] = a_1b * rows[0] + a_1a * rows[1] + a_2  * rows[2] + a_3  * rows[3];
		bytes_buf[3] = a_3  * rows[0] + a_1b * rows[1] + a_1a * rows[2] + a_2  * rows[3];
	end
endmodule