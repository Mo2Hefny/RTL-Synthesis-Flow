`timescale 1ns / 1ps

module tb_carry_bypass_adder;

    // Parameters
    parameter W = 32;
    parameter N = 4;

    // Inputs
    reg signed [W-1:0] a;
    reg signed [W-1:0] b;
    reg cin;

    // Outputs
    wire signed [W-1:0] sum;
    wire cout;
    wire overflow;

    // Instantiate the DUT (Device Under Test)
    carry_bypass_adder #(W, N) uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout),
        .overflow(overflow)
    );

    // Variables for expected results
    reg signed [W:0] expected_sum;
    reg expected_overflow;

    // Test sequence
    initial begin
        $display("Starting Testbench for Carry Bypass Adder...");

        // Test 1: No Overflow, Positive + Positive
        a = 32'h00000015;  // 21
        b = 32'h0000000A;  // 10
        cin = 0;
        #10;
        check_results(a, b, cin);

        // Test 2: No Overflow, Negative + Negative
        a = -32'h00000015; // -21
        b = -32'h0000000A; // -10
        cin = 0;
        #10;
        check_results(a, b, cin);

        // Test 3: Overflow, Positive + Positive
        a = 32'h40000000;  // Large positive number
        b = 32'h40000000;  // Large positive number
        cin = 0;
        #10;
        check_results(a, b, cin);

        // Test 4: Overflow, Negative + Negative
        a = -32'h40000000; // Large negative number
        b = -32'h40000000; // Large negative number
        cin = 0;
        #10;
        check_results(a, b, cin);

        // Test 5: Mixed Sign, Positive + Negative
        a = 32'h7FFFFFFF;  // Max positive
        b = -32'h7FFFFFFF; // Max negative
        cin = 0;
        #10;
        check_results(a, b, cin);

        // Test 6: Edge Case, Zero + Zero
        a = 0;
        b = 0;
        cin = 0;
        #10;
        check_results(a, b, cin);

        $display("Testbench completed.");
        $stop;
    end

    // Task to check results
    task check_results;
        input signed [W-1:0] a_test;
        input signed [W-1:0] b_test;
        input cin_test;
        begin
            $display("Inputs: a = %d, b = %d, cin = %b", a_test, b_test, cin_test);
            $display("Outputs: sum = %d, cout = %b, overflow = %b", sum, cout, overflow);

            // Calculate expected sum and overflow
            expected_sum = a_test + b_test + cin_test;
            expected_overflow = (a_test[W-1] & b_test[W-1] & ~sum[W-1]) | 
                                (~a_test[W-1] & ~b_test[W-1] & sum[W-1]);

            // Check results
            if (sum !== expected_sum[W-1:0]) begin
                $display("ERROR: Sum mismatch! Expected = %d, Got = %d", expected_sum[W-1:0], sum);
            end else if (overflow !== expected_overflow) begin
                $display("ERROR: Overflow mismatch! Expected = %b, Got = %b", expected_overflow, overflow);
            end else begin
                $display("PASS: Sum = %d, Overflow = %b", sum, overflow);
            end

            $display("-------------------------------------------------------");
        end
    endtask
endmodule
