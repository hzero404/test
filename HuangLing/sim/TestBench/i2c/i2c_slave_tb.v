`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/31 09:14:43
// Design Name: 
// Module Name: i2c_slave_tb
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


module i2c_slave_tb;
reg clk, rst_n, scl;
reg sda_in;
wire sda_out;
wire[7:0] data;

i2c_slave u1(
    clk,
    rst_n,
    scl,
    sda_in,
    sda_out,
    data,
    );
always #5000 scl = ~scl;
always #10 clk = ~clk;
initial
 begin
    scl = 1;clk = 1;sda_in = 1;rst_n = 1;
    #2500 sda_in = 0;//s
    #5000 sda_in = 1;
    #10000 sda_in = 0;
    #10000 sda_in = 1;
    #10000 sda_in = 0;
    #10000 sda_in = 0;//
    #10000 sda_in = 0;
    #10000 sda_in = 1;//sddr 51
    #10000 sda_in = 0;//rw
    #10000 sda_in = 0;//ack
    #10000 sda_in = 1;
    #10000 sda_in = 0;
    #10000 sda_in = 1;
    #10000 sda_in = 0;
    #10000 sda_in = 1;
    #10000 sda_in = 1;
    #10000 sda_in = 1; 
    #10000 sda_in = 0;//data ae
    #10000 sda_in = 0;//ack
    #15000 sda_in = 1;//p



    //#10000 sda_in = 0;//s
    //#5000 sda_in = 1;
    //#10000 sda_in = 0;
    //#10000 sda_in = 1;
    //#10000 sda_in = 0;
    //#10000 sda_in = 0;//
    //#10000 sda_in = 0;
    //#10000 sda_in = 1;//sddr 51
    //#10000 sda_in = 0;//rw
    //#10000 sda_in = 0;//ack
    //#10000 sda_in = 1;
    //#10000 sda_in = 0;
    //#10000 sda_in = 1;
    //#10000 sda_in = 0;
    //#10000 sda_in = 1;
    //#10000 sda_in = 1;
    //#10000 sda_in = 1; 
    //#10000 sda_in = 0;//data ae
    //#10000 sda_in = 0;//ack
    //#15000 sda_in = 1;//p
    
    #30000 $finish;
 end

endmodule

