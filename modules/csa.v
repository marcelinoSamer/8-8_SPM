`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 02:14:52 PM
// Design Name: 
// Module Name: csa
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


module csa(
input x,y,rst,clk,
output final_sum
    );
    
    reg Q1,Q2;//for FFs
    wire cout,sum;
    
     half_adder(.a(y),.b(Q2),.cout(cout),.sum(sum));
     
     wire D1,D2;//for FFs
     
     assign D1= sum^x;
     assign D2 =cout^(x&sum);
     
     
     always @(posedge clk) begin//first ff
     
     if(!rst)
        Q1<=0; 
        else
        Q1<=D1;
     end
     
      always @(posedge clk) begin//second ff
     
     if(!rst)
        Q2<=0; 
        else
        Q2<=D2;
     end
     
     assign final_sum =Q1;
endmodule
