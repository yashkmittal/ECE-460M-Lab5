`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2024 03:07:17 PM
// Design Name: 
// Module Name: Input
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


module synchSP(CLK, D, Qout);
    input CLK, D;
    output Qout;
    wire Qint;
    
//    debouncer db(CLK, D, Qint);
//    single_pulse sp(CLK, Qint, Qout);

    debounce_divider dbdiv(CLK, db_clk);
    debouncer db(db_clk, D, Qint);
    single_pulse sp(CLK, Qint, Qout);

endmodule

module debouncer(CLK, Da, Qb);
    input CLK, Da;
    output Qb;
    reg Qa, Qb;
    wire Db = Qa;

    always @(posedge CLK) begin
        Qa <= Da;
        Qb <= Db;
    end
endmodule

module single_pulse(CLK, D, SP);
     input CLK, D;
     output SP;
     reg Q;
     assign Qn = ~Q;
     assign SP = D & Qn;

     always @(posedge CLK) begin
         Q <= D;
     end
endmodule