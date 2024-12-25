module floating_point_mt (
    input clk,
    input rst,
    input start,
    input [31:0] a,      
    input [31:0] b,     
    output [31:0] result,
    output overflow,
    output done  
);

    // Step 1: Extract IEEE 754 fields
    wire sign_a = a[31];
    wire sign_b = b[31];
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [23:0] mant_a = (exp_a == 8'b0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]}; 
    wire [23:0] mant_b = (exp_b == 8'b0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]}; 

    // Step 2: Calculate sign of the result
    wire sign_res = sign_a ^ sign_b;

    // Step 3: Add exponents and subtract bias (127 for 32-bit)
    wire [9:0] exp_sum = exp_a + exp_b - 8'd127;

    // Step 4: Multiply mantissas using tree-based algorithm
    wire [47:0] mant_mult;
    sequential_multiplier #(24) tree_mult (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(mant_a),
        .b(mant_b),
        .product(mant_mult),
        .done(done)
    );

    // Step 5: Normalize result
    wire mant_mult_msb = mant_mult[47];
    wire [22:0] mant_res = mant_mult_msb ? mant_mult[46:24] : mant_mult[45:23];
    wire [7:0] exp_res = mant_mult_msb ? exp_sum + 1 : exp_sum;

    // Step 6: Denormalization handling
    wire is_denorm = exp_sum[9];
    wire [22:0] denorm_mant_res = mant_mult[46:24] >> (1 - exp_sum);
    wire [7:0] denorm_exp_res = is_denorm ? 8'b0 : exp_res;

    // Step 7: Handle special cases
    wire a_is_zero = (a[30:0] == 31'b0);       
    wire b_is_zero = (b[30:0] == 31'b0);       
    wire a_is_inf = (exp_a == 8'b11111111) && (a[22:0] == 0);
    wire b_is_inf = (exp_b == 8'b11111111) && (b[22:0] == 0);
    wire a_is_nan = (exp_a == 8'b11111111) && (a[22:0] != 0);
    wire b_is_nan = (exp_b == 8'b11111111) && (b[22:0] != 0);

    assign overflow = (exp_res > 8'd254);

    assign result = 
        // Case 1: NaN (either input is NaN)
        (a_is_nan || b_is_nan) ? 32'h7FC00000 :

        // Case 2: Infinity * 0 (results in NaN)
        ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) ? 32'h7FC00000 :

        // Case 3: Infinity * finite or Infinity * Infinity
        (a_is_inf || b_is_inf) ? {sign_res, 8'hFF, 23'b0} :

        // Case 4: Zero * anything (except Infinity)
        (a_is_zero || b_is_zero) ? {sign_res, 32'b0} :

        // Case 5: Overflow (result exponent too large)
        overflow ? {sign_res, 8'hFF, 23'b0} :

        // Case 6: Denormalized result
        (is_denorm) ? {sign_res, 8'b0, denorm_mant_res} :

        // Case 7: Normal result
        {sign_res, denorm_exp_res[7:0], mant_res};

endmodule
