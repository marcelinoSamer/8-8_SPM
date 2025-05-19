`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 09:35:19 PM
// Design Name: 
// Module Name: new_spm_tb
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


module new_spm_tb();

    reg clk;
    reg rst;
    reg signed [7:0] x;
    reg signed [7:0] y;
    
    // Outputs
    wire signed [15:0] prod;
    wire done;
    
    // Expected output for verification
    reg signed [15:0] expected_prod;
    
    // Instantiate the Device Under Test (DUT)
    spm2 dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .prod(prod),
        .done(done)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period (100MHz)
    end
    
    // Test cases
    initial begin
        // Initialize test case
        rst = 1;
        x = 0;
        y = 0;
        expected_prod = 0;
        
        // Wait for global reset
        #20;
        rst = 0;
        
        // Test case 1: Positive × Positive
        x = 5;  // 00000101
        y = 7;  // 00000111
        expected_prod = 35; // 0000000000100011
        
        // Wait for multiplication to complete
        wait(done);
        
        // Check result
        #10;
        if (prod === expected_prod)
            $display("Test Case 1 PASSED: %d * %d = %d", x, y, prod);
        else
            $display("Test Case 1 FAILED: %d * %d = %d (Expected: %d)", x, y, prod, expected_prod);
        
        // Reset for next test
        #10;
        rst = 1;
        #20;
        rst = 0;
        
        // Test case 2: Positive × Negative
        x = 6;   // 00000110
        y = -8;  // 11111000
        expected_prod = -48; // 1111111111010000
        
        // Wait for multiplication to complete
        wait(done);
        
        // Check result
        #10;
        if (prod === expected_prod)
            $display("Test Case 2 PASSED: %d * %d = %d", x, y, prod);
        else
            $display("Test Case 2 FAILED: %d * %d = %d (Expected: %d)", x, y, prod, expected_prod);
        
        // Reset for next test
        #10;
        rst = 1;
        #20;
        rst = 0;
        
        // Test case 3: Negative × Positive
        x = -9;  // 11110111
        y = 4;   // 00000100
        expected_prod = -36; // 1111111111011100
        
        // Wait for multiplication to complete
        wait(done);
        
        // Check result
        #10;
        if (prod === expected_prod)
            $display("Test Case 3 PASSED: %d * %d = %d", x, y, prod);
        else
            $display("Test Case 3 FAILED: %d * %d = %d (Expected: %d)", x, y, prod, expected_prod);
        
        // Reset for next test
        #10;
        rst = 1;
        #20;
        rst = 0;
        
        // Test case 4: Negative × Negative
        x = -12; // 11110100
        y = -5;  // 11111011
        expected_prod = 60;  // 0000000000111100
        
        // Wait for multiplication to complete
        wait(done);
        
        // Check result
        #10;
        if (prod === expected_prod)
            $display("Test Case 4 PASSED: %d * %d = %d", x, y, prod);
        else
            $display("Test Case 4 FAILED: %d * %d = %d (Expected: %d)", x, y, prod, expected_prod);
        
        // Test case 5: Edge case - maximum positive values
        #10;
        rst = 1;
        #20;
        rst = 0;
        
        x = 127;  // 01111111 (max positive 8-bit signed)
        y = 127;  // 01111111
        expected_prod = 16129; // 0011111100000001
        
        // Wait for multiplication to complete
        wait(done);
        
        // Check result
        #10;
        if (prod === expected_prod)
            $display("Test Case 5 PASSED: %d * %d = %d", x, y, prod);
        else
            $display("Test Case 5 FAILED: %d * %d = %d (Expected: %d)", x, y, prod, expected_prod);
        
        // Test case 6: Edge case - maximum negative value
        #10;
        rst = 1;
        #20;
        rst = 0;
        
        x = -128;  // 10000000 (min negative 8-bit signed)
        y = -128;  // 10000000
        expected_prod = 16384; // 0100000000000000
        
        // Wait for multiplication to complete
        wait(done);
        
        // Check result
        #10;
        if (prod === expected_prod)
            $display("Test Case 6 PASSED: %d * %d = %d", x, y, prod);
        else
            $display("Test Case 6 FAILED: %d * %d = %d (Expected: %d)", x, y, prod, expected_prod);
        
        // Test case 7: Zero multiplication
        #10;
        rst = 1;
        #20;
        rst = 0;
        
        x = 0;
        y = 42;
        expected_prod = 0;
        
        // Wait for multiplication to complete
        wait(done);
        
        // Check result
        #10;
        if (prod === expected_prod)
            $display("Test Case 7 PASSED: %d * %d = %d", x, y, prod);
        else
            $display("Test Case 7 FAILED: %d * %d = %d (Expected: %d)", x, y, prod, expected_prod);
        
        // Test case 8: Another zero case
        #10;
        rst = 1;
        #20;
        rst = 0;
        
        x = -55;
        y = 0;
        expected_prod = 0;
        
        // Wait for multiplication to complete
        wait(done);
        
        // Check result
        #10;
        if (prod === expected_prod)
            $display("Test Case 8 PASSED: %d * %d = %d", x, y, prod);
        else
            $display("Test Case 8 FAILED: %d * %d = %d (Expected: %d)", x, y, prod, expected_prod);
        
        // End simulation
        #20;
        $display("All tests completed");
        $finish;
    end
    
    // Optional: Monitor signals during simulation
    initial begin
        $monitor("Time: %t, rst: %b, x: %d, y: %d, count: %d, done: %b, prod: %d, sign: %b", 
                $time, rst, x, y, dut.count, done, prod, dut.sign);
    end
endmodule