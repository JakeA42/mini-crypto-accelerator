


module tb_key_gen ();
	logic clk = 0;
	logic rst;
	logic key_valid;
	logic [7:0] rcon;
	logic [4:0] round_num;

	logic [127:0] key_initial;
	logic [127:0] key_out;

	key_single_round dut1 (
		.clk_i(clk),
		.rst_i(rst),
		.clk_en_i('1),
    	.rcon(rcon),
    	.iv(key_initial[31:0]),
		.key_i(key_initial),
    	.key_o(key_out),
    	.key_valid_o(key_valid)
	);

	logic [7:0] rcon_lut [1:10] = '{
        8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80, 8'h1b, 8'h36
    };
	assign rcon = rcon_lut[round_num];
	
	initial begin
		rst = '1;
		round_num = 4'd1;
		key_initial = 128'h2b7e151628aed2a6abf7158809cf4f3c;

		#20 rst = '0;
		#300 $finish;
	end

	always begin
		#5 clk = ~clk;
	end

endmodule