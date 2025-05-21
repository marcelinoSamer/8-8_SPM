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
    input wire clk,
    input wire reset,
    input wire btnL,
    input wire btnR,
    input wire btnC,
    input wire [7:0] multiplicand,
    input wire [7:0] multiplier,
    output wire [6:0] seg,
    output wire [3:0] an,
    output led
);

// Button detectors for left and right
    wire left_pressed, right_pressed, start_pressed, reset_pressed;
    pushbutton_detector pb_left (
        .clk(clk),
        .reset(reset),
        .x(btnL),
        .z(left_pressed)
    );
    pushbutton_detector pb_right (
        .clk(clk),
        .reset(reset),
        .x(btnR),
        .z(right_pressed)
    );
    pushbutton_detector pb_center (
        .clk(clk),
        .reset(reset),
        .x(btnC),
        .z(start_pressed)
    );
//    pushbutton_detector pb_up (
//        .clk(clk),
//        .reset(reset),
//        .x(btnC),
//        .z(reset_pressed)
//    );
    assign reset = reset_pressed; 
    wire [15:0] product;
    
    
    serial_parallel_multiplier spm (
        .clk(clk),
        .rst(reset_pressed),
        .start(start_pressed),
        .x(multiplicand),
        .y(multiplier),
        .P(product),
        .flag(done)
        
    );
    assign led = done;
//----------------------
// BCD Conversion
//----------------------
    wire [19:0] bcd_unsigned;
    wire sign_bit = product[15];
    
    bin_to_bcd #(.W(16)) converter (
        .bin(product),
        .bcd(bcd_unsigned)
    );

    // FSM state
    reg [1:0] state = 0;

    // Assign BCD digits
    wire [3:0] d0 = bcd_unsigned[3:0];
    wire [3:0] d1 = bcd_unsigned[7:4];
    wire [3:0] d2 = bcd_unsigned[11:8];
    wire [3:0] d3 = bcd_unsigned[15:12];
    wire [3:0] d4 = bcd_unsigned[19:16];
    // Sign digit: 10 = '-', 15 = blank (can be changed as needed)
    wire [3:0] d5 = sign_bit ? 4'd10 : 4'd15;

    // Active BCDs for each display slot
    reg [15:0] active_digits;  // 5 × 4-bit digits: d5 dX dX dX

    // State transition
    wire clk_out;
    clockDivider #(500000) divide (clk,reset,clk_out);
   always @(posedge clk_out or posedge reset) begin
    if (reset)
        state <= 0;
    else begin
        case (state)
            2'd0: if (right_pressed) state <= 1;
            2'd1: begin
                if (right_pressed) state <= 2;
                else if (left_pressed) state <= 0;
            end
            2'd2: if (left_pressed) state <= 1;
            default: state <= 0;
        endcase
    end
end

    // Determine displayed digits based on state
    always @(*) begin
        case (state)
            2'd0: active_digits = {d5, d4, d3, d2}; // State 1
            2'd1: active_digits = {d5, d3, d2, d1}; // State 2
            2'd2: active_digits = {d5, d2, d1, d0}; // State 3
            default: active_digits = {d5, d4, d3, d2};
        endcase
    end

    // Drive the display
    seven_seg_display display_unit (
        .clk(clk),
        .reset(reset),
        .bcd_digit(active_digits), // 5 × 4-bit: d5 = sign, rest = digits
        .seg(seg),
        .an(an)
    );

endmodule


module pushbutton_detector(
input clk,reset,x,
output z
    );
wire clk_out;
clockDivider #(500000) divide (clk,reset,clk_out);
wire out;
debouncer deb(clk_out,reset,x,out);
wire out2;
synchronizer sync(clk_out,out,out2);
wire out3;
rising_edge rizz(clk_out,reset,out2,out3);
assign z = out3;     
endmodule

module rising_edge(
input clk, reset, x,
output reg z
    );
    
//    reg  state, nextState;
//    parameter A = 2'b00, B = 2'b01, C =2'b10;
    
//    always @ (x or state)
//    case (state)
//    A: if (x==0) nextState = A;
//    else nextState = B;
//    B: if (x==0) nextState = A;
//    else nextState = C;
//    C: if (x==0) nextState = A;
//    else nextState = C;
//    default: nextState = A;
//    endcase

//    always @ (posedge clk or posedge reset) begin
//    if(reset) state <= A;
//    else state <= nextState;
//    end

//    assign z = (state == B);
    reg x_prev;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_prev <= 0;
            z <= 0;
        end else begin
            z <= x & ~x_prev;  // Output 1 for 1 clock cycle when rising edge
            x_prev <= x;
        end
    end
endmodule

module debouncer(input clk, rst, in, output out);
reg q1,q2,q3;
always@(posedge clk, posedge rst) begin
if(rst == 1'b1) begin
q1 <= 0;
q2 <= 0;
q3 <= 0;
end
else begin
q1 <= in;
q2 <= q1;
q3 <= q2;
end
end
assign out = (rst) ? 0 : q1&q2&q3;
endmodule

module synchronizer ( input wire clk, sig, output reg sig1 );
 reg meta;
 always @(posedge clk) begin
 meta <= sig;
 sig1 <= meta;
 end
endmodule

module clockDivider #(parameter n = 50000000)
(input clk, rst, output reg clk_out);
wire [31:0] count;
// Big enough to hold the maximum possible value
// Increment count
counter_x_bit #(32,n) counterMod
(.clk(clk), .reset(rst),.en(1), .count(count));
// Handle the output clock
always @ (posedge clk, posedge rst) begin
if (rst) // Asynchronous Reset
clk_out <= 0;
else if (count == n-1)
clk_out <= ~ clk_out;
end
endmodule

module counter_x_bit #(parameter x = 3, n = 6)
(input clk, reset, en, output [x-1:0] count);
reg [x-1:0] count;
always @(posedge clk, posedge reset) begin
if (reset == 1)
    count <= 0; 
else if(!en)
    count <= count; 
else if(count == n-1)
    count <= 0; 
else
    count <= count + 1;
end
endmodule