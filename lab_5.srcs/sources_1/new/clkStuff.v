`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2024 03:10:36 PM
// Design Name: 
// Module Name: Divider
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

module Divider(clk100Mhz, clk2Hz);
  input clk100Mhz; 
  output reg clk2Hz; 

  reg[24:0] counter;

  initial begin
    counter = 0;
    clk2Hz = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 25'd25000000) begin
      counter <= 1;
      clk2Hz <= ~clk2Hz;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module debounce_divider(clk100Mhz, clk20Hz);
    input clk100Mhz; 
    output reg clk20Hz;

    reg[21:0] counter;

    initial begin
      counter = 0;
      clk20Hz = 0;
    end

    always @ (posedge clk100Mhz)
    begin
      if(counter == 22'd2500000) begin
        counter <= 1;
        clk20Hz <= ~clk20Hz;
      end
      else begin
        counter <= counter + 1;
      end
    end

endmodule

module seven_seg_clock(clk100Mhz, clk1KHz);
  input clk100Mhz; 
  output reg clk1KHz; 

  reg[15:0] counter;

  initial begin
    counter = 0;
    clk1KHz = 0;
  end

  always @ (posedge clk100Mhz) begin
    if(counter == 16'd50000) begin
      counter <= 1;
      clk1KHz <= ~clk1KHz;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

