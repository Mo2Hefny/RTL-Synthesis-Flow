module carry_bypass_adder #(parameter W=32, parameter N=4) (
    input signed [W-1:0] a,
    input signed [W-1:0] b,
    input cin,
    output signed [W-1:0] sum,
    output cout,
    output overflow
);

    wire[W / N:0] c;              // c[i] indicates whether the ith bit has a carry from the previous bit
    assign c[0] = cin;

    generate
        genvar i;
        for (i = 0; i < W / N; i = i + 1) begin : cba_block
            wire[N-1:0] p;              // p[i] indicates whether the ith bit propagates a carry from the previous bit
            wire[N-1:0] g;              // g[i] indicates whether the ith bit generates a carry
            wire[N-1:0] carry_out;

            assign p = a[N*(i + 1) - 1: N*i] | b[N*(i + 1) - 1: N*i];
            assign g = a[N*(i + 1) - 1: N*i] & b[N*(i + 1) - 1: N*i];
            assign carry_out[0] = c[i];

            genvar j;
            for (j = 1; j < N; j = j + 1) begin : cba_block2
                assign carry_out[j] = g[j-1] | (p[j-1] & carry_out[j-1]);
            end

            assign c[i + 1] = g[N-1] | (p[N-1] & carry_out[N-1]);
            assign sum[N*(i + 1) - 1: N*i] = a[N*(i + 1) - 1: N*i] ^ b[N*(i + 1) - 1: N*i] ^ carry_out[N-1:0];
        end
    endgenerate

    assign cout = c[W / N];
    assign overflow = (a[W-1] & b[W-1] & ~sum[W-1]) | (~a[W-1] & ~b[W-1] & sum[W-1]);
    
endmodule