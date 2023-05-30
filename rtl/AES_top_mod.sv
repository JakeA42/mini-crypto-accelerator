module AES_top_mod(
    input clk_i,
    input rst_i,
    input [0:127] plaintext,
    input [0:127] key,
    output [0:127] ciphertext
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