module spm (
    input wire clk,
    input wire rst,
    input wire signed [7:0] x,    // Parallel multiplicand
    input wire signed [7:0] y,    // Serial multiplier
    output reg signed [15:0] prod, // Product output
    output reg done                // Completion flag
);
    // Internal signals
    reg [2:0] count;               // Counter for bit position in serial input y
    reg signed [15:0] acc;         // Accumulator for partial products
    
    // Current bit from serial input Y
    wire y_bit = y[count];
    
    // Generate partial products (AND gates)
    wire xy7 = x[7] & y_bit;  // Sign bit handling
    wire xy6 = x[6] & y_bit;
    wire xy5 = x[5] & y_bit;
    wire xy4 = x[4] & y_bit;
    wire xy3 = x[3] & y_bit;
    wire xy2 = x[2] & y_bit;
    wire xy1 = x[1] & y_bit;
    wire xy0 = x[0] & y_bit;
    
    // Two's complement for MSB (handling sign bit)
    wire pp7;
    twos_complement tcmp (
        .a(xy7),
        .clk(clk),
        .rst(rst),
        .S(pp7)
    );
    
    // Chain of your CSA modules
    wire pp6, pp5, pp4, pp3, pp2, pp1, pp0;
    
    csa csa6 (
        .x(xy6),
        .y(pp7),
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
    
    // Main sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset condition - active high
            count <= 0;
            acc <= 0;
            prod <= 0;
            done <= 0;
        end else if (!done) begin
            // Instead of shifting and adding each bit position,
            // we'll accumulate the result bit by bit with proper weighting
            // For bit position 'count', we need to shift by 'count' positions
            acc <= acc + ({{15{1'b0}}, pp0} << count);
            
            // Increment counter
            if (count < 7) begin
                count <= count + 1;
            end else begin
                // Final calculation and completion
                prod <= acc + ({{15{1'b0}}, pp0} << count);
                done <= 1;
            end
        end
    end
endmodule