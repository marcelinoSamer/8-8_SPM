`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 02:11:05 PM
// Design Name: 
// Module Name: spm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Your Name
// Design Name: Serial-Parallel Multiplier
// Module Name: spm
// Description: Signed 8-bit × 8-bit Serial-Parallel Multiplier using Carry Save Adders
//////////////////////////////////////////////////////////////////////////////////

//module spm(
//    input clk,
//    input rst,
//    input signed [7:0] x,
//    input signed [7:0] y,
//    output reg signed [15:0] prod,
//    output reg done
//    );

//    // Internal registers
//    reg [7:0] x_reg;
//    reg [7:0] y_reg;
//    reg [2:0] count;
//    reg signed [15:0] acc; // Accumulator for product

//    wire [7:0] partial_product;
//    wire s1, s2, s3, s4, s5, s6, s7, s8;

//    // Current partial product (x & y[count])
//    assign partial_product = y_reg[count] ? x_reg : 8'b0;

//    // Two's complement for MSB bit if needed (sign bit)
//    wire tc_out;
//    twos_complement tcmp (
//        .a(partial_product[7]),
//        .clk(clk),
//        .rst(rst),
//        .S(tc_out)
//    );

//    // Chain of 1-bit CSA stages
//    wire [7:0] csa_out;
    
//    csa csa0(.x(partial_product[0]), .y(acc[0]), .clk(clk), .rst(rst), .final_sum(csa_out[0]));
//    csa csa1(.x(partial_product[1]), .y(acc[1]), .clk(clk), .rst(rst), .final_sum(csa_out[1]));
//    csa csa2(.x(partial_product[2]), .y(acc[2]), .clk(clk), .rst(rst), .final_sum(csa_out[2]));
//    csa csa3(.x(partial_product[3]), .y(acc[3]), .clk(clk), .rst(rst), .final_sum(csa_out[3]));
//    csa csa4(.x(partial_product[4]), .y(acc[4]), .clk(clk), .rst(rst), .final_sum(csa_out[4]));
//    csa csa5(.x(partial_product[5]), .y(acc[5]), .clk(clk), .rst(rst), .final_sum(csa_out[5]));
//    csa csa6(.x(partial_product[6]), .y(acc[6]), .clk(clk), .rst(rst), .final_sum(csa_out[6]));
//    csa csa7(.x(partial_product[7]), .y(acc[7]), .clk(clk), .rst(rst), .final_sum(csa_out[7]));

//    // Control logic
//    always @(posedge clk or negedge rst) begin
//        if (!rst) begin
//            x_reg <= 0;
//            y_reg <= 0;
//            count <= 0;
//            acc <= 0;
//            prod <= 0;
//            done <= 0;
//        end else if (!done) begin
//            if (count == 0) begin
//                x_reg <= x;
//                y_reg <= y;
//                acc <= 0;
//                prod <= 0;
//            end

//            // Shift CSA output left by current count and accumulate
//            acc <= acc + ({{8{1'b0}}, csa_out} << count);
//            count <= count + 1;

//            if (count == 7) begin
//                prod <= acc;
//                done <= 1;
//            end
//        end
//    end

//endmodule


module spm(
    input clk,
    input rst,
    input signed [7:0] x,
   // input signed [7:0] y,// still not sure how Y will be implemented
   input y,
    output reg signed [15:0] prod
    );
    
 
wire s1,s2,s3,s4,s5,s6,s7,s8;


     twos_complement first (.a(y&x[7]),.clk(clk),.rst(rst),.S(s1));// first two's complement
      
          
    // csa numbered from left to right
    
     csa first_csa(.x(x[6]&y),.y(s1),.rst(rst),.clk(clk),.final_sum(s2));
     
     csa second_csa(.x(x[5]&y),.y(s2),.rst(rst),.clk(clk),.final_sum(s3));

     csa third_csa(.x(x[4]&y),.y(s3),.rst(rst),.clk(clk),.final_sum(s4));
     
     csa fourth_csa(.x(x[3]&y),.y(s4),.rst(rst),.clk(clk),.final_sum(s5));
             
     csa fifth_csa(.x(x[2]&y),.y(s5),.rst(rst),.clk(clk),.final_sum(s6));
     
     csa sixth_csa(.x(x[1]&y),.y(s6),.rst(rst),.clk(clk),.final_sum(s7));
     
     csa seventh_csa(.x(x[0]&y),.y(s7),.rst(rst),.clk(clk),.final_sum(s8));

always @(posedge clk) begin
        if (rst)
            prod <= 0;
        else
            prod <= {15'b0, s8}; 
    end

 
endmodule
