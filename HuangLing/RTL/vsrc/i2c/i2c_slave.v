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

parameter slaveaddress = 8'b1010_0010; //address
parameter S0_START = 'd0, S1_SDDR = 'd1, S2_COMPARE = 'd2, S3_RW = 'd3, S4_READ = 'd4, S5_WRITE = 'd5, S6_STOP = 'd6;

reg[3:0] bitcount;//Read data counter
reg[7:0] address;
reg[7:0] data;
reg[7:0] data1;//data
reg[7:0] dataout = 8'b11001010;
reg[3:0] state, next_state;
reg rw;
reg sda_out;
reg start_stop;
reg sda_in_last;
reg scl_last;
reg pedge;
reg nedge;
reg scl_pedge;
reg scl_nedge;
reg scl_low_1st;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        scl_last <= 1'b0;
        scl_pedge <= 1'b0;
        scl_nedge <= 1'b1;
    end
    else
    begin
        scl_last <= scl;
    	scl_pedge <= scl & ~scl_last;//Set 1 at the posedge scl
    	scl_nedge <= scl | ~scl_last;//Set 0 at the negedge scl
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        sda_in_last <= 1'b0;
        pedge <= 1'b0;
        nedge <= 1'b1;
    end
    else
    begin
        sda_in_last <= sda_in;
    	pedge <= sda_in & ~sda_in_last;//Set 1 at the posedge sda_in
    	nedge <= sda_in | ~sda_in_last;//Set 0 at the negedge sda_in
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        state <= S0_START;
        bitcount <= 4'd0;
        address <= 8'b0000_0000;
        data <= 8'b0000_0000;
        data1 <= 8'b0000_0000;
        rw <= 1'b0;
        sda_out <= 1'b1;
        start_stop <= 1'b0;
        pedge <= 1'b0;
        nedge <= 1'b1;
        scl_pedge <= 1'b0;
        scl_nedge <= 1'b1;
    end
    else
        state <= next_state;
end

always @(state or scl or nedge or pedge or scl_pedge or scl_nedge)
begin
    if(scl && !nedge)
    start_stop <= 1'b1;
	 
	else if(scl && pedge)
    start_stop <= 1'b0;

    else
    begin
        case (state) 
            S0_START: begin //Detection start status
                    if(start_stop) begin next_state  <= S1_SDDR; end
                    else           begin next_state  <= S0_START; end
                end

            S1_SDDR: begin //Read the address
                    if(scl_pedge)
                        begin
                            if (bitcount == 4'd8)
							begin
                                bitcount <= 4'd0;
                                rw <= address[0];
                                next_state  <= S3_RW;
                            end
                            else if(bitcount == 4'd7)
                            begin
                                bitcount <= bitcount + 5'd1;
                                address[7 - bitcount] <= sda_in;
                                next_state  <= S2_COMPARE; //Read the address to S2_COMPARE
                            end
                            else
                            begin
                                bitcount <= bitcount + 5'd1;
                                address[7 - bitcount] <= sda_in;
                            end
                        end
                    else
                    next_state  <= S1_SDDR;
                end
					 
			S2_COMPARE: begin //Compare address
                    if(!scl_nedge)
                    begin
                        if(address[7:1] == slaveaddress[7:1]) begin sda_out <= 1'b0; next_state  <= S1_SDDR;    end
			            else                                  begin start_stop <= 1'b0; next_state  <= S0_START; end
                    end
                    else
			        next_state  <= S2_COMPARE;
				end
				 
			S3_RW: begin //judge rw
			       if(rw == 1'b0) begin next_state  <= S4_READ; end
                   else           begin next_state  <= S5_WRITE; end
				end
			
			S4_READ: begin //slave read
			        if(scl_pedge)   
                    begin
                        if (bitcount == 4'd8)
						begin
                            bitcount <= 4'd0;
							data <= data1;
                            next_state  <= S6_STOP;
                        end
                        else
                        begin
                            bitcount <= bitcount + 5'd1;
                            data1[7 - bitcount] <= sda_in;
                        end
                    end
                    else
                    next_state  <= S4_READ;
				end
				 
			S5_WRITE: begin //slave write
			    	if(!scl_nedge)   
                    begin
                        if (bitcount == 4'd8)
						begin
                            bitcount <= 4'd0;
                            if(!sda_in)
                            begin
                                sda_out <= 1'b0;//ack
                                next_state  <= S6_STOP;
                            end
                            else next_state  <= S0_START;
                        end
                        else
                        begin
                            bitcount <= bitcount + 5'd1;
                            sda_out <= dataout[7 - bitcount];
                        end
                    end
                    else
                    next_state  <= S5_WRITE;
			    end
				 
            S6_STOP: begin
                    if (!start_stop)
                    begin
                        bitcount <= 4'd0;
                        data <= 8'b0;
                        next_state  <= S0_START;
                    end
                    else
                    next_state  <= S6_STOP;
                end
            default: next_state  <= S0_START;
        endcase
    end

end


endmodule
