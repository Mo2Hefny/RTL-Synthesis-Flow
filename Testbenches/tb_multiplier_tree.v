`timescale 1ns / 1ps

module tb_multiplier_tree;

    parameter W = 32;

    // Inputs
    reg signed [W-1:0] a;
    reg signed [W-1:0] b;
    reg signed [2*W-1:0] expected;

    // Output
    wire signed [2*W-1:0] product;

    // Instantiate the DUT
    multiplier_tree #(W) uut (
        .a(a),
        .b(b),
        .product(product)
    );

    // Test sequence
    initial begin
        // Test 1: 15 * 10 = 150
        a = 15; b = 10;
        #10 $display("Test 1: a = %d, b = %d, product = %d (Expected: 150)", a, b, product);

        // Test 2: -25 * 12 = -300
        a = -25; b = 12;
        #10 $display("Test 2: a = %d, b = %d, product = %d (Expected: -300)", a, b, product);

        // Test 3: -8 * -8 = 64
        a = -8; b = -8;
        #10 $display("Test 3: a = %d, b = %d, product = %d (Expected: 64)", a, b, product);

        // Test 4: 0 * 123 = 0
        a = 0; b = 123;
        #10 $display("Test 4: a = %d, b = %d, product = %d (Expected: 0)", a, b, product);

        // Test 5: Maximum values
        a = 32'h7FFFFFFF; b = 32'h7FFFFFFF;
        expected = 64'd4611686014132420609;
        #10 $display("Test 5: a = %d, b = %d, product = %d (Expected: %d)", a, b, product, expected);

        // Test 6: Minimum values
        a = 32'h80000000; b = 32'h80000000;
        expected = 64'd4611686018427387904;
        #10 $display("Test 6: a = %d, b = %d, product = %d (Expected: %d)", a, b, product, expected);

        // End simulation
        #50 $stop;
    end

endmodule
