module floating_point_cla #(parameter N = 32)(
    input [N-1:0] in1, in2,
    output [N-1:0] result,
    output cout,
    output overflow
);

// Parse the inputs: sign, exponent, and mantissa
wire signA = in1[N-1];
wire signB = in2[N-1];
wire [7:0] expA = in1[N-2:N-9];
wire [7:0] expB = in2[N-2:N-9];
wire [23:0] mantA = (expA == 8'b0) ? {1'b0, in1[N-10:0]} : {1'b1, in1[N-10:0]};
wire [23:0] mantB = (expB == 8'b0) ? {1'b0, in2[N-10:0]} : {1'b1, in2[N-10:0]};

// Special case handling
wire isNaN_A = (expA == 8'b11111111) && (mantA[22:0] != 0);
wire isNaN_B = (expB == 8'b11111111) && (mantB[22:0] != 0);
wire isInf_A = (expA == 8'b11111111) && (mantA[22:0] == 0);
wire isInf_B = (expB == 8'b11111111) && (mantB[22:0] == 0);

// Handle NaN cases
wire resultNaN = isNaN_A || isNaN_B || (isInf_A && isInf_B && (signA != signB));
wire [31:0] nanResult = {1'b0, 8'b11111111, 23'b1}; // Canonical NaN

// Handle Infinity cases
wire resultInf = isInf_A || isInf_B;
wire resultInfSign = isInf_A ? signA : signB;
wire [31:0] infResult = {resultInfSign, 8'b11111111, 23'b0}; // Infinity

// Exponent difference and mantissa alignment
wire [7:0] expDiff = (expA >= expB) ? (expA - expB) : (expB - expA);
wire [24:0] mantA_aligned = (expA >= expB) ? {1'b0, mantA} : ({1'b0, mantA} >> expDiff);
wire [24:0] mantB_aligned = (expB >= expA) ? {1'b0, mantB} : ({1'b0, mantB} >> expDiff);
wire [7:0] greaterExp = (expA >= expB) ? expA : expB;

// Perform addition or subtraction of aligned mantissas using CarryLookAheadAdder
wire [24:0] operandA = (mantA_aligned >= mantB_aligned) ? mantA_aligned : mantB_aligned;
wire [24:0] operandB = (mantA_aligned >= mantB_aligned) ? mantB_aligned : mantA_aligned;
wire [24:0] operandB_adjusted = signA == signB ? operandB : ~operandB + 1; // Adjust for subtraction

wire [24:0] sumMantissaTemp;

cla_adder #(25) CLA (
    .a(operandA),
    .b(operandB_adjusted),
    .cin(1'b0), // Add carry-in for subtraction
    .sum(sumMantissaTemp),
    .cout(cout)                       // Carry out for overflow detection
    .overflow(overflow)
);

wire addCarry = sumMantissaTemp[24];

// Normalize the mantissa and adjust the exponent
wire [24:0] adjustedSumMantissa = addCarry 
                                    ? (sumMantissaTemp >> 1) 
                                    : (sumMantissaTemp << (sumMantissaTemp[23] ? 0 : 1));

wire [7:0] normalizedExp = addCarry 
                            ? (greaterExp + 1) 
                            : (sumMantissaTemp[23] ? greaterExp : greaterExp - 1);

// Determine the result sign
wire resultSign = (signA & signB) || (signA & !signB & (mantA_aligned >= mantB_aligned)) || 
                  (signB & !signA & (mantB_aligned > mantA_aligned));

// Check for zero result
wire resultZero = (sumMantissaTemp == 0);
wire [31:0] zeroResult = {1'b0, 8'b0, 23'b0}; // Canonical zero

// Assemble the final result in IEEE 754 format
wire [31:0] normalResult = {resultSign, normalizedExp, adjustedSumMantissa[22:0]};

// Output result with priority handling of special cases
assign result = resultNaN   ? nanResult   :
                resultInf   ? infResult   :
                resultZero  ? zeroResult  :
                normalResult;

endmodule