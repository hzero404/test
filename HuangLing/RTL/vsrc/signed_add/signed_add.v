`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/01 16:12:18
// Design Name: 
// Module Name: signed_add
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


module signed_add(
    a_u,
    a_s,
    b_u,
    b_s,
    o_u,
    o_s
    );

input signed [3:0] a_s;
input[3:0] a_u;
input[2:0] b_s;
input[3:0] b_u;
output signed [3:0] o_s;
output[3:0] o_u;

reg[2:0] b_s_r;
reg signed [3:0] b_s_r_nege;
wire signed [3:0] o_s;
wire signed [3:0] o_u;

always @(b_s)
begin
    b_s_r = ~b_s + 1'b1;
    b_s_r_nege = {1'b1, b_s_r};
end

assign o_s = a_s + b_s_r_nege;

assign o_u = a_u - b_u;

endmodule
