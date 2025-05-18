`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2025 10:12:11 AM
// Design Name: 
// Module Name: helper_bcd_to_7seg
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


module helper_bcd_to_7seg(
    input wire [3:0] bcd_in,
    output reg [6:0] seg_out
);
    always @(*) begin
        case (bcd_in)
            4'd0: seg_out = 7'b1000000;
            4'd1: seg_out = 7'b1111001;
            4'd2: seg_out = 7'b0100100;
            4'd3: seg_out = 7'b0110000;
            4'd4: seg_out = 7'b0011001;
            4'd5: seg_out = 7'b0010010;
            4'd6: seg_out = 7'b0000010;
            4'd7: seg_out = 7'b1111000;
            4'd8: seg_out = 7'b0000000;
            4'd9: seg_out = 7'b0010000;
            4'd10: seg_out = 7'b0111111; // '-' sign
            default: seg_out = 7'b1111111; // blank
        endcase
    end
endmodule