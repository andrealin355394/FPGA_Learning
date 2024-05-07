`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2023 10:14:31 AM
// Design Name: 
// Module Name: breath_led
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


module breath_led(
  input       sys_clk         ,         
  input       sys_rst_n       ,         
  input       sw_ctrl         ,         
  input       set_en          ,         
  input [9:0] set_freq_step   ,   
  
  output      led             
//  output[15:0]cnt_flag        
    );
    
parameter START_FREQ_STEP = 10'd100;
 
reg [15:0] period_cnt       ;
reg [9:0]  freq_step        ;
reg [15:0] duty_cycle       ;
reg        inc_dec_flag     ;

wire       led_t            ;

assign led_t = ( period_cnt <= duty_cycle ) ? 1'b1 : 1'b0 ; 
assign led = led_t & sw_ctrl;
//assign cnt_flag = period_cnt;
 
always @ (posedge sys_clk) begin
    if(!sys_rst_n)
        period_cnt <= 16'd0;
    else if(!sw_ctrl)
        period_cnt <= 16'd0;
    else if(period_cnt == 16'd50_000)
        period_cnt <= 16'd0;
    else
        period_cnt <= period_cnt + 16'd1;
end
        
always @(posedge sys_clk) begin 
    if(!sys_rst_n)
        freq_step <= START_FREQ_STEP;
    else if(set_en) begin
        if(set_freq_step == 0)     
            freq_step <= 10'd1;
        else if(set_freq_step >= 10'd1_000)
            freq_step <= 10'd1_000;
        else
            freq_step <= set_freq_step;           
    end
end
 
always @(posedge sys_clk) begin
    if (sys_rst_n == 1'b0) begin
        duty_cycle <= 16'd0;
        inc_dec_flag <= 1'b0;
    end
    else if(!sw_ctrl)begin
        duty_cycle <= 16'd0;
        inc_dec_flag <= 1'b0;
    end
    else if(period_cnt == 16'd50_000) begin
        if(inc_dec_flag) begin
            if(duty_cycle == 16'd0)
                inc_dec_flag <= 1'b0;
            else if(duty_cycle < freq_step)
                duty_cycle <= 16'd0;
            else 
                duty_cycle <= duty_cycle - freq_step;
        end
        else begin
            if(duty_cycle >= 16'd50_000)
                inc_dec_flag <= 1'b1;
            else
                duty_cycle <= duty_cycle + freq_step;
        end
    end
    else
        duty_cycle <= duty_cycle;
end 
endmodule