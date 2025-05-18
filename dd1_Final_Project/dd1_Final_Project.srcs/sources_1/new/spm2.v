`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2025 09:43:54 PM
// Design Name: 
// Module Name: spm2
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


module spm2 (
    input wire clk,
    input wire rst,
    input wire signed [7:0] x,  // Parallel multiplicand
    input wire signed [7:0] y,  // Serial multiplier
    output reg signed [15:0] prod,  // Product output
    output reg done  // Completion flag
);

// wire signed [7:0] x_reg;  
// wire signed [7:0] y_reg;

 reg signed [7:0] x_reg;  
 reg  signed [7:0] y_reg;

  reg [7:0]shift_reg_y;
  reg [2:0] count;      // Counter for bit position in serial input y

//  assign x_reg= (x[7]&y[7]) ? ~x+1:x;
//  assign y_reg= (x[7]&y[7]) ? ~y+1:y;
//  assign shift_reg_y = y_reg;
  
   always @(posedge clk or posedge rst) begin
//        shift_reg_y <= y;

//        x_reg<= (x[7]&y[7]) ? ~x+1:x;
//        y_reg<= (x[7]&y[7]) ? ~y+1:y;

        if (rst) begin
            // Reset all registers
            count <= 0;
            prod <= 0;
            done <= 0;
            shift_reg_y <= 0;
            x_reg <= 0;
            y_reg <= 0;
        end 
        else if (!done) begin
             if (count == 0) begin
                // First cycle after reset - Initialize values
                x_reg <= x[7] ? (~x + 1) : x;  // Absolute value of x
                y_reg <= y[7] ? (~y + 1) : y;  // Absolute value of y
                shift_reg_y <= y[7] ? (~y + 1) : y;  // Initialize shift register
                count <= count + 1;
             end
             else if (count < 8) begin
                  if(shift_reg_y[0]) begin
                    prod <= prod +{{8{x_reg[7]}}, x_reg} << count;
                  end
                  shift_reg_y <= {y_reg[7], shift_reg_y[7:1]};
                  count <= count + 1;
             end 
        end
        else done <= 1;
    end

endmodule
