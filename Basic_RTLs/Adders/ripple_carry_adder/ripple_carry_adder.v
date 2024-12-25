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
    input signed [N-1:0] A,    // Signed operand A
    input signed [N-1:0] B,    // Signed operand B
    input Cin,                 // Initial carry-in
    output [N-1:0] Sum,        // Sum output
    output Cout,               // Final carry-out
    output Overflow            // Overflow flag for signed addition
);
    wire [N:0] Carry;          // Internal carry signals
    assign Carry[0] = Cin;     // Initial carry-in

    // Instantiate Full Adder for each bit
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : FullAdderStage
            FullAdder FA (
                .A(A[i]),
                .B(B[i]),
                .Cin(Carry[i]),
                .Sum(Sum[i]),
                .Cout(Carry[i+1])
            );
        end
    endgenerate

    // Final carry-out: This is the carry from the MSB, but only meaningful for unsigned addition.
    assign Cout = Carry[N];  // This will be 1 if there was a carry out from MSB (not signed overflow)

    // Detect signed overflow
    assign Overflow = Carry[N-1] ^ Carry[N]; // Check for MSB carry inconsistency

endmodule
