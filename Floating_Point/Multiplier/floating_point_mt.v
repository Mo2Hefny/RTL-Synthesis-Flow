module floating_point_mt (
    input [31:0] a,      
    input [31:0] b,     
    output [31:0] result,
    output overflow
);

    wire sign_a = a[31];
    wire sign_b = b[31];
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [23:0] in_a = (exp_a == 8'b0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]}; 
    wire [23:0] in_b = (exp_b == 8'b0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]}; 

    wire sign_res = sign_a ^ sign_b;

    wire [9:0] exp_sum = exp_a + exp_b - 8'd127;

    wire [47:0] product;
    simple_multiplier #(24) simple_mul (
        .a(in_a),
        .b(in_b),
        .product(product)
    );

    wire product_msb = product[47];
    wire [22:0] product_res = product_msb ? product[46:24] : product[45:23];
    wire [7:0] exp_res = product_msb ? exp_sum + 1 : exp_sum;

    wire is_denorm = exp_sum[9];
    wire [22:0] denorm_product_res = product[46:24] >> (1 - exp_sum);
    wire [7:0] denorm_exp_res = is_denorm ? 8'b0 : exp_res;

    wire a_is_zero = (a[30:0] == 31'b0);       
    wire b_is_zero = (b[30:0] == 31'b0);       
    wire a_is_inf = (exp_a == 8'b11111111) && (a[22:0] == 0);
    wire b_is_inf = (exp_b == 8'b11111111) && (b[22:0] == 0);
    wire a_is_nan = (exp_a == 8'b11111111) && (a[22:0] != 0);
    wire b_is_nan = (exp_b == 8'b11111111) && (b[22:0] != 0);

    assign overflow = (exp_res > 8'd254);

    assign result = 
        (a_is_nan || b_is_nan) ? 32'h7FC00000 :
        ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) ? 32'h7FC00000 :
        (a_is_inf || b_is_inf) ? {sign_res, 8'hFF, 23'b0} :
        (a_is_zero || b_is_zero) ? {sign_res, 32'b0} :
        overflow ? {sign_res, 8'hFF, 23'b0} :
        (is_denorm) ? {sign_res, 8'b0, denorm_product_res} :
        {sign_res, denorm_exp_res[7:0], product_res};

endmodule
