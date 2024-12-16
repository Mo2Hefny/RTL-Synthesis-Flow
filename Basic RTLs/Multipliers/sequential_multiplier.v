module sequential_multiplier #(parameter W=32) (
    input [W-1:0] a,
    input [W-1:0] b,
    output [2*W-1:0] p
);

    wire [2*W-1:0] a_shift;                  // a_shift stores the shifted a
    wire [W-1:0] b_shift;                    // b_shift stores the shifted b
    wire [2*W-1:0] result = {2*W{1'b0}};
    generate
        genvar i;
        for (i = 0; i < W; i = i + 1) begin : seq_mul_block
            assign a_shift = a <<< i;
            assign b_shift = b >>> i;
            
            if (b_shift[0] == 1'b1) begin
                result = result + a_shift;
            end
        end
    endgenerate

    assign p = result;
endmodule