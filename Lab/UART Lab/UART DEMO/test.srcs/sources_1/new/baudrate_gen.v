`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/05 15:08:44
// Design Name: 
// Module Name: baudrate_gen
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


module baudrate_gen(
        input           I_clk                 ,
        input           I_rst               ,
        input           I_bps_tx_clk_en       ,
        input           I_bps_rx_clk_en       ,
        output          O_bps_tx_clk          ,
        output          O_bps_rx_clk          ,
        output          rx_cnt,
        output          tx_cnt
    );

//  50Mhz  
parameter       C_bps9600       =   5207        ,   // 50M / 9600 =5208     
               C_bps19200      =   2063        ,
               C_bps38400      =   1301        ,
               C_bps57600      =   867         ,
               C_bps115200     =   433         ;
                   
parameter       C_bps_select = C_bps115200;     //select the baud rate

reg     [12:0]  R_bps_tx_cnt;                   
reg     [12:0]  R_bps_rx_cnt;                   
    
//////////////////////////////////////////////////////////////////////////////////    
// Serial port  'tx' baud rate clock logic 
/////////////////////////////////////////////////////////////////////////////////    

always@(posedge I_clk)
begin
    if(I_rst)
        R_bps_tx_cnt <= 13'd0;
    else if(I_bps_tx_clk_en == 1'b1)
        begin
            if(R_bps_tx_cnt == C_bps_select)
                R_bps_tx_cnt <= 13'd0;
            else
                R_bps_tx_cnt <= R_bps_tx_cnt + 1'b1;    
        end
    else
         R_bps_tx_cnt <= 13'd0;   
end

assign O_bps_tx_clk = (R_bps_tx_cnt ==13'd1)?1'b1:1'b0;


//////////////////////////////////////////////////////////////////////////////////    
// Serial port  'rx' baud rate clock logic 
/////////////////////////////////////////////////////////////////////////////////    

always@(posedge I_clk)
begin
    if(I_rst)
        R_bps_rx_cnt <= 13'd0;
    else if(I_bps_rx_clk_en == 1'b1)
        begin
            if(R_bps_rx_cnt == C_bps_select)
                R_bps_rx_cnt <= 13'd0;
            else
                R_bps_rx_cnt <= R_bps_rx_cnt + 1'b1;    
        end
    else
         R_bps_rx_cnt <= 13'd0;   
end

assign O_bps_rx_clk = (R_bps_rx_cnt ==1'b1)?1'b1:1'b0;
    
endmodule
