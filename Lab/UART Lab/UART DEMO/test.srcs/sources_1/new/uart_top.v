`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/08 09:49:55
// Design Name: 
// Module Name: uart_top
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

module uart_top(
                input I_clk,
                input I_rst,
                input I_rs232_rxd, //rx input 
                output O_rs232_txd //tx output 
);

wire            W_bps_tx_clk                 ;
wire            W_bps_tx_clk_en              ;
wire            W_bps_rx_clk                 ;
wire            W_bps_rx_clk_en              ;
wire            W_tx_start                   ;
wire            W_tx_done                    ;
wire            W_rx_done                    ;
wire  [7:0]     W_para_data                  ;
wire  [7:0]     W_rx_para_data               ;
            
reg   [7:0]     R_data_reg                   ;
reg   [31:0]    R_cnt_1s                     ;
reg             R_tx_start_reg               ;
reg             R_rx_start_reg               ;
    
assign W_tx_start     =    R_tx_start_reg      ;
assign W_rx_start     =    R_rx_start_reg      ;
assign W_para_data    =    R_data_reg          ; 
    
/////////////////////////////////////////////////////////////////////
// single
/////////////////////////////////////////////////////////////////////
always @(posedge I_clk)
begin
     if(I_rst)
        begin
             R_cnt_1s         <= 31'd0     ;
             R_data_reg       <= 8'd0      ;
             R_tx_start_reg   <= 1'b0      ;
             R_rx_start_reg   <= 1'b0      ;
        end
     else if(R_cnt_1s == 31'd5000)
        begin
             R_cnt_1s         <= 31'd0                 ;
             R_data_reg       <= R_data_reg + 1'b1     ;
             R_tx_start_reg   <= 1'b1                  ;
             R_rx_start_reg   <= 1'b1      ;
        end
     else
        begin
          R_cnt_1s           <= R_cnt_1s + 1'b1     ;
          R_tx_start_reg     <= 1'b0                ;
          R_rx_start_reg     <= 1'b0                ;
        end
end

uart_tx U_uart_tx
(
    .I_clk               (I_clk                 ), 
    .I_rst               (I_rst               ), 
    .I_tx_start          (W_tx_start            ), 
    .I_bps_tx_clk        (W_bps_tx_clk          ), 
    .I_para_data         (W_para_data           ), 
    .O_rs232_txd         (O_rs232_txd           ), 
    .O_bps_tx_clk_en     (W_bps_tx_clk_en       ), 
    .O_tx_done           (W_tx_done             )  
);

baudrate_gen U_baudrate_gen
(
    .I_clk              (I_clk              ), 
    .I_rst              (I_rst            ), 
    .I_bps_tx_clk_en    (W_bps_tx_clk_en    ), 
    .I_bps_rx_clk_en    (W_bps_rx_clk_en    ), 
    .O_bps_tx_clk       (W_bps_tx_clk       ), 
    .O_bps_rx_clk       (W_bps_rx_clk       )  
);

uart_rx U_uart_rx
(
    .I_clk              (I_clk              ), 
    .I_rst              (I_rst            ), 
    .I_rx_start         (R_rx_start_reg            ), 
    .I_bps_rx_clk       (W_bps_rx_clk       ), 
    .I_rs232_rxd        (O_rs232_txd        ), 
    .O_bps_rx_clk_en    (W_bps_rx_clk_en    ), 
    .O_rx_done          (W_rx_done          ), 
    .O_para_data        (W_rx_para_data     )  
);    
    
endmodule
