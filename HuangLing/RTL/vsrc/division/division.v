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
    start,
    a,
    b,
    quotient,
    remainder
    );

parameter size = 4;
parameter zero = {size{1'b0}};
parameter size_2 = size * 2;
parameter S0_START = 'd0, S1_EXPAND = 'd1, S2_SHIFT = 'd2, S3_COMPARE = 'd3, S4_OUT = 'd4;

input clk, rst_n;
input start;
input[size - 1 : 0] a;//dividend
input[size - 1 : 0] b;//divisor
output[size - 1 : 0] quotient;
output[size - 1 : 0] remainder;

reg[7:0] i;
reg[3:0] state, next_state;
reg[size_2 - 1 : 0] a_long;
reg[size_2 - 1 : 0] b_long;
reg[size - 1 : 0] quotient;
reg[size - 1 : 0] remainder;
reg done, start_last, start_pedge;

always @(posedge clk or negedge rst_n)//Use the "posedge start" as the start signal
begin
    if(!rst_n)
    begin
        start_last <= 1'b0;
        start_pedge <= 1'b0;
    end
    else
    begin
        start_last <= start;
        start_pedge <= start & ~start_last;//Set 1 at the posedge start
    end
end

always @(posedge clk or negedge rst_n)//Finite State
begin
    if(!rst_n)
        state <= S0_START;
    else
        state <= next_state;
end



always @(state or a or b or i or a_long or done)//Next state logic
begin
    case(state)
    S0_START:
            begin
                if(!done)//When done becomes 0, it means division begins
                    next_state = S1_EXPAND;
                else
                    next_state = S0_START;
            end

    S1_EXPAND:
            begin
                next_state = S2_SHIFT;
            end

    S2_SHIFT:
            begin
                if(i < size)
                    next_state = S3_COMPARE;
                else
                    next_state = S4_OUT;
            end

    S3_COMPARE:
            begin
                if(a_long[size_2 - 1 : size] >= b)
                    next_state = S2_SHIFT;
                else
                    next_state = S2_SHIFT;
            end

    S4_OUT:
            begin
                next_state = S0_START;
            end

    default: next_state = 4'bx;
    endcase
end



always @(posedge clk or negedge rst_n)//Output Logic
begin
    if(!rst_n)
    begin
        quotient <= 'b0;
        remainder <= 'b0;
        a_long <= {size_2{1'b0}};
        b_long <= {size_2{1'b0}};
        i <= 8'h00;
        done <= 1'b1;
    end
    else
    begin
        case(state)
        S0_START:
                begin
                    if(start_pedge)//If you press start, set "done" to 0
                        done <= 1'b0;
                end

        S1_EXPAND:
                begin
                    a_long <= {zero, a};
                    b_long <= {b, zero};
                end
    
        S2_SHIFT:
                begin
                    i <= i + 1'b1;
                    if(i < size)
                        a_long <= {a_long[size_2 - 2 : 0], 1'b0};
                    else
                        i <= 8'h00;
                end
    
        S3_COMPARE:
                begin
                    if(a_long[size_2 - 1 : size] >= b)
                        a_long <= a_long - b_long + 1'b1;
                end
    
        S4_OUT:
                begin
                    done <= 1'b1;
                    quotient <= a_long[size - 1 : 0];
                    remainder <= a_long[size_2 - 1 : size];
                end
        
        default:
        begin
            quotient <= 'b0;
            remainder <= 'b0;
        end
        endcase
    end
end

endmodule
