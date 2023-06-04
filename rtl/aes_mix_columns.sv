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
	input logic  [31:0] col_i,
	output logic [31:0] col_o
);
	logic fwd;
	assign fwd = fwd_ninv_i;

	logic [7:0] rows [0:3];
	logic [7:0] bytes_buf [0:3];

	assign rows[3] = col_i[7:0];
	assign rows[2] = col_i[15:8];
	assign rows[1] = col_i[23:16];
	assign rows[0] = col_i[31:24];

	logic [7:0] a_1a, a_1b, a_2, a_3;

	assign a_1a = fwd ? 8'h01 : 8'h09;
	assign a_1b = fwd ? 8'h01 : 8'h0d;
	assign a_2  = fwd ? 8'h02 : 8'h0e;
	assign a_3  = fwd ? 8'h03 : 8'h0b;

    assign col_o = {bytes_buf[0],bytes_buf[1],bytes_buf[2],bytes_buf[3]};

	function [7:0] gmul_2(input [7:0] a);
		//gmul_2 = {a[6:0], 1'd0};
		//gmul_2 ^= a[7] ? 8'h1b : 8'h00; 
		gmul_2 = {a[6:0],1'd0} ^ (8'h1b & {8{a[7]}});
	endfunction

	function [7:0] gmul_3(input [7:0] a);
		gmul_3 = gmul_2(a) ^ a;
	endfunction

	function [7:0] gmul_9(input [7:0] a);
		//gmul_9 = gmul_3(gmul_3(a));
		gmul_9 = gmul_2(gmul_2(gmul_2(a))) ^ a;
	endfunction

	function [7:0] gmul_b(input [7:0] a);
		// b = 11 -> a * 9 + a * 2
		// a*2*2*2 + a*2 + a
		//gmul_b = gmul_9(a) ^ gmul_2(a);
		gmul_b = gmul_2(gmul_2(gmul_2(a))) ^ gmul_2(a) ^ a;
	endfunction

	function [7:0] gmul_d(input [7:0] a);
		// d = 13 -> a * 9 + a * 2 * 2
		// a*2*2*2 + a*2*2 + a
		//gmul_d = gmul_9(a) ^ gmul_2(gmul_2(a));
		gmul_d = gmul_2(gmul_2(gmul_2(a))) ^ gmul_2(gmul_2(a)) ^ a;
	endfunction

	function [7:0] gmul_e(input [7:0] a);
		// e = 14 -> a * 9 + a * 2 * 2 + a
		// a*2*2*2 + a*2*2 + a*2
		//gmul_e = gmul_9(a) ^ gmul_2(gmul_2(a)) ^ a;
		gmul_e = gmul_2(gmul_2(gmul_2(a))) ^ gmul_2(gmul_2(a)) ^ gmul_2(a);
	endfunction



	function [7:0] gmul1a (input [7:0] a);
		gmul1a = fwd ? a : gmul_9(a);
	endfunction
	function [7:0] gmul1b (input [7:0] a);
		gmul1b = fwd ? a : gmul_d(a);
	endfunction
	function [7:0] gmul2 (input [7:0] a);
		gmul2 = fwd ? gmul_2(a) : gmul_e(a);
	endfunction
	function [7:0] gmul3 (input [7:0] a);
		gmul3 = fwd ? gmul_3(a) : gmul_b(a);
	endfunction

	always_comb begin
		bytes_buf[0] = gmul2(rows[0]) ^ gmul3(rows[1]) ^ gmul1b(rows[2]) ^ gmul1a(rows[3]);
		bytes_buf[1] = gmul1a(rows[0]) ^ gmul2(rows[1]) ^ gmul3(rows[2]) ^ gmul1b(rows[3]);
		bytes_buf[2] = gmul1b(rows[0]) ^ gmul1a(rows[1]) ^ gmul2(rows[2]) ^ gmul3(rows[3]);
		bytes_buf[3] = gmul3(rows[0]) ^ gmul1b(rows[1]) ^ gmul1a(rows[2]) ^ gmul2(rows[3]);
	end
endmodule