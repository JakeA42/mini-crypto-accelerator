


module tb_1block ();
	logic clk = 0;
	logic rst;
	logic key_valid;


	logic [127:0] key_initial;
	logic [127:0] data_in;
	logic [127:0] data_out;
	logic data_out_valid;

	logic loadkey;
	logic in_ready;
	logic in_valid;
	
	logic decrypt;

	// key_single_round round (
	// 	.clk_i(clk),
	// 	.rst_i(rst),
	// 	.clk_en_i('1),
    // 	.rcon(rcon),
    // 	.iv(key_initial[31:0]),
	// 	.key_i(key_initial),
    // 	.key_o(key_out),
    // 	.key_valid_o(key_valid)
	// );

	AES_top_mod dut (
		.clk_i(clk),
		.rst_i(rst),
		.decrypt_i(decrypt),
		.load_key_i(loadkey),
		.indata_valid_i(in_valid),
		.indata_ready_o(in_ready),
		.indata_i(data_in),
		.key_i(key_initial),
		.outdata_o(data_out),
		.outdata_valid_o(data_out_valid)
	);
	
	logic [127:0] data_reg;

	initial begin
		rst = '1;
		@(posedge clk);
		loadkey = '1;
		decrypt = '0;
		key_initial = 128'h2b7e151628aed2a6abf7158809cf4f3c;
		//key_initial = 128'h2b28ab097eaef7cf15d2154f16a6883c;
		in_valid = 0;
		data_in = 'x;

		#25 rst = '0;
		#10 loadkey = '0;

		@(posedge clk && in_ready);
		in_valid = 1;
		data_in = 128'h3243f6a8885a308d313198a2e0370734;
		@(posedge clk);
		in_valid = '0;
		data_in = '0;
		//data_in = 128'h328831e0435a3137f6309807a88da234;
		
		@(posedge clk && data_out_valid);
		data_reg = data_out;
		@(posedge clk);
		decrypt = '1;
		data_in = data_reg;
		in_valid = '1;
		@(posedge clk);
		in_valid = '0;
		@(posedge clk && data_out_valid);
		assert (data_out == 128'h3243f6a8885a308d313198a2e0370734)
		else $display("failed");
		#30 $finish;
	end

	always begin
		#5 clk = ~clk;
	end

endmodule