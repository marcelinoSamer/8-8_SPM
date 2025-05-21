`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2025 02:13:58 AM
// Design Name: 
// Module Name: serial_parallel_multiplier
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
// Company:
// Engineer:
//
// Create Date: 05/21/2025 07:40:28 AM
// Design Name:
// Module Name: spm_finally
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




  module serial_parallel_multiplier(
    input clk, rst,
    input start,
    input [7:0] x, y,
    output reg [15:0] P,
    output reg flag
    );
   
   
     reg state;
    reg [7:0] x_reg;
    reg [7:0] y_reg;
    reg s;
   
   
    reg [3:0] counter;
   
   
    always @(posedge clk , posedge rst) begin
       
        if (rst) begin
            flag <= 0;
            x_reg <= 0;
            y_reg <= 0;
            P <= 0;
            counter <= 0;
            state <= 0;
        end
        else if (start && state == 0) begin
            state <= 1;
            flag <= 0;
               s <= x[7] ^ y[7];
            y_reg <= y[7] ? (~y + 1) : y;
            x_reg <= x[7] ? (~x + 1) : x;
                P <= 0;
           counter <= 8;
        end
        else if (state) begin
            if (counter > 0) begin
                P <= P + (y_reg[0] ? ({{8{x_reg[7]}}, x_reg} << (8 - counter)) : 0);
               
               
                y_reg <= {y_reg[7], y_reg[7:1]};
                counter <= counter - 1;
            end
            else begin
                P <= s ? (~P + 1) : P;
                flag <= 1;
                state <= 0;
            end
        end
       
    end
endmodule
