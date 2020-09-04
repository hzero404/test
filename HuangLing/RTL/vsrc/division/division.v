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
parameter s0_expand = 'd0, s1_shift = 'd1, s2_compare = 'd2, s3_out = 'd3;
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
        state <= s0_expand;
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
    s0_expand: begin
        a_long <= {zero, a};
        b_long <= {b, zero};
        next_state <= s1_shift;
    end
    
    s1_shift: begin
        i <= i + 1'b1;
        if(i < size)
        begin
            a_long <= {a_long[size_2 - 2 : 0], 1'b0};
            next_state <= s2_compare;
        end
        else
            next_state <= s3_out;
    end

    s2_compare: begin
        if(a_long[size_2 - 1 : size] >= b_r)
        begin
            a_long <= a_long - b_long + 1'b1;
            next_state <= s1_shift;
        end
        else
        begin
            a_long <= a_long;
            next_state <= s1_shift;
        end
    end

    s3_out: begin
        o_shang <= a_long[size - 1 : 0];
        o_yushu <= a_long[size_2 - 1 : size];
        if((a_r != a) || (b_r != b))
        begin
            next_state <= s0_expand;
            i <= 8'h00;
        end
        else
            next_state <= s3_out;
    end

    default: next_state <= s0_expand;
    endcase
end

endmodule
