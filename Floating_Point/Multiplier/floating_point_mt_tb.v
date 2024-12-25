`timescale 1ns / 1ps

module floating_point_mt_tb;

    reg [31:0] a;  
    reg [31:0] b;  

    wire [31:0] result; 
    wire overflow;

    floating_point_mt uut (
        .a(a),
        .b(b),
        .result(result),
        .overflow(overflow)
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
        // Test Case 1: Multiplying two zeros
        a = 32'h00000000; b = 32'h00000000; // 0 * 0
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h00000000, 1'b0);

        // Test Case 2: Multiplying a zero with a large positive number
        a = 32'h00000000; b = 32'h7F7FFFFF; // 0 * Largest finite positive
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h00000000, 1'b0);

        // Test Case 3: Multiplying a positive number with a large negative number
        a = 32'h3F800000; b = 32'hFF800000; // 1.0 * -Infinity
        #20
        display_result(a, b, result, overflow);
        assert_result(32'hFF800000, 1'b1);

        // Test Case 4: Multiplying two positive numbers
        a = 32'h3F800000; b = 32'h40000000; // 1.0 * 2.0
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h40000000, 1'b0);

        // Test Case 5: Multiplying a negative number with zero
        a = 32'hBF800000; b = 32'h00000000; // -1.0 * 0
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h00000000, 1'b0);

        // Test Case 6: Multiplying two numbers leading to denormalized result
        a = 32'h3F800000; b = 32'hBF800000; // 1.0 * -1.0
        #20
        display_result(a, b, result, overflow);
        assert_result(32'hBF800000, 1'b0); // Expected smallest subnormal

        // Test Case 7: Multiplying a finite number with NaN
        a = 32'h3F800000; b = 32'h7FC00000; // 1.0 * NaN
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h7FC00000, 1'b1);

        // Test Case 10: Multiplying two small normalized numbers
        a = 32'h40800000; b = 32'h40A00000; // 4.0 * 5.0
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h41a00000, 1'b0); // Expected 20.0

        // Test Case 11: Multiplying two small random numbers
        a = 32'h42480000; b = 32'hC2A00000; // 50.0 * -80.0
        #20
        display_result(a, b, result, overflow);
        assert_result(32'hC57a0000, 1'b0); // Expected -4000.0

        // Test Case 12: Multiplying two small random negative numbers
        a = 32'hC1200000; b = 32'hC1A00000; // -10.0 * -20.0
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h43480000, 1'b0); // Expected 200.0


        // Test Case 13: Multiplying a negative infinity with a finite positive number
        a = 32'hFF800000; b = 32'h3F800000; // -Infinity * 1.0
        #20
        display_result(a, b, result, overflow);
        assert_result(32'hFF800000, 1'b1);

        // Test Case 14: Multiplying a positive number with its reciprocal
        a = 32'h40800000; b = 32'h3F000000; // 4.0 * 0.5
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h40000000, 1'b0); // Expected 2.0


        $stop;
    end

endmodule
