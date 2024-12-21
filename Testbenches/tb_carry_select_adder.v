module TestbenchSignedCSA;
    reg signed [7:0] A, B; // 8-bit signed inputs
    reg Cin;               // Carry-in
    wire signed [7:0] Sum; // 8-bit signed sum
    wire Cout;             // Carry-out
    wire Overflow;         // Overflow flag

    // Instantiate the Carry Select Adder (CSA)
    CarrySelectAdder #(8) CSA (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout),
        .Overflow(Overflow)
    );

    initial begin
        // Test Case 1: Overflow with positive numbers
        A = 8'sb01111111;  // +127
        B = 8'sb00000001;  // +1
        Cin = 0;
        #10;
        $display("Test 1: A=%d, B=%d, Cin=%b, Sum=%d, Cout=%b, Overflow=%b", A, B, Cin, Sum, Cout, Overflow);

        // Test Case 2: Overflow with negative numbers
        A = 8'sb10000000;  // -128
        B = 8'sb11111111;  // -1
        Cin = 0;
        #10;
        $display("Test 2: A=%d, B=%d, Cin=%b, Sum=%d, Cout=%b, Overflow=%b", A, B, Cin, Sum, Cout, Overflow);

        // Test Case 3: Addition of positive and negative number
        A = 8'sb00001010;  // +10
        B = 8'sb11110110;  // -10
        Cin = 0;
        #10;
        $display("Test 3: A=%d, B=%d, Cin=%b, Sum=%d, Cout=%b, Overflow=%b", A, B, Cin, Sum, Cout, Overflow);

        // Test Case 4: Addition of two positive numbers
        A = 8'sb00000011;  // +3
        B = 8'sb00000010;  // +2
        Cin = 0;
        #10;
        $display("Test 4: A=%d, B=%d, Cin=%b, Sum=%d, Cout=%b, Overflow=%b", A, B, Cin, Sum, Cout, Overflow);

        // Test Case 5: Addition of two negative numbers
        A = 8'sb11111101;  // -3
        B = 8'sb11111110;  // -2
        Cin = 0;
        #10;
        $display("Test 5: A=%d, B=%d, Cin=%b, Sum=%d, Cout=%b, Overflow=%b", A, B, Cin, Sum, Cout, Overflow);

        // Test Case 6: Random Test Case 1
        A = 8'sb01100101;  // +101
        B = 8'sb10010101;  // -107
        Cin = 0;
        #10;
        $display("Test 6: A=%d, B=%d, Cin=%b, Sum=%d, Cout=%b, Overflow=%b", A, B, Cin, Sum, Cout, Overflow);

        // Test Case 7: Random Test Case 2
        A = 8'sb10101010;  // -86
        B = 8'sb00110100;  // +52
        Cin = 0;
        #10;
        $display("Test 7: A=%d, B=%d, Cin=%b, Sum=%d, Cout=%b, Overflow=%b", A, B, Cin, Sum, Cout, Overflow);

        // Test Case 8: Random Test Case 3
        A = 8'sb01111100;  // +124
        B = 8'sb00000011;  // +3
        Cin = 0;
        #10;
        $display("Test 8: A=%d, B=%d, Cin=%b, Sum=%d, Cout=%b, Overflow=%b", A, B, Cin, Sum, Cout, Overflow);
    end
endmodule

