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
    input wire reset, // can be removed
    input wire [15:0] bcd_digit,  // 5 × 4-bit BCD digits
//    input wire sign,
    output wire [6:0] seg, // sign - tenthousands - ... - units
    output wire [3:0] an           // 6 digits: 5 for number, 1 for sign
);

    reg [2:0] digit_index = 0;
    reg [3:0] current_bcd;
    reg [19:0] refresh_counter = 0;
//    wire [6:0] seg_decoded [5:0];

    wire [6:0] seg_out;
    // BCD to 7-segment converter
    helper_bcd_to_7seg d5 (.bcd_in(current_bcd),.seg_out(seg_out));

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
                if (digit_index == 3'd3) // loop for 4 digits only
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
//            3'd4: current_bcd = bcd_digit[19:16];   // ten-thousands
//            3'd5: current_bcd = sign ? 4'd10 : 4'd15; // sign (10 = '-', 15 = blank)
            default: current_bcd = 4'd15;           // blank
        endcase
    end 

    assign seg = seg_out;
reg [3:0] an_reg;

always @(*) begin
    case (digit_index)
        3'd0: an_reg = 4'b1110; // units
        3'd1: an_reg = 4'b1101; // tens
        3'd2: an_reg = 4'b1011; // hundreds
        3'd3: an_reg = 4'b0111; // thousands
        default: an_reg = 4'b1111;
    endcase
end

assign an = an_reg;
endmodule
