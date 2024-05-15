`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/15 10:06:16
// Design Name: 
// Module Name: HDMI_lab
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


module HDMI_lab(
    input       I_clk,    
    input       I_rst,    
    output      O_hs,    
    output      O_vs,
    output      O_de,   //video vaild
    output[7:0] O_rgb_r,
    output[7:0] O_rgb_g,
    output[7:0] O_rgb_b
    );



//vide timing parameter        
`define video_800_600

//1280*720
`ifdef video_1280_720
parameter       H_active     =      16'd1200;
parameter       H_fp         =      16'd110;
parameter       H_sync       =      16'd40;
parameter       H_bp         =      16'd220;
parameter       V_active     =      16'd720;
parameter       V_fp         =      16'd5;
parameter       V_sync       =      16'd20;
parameter       V_bp         =      16'd20;
parameter       Hs_pol       =      1'b1;       
parameter       Vs_pol       =      1'b1;
`endif

//640*480   25.175Mhz
`ifdef video_640_280
parameter       H_active     =      16'd640;
parameter       H_fp         =      16'd16;
parameter       H_sync       =      16'd96;
parameter       H_bp         =      16'd48;
parameter       V_active     =      16'd480;
parameter       V_fp         =      16'd10;
parameter       V_sync       =      16'd2;
parameter       V_bp         =      16'd22;
parameter       Hs_pol       =      1'b0;       
parameter       Vs_pol       =      1'b0;
`endif


//800*600   40Mhz
`ifdef video_800_600
parameter       H_active     =      16'd800;
parameter       H_fp         =      16'd40;
parameter       H_sync       =      16'd128;
parameter       H_bp         =      16'd88;
parameter       V_active     =      16'd600;
parameter       V_fp         =      16'd1;
parameter       V_sync       =      16'd4;
parameter       V_bp         =      16'd23;
parameter       Hs_pol       =      1'b1;       
parameter       Vs_pol       =      1'b1;
`endif

//1024*768 65Mhz
`ifdef video_1024_768
parameter       H_active     =      16'd1024;
parameter       H_fp         =      16'd24;
parameter       H_sync       =      16'd136;
parameter       H_bp         =      16'd160;
parameter       V_active     =      16'd768;
parameter       V_fp         =      16'd3;
parameter       V_sync       =      16'd6;
parameter       V_bp         =      16'd29;
parameter       Hs_pol       =      1'b0;       
parameter       Vs_pol       =      1'b0;
`endif

//1920*1080 148.5Mhz
`ifdef video_1920_1080
parameter       H_active     =      16'd1920;
parameter       H_fp         =      16'd88;
parameter       H_sync       =      16'd44;
parameter       H_bp         =      16'd148;
parameter       V_active     =      16'd1080;
parameter       V_fp         =      16'd4;
parameter       V_sync       =      16'd5;
parameter       V_bp         =      16'd36;
parameter       Hs_pol       =      1'b1;       
parameter       Vs_pol       =      1'b1;
`endif

parameter       H_TOTAL = H_active + H_fp + H_sync + H_bp;
parameter       V_TOTAL = V_active + V_fp + V_sync + V_bp;

//reg
reg     h_syns;         //horizontal sync register
reg     v_syns;         //vertical sync register
reg     h_syns_d0;      //deley one clock
reg     v_syns_d0;      //deley one clock
reg[11:0]       h_cnt;
reg[11:0]       v_cnt;
reg[11:0]       active_x;   //vedio  x position
reg[11:0]       active_y;   //video  v position
reg[7:0]        rgb_r_reg;
reg[7:0]        rgb_g_reg;
reg[7:0]        rgb_b_reg;
reg     h_active;
reg     v_active;
wire    W_act_Flag;
reg     W_act_Flag_d0;      //deley one clock

assign  O_hs = h_syns_d0;
assign  O_vs = v_syns_d0;
assign  W_act_Flag = h_active & v_active;
assign  O_de = W_act_Flag_d0;

assign O_rgb_r  =     rgb_r_reg;
assign O_rgb_g  =     rgb_g_reg;
assign O_rgb_b  =     rgb_b_reg;

//output logic
always@(posedge I_clk or posedge I_rst)
begin
    if(I_rst)
        begin
            h_syns_d0   <=  1'b0;
            v_syns_d0   <=  1'b0;
            W_act_Flag_d0      <=   1'b0;
        end
    else
        begin
            h_syns_d0   <=  h_syns; 
            v_syns_d0   <=  v_syns; 
            W_act_Flag_d0      <= W_act_Flag;
        end    
end

//horizontal L:ogic

//counter maximunm logic
always@(posedge I_clk or posedge I_rst)
begin
    if(I_rst)
        h_cnt <= 12'd0;
    else if(h_cnt == H_TOTAL - 12'd1)   //horizontal counter maximun value
        h_cnt   <=  12'd0;
    else
        h_cnt <= h_cnt + 12'd1;            
end

//active horizontal logic
always@(posedge I_clk or posedge I_rst)
begin
    if(I_rst)
        active_x <= 12'd0;
    else if(h_cnt >= H_fp + H_sync + H_bp - 12'd1)//horizontal active 
        active_x <= h_cnt - (H_fp[11:0] + H_sync[11:0] + H_bp[11:0] - 12'd1);
    else
        active_x <= active_x;    
end


//vertical output logic
//vcnt logic
always@(posedge I_clk or posedge I_rst)
begin
    if(I_rst)
        v_cnt <= 12'd0;
    else if(h_cnt == H_fp - 12'd1) // horizotal sync time 
        if(v_cnt == V_TOTAL - 12'd1) //vertical counter
            v_cnt <= 12'd0;
        else
            v_cnt <= v_cnt + 12'd1;
    else 
        v_cnt <= v_cnt;                
end

//horizontal sync process 

always@(posedge I_clk or posedge I_rst)
begin
    if(I_rst)
        h_syns <= 1'b0;
    else if(h_cnt == H_fp - 12'd1) // horizontal sync begin
    begin
        h_syns <= Hs_pol;
    end    
    else if(h_cnt == H_fp + H_sync - 12'd1)//horizontal sync end
    begin
        h_syns <= ~h_syns;
    end
    else 
        h_syns <= h_syns;           
end

//horizontal active process
always@(posedge I_clk or posedge I_rst)
begin
    if(I_rst)
        h_active <= 1'b0;
    else if(h_cnt == H_fp + H_sync + H_bp - 12'd1)//horizontal active begin
        h_active <= 1'b1;
    else if(h_cnt == H_TOTAL - 12'd1)//horizontal active end
        h_active <= 1'b0;
    else
        h_active <= h_active;            
end

//vertical sync process
always@(posedge I_clk or posedge I_rst)
begin
    if(I_rst)
        v_syns <= 1'b0;
    else if(v_cnt == V_fp - 12'd1) // vertical sync begin
    begin
        v_syns <= Vs_pol;
    end    
    else if(v_cnt == V_fp + V_sync - 12'd1)//vertical sync end
    begin
        v_syns <= ~v_syns;
    end
    else
        v_syns <= v_syns;
end     

// verticalactive process
always@(posedge I_clk or posedge I_rst)
begin
    if(I_rst)
        h_active <= 1'b0;
    else if(h_cnt == H_fp + H_sync + H_bp - 12'd1)//horizontal active begin
        h_active <= 1'b1;
    else if(h_cnt == H_TOTAL - 12'd1)//horizontal active end
        h_active <= 1'b0;
    else
        h_active <= h_active;            
end

endmodule
