`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2024 03:39:06 PM
// Design Name: 
// Module Name: lab5_tb
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


module lab5_tb(
    
    );
    
    reg clk;
    wire cs;
     wire we;
     wire [6:0] address;
    wire [7:0] data_in;
     wire [7:0] data_out;
    reg [3:0] btns;
    reg [7:0] swtchs;
    wire [7:0] leds;
    wire [6:0] segs;
    wire [3:0] an;
    
    wire[7:0] data_out_mem;
    
        //CHANGE THESE TWO LINES
    assign data_in = we ? data_out : 8'bzzzzzzzz; // 1st driver of the data bus -- tri state switches
    // function of we and data_out_ctrl
    
    assign data_in = we ? 8'bzzzzzzzz : data_out_mem; // 2nd driver of the data bus -- tri state switches
    // function of we and data_out_mem
     
    controller ctrl(clk, cs, we, address, data_in, data_out,
    btns, swtchs, leds, segs, an);
    
    memory mem(clk, cs, we, address, data_in, data_out_mem);
    initial begin
        clk <= 0;
        btns <= 0;
        swtchs <= 8'h42;
        #10
        btns <= 1;
        #10
        btns <= 0;
        #10
        swtchs <= 8'h21;
        btns <= 1;
        #10
        btns <= 0;
        #10
        swtchs <= 8'h05;
        btns <= 1; // push
        #10
        btns <= 0;
        #10
        btns <= 10; // rst
        #10
        btns <= 0;
        
        
        
        
    end
    
    always #1 clk <= ~clk;
    
    
endmodule
