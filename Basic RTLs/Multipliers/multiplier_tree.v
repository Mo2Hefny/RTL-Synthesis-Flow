module multiplier_tree #(parameter W=32) (
    input [W-1:0] a,
    input [W-1:0] b,
    output [2W-1:0] p
);

    wire [W-1:0] partial_p [W-1:0];             // partial_p[i] stores the ith partial product
    genvar i;
    generate
        for (i = 0; i < W; i = i + 1) begin : mul_tree_partial_product_block
            assign partial_p[i] = a[i] ? b : {W{1'b0}};
        end
    endgenerate

    wire [2*W-1:0] sum [W-1:0];                 // sum[i] stores the shifted partial product
    generate
        for (i = 0; i < W; i = i + 1) begin : mul_tree_sum_block
            assign sum[i] = {p[i], i{1'b0}};
        end
    endgenerate

    wire [2*W-1:0] final_sum = {2*W{1'b0}};
    generate
        for (i = 0; i < W; i = i + 1) begin : mul_tree_final_sum_block
            assign final_sum = final_sum + sum[i];
        end
    endgenerate

    assign p = final_sum;
endmodule