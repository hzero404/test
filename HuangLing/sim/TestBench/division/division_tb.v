`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/02 15:10:36
// Design Name: 
// Module Name: division_tb
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


module division_tb;

parameter size = 4;
parameter DELAY = 100;
reg clk, rst_n;
reg start;
reg[size - 1 : 0] a, b;
wire[size - 1 : 0] quotient, remainder;

division u1(
    clk,
    rst_n,
    start,
    a,
    b,
    quotient,
    remainder
    );

always #10 clk = ~clk;

initial
begin
        clk = 1; rst_n = 0; a = 'd0;  b = 'd0; start = 0;
    #10 rst_n = 1;

    #500 start = 1; a = 'd8;  b = 'd4;
    #40 start = 0;
    #((size * 40) + DELAY) $display(" %d  / %d  = %d  ... %d",a, b, quotient, remainder);
    //(2*size+7)*20
    #500 start = 1; a = 'd8;  b = 'd3;
    #40 start = 0;
    #((size * 40) + DELAY) $display(" %d  / %d  = %d  ... %d",a, b, quotient, remainder);
    #500 start = 1; a = 'd8;  b = 'd5;
    #40 start = 0;
    #((size * 40) + DELAY) $display(" %d  / %d  = %d  ... %d",a, b, quotient, remainder);

    #500 $finish;

end 

endmodule
