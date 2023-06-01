//////////////////////////////////////////////
// 
// Mini crypto accelerator
// with memory mapped interface
//
// crypto_acc.sv (Top module)
//
// By: Blake Ward, Jake Alt
// 30 May 2023
// 
//////////////////////////////////////////////



module crypto_acc #(
	parameter BUS_WIDTH = 32,
	parameter BASE_ADDRESS = 32'hF4000000
) (
	input clk_i,
	input rst_i,
	input logic  read_en_i,
	input logic  write_en_i,
	input logic  [BUS_WIDTH-1:0] data_i,
	input logic  [BUS_WIDTH-1:0] addr_i,
	output logic [BUS_WIDTH-1:0] data_o
);

// Memory map:
localparam ctrl_reg_addr        = 32'h00000000; // RW
localparam opts_reg_addr        = 32'h00000004; // RW
localparam status_reg_addr      = 32'h00000008; // R
localparam key_len_reg_addr     = 32'h00000104; // RW
localparam data_len_reg_addr    = 32'h00000108; // RW
localparam result_len_reg_addr  = 32'h0000010c; // R
localparam key_buf_reg_addr     = 32'h00004zzz; // RW
localparam data_buf_reg_addr    = 32'h00008zzz; // RW
localparam result_buf_reg_addr  = 32'h0000czzz; // R

logic key_len_reg;
logic data_len_reg;

always_ff @(posedge clk_i) begin
	if (rst_i) begin
		key_len_reg <= '0;
		data_len_reg <= '0;
	end else if (write_en_i) begin
		casez (addr - BASE_ADDRESS)
			key_len_reg_addr:  key_len_reg  <= data_i;
			data_len_reg_addr: data_len_reg <= data_i;
			key_buf_reg_addr: begin
				// TODO: key and data buffer slicing and filling
			end
			default: ;
		endcase
	end
end

// TODO: read data


AES_top_mod aes (
	.clk_i(clk_i),
	.rst_i(rst_i)
);

endmodule