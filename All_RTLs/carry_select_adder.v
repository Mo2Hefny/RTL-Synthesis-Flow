module carry_select_adder #(parameter N = 32) (
    input [N-1:0] A,         // Input operand A
    input [N-1:0] B,         // Input operand B
    input Cin,               // Initial carry-in
    output [N-1:0] Sum,      // Output Sum
    output Cout              // Final carry-out
);
    // Internal signals
    wire [N-1:0] Sum0, Sum1; // Sum for carry_in = 0 and carry_in = 1
    wire [N:0] Carry0, Carry1; // Carry chain for carry_in = 0 and carry_in = 1
    wire [N-1:0] CarryMux;   // Selected carry at each stage

    assign Carry0[0] = 0;    // Carry chain start for carry_in = 0
    assign Carry1[0] = 1;    // Carry chain start for carry_in = 1

    // Generate sums and carries for both carry_in = 0 and carry_in = 1
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : FullAdderLogic
            // Full adder logic for carry_in = 0
            assign Sum0[i] = A[i] ^ B[i] ^ Carry0[i];
            assign Carry0[i+1] = (A[i] & B[i]) | (A[i] & Carry0[i]) | (B[i] & Carry0[i]);

            // Full adder logic for carry_in = 1
            assign Sum1[i] = A[i] ^ B[i] ^ Carry1[i];
            assign Carry1[i+1] = (A[i] & B[i]) | (A[i] & Carry1[i]) | (B[i] & Carry1[i]);

            // MUX to select correct carry and sum based on previous stage carry
            assign CarryMux[i] = (Cin == 0) ? Carry0[i+1] : Carry1[i+1];
            assign Sum[i] = (Cin == 0) ? Sum0[i] : Sum1[i];
        end
    endgenerate

    // Final carry-out
    assign Cout = CarryMux[N-1];

endmodule
