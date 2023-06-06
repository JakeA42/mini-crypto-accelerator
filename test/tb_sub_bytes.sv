`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2023 02:19:10 PM
// Design Name: 
// Module Name: tb_sub_bytes
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


module tb_sub_bytes();

logic CLK, RST, FWD_NINV;
logic [127:0] IN_STATE, OUT_STATE;

always begin
    #5 CLK = 0;
    #5 CLK = 1;
end

sub_bytes sb1(
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
    IN_STATE = 128'h00112233445566778899AABBCCDDEEFF;
    
    #20
    RST = 0;
    FWD_NINV = 0;
    IN_STATE = 128'h638293c31bfc33f5c4eeacea4bc12816;
    

end

endmodule
