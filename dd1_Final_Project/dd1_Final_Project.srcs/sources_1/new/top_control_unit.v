`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2025 02:39:45 PM
// Design Name: 
// Module Name: top_control_unit
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


module top_control_unit(
    // all modules
    input wire clk,
    input wire reset, // start
    
    // spm mpodule    
    input [7:0] parallel,
//    input [7:0] serial,
    input serial, //testing
    
    // for scrolling
    input wire btnL,
    input wire btnR,
    output reg [2:0] scroll_offset, // intermediate not output
    
    output done,
    
    // final out
    output reg [6:0] displayedSign,
    output reg [6:0] displayed1, displayed2, displayed3
    
    
);

// spm module
    wire [15:0] product; // or reg

// bin_to_bcd module
    wire sign1;
    wire [19:0] bcd;
    
// seven_seg_display module
    wire [6:0] digit [5:0];
    
// toggle logic
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

spm spm0 (.clk(clk),.rst(reset), .x(parallel), .y(serial), .prod(product)); // out: prod // edit to accept [7:0] y

bin_to_bcd bin_to_bcd0 ( .clk(clk), .reset(reset), 
                         .start(1), // revise start again
                         .binary_in(product),
                         .done(done), // revise 
                         .sign(sign1), 
                         .bcd_digit(bcd)); // out: done, sign, bcd_digit
                                                                                                             

seven_seg_display display( .clk(clk), .reset(reset), 
    .bcd_digit(bcd),  // 5 × 4-bit BCD digits
    .sign(sign),
    .d5(digit[5]), .d4(digit[4]) , .d3(digit[3]), .d2(digit[2]), .d1(digit[1]), .d0(digit[0]), // sign - tenthousands - ... - units
    .an()           // 6 digits: 5 for number, 1 for sign
);

always @(*) begin
    displayedSign = digit[5];  // Sign is always leftmost

    case (scroll_offset)
        0: begin
            displayed1 = digit[4];
            displayed2 = digit[3];
            displayed3 = digit[2];
        end
        1: begin
            displayed1 = digit[3];
            displayed2 = digit[2];
            displayed3 = digit[1];
        end
        2: begin
            displayed1 = digit[2];
            displayed2 = digit[1];
            displayed3 = digit[0];
        end
        default: begin
            displayed1 = digit[4];
            displayed2 = digit[3];
            displayed3 = digit[2];
        end
    endcase
end


endmodule