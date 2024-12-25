module multiplier_tree #(parameter W=32, parameter N=4) (
    input signed [W-1:0] a,
    input signed [W-1:0] b,
    output signed [2*W-1:0] product
);
    wire is_negative = a[W-1] ^ b[W-1];

    // Turn a and b into positive numbers if needed
    wire [W-1:0] a_pos = a[W-1] ? ~a + 1 : a;
    wire [W-1:0] b_pos = b[W-1] ? ~b + 1 : b;

    wire [W-1:0] partial_p [W-1:0];             // partial_p[i] stores the ith partial product
    genvar i;
    generate
        for (i = 0; i < W; i = i + 1) begin : mul_tree_partial_product_block
            assign partial_p[i] = a_pos[i] ? b_pos : {W{1'b0}};
        end
    endgenerate

    wire [2*W-1:0] sum [W-1:0];                 // sum[i] stores the shifted partial product
    generate
        for (i = 0; i < W; i = i + 1) begin : mul_tree_sum_block
            assign sum[i] = partial_p[i] << i;
        end
    endgenerate

    reg [2*W-1:0] final_sum;
    integer j;
    always @(*) begin
        final_sum = 0;
        for (j = 0; j < W; j = j + 1) begin
            final_sum = final_sum + sum[j];
        end
    end

    // If the result is negative, turn it into a negative number
    assign product = is_negative ? ~final_sum + 1 : final_sum;
endmodule