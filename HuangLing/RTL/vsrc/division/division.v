`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/02 14:16:42
// Design Name: 
// Module Name: division
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


module division(
    clk,
    rst_n,
    a,
    b,
    o_shang,
    o_yushu
    );

parameter size = 4;
parameter zero = {size{1'b0}};
parameter size_2 = size * 2;
parameter S0_EXPAND = 'd0, S1_SHIFT = 'd1, S2_COMPARE = 'd2, S3_OUT = 'd3;
input clk, rst_n;
input[size - 1 : 0] a, b;
output[size - 1 : 0] o_shang, o_yushu;

reg[7:0] i;
reg[3:0] state, next_state;
reg[size_2 - 1 : 0] a_long , b_long;
reg[size - 1 : 0] o_shang, o_yushu;
reg[size - 1 : 0] a_r;
reg[size - 1 : 0] b_r;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        state <= S0_EXPAND;
        o_shang = 'b0;
        o_yushu = 'b0;
        i <= 8'h00;
        a_r <= {size{1'b0}};
        b_r <= {size{1'b0}};
    end
    else
        state <= next_state;
end



always @(state or a or b)
begin
    a_r <= a;
    b_r <= b;
    case(state)
    S0_EXPAND: begin
        a_long <= {zero, a};
        b_long <= {b, zero};
        next_state <= S1_SHIFT;
    end
    
    S1_SHIFT: begin
        i <= i + 1'b1;
        if(i < size)
        begin
            a_long <= {a_long[size_2 - 2 : 0], 1'b0};
            next_state <= S2_COMPARE;
        end
        else
            next_state <= S3_OUT;
    end

    S2_COMPARE: begin
        if(a_long[size_2 - 1 : size] >= b_r)
        begin
            a_long <= a_long - b_long + 1'b1;
            next_state <= S1_SHIFT;
        end
        else
        begin
            a_long <= a_long;
            next_state <= S1_SHIFT;
        end
    end

    S3_OUT: begin
        o_shang <= a_long[size - 1 : 0];
        o_yushu <= a_long[size_2 - 1 : size];
        if((a_r != a) || (b_r != b))
        begin
            next_state <= S0_EXPAND;
            i <= 8'h00;
        end
        else
            next_state <= S3_OUT;
    end

    default: next_state <= S0_EXPAND;
    endcase
end

endmodule
