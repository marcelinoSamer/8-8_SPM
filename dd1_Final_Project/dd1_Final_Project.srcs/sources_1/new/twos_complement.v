`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 04:41:46 PM
// Design Name: 
// Module Name: twos_complement
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


module twos_complement(
input a,clk,rst,
output S
    );
    
        reg Q1,Q2;//for FFs
   
     
     wire D1,D2;//for FFs
     
     assign D1= a^Q2;
     assign D2 =a|Q2;
     
     
     always @(posedge clk) begin//first ff
     
     if(rst)
        Q1<=0; 
        else
        Q1<=D1;
     end
     
      always @(posedge clk) begin//second ff
     
     if(rst)
        Q2<=0; 
        else
        Q2<=D2;
     end
     
     assign S =Q1;
endmodule
