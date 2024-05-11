`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 13:47:17
// Design Name: 
// Module Name: VGA_Driver
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


module VGA_Driver
(
    input           I_clk       ,
    input           I_rst       ,
    output reg[4:0] O_red       ,           //VGA 
    output reg[5:0] O_green       ,         
    output reg[4:0] O_blue       ,          
    output          O_hs        ,       //hor
    output          O_vs                //ver 
 );
 
//640*480   Hor
parameter          C_H_SYNC_PUlSE       =       'd96   ,   
                  C_H_BACK_PORCH       =        'd48  ,
                  C_H_ACTIVE_TIME      =        'd640 ,
                  C_H_FRONT_PORCH      =        'd16  ,
                  C_H_LINE_PERIOD      =        'd800 ;
                     
//640*480   Ver
parameter          C_V_SYNC_PULSE      =         'd2   , 
                  C_V_BACK_PORCH      =         'd33  ,
                  C_V_ACTIVE_TIME     =         'd480 ,
                  C_V_FRONT_PORCH     =         'd10  ,
                  C_V_FRAME_PERIOD    =         'd525 ;
                  
// 8 colors                   
parameter          C_COLOR_BAR_WIDTH   =   C_H_ACTIVE_TIME / 8  ;  

reg     [11:0]      R_h_cnt;
reg     [11:0]      R_v_cnt;

reg                 R_clk_25M;
wire                W_act_flag;         //enable sigle ,   when 1 ,show the RGB on the screen


/////////////////////////////////////////////////////////////////////////
//male 25Mkhz clock
/////////////////////////////////////////////////////////////////////////
always@(posedge I_clk)
begin
    if(I_rst)
        R_clk_25M   <=  'b0;
    else
        R_clk_25M   <=  ~R_clk_25M;
end

/////////////////////////////////////////////////////////////////////////
// Hov timer 
/////////////////////////////////////////////////////////////////////////
always@(posedge I_clk)
begin
    if(I_rst)
        R_h_cnt <=  'd0;
    else if(R_h_cnt == C_H_LINE_PERIOD - 'b1)
        R_h_cnt <=  'd0;
    else
        R_h_cnt <=  R_h_cnt +   'd1;  
end
assign O_hs =   (R_h_cnt < C_H_SYNC_PUlSE) ? 1'b0 : 1'b1;   
 
/////////////////////////////////////////////////////////////////////////
// Ver timer 
/////////////////////////////////////////////////////////////////////////
always@(posedge I_clk)
begin
    if(I_rst)
        R_v_cnt <=  'd0;
    else if(R_h_cnt == C_V_FRAME_PERIOD - 'b1)
        R_v_cnt <=  'd0;
    else if(R_h_cnt == C_H_LINE_PERIOD - 'b1)
        R_v_cnt <=  R_v_cnt +   'd1;    
    else
        R_v_cnt <=  R_v_cnt;        
end
assign   O_vs =   (R_v_cnt < C_V_SYNC_PULSE) ? 1'b0 : 1'b1;   
 
 
// actice signle
assign   W_act_flag =   (R_h_cnt >= (C_H_SYNC_PUlSE + C_H_BACK_PORCH                  ))  &&
                        (R_h_cnt <= (C_H_SYNC_PUlSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME))  && 
                        (R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                  ))  &&
                        (R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME))  ; 
                        
                        
// 8's colors each width 80

always@(posedge I_clk)
begin
    if(I_rst)
        begin
            O_red   <=  5'b00000;
            O_green <=  6'b000000;
            O_blue  <=  5'b00000;
        end
    else if(W_act_flag)
        begin
            if(R_h_cnt < (C_H_SYNC_PUlSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH)) // red
                begin
                    O_red   <=  5'b11111    ; 
                    O_green <=  6'b000000   ;
                    O_blue  <=  5'b00000    ;
                end
            else if(R_h_cnt < (C_H_SYNC_PUlSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*2)) // green
                begin
                    O_red   <=  5'b00000    ;
                    O_green <=  6'b111111   ; 
                    O_blue  <=  5'b00000    ;
                end 
            else if(R_h_cnt < (C_H_SYNC_PUlSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*3)) // blue
                begin
                    O_red   <=  5'b00000    ;
                    O_green <=  6'b000000   ;
                    O_blue  <=  5'b11111    ; 
                end 
            else if(R_h_cnt < (C_H_SYNC_PUlSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*4)) // white
                begin
                    O_red   <=  5'b11111    ; 
                    O_green <=  6'b111111   ;
                    O_blue  <=  5'b11111    ;
                end 
            else if(R_h_cnt < (C_H_SYNC_PUlSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*5)) // black
                begin
                    O_red   <=  5'b00000    ;
                    O_green <=  6'b000000   ;
                    O_blue  <=  5'b00000    ;
                end 
            else if(R_h_cnt < (C_H_SYNC_PUlSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*6)) // yellow
                begin
                    O_red   <=  5'b11111    ; 
                    O_green <=  6'b111111   ; 
                    O_blue  <=  5'b00000    ; 
                end 
            else if(R_h_cnt < (C_H_SYNC_PUlSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*7)) 
                begin
                    O_red   <=  5'b11111    ; 
                    O_green <=  6'b000000   ; 
                    O_blue  <=  5'b11111    ;
                end 
            else                              
                begin
                    O_red   <=  5'b00000    ; 
                    O_green <=  6'b111111   ;
                    O_blue  <=  5'b11111    ; 
                end
        end
end                      
                        
 
endmodule
