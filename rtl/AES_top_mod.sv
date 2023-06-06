module AES_top_mod(
    input clk_i,
    input rst_i,
    input fwd_ninv_i,
    input [127:0] plaintext_i,
    input [255:0] key_i,
    output [127:0] ciphertext
);

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