`timescale 1ns / 1ps

module tb_combined_multipliers;

    // Parameters
    parameter W = 32;

    // Inputs for both modules
    reg clk;
    reg rst;
    reg start;
    reg signed [W-1:0] a;
    reg signed [W-1:0] b;

    // Outputs from sequential multiplier
    wire signed [2*W-1:0] seq_product;
    wire seq_done;

    // Outputs from multiplier tree
    wire signed [2*W-1:0] tree_product;

    // Instantiate the Sequential Multiplier
    sequential_multiplier #(W) sequential_uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .product(seq_product),
        .done(seq_done)
    );

    // Instantiate the Multiplier Tree
    multiplier_tree #(W) tree_uut (
        .a(a),
        .b(b),
        .product(tree_product)
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

        // Test cases
        perform_test(15, 10, 150);         // Test 1: Positive * Positive
        perform_test(-25, 12, -300);      // Test 2: Negative * Positive
        perform_test(-8, -8, 64);         // Test 3: Negative * Negative
        perform_test(0, 123, 0);          // Test 4: Zero * Positive
        perform_test(32'h7FFFFFFF, 32'h7FFFFFFF, 64'd4611686014132420609); // Test 5: Max Positive
        perform_test(32'h80000000, 32'h80000000, 64'd4611686018427387904); // Test 6: Max Negative

        // End simulation
        #50 $stop;
    end

    // Task to perform a single test
    task perform_test;
        input signed [W-1:0] test_a;
        input signed [W-1:0] test_b;
        input signed [2*W-1:0] expected;

        begin
            // Apply test inputs
            a = test_a;
            b = test_b;

            // Start sequential multiplier
            start = 1;
            #10 start = 0;

            // Wait for sequential multiplier to finish
            wait(seq_done);

            // Display results
            $display("Inputs: a = %d, b = %d", a, b);
            $display("Sequential Multiplier Product = %d, Tree Multiplier Product = %d", seq_product, tree_product);

            // Check results
            if (seq_product !== expected || tree_product !== expected) begin
                $display("ERROR: Expected = %d, Sequential = %d, Tree = %d", expected, seq_product, tree_product);
            end else begin
                $display("PASS: Expected = %d, Sequential = %d, Tree = %d", expected, seq_product, tree_product);
            end
            
            #10;
        end
    endtask
endmodule
