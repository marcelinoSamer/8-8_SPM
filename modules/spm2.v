`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Signed Parallel-Serial Multiplier (spm3)
// Multiplies two 8-bit signed inputs using serial-shift method
//////////////////////////////////////////////////////////////////////////////////

module spm2 (
    input wire clk,
    input wire rst,
    input wire signed [7:0] x,  
    input wire signed [7:0] y,  
    output reg signed [15:0] prod,  
    output reg done  
);

    reg signed [7:0] x_reg;  
    reg signed [7:0] y_reg;
    reg [7:0] shift_reg_y;
    reg [2:0] count; // 3-bit counter (0 to 7)
    reg sign;        // sign of the final product

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers
            count <= 0;
            prod <= 0;
            done <= 0;
            shift_reg_y <= 0;
            x_reg <= 0;
            y_reg <= 0;
            sign <= 0;
        end 
        else if (!done) begin
            if (count == 0) begin
                // Initialize values and determine sign
                x_reg <= x[7] ? (~x + 1) : x;
                y_reg <= y[7] ? (~y + 1) : y;
                shift_reg_y <= y[7] ? (~y + 1) : y;
                sign <= x[7] ^ y[7];  // Result is negative if signs differ
                prod <= 0;
                count <= count + 1;
            end 
            else if (count < 7) begin
                if (shift_reg_y[0]) begin
                    prod <= prod + ({{8{x_reg[7]}}, x_reg} << (count - 1));
                end
                shift_reg_y <= {1'b0, shift_reg_y[7:1]}; // Logical right shift
                count <= count + 1;
            end 
            else begin
                if (sign)
                    prod <= ~prod + 1;  // Two's complement for negative result
                done <= 1;
            end
        end
    end

endmodule
