`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2024 03:14:24 PM
// Design Name: 
// Module Name: Ouput
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


module sevenSeg(input CLK, 
                input [6:0] seven_0, input [6:0] seven_1, 
                output reg [6:0] seven_out, output reg [3:0] digit);
	reg state, next_state;

	initial begin
		state <= 0;
	end

	always @* begin
		case (state)
			0: begin
				seven_out <= seven_0;
				digit <= 4'b1110;
				next_state <= 1;
			end
			1: begin
				seven_out <= seven_1;
			    digit <= 4'b1101;
				next_state <= 0;
			end
		endcase
	end

	always @(posedge CLK) begin
		state <= next_state;
	end
endmodule

module twoBCDSeven(input [7:0] D, output [7:1] seven_0, output [7:1] seven_1);
    wire [3:0] digit_0, digit_1;

    assign digit_0 = D[3:0];
    assign digit_1 = D[7:4];

    bcd_seven bcd0(digit_0, seven_0);
    bcd_seven bcd1(digit_1, seven_1);
endmodule

module bcd_seven(bcd, seven);
    input [3:0] bcd;
    output reg [7:1] seven;

    always @(bcd) begin
        case (bcd)
            4'b0000 : seven = 7'b1000000;
            4'b0001 : seven = 7'b1111001;
            4'b0010 : seven = 7'b0100100;
            4'b0011 : seven = 7'b0110000;
            4'b0100 : seven = 7'b0011001;
            4'b0101 : seven = 7'b0010010;
            4'b0110 : seven = 7'b0000010;
            4'b0111 : seven = 7'b1111000;
            4'b1000 : seven = 7'b0000000;
            4'b1001 : seven = 7'b0010000;
            4'b1010 : seven = 7'b0001000;
            4'b1011 : seven = 7'b0000011;
            4'b1100 : seven = 7'b1000110;
            4'b1101 : seven = 7'b0100001;
            4'b1110 : seven = 7'b0000110;
            4'b1111 : seven = 7'b0001110;
            default : seven = 7'b1111111;
        endcase
    end
endmodule