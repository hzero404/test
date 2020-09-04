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
reg clk, rst_n;
reg[size - 1 : 0] a, b;
wire[size - 1 : 0] o_shang, o_yushu;

division u1(
    clk,
    rst_n,
    a,
    b,
    o_shang,
    o_yushu
    );

always #10 clk = ~clk;

initial  
begin
        clk = 1; rst_n = 0;
    #10 rst_n = 1;

        a = 'd8;  b = 'd5;
          #500 $display(" %d  / %d  = %d  ... %d",a, b, o_shang, o_yushu); 
    #500 a = 'd8;  b = 'd4;
          #500 $display(" %d  / %d  = %d  ... %d",a, b, o_shang, o_yushu);
    #500 a = 'd8;  b = 'd3;
          #500 $display(" %d  / %d  = %d  ... %d",a, b, o_shang, o_yushu);

    #500 $finish;

end  

endmodule
