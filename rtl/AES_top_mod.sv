module AES_top_mod(
    input clk_i,
    input rst_i,
    input decrypt_i,
    input load_key_i,
    input indata_valid_i,
    output logic indata_ready_o,
    input [127:0] indata_i,
    input [127:0] key_i,
    output logic [127:0] outdata_o,
    output logic outdata_valid_o
);

    localparam PL_DEPTH = 10*4;
    logic decrypt;
    assign decrypt = decrypt_i;

    logic [127:0] round_inblocks [0:10];
    logic [127:0] round_outblocks [0:10];
    logic [127:0] round_keys [0:10];
    logic round_keys_done [0:10];

    logic [PL_DEPTH:0] pl_data_valid;

    assign outdata_valid_o = pl_data_valid[PL_DEPTH];

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            pl_data_valid[PL_DEPTH:1] <= '0;
        end else begin
            pl_data_valid[PL_DEPTH:1] <= pl_data_valid[PL_DEPTH-1:0];
        end
    end

    logic begin_keygen;
    logic [127:0] base_key;

    // Round 0: only add round key
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            round_outblocks[0] <= '0;
            pl_data_valid[1] <= '0;
        end else begin
            round_outblocks[0] <= round_inblocks[0] ^ round_keys[0];
            pl_data_valid[1] <= pl_data_valid[0];
        end
	end
    
    always_comb begin
        if (decrypt) begin
            round_inblocks[10] = indata_i;
            for (int i = 0; i < 10; i++) begin
                round_inblocks[i] = round_outblocks[i+1];
            end
            outdata_o = round_outblocks[0];
        end else begin
            round_inblocks[0] = indata_i;
            for (int i = 0; i < 10; i++) begin
                round_inblocks[i+1] = round_outblocks[i];
            end
            outdata_o = round_outblocks[10];
        end

    end

    // Rounds 1-10
    genvar i;
    generate
        for (i = 1; i <= 10; i++) begin : rounds
            aes_round #(
                .last_round(i == 10)
            ) round (
                .clk_i(clk_i),
                .rst_i(rst_i),
                .decrypt(decrypt),
                .key_i(round_keys[i]),
                .block_i(round_inblocks[i]),
                .block_o(round_outblocks[i])
                // .valid_i(pl_data_in_valid[i]),
                // .valid_o(pl_data_out_valid[i])
            );

            // always_ff @(posedge clk_i) begin
            //     if (rst_i)
            //         pl_data_valid[i+1] <= '0;
            //     else
            //         pl_data_valid[i+1] <= pl_data_valid[i];
            // end

        end
    endgenerate


    aes_key_expansion keygen (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .begin_key_gen_i(begin_keygen),
        .initial_key(base_key),
        .round_keys(round_keys),
        .round_keys_done(round_keys_done)
    );

    logic loadkey;

    always_ff @(posedge clk_i) begin
        if (rst_i)
            base_key <= '0;
        if (loadkey)
            base_key <= key_i;
    end


    localparam ST_IDLE = 2'd0;
    localparam ST_KEY_LOAD = 2'd1;
    localparam ST_READY = 2'd2;
    localparam ST_RUNNING = 2'd3;

    logic [1:0] state, next_state;

    always_ff @(posedge clk_i) begin
        if (rst_i)
            state <= ST_IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        begin_keygen = '0; // Mealy
        loadkey = '0;
        indata_ready_o = '0;
        pl_data_valid[0] = '0;
        next_state = state;
        if (!rst_i) begin
            case (state)
                ST_IDLE: begin
                    if (load_key_i) begin
                        next_state = ST_KEY_LOAD;
                        //begin_keygen = '1;
                        loadkey = '1;
                    end
                end
                ST_KEY_LOAD: begin
                    if (round_keys_done[9]) begin
                        next_state = ST_READY;
                    end else begin
                        begin_keygen = '1;
                    end
                end
                ST_READY: begin
                    indata_ready_o = '1;
                    pl_data_valid[0] = indata_valid_i;
                end
                ST_RUNNING: begin
                    indata_ready_o = '1;
                    pl_data_valid[0] = indata_valid_i;
                end
            endcase
        end
    end

// blocks = divide_into_blocks(plaintext)
// round_keys = get_round_keys(key)
// ciphertext_blocks = []

// for block in blocks 

    // state = add_round_key(block, round) 

    // for 10 rounds
        // state = sub_bytes(state)
        // state = shift_rows(state)
        // state = mix_columns(state)
        // state = add_round_key(state)

    // state = sub_bytes(state)
    // state = shift_rows(state)
    // state = add_round_key(state) 

// ciphertext_blocks.append(state)
// ciphertext = reassemble_blocks(ciphertext_blocks)
// return ciphertext

endmodule