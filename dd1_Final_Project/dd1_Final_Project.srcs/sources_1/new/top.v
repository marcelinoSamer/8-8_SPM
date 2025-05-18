`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2025 01:56:52 PM
// Design Name: 
// Module Name: top
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


module top(
    input wire clk,
    input wire reset,
    input wire btnL,
    input wire btnR,
    output reg [1:0] scroll_offset  // 0 or 1
);

    reg btnL_prev = 0;
    reg btnR_prev = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            scroll_offset <= 0;
            btnL_prev <= 0;
            btnR_prev <= 0;
        end else begin
            btnL_prev <= btnL;
            btnR_prev <= btnR;

            // Left button scrolls right (decreases offset)
            if (btnL && !btnL_prev && scroll_offset > 0)
                scroll_offset <= scroll_offset - 1;

            // Right button scrolls left (increases offset)
            if (btnR && !btnR_prev && scroll_offset < 1)
                scroll_offset <= scroll_offset + 1;
        end
    end

endmodule