`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 02:47:50 PM
// Design Name: 
// Module Name: bin_to_bcd_tb
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


module bin_to_bcd_tb();

  parameter W = 16;
  localparam BCD_WIDTH = W + (W - 4) / 3;

  reg [W-1:0] bin;
  wire [BCD_WIDTH:0] bcd;

  integer k;

  // Instantiate the bin_to_bcd module
  bin_to_bcd #(W) uut (
    .bin(bin),
    .bcd(bcd)
  );

  initial begin
    $display("Time\tBinary\t\tBCD");
    $display("----\t------\t\t---");

    // Test values
    for (k = 0; k <= 10; k = k + 1) begin
      bin = k * 1234; // test multiple values
      #10; // wait for combinational logic to settle
      $display("%4dns\t%d\t\t%0d", $time, bin, bcd);
    end

    bin = 16'd65535; // maximum 16-bit value
    #10;
    $display("%4dns\t%d\t\t%0d", $time, bin, bcd);

    $finish;
  end

endmodule
