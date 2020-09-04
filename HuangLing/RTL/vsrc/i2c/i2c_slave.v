`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/28 09:00:31
// Design Name: 
// Module Name: i2c_slave
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


module i2c_slave(
    clk,
    rst_n,
    scl,
    sda_in,
    sda_out,
    data,
    );

input clk, rst_n, scl;
input sda_in;
output sda_out;
output[7:0] data;

parameter sclt = 11'd500;
parameter sclt_half = 11'd250;
parameter slaveaddress = 8'b1010_0010; //��ַ
parameter s0 = 'd0,s1 = 'd1,s2 = 'd2,s3 = 'd3,s4 = 'd4,s5 = 'd5,s6 = 'd6,s7 = 'd7;

wire scl_high_mid;    //scl�ߵ�ƽ��־
wire scl_low_mid;    //scl�͵�ƽ��־

reg[10:0] scl_cnt = 11'd0;
reg[10:0] scl_cnt_half = 11'd0;
reg[3:0] bitcount = 4'd0;//��ȡ���ݼ�����
reg[7:0] address = 8'b0000_0000;
reg[7:0] data = 8'b0000_0000;
reg[7:0] data1 = 8'b0000_0000;//����
reg[7:0] dataout = 8'b11001010;
reg[3:0] state = 4'd0;
reg rw = 1'b0;
reg sda_out = 1'b1;
reg start_stop = 1'b0;
reg sda_in_last = 1'b0;
reg pedge = 1'b0;
reg nedge = 1'b1;
reg scl_low_1st = 1'b0;

always @(posedge clk or negedge rst_n)//��500��scl�ߵ�ƽ�е�
begin
    if(!rst_n)
        scl_cnt <= 11'd0; 
    else if(start_stop)   
        begin
            if(scl_cnt == sclt - 1'b1)
                scl_cnt <= 11'd0;
            else
                scl_cnt <= scl_cnt + 1'b1;     
        end
    else
        scl_cnt <= 11'd0;
end

always @(posedge clk or negedge rst_n)//����250����500��scl�͵�ƽ�е�
begin
    if(!rst_n)
        scl_cnt_half <= 11'd0; 
    else if(start_stop && !scl_low_1st) 
        begin
            if(scl_cnt_half == sclt_half - 1'b1)
            begin
                scl_cnt_half <= 11'd0;
                scl_low_1st <= 1'b1;
            end
            else
                scl_cnt_half <= scl_cnt_half + 1'b1;  
        end
    else if(start_stop && scl_low_1st)
        begin
            if(scl_cnt_half == sclt - 1'b1)
            begin
                scl_cnt_half <= 11'd0;
                scl_low_1st <= 1'b1;
            end
            else
                scl_cnt_half <= scl_cnt_half + 1'b1;  
        end
    else
    begin
        scl_cnt_half <= 11'd0;
        scl_low_1st <= 1'b0;
    end
end

assign scl_high_mid = (scl_cnt == sclt - 1'b1) ? 1'b1 : 1'b0;//scl�ߵ�λ�е�
assign scl_low_mid = (scl_cnt_half == sclt - 1'b1) ? 1'b1 : 1'b0;//scl�͵�λ�е�

always @(posedge clk)
begin
    sda_in_last <= sda_in;
	pedge <= sda_in & ~sda_in_last;//sda_in��������1
	nedge <= sda_in | ~sda_in_last;//sda_in�½�����0
end

always @(posedge clk or negedge rst_n)
begin
    if(scl && !nedge)
    start_stop <= 1'b1;
	 
	else if(scl && pedge)
    start_stop <= 1'b0;

    else
    begin

    if (!rst_n) begin
        state = 4'd0;
        start_stop <= 1'b0;
        bitcount <= 5'd0;
        data = 8'b0000_0000; 
    end 
    else
    begin
        case (state) 
            s0: begin //��⿪ʼ
                    if(start_stop) begin state <= s1; end
                    else           begin state <= s0; end
                end

            s1: begin //�Աȵ�ַ
                    if(scl_high_mid)   
                        begin
                            if (bitcount == 4'd8)
							begin
                                bitcount <= 4'd0;
                                rw <= address[0];
                                state <= s3;
                            end
                            else if(bitcount == 4'd7)
                            begin
                                bitcount <= bitcount + 5'd1;
                                address[7 - bitcount] <= sda_in;
                                state <= s2; //�����ַȥ�ж�
                            end
                            else
                            begin
                                bitcount <= bitcount + 5'd1;
                                address[7 - bitcount] <= sda_in;
                            end
                        end
                    else
                    state <= s1;
                end
					 
			s2: begin//Ӧ��
                    if(scl_low_mid)
                    begin
                        if(address[7:1] == slaveaddress[7:1]) begin sda_out <= 1'b0; state <= s1;    end
			            else                                  begin start_stop <= 1'b0; state <= s0; end
                    end
                    else
			        state <= s2;
				end
				 
			s3: begin //�ж϶�д
			       if(rw == 1'b0) begin state <= s4; end
                   else           begin state <= s5; end
				end
			
			s4: begin //�ӻ���
			        if(scl_high_mid)   
                    begin
                        if (bitcount == 4'd8)
						begin
                            bitcount <= 4'd0;
							data <= data1;
                            state <= s6;//ȥӦ��
                        end
                        else
                        begin
                            bitcount <= bitcount + 5'd1;
                            data1[7 - bitcount] <= sda_in;
                        end
                    end
                    else
                    state <= s4;
				end
				 
			s5: begin //�ӻ�д
			    	if(scl_low_mid)   
                    begin
                        if (bitcount == 4'd8)
						begin
                            bitcount <= 4'd0;
                            state <= s6;//ȥӦ��
                        end
                        else
                        begin
                            bitcount <= bitcount + 5'd1;
                            sda_out <= dataout[7 - bitcount];
                        end
                    end
                    else
                    state <= s5;
			    end
				 
			s6: begin//Ӧ��
                    if(scl_low_mid)
                    begin
                        sda_out <= 1'b0;
                        state <= s7;
                    end
                    else
			        state <= s6;
			    end

            s7: begin
                    if (!start_stop)
                    begin
                        bitcount <= 4'd0;
                        data <= 8'b0;
                        state <= s0;
                    end
                    else
                    state <= s7;
                end
            default: state <= s0;
        endcase
    end

    end
end


endmodule
