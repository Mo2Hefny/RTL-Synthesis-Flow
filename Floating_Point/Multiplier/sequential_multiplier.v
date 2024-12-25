module sequential_multiplier #(parameter W = 32) (
    input clk,
    input rst,
    input start,
    input signed [W-1:0] a,
    input signed [W-1:0] b,
    output reg signed [2*W-1:0] product,
    output reg done
);

    reg [W-1:0] a_reg, b_reg;
    reg [2*W-1:0] product_reg;
    reg [5:0] count; // Supports up to 32-bit multiplication (log2(W) = 6 bits)
    reg is_negative;
    reg running;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product <= 0;
            product_reg <= 0;
            a_reg <= 0;
            b_reg <= 0;
            count <= 0;
            done <= 0;
            is_negative <= 0;
            running <= 0;
        end else begin
            if (start && !running) begin
                a_reg <= a[W-1] ? ~a + 1 : a;
                b_reg <= b[W-1] ? ~b + 1 : b;
                product_reg <= 0;
                count <= 0;
                done <= 0;
                running <= 1;
                is_negative <= a[W-1] ^ b[W-1];
            end else if (running) begin
                if (count < W) begin
                    if (b_reg[0]) begin
                        product_reg <= product_reg + (a_reg << count);
                    end
                    b_reg <= b_reg >> 1;
                    count <= count + 1;
                end else begin
                    product <= is_negative ? ~product_reg + 1 : product_reg;
                    done <= 1;
                    running <= 0;
                end
            end
        end
    end

endmodule
