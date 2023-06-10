/* 
KeyExpansion(byte key[4*Nk], word w[Nb*(Nr+1)], Nk)
begin
    word temp
    i = 0
    while (i < Nk)
        w[i] = word(key[4*i], key[4*i+1], key[4*i+2], key[4*i+3])
        i = i+1
    end while
    i = Nk
    while (i < Nb * (Nr+1)]
        temp = w[i-1]
        if (i mod Nk = 0)
            temp = SubWord(RotWord(temp)) xor Rcon[i/Nk]
        else if (Nk > 6 and i mod Nk = 4)
            temp = SubWord(temp)
        end if
        w[i] = w[i-Nk] xor temp
        i = i + 1
    end while
end

*/




module key_single_round (
    input clk_i,
    input rst_i,
    input clk_en_i,
    input [7:0] rcon,
    input [31:0] iv,
    input [127:0] key_i,
    output logic [127:0] key_o,
    output logic key_valid_o
);

    logic [31:0] irows [0:3];
    logic [31:0] orows [0:3];
    logic [127:0] key_post, block_i;

    assign key_o = key_post;
    assign block_i = key_i;

    // assign {key_post[127:120],key_post[95:88],key_post[63:56],key_post[31:24]} = orows[0];
    // assign {key_post[119:112],key_post[87:80],key_post[55:48],key_post[23:16]} = orows[1];
    // assign {key_post[111:104],key_post[79:72],key_post[47:40],key_post[15:8]} = orows[2];
    // assign {key_post[103:96], key_post[71:64],key_post[39:32],key_post[7:0]} = orows[3];

    assign key_post = {orows[0], orows[1], orows[2], orows[3]};
    assign {irows[0], irows[1], irows[2], irows[3]} = block_i;
    // always_comb begin
    //     irows[0] = {block_i[127:120],block_i[95:88],block_i[63:56],block_i[31:24]};
    //     irows[1] = {block_i[119:112],block_i[87:80],block_i[55:48],block_i[23:16]};
    //     irows[2] = {block_i[111:104],block_i[79:72],block_i[47:40],block_i[15:8]};
    //     irows[3] = {block_i[103:96], block_i[71:64],block_i[39:32],block_i[7:0]};
    // end

    logic [7:0] sbox [0:255] = '{
        8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5, 8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe, 8'hd7, 8'hab, 8'h76,
        8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0, 8'had, 8'hd4, 8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0,
        8'hb7, 8'hfd, 8'h93, 8'h26, 8'h36, 8'h3f, 8'hf7, 8'hcc, 8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15,
        8'h04, 8'hc7, 8'h23, 8'hc3, 8'h18, 8'h96, 8'h05, 8'h9a, 8'h07, 8'h12, 8'h80, 8'he2, 8'heb, 8'h27, 8'hb2, 8'h75,
        8'h09, 8'h83, 8'h2c, 8'h1a, 8'h1b, 8'h6e, 8'h5a, 8'ha0, 8'h52, 8'h3b, 8'hd6, 8'hb3, 8'h29, 8'he3, 8'h2f, 8'h84,
        8'h53, 8'hd1, 8'h00, 8'hed, 8'h20, 8'hfc, 8'hb1, 8'h5b, 8'h6a, 8'hcb, 8'hbe, 8'h39, 8'h4a, 8'h4c, 8'h58, 8'hcf,
        8'hd0, 8'hef, 8'haa, 8'hfb, 8'h43, 8'h4d, 8'h33, 8'h85, 8'h45, 8'hf9, 8'h02, 8'h7f, 8'h50, 8'h3c, 8'h9f, 8'ha8,
        8'h51, 8'ha3, 8'h40, 8'h8f, 8'h92, 8'h9d, 8'h38, 8'hf5, 8'hbc, 8'hb6, 8'hda, 8'h21, 8'h10, 8'hff, 8'hf3, 8'hd2,
        8'hcd, 8'h0c, 8'h13, 8'hec, 8'h5f, 8'h97, 8'h44, 8'h17, 8'hc4, 8'ha7, 8'h7e, 8'h3d, 8'h64, 8'h5d, 8'h19, 8'h73,
        8'h60, 8'h81, 8'h4f, 8'hdc, 8'h22, 8'h2a, 8'h90, 8'h88, 8'h46, 8'hee, 8'hb8, 8'h14, 8'hde, 8'h5e, 8'h0b, 8'hdb,
        8'he0, 8'h32, 8'h3a, 8'h0a, 8'h49, 8'h06, 8'h24, 8'h5c, 8'hc2, 8'hd3, 8'hac, 8'h62, 8'h91, 8'h95, 8'he4, 8'h79,
        8'he7, 8'hc8, 8'h37, 8'h6d, 8'h8d, 8'hd5, 8'h4e, 8'ha9, 8'h6c, 8'h56, 8'hf4, 8'hea, 8'h65, 8'h7a, 8'hae, 8'h08,
        8'hba, 8'h78, 8'h25, 8'h2e, 8'h1c, 8'ha6, 8'hb4, 8'hc6, 8'he8, 8'hdd, 8'h74, 8'h1f, 8'h4b, 8'hbd, 8'h8b, 8'h8a,
        8'h70, 8'h3e, 8'hb5, 8'h66, 8'h48, 8'h03, 8'hf6, 8'h0e, 8'h61, 8'h35, 8'h57, 8'hb9, 8'h86, 8'hc1, 8'h1d, 8'h9e,
        8'he1, 8'hf8, 8'h98, 8'h11, 8'h69, 8'hd9, 8'h8e, 8'h94, 8'h9b, 8'h1e, 8'h87, 8'he9, 8'hce, 8'h55, 8'h28, 8'hdf,
        8'h8c, 8'ha1, 8'h89, 8'h0d, 8'hbf, 8'he6, 8'h42, 8'h68, 8'h41, 8'h99, 8'h2d, 8'h0f, 8'hb0, 8'h54, 8'hbb, 8'h16
    };

    function [31:0] rotword (input [31:0] a);
        rotword = {a[23:0], a[31:24]};
    endfunction

    function [31:0] subword (input [31:0] a);
        subword = {sbox[a[31:24]], sbox[a[23:16]], sbox[a[15:8]], sbox[a[7:0]]};
    endfunction

    logic [31:0] rcon_full;
    logic [31:0] rotated;
    logic [31:0] subbed;
    logic [31:0] temp;
    logic [31:0] orow;
    logic [1:0] row_num;
    assign rcon_full = {rcon, 24'd0};

    assign rotated = rotword(row_num == 0 ? iv : orows[row_num - 2'd1]);
    assign subbed = subword(rotated);
    assign temp = subbed ^ rcon_full;
    assign orow = ((row_num == 0) ? temp : orows[row_num - 2'd1]) ^ irows[row_num];

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            orows[0] <= '0;
            orows[1] <= '0;
            orows[2] <= '0;
            orows[3] <= '0;
            key_valid_o <= '0;
            row_num <= '0;
        end else if (clk_en_i) begin
            orows[row_num] <= orow;
            key_valid_o <= (row_num == 2'd3);
            row_num <= row_num + 2'd1;
        end
    end

    
endmodule


module aes_key_expansion (
    input clk_i,
    input rst_i,
    input begin_key_gen_i,
    input [127:0] initial_key,
    output logic [127:0] round_keys [0:10],
    output logic round_keys_done [0:10]
);
    localparam num_rounds = 4'd11;

    localparam ST_NOT_STARTED = 2'd0;
    localparam ST_ACTIVE = 2'd1;
    localparam ST_VALID_OUT = 2'd2;

    logic [1:0] state, next_state;
    logic reset_keys;
    logic [3:0] round_num;

    logic [7:0] rcon [0:10] = '{
        8'h01, 8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80, 8'h1b, 8'h36
    };

    logic clk_en_rg;
    logic current_key_o_valid;

    logic [31:0] round_key_iv;

    logic [127:0] current_key_in;
    logic [127:0] current_key_out;


    assign round_key_iv = (round_num == 0) ? initial_key[31:0] : round_keys[round_num-4'd1][31:0];
    assign current_key_in = (round_num == 0) ? initial_key : round_keys[round_num-4'd1];

    key_single_round round_gen(
        .clk_i(clk_i),
        .rst_i(rst_i || current_key_o_valid),
        .rcon(rcon[round_num]),
        .clk_en_i(clk_en_rg),
        .iv(round_key_iv),
        .key_i(current_key_in),
        .key_o(current_key_out),
        .key_valid_o(current_key_o_valid)
    );

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            state <= ST_NOT_STARTED;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(posedge clk_i) begin
        if (rst_i || reset_keys) begin
            round_num <= '0;
            round_keys_done <= '{default: '0};
            round_keys <= '{default: '0};
        end else if (state == ST_ACTIVE) begin
            if (round_num == 4'd0) begin
                round_num <= round_num + 4'd1;
                round_keys[round_num] <= initial_key;
                round_keys_done[round_num] <= 1'd1;
                //current_key_in <= initial_key;
            end else if (current_key_o_valid) begin
                round_num <= round_num + 4'd1;
                round_keys[round_num] <= current_key_out;
                round_keys_done[round_num] <= 1'd1;
                //current_key_in <= current_key_out;
            end
        end
    end

    always_comb begin
        clk_en_rg = 0;
        next_state = state;
        reset_keys = 0;
        //round_key_iv = initial_key[31:0];
        case (state)
            ST_NOT_STARTED: begin
                next_state = begin_key_gen_i ? ST_ACTIVE : ST_NOT_STARTED;
            end
            ST_ACTIVE: begin
                next_state = (round_num == num_rounds) ? ST_VALID_OUT : ST_ACTIVE;
                clk_en_rg = 1;
                //round_key_iv = round_keys[round_num-4'd1][31:0];
            end
            ST_VALID_OUT: begin
                if (begin_key_gen_i) begin
                    next_state = ST_ACTIVE;
                    reset_keys = 1;
                end
            end
            default: begin
                next_state = ST_NOT_STARTED;
                reset_keys = 1;
            end
        endcase
    end

endmodule
