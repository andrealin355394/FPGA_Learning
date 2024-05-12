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
    output reg[3:0] O_red       ,           //VGA 
    output reg[3:0] O_green       ,         
    output reg[3:0] O_blue       ,          
    output          O_hs        ,       //hor
    output          O_vs         ,      //ver 
    output[2:0]     led
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

wire                 R_clk_25M;
wire                W_act_flag;         //enable sigle ,   when 1 ,show the RGB on the screen

//IMG
parameter          C_IMG_WIDTH         =        'd450    ,
                  C_IMG_HEIGH         =        'd468    ,
                  C_IMG_PIX_NUM       =        'd210600  ; //300*212

//ROM
reg     [15:0]          R_ROM_ADDR; //input addr
wire    [11:0]          ROM_DATA;   //output

blk_mem_gen_0 u1 (
    .clka(R_clk_25M),
    .addra(R_ROM_ADDR),
    .douta(ROM_DATA)
  );


clk_wiz_0 u0(
                .clk_out1(R_clk_25M),
                .clk_in1(I_clk)
                ); 


/////////////////////////////////////////////////////////////////////////
// Horizontal Timing
/////////////////////////////////////////////////////////////////////////
always@(posedge R_clk_25M or negedge I_rst)
begin
    if(!I_rst)
        R_h_cnt <=  'd0;
    else if(R_h_cnt == C_H_LINE_PERIOD - 'b1)
        R_h_cnt <=  'd0;
    else
        R_h_cnt <=  R_h_cnt +   'd1;  
end
assign O_hs =   (R_h_cnt < C_H_SYNC_PUlSE) ? 1'b0 : 1'b1;   
 
/////////////////////////////////////////////////////////////////////////
// Vertical Timing
/////////////////////////////////////////////////////////////////////////
always@(posedge R_clk_25M or negedge I_rst)
begin
    if(!I_rst)
        R_v_cnt <=  'd0;
    else if(R_v_cnt == C_V_FRAME_PERIOD - 'b1)
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

//load rom data
always@(posedge R_clk_25M or negedge I_rst)
begin
    if(!I_rst)
        begin
            R_ROM_ADDR <= 'b0;
        end
    else if(W_act_flag) begin
        if(             //IMG WIDTH HEIGH
            R_h_cnt >= (C_H_SYNC_PUlSE + C_H_BACK_PORCH)                        && 
            R_h_cnt <= (C_H_SYNC_PUlSE + C_H_BACK_PORCH + C_IMG_WIDTH - 'd1)    && 
            R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH)                        && 
            R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_IMG_HEIGH - 'd1)
           )
            begin
                O_red       <= ROM_DATA[11:8]    ; // red
                O_green     <= ROM_DATA[7:4]     ; // green
                O_blue      <= ROM_DATA[3:0]      ; // blue
//                O_red         =   'b1111;
//                O_green       =   'b0000;
//                O_blue        =   'b0000; 
                
                if(R_ROM_ADDR == C_IMG_PIX_NUM  - 'd1)
                begin
                    R_ROM_ADDR <= 'd0;
                end
                else
                    R_ROM_ADDR <= R_ROM_ADDR +'d1;
            end
        else
            begin
                O_red       <=  'd0        ;
                O_green     <=  'd0        ;
                O_blue      <=  'd0        ;
                R_ROM_ADDR  <=  R_ROM_ADDR  ;
            end
    end        
    else
        begin
            O_red       <=  'd0        ;
            O_green     <=  'd0        ;
            O_blue      <=  'd0        ;
            R_ROM_ADDR  <=  R_ROM_ADDR  ;
        end
end
endmodule
