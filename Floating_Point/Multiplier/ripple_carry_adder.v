module FullAdder (
    input A,        // 1-bit input A
    input B,        // 1-bit input B
    input Cin,      // Carry-in
    output Sum,     // 1-bit Sum output
    output Cout     // Carry-out
);
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (B & Cin) | (A & Cin);
endmodule

// the signed 8-bit range is from -128 to 127

module RippleCarryAdder #(parameter N = 8) (
    input signed [N-1:0] a,    // Signed operand A
    input signed [N-1:0] b,    // Signed operand B
    input cin,                 // Initial carry-in
    output [N-1:0] sum,        // Sum output
    output cout,               // Final carry-out
    output overflow            // Overflow flag for signed addition
);
    wire [N:0] carry;          // Internal carry signals
    assign carry[0] = cin;     // Initial carry-in

    // Instantiate Full Adder for each bit
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : FullAdderStage
            FullAdder FA (
                .A(a[i]),
                .B(b[i]),
                .Cin(carry[i]),
                .Sum(sum[i]),
                .Cout(carry[i+1])
            );
        end
    endgenerate

    // Final carry-out: This is the carry from the MSB, but only meaningful for unsigned addition.
    assign cout = carry[N];  // This will be 1 if there was a carry out from MSB (not signed overflow)

    // Detect signed overflow
    assign overflow = carry[N-1] ^ carry[N]; // Check for MSB carry inconsistency

endmodule
