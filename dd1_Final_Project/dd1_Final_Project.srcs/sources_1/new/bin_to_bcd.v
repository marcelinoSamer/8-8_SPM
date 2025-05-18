`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2025 09:52:54 AM
// Design Name: 
// Module Name: bin_to_bcd
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


module bin_to_bcd(  
    input wire clk,
    input wire reset,
    input wire start, 
    input wire signed [15:0] binary_in,
    output reg done,
    output reg sign,
    output reg [19:0] bcd_digit
    );
    
    reg [5:0] shift_count;
    reg [35:0] shift_reg; // 5*4 BCD + 16 bits for input = 36 bits total
    reg working;

    integer i;
    
    always @(posedge clk) begin
        if (reset) begin
            done <= 0;
            working <= 0;
            shift_count <= 0;
            shift_reg <= 0;
            sign <= 0;
            bcd_digit <= 19'b0;
        end else if (start && !working) begin
            done <= 0;
            working <= 1;
            shift_count <= 0;
            sign <= binary_in[15];
            // Load absolute value of input into LSBs of shift register
            shift_reg[15:0] <= binary_in[15] ? (~binary_in + 1) : binary_in;
            shift_reg[35:16] <= 20'd0;
        end else if (working) begin
            // Add 3 to any BCD digit >= 5
            for (i = 0; i < 5; i = i + 1) begin
                if (shift_reg[16 + i*4 +: 4] >= 5) // not indexed right
                    shift_reg[16 + i*4 +: 4] <= shift_reg[16 + i*4 +: 4] + 3; // not indexed right
            end

            // Shift left by 1
            shift_reg <= shift_reg << 1;
            shift_count <= shift_count + 1;

            if (shift_count == 16) begin
                working <= 0;
                done <= 1;
                // Assign output BCD digits
                bcd_digit <= shift_reg[35:16];  // 20 bits = 5 × 4-bit BCD
            end
        end
    end


endmodule
