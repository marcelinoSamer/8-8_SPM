`timescale 1ns / 1ps

module spm_tb();
    // Inputs
    reg clk;
    reg rst;
    reg signed [7:0] x;
    reg signed [7:0] y;
    
    // Outputs
    wire signed [15:0] prod;
    wire done;
    
    // Instantiate the Unit Under Test (UUT)
    spm2 uut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .prod(prod),
        .done(done)
    );
    
    // Clock generation: 10ns period
    always #5 clk = ~clk;
    
    // Test process
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;
        x = 0;
        y = 0;
        
        // Apply reset for 20ns
        #20;
        rst = 0;
        // Test case 1: 8 * 8 = 64
        x = 8'd8;
        y = 8'd8;
        
        // Wait for done signal
        wait(done);
        $display("Test 1: %d * %d = %d (Expected: 64)", x, y, prod);
        
        // Reset for next test
        #100;
        rst = 1;
        #20;
        rst = 0;
        
        // Test case 2: -12 * 5 = -60
        x = -8'sd12;
        y = 8'd5;
        
        // Wait for done signal
        wait(done);
        $display("Test 2: %d * %d = %d (Expected: -60)", x, y, prod);
        
        // Reset for next test
        #10;
        rst = 1;
        #20;
        rst = 0;
        
        // Test case 3: -7 * -6 = 42
        x = -8'sd7;
        y = -8'sd6;
        
        // Wait for done signal
        wait(done);
        $display("Test 3: %d * %d = %d (Expected: 42)", x, y, prod);
        
        // Finish simulation
        #50;
        $finish;
    end
    
    // Optional: Monitor signals for debugging
    initial begin
        $monitor("Time: %t, x=%d, y=%d, count=%d, prod=%d, done=%b", 
                 $time, x, y, uut.count, prod, done);
    end
endmodule