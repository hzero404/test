`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/01 16:35:26
// Design Name: 
// Module Name: signed_add_tb
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


module signed_add_tb;
reg signed [3:0] a_s;
reg[3:0] a_u;
reg [2:0] b_s;
reg[3:0] b_u;
wire signed [3:0] o_s;
wire[3:0] o_u;
signed_add u1(
    a_u,
    a_s,
    b_u,
    b_s,
    o_u,
    o_s
    );
initial
begin
        a_s = 4'd1; b_s = 3'd1;//1-1
        a_u = 4'd1; b_u = 4'd1;

    #10 a_s = 4'd7; b_s = 3'd1;//7-1
        a_u = 4'd7; b_u = 4'd1;

    #10 a_s = 4'd7; b_s = 3'd5;//7-5
        a_u = 4'd7; b_u = 4'd5;
    
    #10 $finish;
end
initial $monitor($time,,,"ÓÐ·ûºÅ %d + (-%d ) = %d   ÎÞ·ûºÅ  %d - %d = %d", a_s, b_s, o_s, a_u, b_u, o_u);
endmodule
