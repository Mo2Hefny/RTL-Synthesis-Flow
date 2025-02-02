module cla_adder #(parameter N = 8) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    input  wire         cin,
    output wire [N-1:0] sum,
    output wire         cout,
    output wire         overflow
);
    wire [N-1:0] p, g;
    wire [N:0]   carry;

    assign carry[0] = cin;

    // Generate and propagate signals
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            assign p[i] = a[i] ^ b[i];          // Propagate
            assign g[i] = a[i] & b[i];          // Generate
            assign sum[i] = p[i] ^ carry[i];    // Sum
            assign carry[i+1] = g[i] | (p[i] & carry[i]); // Next carry
        end
    endgenerate

    assign cout = carry[N];  // Final carry output
    assign overflow = carry[N] ^ carry[N-1]; // Overflow detection
endmodule