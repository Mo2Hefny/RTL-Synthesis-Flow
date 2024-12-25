`timescale 1ns / 1ps
module floating_point_cla_tb #(parameter W = 32);
    reg [W-1:0] A, B;
    wire [W-1:0] result;
    real value;
    floating_point_cla #(32) F_Add (.a(A), .b(B), .sum(result));

    initial  
    begin
        A = 32'b0_10000000_10011001100110011001100;
        B = 32'b0_10000001_00001100110011001100110;
        #20
        A = 32'b0_01111110_01010001111010111000010;  // 0.66
        B = 32'b0_01111110_00000101000111101011100;  // 0.51
        #20
        A = 32'b1_01111110_00000000000000000000000;  // -0.5
        B = 32'b1_10000001_10011001100110011001100;  // -6.4
        #20
        A = 32'b1_01111110_00000000000000000000000;  // -0.5
        B = 32'b0_10000001_10011001100110011001100;  //  6.4
        #20
        A = 32'h4034b4b5;
        B = 32'hbf70f0f1;
        #20
        A = 32'h3F800000; // 1.0
        B = 32'hBF800000; // -1.0
        #20
        A = 32'h41200000; // 10.0
        B = 32'hC1200000; // -10.0
        #20
        A = 32'h3FC00000; // 1.5
        B = 32'h3FC00000; // 1.5
    end

    initial
    begin
        value = (2 ** (result[30:23] - 127)) * ($itor({1'b1, result[22:0]}) / (2 ** 23)) * ((-1) ** result[31]);

        $display("Expected Value : %f Result : %f", 3.2 + 4.2, value);

        #20
        value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
        $display("Expected Value : %f Result : %f", 0.66 + 0.51, value);

        #20
        value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
        $display("Expected Value : %f Result : %f", -0.5 - 6.4, value);

        #20
        value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
        $display("Expected Value : %f Result : %f", -0.5 + 6.4, value);

        #20
        value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
       $display("Expected Value : %f Result : %f", 2.8235295 - 0.9411765, value);

        #20
        value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
        $display("Expected Value : %f Result : %f", 1.0 - 1.0, value);

        #20
        value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
        $display("Expected Value : %f Result : %f", 10.0 + (-10.0), value);

        #20
        value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
        $display("Expected Value : %f Result : %f", 1.5 + 1.5, value);
        $finish;
    end
endmodule


