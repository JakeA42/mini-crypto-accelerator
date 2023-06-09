`timescale 1ns / 1ps

module shift_rows(
    input clk_i,
    input rst_i,
    input fwd_ninv_i, // encrypt on high signal
    input [127:0] in_state,
    output logic [127:0] out_state
);

    logic [31:0] row0, row1, row2, row3;


    always_comb begin
        if (fwd_ninv_i) begin
            row0 = in_state[127:96];
            row1 = {in_state[87:80], in_state[79:72], in_state[71:64], in_state[95:88]};
            row2 = {in_state[47:40], in_state[39:32], in_state[63:56], in_state[55:48]};
            row3 = {in_state[7:0], in_state[31:24], in_state[23:16], in_state[15:8]};
        end else begin
            row0 = in_state[127:96];
            row1 = {in_state[71:64], in_state[95:88], in_state[87:80], in_state[79:72]};
            row2 = {in_state[47:40], in_state[39:32], in_state[63:56], in_state[55:48]};
            row3 = {in_state[23:16], in_state[15:8], in_state[7:0], in_state[31:24]};
        end
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            out_state <= 0;
        end else if (fwd_ninv_i) begin
            // row0 <= in_state[127:96];
            // row1 <= {in_state[87:80], in_state[79:72], in_state[71:64], in_state[95:88]};
            // row2 <= {in_state[47:40], in_state[39:32], in_state[63:56], in_state[55:48]};
            // row3 <= {in_state[7:0], in_state[31:24], in_state[23:16], in_state[15:8]};
            out_state <= {row0, row1, row2, row3};
            
        end else begin
            // row0 <= in_state[127:96];
            // row1 <= {in_state[71:64], in_state[95:88], in_state[87:80], in_state[79:72]};
            // row2 <= {in_state[47:40], in_state[39:32], in_state[63:56], in_state[55:48]};
            // row3 <= {in_state[23:16], in_state[15:8], in_state[7:0], in_state[31:24]};
            out_state <= {row0, row1, row2, row3};
        end
    end

endmodule