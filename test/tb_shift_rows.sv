`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2023 02:27:58 PM
// Design Name: 
// Module Name: tb_shift_rows
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_shift_rows();

logic CLK, RST, FWD_NINV;
logic [127:0] IN_STATE,OUT_STATE;

always begin
    #5 CLK = 0;
    #5 CLK = 1;
end

shift_rows sr(
    .clk_i(CLK),
    .rst_i(RST),
    .fwd_ninv_i(FWD_NINV),
    .in_state(IN_STATE),
    .out_state(OUT_STATE)
);

initial begin
    #20 
    RST = 0; 
    FWD_NINV = 1; 
    IN_STATE = 128'h000102030405060708090A0B0C0D0E0F;
    
    #20 
    RST = 0; 
    FWD_NINV = 0; 
    IN_STATE = 128'h00010203050607040a0b08090f0c0d0e;
    
    #20 
    RST = 1; 
    FWD_NINV = 1; 
    IN_STATE = 128'h000102030405060708090A0B0C0D0E0F;
    
    #20 
    RST = 1; 
    FWD_NINV = 0; 
    IN_STATE = 128'h00010203050607040a0b08090f0c0d0e;
end

endmodule
