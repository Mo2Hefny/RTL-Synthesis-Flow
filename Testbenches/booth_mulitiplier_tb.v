`timescale 1ns / 1ps

module booth_multiplier_tb;

    // Parameters
    parameter WIDTH = 32;
    parameter RESULT_WIDTH = 2 * WIDTH;

    // Testbench signals
    reg signed [WIDTH-1:0] multiplicand;
    reg signed [WIDTH-1:0] multiplier;
    wire signed [RESULT_WIDTH-1:0] product;
    wire signed [RESULT_WIDTH-1:0] productR;
    wire signed [RESULT_WIDTH-1:0] productS;

    integer success_count = 0;
    integer failure_count = 0;
    integer testcase_num = 1;

    // Instantiate the DUT
    booth_multiplier dut (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product)
    );

   // booth_multiplierR dutR (
    //    .multiplicand(multiplicand),
        //.multiplier(multiplier),
      //  .product(productR)
    //);

  //  booth_multiplierS dutS (
//        .multiplicand(multiplicand),
        //.multiplier(multiplier),
      //  .product(productS)
    //);

    // Task to execute a single test case
    task run_testcase;
        input signed [WIDTH-1:0] test_multiplicand;
        input signed [WIDTH-1:0] test_multiplier;
        input signed [RESULT_WIDTH-1:0] expected_product;
        begin
            multiplicand = test_multiplicand;
            multiplier = test_multiplier;
            #10; // Allow some time for the computation

            if (product === expected_product) begin
                $display("TestCase#%0d: success (Multiplicand=%d, Multiplier=%d, Product=%d)", 
                    testcase_num, multiplicand, multiplier, product);
                success_count = success_count + 1;
            end else begin
                $display("TestCase#%0d: failed (Multiplicand=%d, Multiplier=%d, Product=%d, Expected=%d)", 
                    testcase_num, multiplicand, multiplier, product, expected_product);
                failure_count = failure_count + 1;
            end

            testcase_num = testcase_num + 1;
            #20; // Wait for the result to stabilize
        end
    endtask

    // Test sequence
    initial begin
        // 1. Multiplication of a positive and a negative number
        run_testcase(32'd15, -32'd3, -64'd45);
        

        // 2. Multiplication of two positive numbers
        run_testcase(32'd12, 32'd5, 64'd60);

        // 3. Multiplication of two negative numbers
        run_testcase(-32'd7, -32'd6, 64'd42);

        // 4. Multiplication of a negative and a positive number
        run_testcase(-32'd8, 32'd9, -64'd72);

        // 5. Multiplication by zero
        run_testcase(32'd0, 32'd25, 64'd0);
        run_testcase(32'd25, 32'd0, 64'd0);

        // 6. Multiplication by one
        run_testcase(32'd1, 32'd50, 64'd50);
        run_testcase(32'd50, 32'd1, 64'd50);

        // 7. Random test cases
        run_testcase(32'd12345, 32'd6789, 64'd83810205); // Random case 1
        run_testcase(-32'd4567, 32'd2345, -64'd10709615); // Random case 2

        // Display summary
        $display("Total test cases: %0d", testcase_num - 1);
        $display("Successes: %0d", success_count);
        $display("Failures: %0d", failure_count);

        $stop; // End simulation
    end

endmodule