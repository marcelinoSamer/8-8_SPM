`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2025 09:54:59 AM
// Design Name: 
// Module Name: seven_seg_display
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

module seven_seg_display(
    input wire clk,
    input wire reset,
    input wire [19:0] bcd_digit,  // 5 × 4-bit BCD digits
    input wire sign,
    output reg [6:0] d5,d4,d3,d2,d1,d0, // sign - tenthousands - ... - units
    output reg [5:0] an           // 6 digits: 5 for number, 1 for sign
);

    reg [2:0] digit_index = 0;
    reg [3:0] current_bcd;
    reg [19:0] refresh_counter = 0;
    wire [6:0] seg_decoded [5:0];

    // BCD to 7-segment converter
    // sign
    helper_bcd_to_7seg d5 (.bcd_in(current_bcd),.seg_out(seg_decoded[5]));
    // Ten-thousands
    helper_bcd_to_7seg d4 (.bcd_in(current_bcd),.seg_out(seg_decoded[4]));
    // thousands
    helper_bcd_to_7seg d3 (.bcd_in(current_bcd),.seg_out(seg_decoded[3]));
    // hundreds
    helper_bcd_to_7seg d2 (.bcd_in(current_bcd),.seg_out(seg_decoded[2]));
    // tens
    helper_bcd_to_7seg d1 (.bcd_in(current_bcd),.seg_out(seg_decoded[1]));
    // units
    helper_bcd_to_7seg d0 (.bcd_in(current_bcd),.seg_out(seg_decoded[0]));

    // Clock divider for display multiplexing (slow refresh)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            refresh_counter <= 0;
            digit_index <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
            if (refresh_counter == 100000) begin
                refresh_counter <= 0;
                digit_index <= digit_index + 1;
                if (digit_index == 3'd5)
                    digit_index <= 0;
            end
        end
    end

    // Select the correct BCD digit or sign
    always @(*) begin
        case (digit_index)
            3'd0: current_bcd = bcd_digit[3:0];     // units
            3'd1: current_bcd = bcd_digit[7:4];     // tens
            3'd2: current_bcd = bcd_digit[11:8];    // hundreds
            3'd3: current_bcd = bcd_digit[15:12];   // thousands
            3'd4: current_bcd = bcd_digit[19:16];   // ten-thousands
            3'd5: current_bcd = sign ? 4'd10 : 4'd15; // sign (10 = '-', 15 = blank)
            default: current_bcd = 4'd15;           // blank
        endcase
    end

    // Set segment and anode outputs
    always @(*) begin
        d5 = seg_decoded[5];
        d4 = seg_decoded[4];
        d3 = seg_decoded[3];
        d2 = seg_decoded[2];
        d1 = seg_decoded[1];
        d0 = seg_decoded[0];
        // Active-low anode: only one active at a time
        an = 6'b000000;
    end

endmodule
