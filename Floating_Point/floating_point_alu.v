module floating_point_alu #(parameter W=32) (
    input clk.
    input signed [W-1:0] a,
    input signed [W-1:0] b,
    input sel,
    output reg signed [W-1:0] result.
    output reg overflow
);

    wire [W-1:0] adder_result;
    wire [W-1:0] multiplier_result;
    wire overflow_adder;
    wire overflow_multiplier;

    floating_point_cla adder (
        .a(a),
        .b(b),
        .cin(sel),
        .sum(adder_result),
        .cout(),
        .overflow(overflow_adder)
    );

    floating_point_mt multiplier (
        .a(a),
        .b(b),
        .product(multiplier_result)
        .overflow(overflow_multiplier)
    );

endmodule
