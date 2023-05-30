module sub_bytes(input in_state, output out_state);

logic i, j;
    for(i=0; i < 3; i++) begin
        for(j=0; j < 3; j++) begin
            out_state[i][j] = sbox[in_state[i][j]];
        end
    end