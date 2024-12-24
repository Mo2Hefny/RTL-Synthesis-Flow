module booth_multiplier (
    input signed [31:0] multiplicand, // The number being multiplied
    input signed [31:0] multiplier,  // The multiplier
    output reg signed [63:0] product // The 64-bit product
);
    reg [63:0] A, S, P; // Registers for Booth's operations
    reg [32:0] Q;       // Extended multiplier with extra bit for Booth encoding
    integer i;

    initial begin
        product = 0; // Initialize product to 0
    end

    always @(*) begin
        // Initialize Booth's Registers
        A = {multiplicand, 32'b0}; // A = Multiplicand shifted left
        S = {-multiplicand, 32'b0}; // S = -Multiplicand shifted left
        P = {32'b0, multiplier}; // P = Partial product
        Q = {multiplier, 1'b0}; // Extended multiplier with an extra 0

        // Perform Booth's Algorithm
        for (i = 0; i < 32; i = i + 1) begin
            case (Q[1:0])
                2'b01: P = P + A; // Add multiplicand to the partial product
                2'b10: P = P + S; // Subtract multiplicand from the partial product
                default: P = P;   // No operation
            endcase
            P = {P[63], P[63:1]}; // Arithmetic right shift (preserves the sign)
            Q = {P[0], Q[32:1]};  // Shift the Q register
        end

        // Assign final product
        product = P;
    end
endmodule