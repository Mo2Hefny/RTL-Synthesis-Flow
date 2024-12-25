`timescale 1ns / 1ps

module floating_point_mt_tb;

    reg clk;
    reg rst;
    reg start;
    reg [31:0] a;  
    reg [31:0] b;  

    wire [31:0] result; 
    wire overflow;
    wire done;

    floating_point_mt uut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .start(start),
        .result(result),
        .overflow(overflow),
        .done(done)
    );

    task display_result;
        input [31:0] input_a;
        input [31:0] input_b;
        input [31:0] output_res;
        input overflow_flag;
        real real_a;
        real real_b;
        real real_res;
        begin
            real_a = ieee754_to_real(input_a);
            real_b = ieee754_to_real(input_b);
            real_res = ieee754_to_real(output_res);

            $display("A: %h (%0.6f) | B: %h (%0.6f) | Result: %h (%0.6f) | Overflow: %b",
                    input_a, real_a,
                    input_b, real_b,
                    output_res, real_res,
                    overflow_flag);
        end
    endtask

    task assert_result;
        input [31:0] expected_result;
        input expected_overflow;
        real real_expected;
        real real_actual;
        begin
            real_expected = ieee754_to_real(expected_result);
            real_actual = ieee754_to_real(result);

            if (result !== expected_result || overflow !== expected_overflow) begin
                $display("ASSERTION FAILED: Expected Result = %h (%0.6f), Got = %h (%0.6f) | Expected Overflow = %b, Got = %b",
                        expected_result, real_expected,
                        result, real_actual,
                        expected_overflow, overflow);
            end else begin
                $display("ASSERTION PASSED: Result = %h (%0.6f) | Overflow = %b", 
                        result, real_actual, overflow);
            end
        end
    endtask

    // Function to convert IEEE 754 binary representation to real number
    function real ieee754_to_real(input [31:0] ieee);
        begin
            ieee754_to_real = (2.0 ** (ieee[30:23] - 127)) *
                            ($itor({1'b1, ieee[22:0]}) / (2.0 ** 23)) *
                            ((-1.0) ** ieee[31]);
        end
    endfunction

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate clock with period of 10ns
    end

    initial begin
        // reset
        rst = 1;
        start = 1;
        a = 0;
        b = 0;
        @(posedge clk);
        rst = 0;

        // Test Case 1: Multiplying two zeros
        a = 32'h00000000; b = 32'h00000000; // 0 * 0
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h00000000, 1'b0);

        // Test Case 2: Multiplying a zero with a positive number
        a = 32'h00000000; b = 32'h3F800000; // 0 * 1.0
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h00000000, 1'b0);

        // Test Case 3: Multiplying a zero with a negative number
        a = 32'h00000000; b = 32'hBF800000; // 0 * -1.0
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h00000000, 1'b0);

        // Test Case 4: Multiplying two positive numbers
        a = 32'h3F800000; b = 32'h40000000; // 1.0 * 2.0
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h40000000, 1'b0);

        // Test Case 5: Multiplying two negative numbers
        a = 32'hBF800000; b = 32'hBF800000; // -1.0 * -1.0
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h3F800000, 1'b0);

        // Test Case 6: Multiplying a positive and a negative number
        a = 32'h3F800000; b = 32'hBF800000; // 1.0 * -1.0
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'hBF800000, 1'b0);

        // Test Case 7: Multiplying numbers leading to overflow
        a = 32'h7F7FFFFF; b = 32'h40000000; // Largest finite * 2
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h7F800000, 1'b1); // Expected infinity with overflow

        // Test Case 8: Multiplying small numbers (denormalized case)
        a = 32'h00800000; b = 32'h00800000; // Smallest normalized * Smallest normalized
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h00000000, 1'b0); // Expected denormalized product

        // Test Case 9: Multiplying numbers with large exponent difference
        a = 32'h7F800000; b = 32'h00000001; // Infinity * Smallest subnormal
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h7F800000, 1'b0); // Expected infinity

        // Test Case 10: Multiplying random numbers
        a = 32'h40800000; b = 32'h40A00000; // 4.0 * 5.0
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h41200000, 1'b0); // Expected 20.0

        // Test Case 11: Multiplying infinity with a finite number
        a = 32'h7F800000; b = 32'h3F800000; // Infinity * 1.0
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h7F800000, 1'b1); // Expected infinity

        // Test Case 12: Multiplying infinity with infinity
        a = 32'h7F800000; b = 32'h7F800000; // Infinity * Infinity
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h7F800000, 1'b0); // Expected infinity

        // Test Case 13: Multiplying infinity with NaN
        a = 32'h7F800000; b = 32'h7FC00000; // Infinity * NaN
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h7FC00000, 1'b0); // Expected NaN

        // Test Case 14: Multiplying NaN with a finite number
        a = 32'h7FC00000; b = 32'h3F800000; // NaN * 1.0
        @(posedge clk);
        display_result(a, b, result, overflow);
        assert_result(32'h7FC00000, 1'b1); // Expected NaN

        $stop;
    end

endmodule
