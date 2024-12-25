module booth_multiplier (
    input signed [31:0] a,
    input signed [31:0] b,
    output reg signed [63:0] product
);
    reg [63:0] regA, regS, regP;
    reg [32:0] regQ;
    integer i;

    initial begin
        product = 0;
    end

    always @(*) begin
        regA = {a, 32'b0};
        regS = {-a, 32'b0};
        regP = {32'b0, b};
        regQ = {b, 1'b0};

        for (i = 0; i < 32; i = i + 1) begin
            case (regQ[1:0])
                2'b01: regP = regP + regA;
                2'b10: regP = regP + regS;
                default: regP = regP;
            endcase
            regP = {regP[63], regP[63:1]};
            regQ = {regP[0], regQ[32:1]};
        end

        product = regP;
    end
endmodule