module verilog_multiplier #(parameter N = 32) (
    input [N-1:0] a,          // Input a with generic width
    input [N-1:0] b,          // Input b with generic width
    output [2*N-1:0] product  // Output product, width of a+b
);

    assign product = a * b; // Perform multiplication
endmodule
