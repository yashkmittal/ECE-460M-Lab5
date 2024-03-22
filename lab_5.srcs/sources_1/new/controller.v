`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2024 03:51:40 PM
// Design Name: 
// Module Name: controller
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


module controller(clk, cs, we, address, data_in, data_out, btns, swtchs, leds, segs, an);
    input clk;
    output cs;
    output reg we;
    output reg [6:0] address;
    input[7:0] data_in;
    output reg [7:0] data_out;
    input[3:0] btns;
    input[7:0] swtchs;
    output[7:0] leds;
    output[6:0] segs;
    output[3:0] an;
    
    //WRITE THE FUNCTION OF THE CONTROLLER
    reg is_add;
    reg is_sub;
    
    reg [2:0] op_state;
    reg [7:0] op1, op2;
    
    reg [6:0] SPR;
    reg [6:0] DAR;
    reg [7:0] DVR;
    
    wire clk100Hz;
    wire [6:0] onesDigit, tensDigit;
    
    assign empty = (SPR == 7'h7F) ? 1 : 0;
    assign cs = we;
    assign leds[6:0] = DAR;
    assign leds[7] = empty;
    
    synchSP btn1(clk, btns[1], left);
    synchSP btn0(clk, btns[0], right);
    
    seven_seg_clock hz100clk(clk, clk100hz);
    twoBCDSeven sevenSegConverter(DVR, onesDigit, tensDigit);
    sevenSeg(clk100hz, onesDigit, tensDigit, segs, an);
    
    wire [3:0] ctrl_inputs;
    assign ctrl_inputs = {btns[3], btns[2], left, right};
    
    initial begin
        is_add <= 0;
        is_sub <= 0;
        op_state <= 0;
    end
    
    always @(posedge clk) begin
        if(op_state != 0) begin
            case(op_state)
            1: op_state <= op_state + 1;
            2: begin
                op1 <= data_in;
                SPR <= SPR + 1;
                DAR <= DAR + 1;
                address <= DAR + 1;
                op_state <= op_state + 1;
            end
            3: op_state <= op_state + 1;
            4: begin
                op2 <= data_in;
                SPR <= SPR + 1;
                op_state <= op_state + 1;
            end
            5: op_state <= op_state + 1;
            6: begin
                we <= 1;
                address <= SPR;
                if(is_add) begin 
                    data_out <= op2 + op1;
                    is_add <= 0;
                end
                if(is_sub) begin 
                    data_out <= op2 - op1;
                    is_sub <= 0;
                end
                SPR <= SPR - 1;
                op_state <= op_state + 1;
            end
            7: op_state <= 0;
            default: op_state <= 0;
            endcase 
        end
        
        else begin
            case(ctrl_inputs)
            1: begin //push
                address <= SPR;
                data_out <= swtchs;
                SPR <= SPR - 1;
                DAR <= SPR;
                we <= 1;
            end
            2: begin //pop
                address <= DAR;
                DVR <= data_in;
                SPR <= SPR + 1;
                DAR <= SPR + 2;
                we <= 0;
            end
            5: begin //add
                we <= 0;
                DVR <= data_in;
                DAR <= SPR + 1;
                address <= SPR + 1;
                op_state <= 1;
                is_add <= 1;
            end
            6: begin //sub
                we <= 0;
                DVR <= data_in;
                DAR <= SPR + 1;
                address <= SPR + 1;
                op_state <= 1;
                is_sub <= 1;
            end
            9: begin //top
                we <= 0;
                address <= DAR;
                SPR <= 8'h7F;
                DAR <= 0;
                DVR <= 0;
            end
            10: begin //rst
                we <= 0;
                address <= DAR;
                DVR <= data_in;
                DAR <= SPR + 1;
            end
            13: begin //inc
                we <= 0;
                DAR <= DAR + 1;
                DVR <= data_in;
                address <= DAR;
            end
            14: begin //dec
                we <= 0;
                DAR <= DAR - 1;
                DVR <= data_in;
                address <= DAR;
            end
            endcase
        end
        
    end

endmodule
