module shift_rows(
    input clk_i,
    input rst_i,
    input fwd_ninv_i, // encrypt on high signal
    input [127:0] in_state,
    output [127:0] out_state
);
logic [7:0] in_bytes [0:15];
logic [7:0] out_bytes [0:15];
assign in_bytes = in_state;
if(fwd_ninv_i) begin
    // encrypt logic
    // row 1 - don't shift
    assign out_bytes[0] = in_bytes[0];
    assign out_bytes[1] = in_bytes[1];
    assign out_bytes[2] = in_bytes[2];
    assign out_bytes[3] = in_bytes[3];
    // row 2 - shift 1
    assign out_bytes[4] = in_bytes[5];
    assign out_bytes[5] = in_bytes[6];
    assign out_bytes[6] = in_bytes[7];
    assign out_bytes[7] = in_bytes[4];
    // row 3 - shift 2
    assign out_bytes[8] = in_bytes[10];
    assign out_bytes[9] = in_bytes[11];
    assign out_bytes[10] = in_bytes[8];
    assign out_bytes[11] = in_bytes[9];
    // row 4 - shift 3
    assign out_bytes[12] = in_bytes[15];
    assign out_bytes[13] = in_bytes[12];
    assign out_bytes[14] = in_bytes[13];
    assign out_bytes[15] = in_bytes[14];
end 
else begin
    // decrypt logic
    // row 1 - don't shift
    assign out_bytes[0] = in_bytes[0];
    assign out_bytes[1] = in_bytes[1];
    assign out_bytes[2] = in_bytes[2];
    assign out_bytes[3] = in_bytes[3];
    // row 2 - shift 1
    assign out_bytes[4] = in_bytes[];
    assign out_bytes[5] = in_bytes[];
    assign out_bytes[6] = in_bytes[];
    assign out_bytes[7] = in_bytes[];
    // row 3 - shift 2
    assign out_bytes[8] = in_bytes[];
    assign out_bytes[9] = in_bytes[];
    assign out_bytes[10] = in_bytes[];
    assign out_bytes[11] = in_bytes[];
    // row 4 - shift 3
    assign out_bytes[12] = in_bytes[];
    assign out_bytes[13] = in_bytes[];
    assign out_bytes[14] = in_bytes[];
    assign out_bytes[15] = in_bytes[];

end




assign out_state = out_bytes;