`timescale 1ns / 1ps

module floating_point_alu_tb;

    reg [31:0] a;
    reg [31:0] b;
    reg cin;
    reg sel;
    wire [31:0] result; 
    wire overflow;
    wire done;

    floating_point_alu uut (
        .a(a),
        .b(b),
        .sel(sel),
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
        // reset
        cin = 0;
        // Test Case 1:
        a = 32'h00000000; b = 32'h00000000; // 0, 0
        sel = 1'b0;
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h00000000, 1'b0);
        sel = 1'b1;
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h00000000, 1'b0);

        // Test Case 2:
        a = 32'h00000000; b = 32'h3F800000; // 0, 1.0
        sel = 1'b0;
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h3F800000, 1'b0);
        sel = 1'b1;
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h00000000, 1'b0);

        // Test Case 3:
        a = 32'h00000000; b = 32'hBF800000; // 0, -1.0
        sel = 1'b0;
        #20
        display_result(a, b, result, overflow);
        assert_result(32'hBF800000, 1'b0);
        sel = 1'b1;
        #20
        display_result(a, b, result, overflow);
        assert_result(32'h00000000, 1'b0);

        // Test Case 4:
        a = 32'b1_01111110_00000000000000000000000; b = 32'b1_10000001_10011001100110011001100; // 1.0, 2.0
        sel = 1'b0;
        #20
        display_result(a, b, result, overflow);
        assert_result(32'hC0DCCCCC, 1'b0);
        $stop;
    end

endmodule
