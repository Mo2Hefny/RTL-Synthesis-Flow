module mantissa_tree_multiplier (
    input [23:0] a,
    input [23:0] b,
    output [47:0] product
);
    wire [47:0] partial_products[23:0];
    wire [47:0] intermediate_sums[22:0];
    wire [47:0] carry_out[22:0];

    genvar i, j;

    generate
        for (i = 0; i < 24; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = b[i] ? (a << i) : 48'd0;
        end
    endgenerate

    RippleCarryAdder #(48) rca_0 (
        .a(partial_products[0]),
        .b(partial_products[1]),
        .cin(1'b0),
        .sum(intermediate_sums[0]),
        .cout()
    );

    generate
        for (j = 1; j < 23; j = j + 1) begin : gen_tree_reduction
            RippleCarryAdder #(48) rca (
                .a(intermediate_sums[j-1]),
                .b(partial_products[j+1]),
                .cin(1'b0),
                .sum(intermediate_sums[j]),
                .cout()
            );
        end
    endgenerate

    assign product = intermediate_sums[22];
endmodule
