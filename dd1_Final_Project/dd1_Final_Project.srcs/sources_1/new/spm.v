`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// Design Name: Serial-Parallel Multiplier
// Module Name: spm
// Description: Signed 8-bit × 8-bit Serial-Parallel Multiplier using Carry Save Adders
//////////////////////////////////////////////////////////////////////////////////

//this is what we did 
//module spm (
//    input wire clk,
//    input wire rst,
//    input wire signed [7:0] x,
//    input wire signed [7:0] y,
//    output reg signed [15:0] prod,
//    output reg done
//);
//    // Internal signals
//    reg [2:0] count;
//    reg signed [15:0] acc;
//    reg start;  // Flag to indicate first cycle
    
//    wire y_bit = y[count];  // current bit from serial input Y
//    wire twos_out;
    
//    // First stage: Handle MSB of x with two's complement logic
//    twos_complement tcmp (
//        .a(x[7] & y_bit),
//        .clk(clk),
//        .rst(rst),
//        .S(twos_out)
//    );
    
//    // Chain of CSAs
//    wire csa0_out, csa1_out, csa2_out, csa3_out, csa4_out, csa5_out, csa6_out;
    
//    csa csa0 (.x(x[6] & y_bit), .y(twos_out), .clk(clk), .rst(rst), .final_sum(csa0_out));
//    csa csa1 (.x(x[5] & y_bit), .y(csa0_out), .clk(clk), .rst(rst), .final_sum(csa1_out));
//    csa csa2 (.x(x[4] & y_bit), .y(csa1_out), .clk(clk), .rst(rst), .final_sum(csa2_out));
//    csa csa3 (.x(x[3] & y_bit), .y(csa2_out), .clk(clk), .rst(rst), .final_sum(csa3_out));
//    csa csa4 (.x(x[2] & y_bit), .y(csa3_out), .clk(clk), .rst(rst), .final_sum(csa4_out));
//    csa csa5 (.x(x[1] & y_bit), .y(csa4_out), .clk(clk), .rst(rst), .final_sum(csa5_out));
//    csa csa6 (.x(x[0] & y_bit), .y(csa5_out), .clk(clk), .rst(rst), .final_sum(csa6_out));
    
//    wire partial_bit = csa6_out;
    
//    // Main sequential logic
//    always @(posedge clk or posedge rst) begin
//        if (rst) begin
//            // Reset condition - active low
//            count <= 0;
//            acc <= 0;
//            prod <= 0;
//            done <= 0;
////            start <= 1;  // Set start flag for initial cycle
//        end else if (!done) begin
////            if (start) begin
////                // Initial cycle
////                acc <= 0;
////                start <= 0;
////            end else begin
//                // Shift partial bit to correct position and accumulate
//                acc <= acc + ({{15{1'b0}}, partial_bit} << count);
//            end
            
//            // Increment counter
//            if (count < 7) begin
//                count <= count + 1;
//            end else begin
//                // Final calculation and completion
//                prod <= acc + ({{15{1'b0}}, partial_bit} << count);
//                done <= 1;
//            end
//        end
//endmodule


module spm (
    input wire clk,
    input wire rst,
    input wire signed [7:0] x,  // Parallel multiplicand
    input wire signed [7:0] y,  // Serial multiplier
    output reg signed [15:0] prod,  // Product output
    output reg done  // Completion flag
);

assign x= x[7]&y[7] ? ~x+1:x;
  assign y= x[7]&y[7] ? ~y+1:y;
    // Internal signals
    reg [2:0] count;      // Counter for bit position in serial input y
    reg signed [15:0] acc;  // Accumulator for partial products
    
    // Generate y_bit for current bit position from serial input y
    wire y_bit = y[count];
    
    // Generate partial products (AND gates in the diagram)
    wire xy7 = x[7] & y_bit;  // AND7 output
    wire xy6 = x[6] & y_bit;  // AND6 output
    wire xy5 = x[5] & y_bit;  // AND5 output
    wire xy4 = x[4] & y_bit;  // AND4 output
    wire xy3 = x[3] & y_bit;  // AND3 output
    wire xy2 = x[2] & y_bit;  // AND2 output
    wire xy1 = x[1] & y_bit;  // AND1 output
    wire xy0 = x[0] & y_bit;  // AND0 output
    
    
    
    // Internal partial product wires (PP7-PP1 in the diagram)
    wire pp7, pp6, pp5, pp4, pp3, pp2, pp1;
    
    // Two's complement for MSB (TCMP in the diagram)
    twos_complement tcmp (
        .a(xy7),    // Sign bit of x ANDed with current y bit
        .clk(clk),
        .rst(rst),
        .S(pp7)     // Output is PP7 in the diagram
    );
    
    // Chain of CSAs (CSA6-CSA0 in the diagram)
    csa csa6 (
        .x(xy6),
        .y(pp7),    // Output from two's complement
        .clk(clk),
        .rst(rst),
        .final_sum(pp6)
    );
    
    csa csa5 (
        .x(xy5),
        .y(pp6),
        .clk(clk),
        .rst(rst),
        .final_sum(pp5)
    );
    
    csa csa4 (
        .x(xy4),
        .y(pp5),
        .clk(clk),
        .rst(rst),
        .final_sum(pp4)
    );
    
    csa csa3 (
        .x(xy3),
        .y(pp4),
        .clk(clk),
        .rst(rst),
        .final_sum(pp3)
    );
    
    csa csa2 (
        .x(xy2),
        .y(pp3),
        .clk(clk),
        .rst(rst),
        .final_sum(pp2)
    );
    
    csa csa1 (
        .x(xy1),
        .y(pp2),
        .clk(clk),
        .rst(rst),
        .final_sum(pp1)
    );
    
    csa csa0 (
        .x(xy0),
        .y(pp1),
        .clk(clk),
        .rst(rst),
        .final_sum(pp0)
    );
    
    // Output from the CSA chain
    wire pp0; // Final partial product bit (PROD signal in diagram)
    
    // FSM for the multiplier control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset condition - active high (matching the diagram's R signal)
            count <= 0;
            acc <= 0;
            prod <= 0;
            done <= 0;
        end 
        else if (!done) begin
            // Shift the final result bit to the correct position and accumulate
            acc <= acc + ({{15{1'b0}}, pp0} << count);
            
            // Increment bit counter
            if (count < 7) begin
                count <= count + 1;
            end 
            else begin
                // Final result is ready
                prod <= acc ;//+ ({{15{1'b0}}, pp0} << count);
                done <= 1;
            end
        end
    end
    
endmodule