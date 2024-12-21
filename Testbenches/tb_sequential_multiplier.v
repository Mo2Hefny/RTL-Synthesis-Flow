`timescale 1ns / 1ps

module tb_sequential_multiplier;
    // Parameters
    parameter W = 32;

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg signed [W-1:0] a;
    reg signed [W-1:0] b;
    reg signed [2*W-1:0] expected;

    // Outputs
    wire signed [2*W-1:0] product;
    wire done;

    // Instantiate the DUT (Device Under Test)
    sequential_multiplier #(W) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .product(product),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst = 1;
        start = 0;
        a = 0;
        b = 0;

        // Apply reset
        #20 rst = 0;

        // Test 1: 15 * 10 = 150
        #10 a = 15; b = 10; start = 1;
        #10 start = 0;
        wait (done);
        $display("Test 1: a = %d, b = %d, product = %d (Expected: 150)", a, b, product);

        // Test 2: -25 * 12 = -300
        #10 a = -25; b = 12; start = 1;
        #10 start = 0;
        wait (done);
        $display("Test 2: a = %d, b = %d, product = %d (Expected: -300)", a, b, product);

        // Test 3: -8 * -8 = 64
        #10 a = -8; b = -8; start = 1;
        #10 start = 0;
        wait (done);
        $display("Test 3: a = %d, b = %d, product = %d (Expected: 64)", a, b, product);

        // Test 4: 0 * 123 = 0
        #10 a = 0; b = 123; start = 1;
        #10 start = 0;
        wait (done);
        $display("Test 4: a = %d, b = %d, product = %d (Expected: 0)", a, b, product);

        // Test 5: Maximum values
        #10 a = 32'h7FFFFFFF; b = 32'h7FFFFFFF; start = 1; // Largest positive values
        #10 start = 0;
        expected = 64'd4611686014132420609;
        wait (done);
        $display("Test 5: a = %d, b = %d, product = %d (Expected: %d)", a, b, product, expected);

        // Test 6: Minimum values
        #10 a = 32'h80000000; b = 32'h80000000; start = 1; // Largest negative values
        #10 start = 0;
        expected = 64'd4611686018427387904;
        wait (done);
        $display("Test 6: a = %d, b = %d, product = %d (Expected: %d)", a, b, product, expected);

        // End simulation
        #50 $stop;
    end
endmodule
