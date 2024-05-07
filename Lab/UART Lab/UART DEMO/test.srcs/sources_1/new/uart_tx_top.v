`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/06 13:40:11
// Design Name: 
// Module Name: uart_tx_top
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


module uart_tx_top
(
    input I_clk,
    input I_rst,
    output O_rs232txd
    
 );
 
wire            W_bps_tx_clk             ;
wire            W_bps_tx_clk_en          ;
wire            W_tx_start               ;
wire            W_tx_done                ;
wire  [7:0]     W_para_data              ;
        
reg   [7:0]     R_data_reg               ;
reg   [31:0]    R_cnt_1s                 ;
reg             R_tx_start_reg           ;

assign W_tx_start     =    R_tx_start_reg    ;
assign W_para_data    =    R_data_reg        ;

// make single 

always@(posedge I_clk)
begin
    if(I_rst)
        begin 
            R_cnt_1s <= 31'd0;
            R_data_reg = 7'd0;
            R_tx_start_reg =1'd0;
        end
     else if(R_cnt_1s == 31'd5000)
        begin
             R_cnt_1s         <= 31'd0                 ;
             R_data_reg       <= R_data_reg + 1'b1      ;
             R_tx_start_reg <= 1'b1                 ;
        end
     else
        begin
          R_cnt_1s             <= R_cnt_1s + 1'b1     ;
          R_tx_start_reg     <= 1'b0             ;
        end        
end

uart_tx U_uart_txd
(
    .I_clk               (I_clk                 ), // �t?50MHz??
    .I_rst               (I_rst               ), // �t?�����`��
    .I_tx_start          (W_tx_start            ), // ?�e�ϯ�H?
    .I_bps_tx_clk        (W_bps_tx_clk          ), // �i�S�v??
    .I_para_data         (W_para_data           ), // �n?�e���}��?�u
    .O_rs232_txd         (O_rs232_txd           ), // ?�e�����?�u�A�b�w��W�O��f��?
    .O_bps_tx_clk_en     (W_bps_tx_clk_en       ), // �i�S�v??�ϯ�H?
    .O_tx_done           (W_tx_done             )  // ?�e������?��
);

baudrate_gen U_baudrate_gen
(
    .I_clk              (I_clk              ), // �t?50MHz??
    .I_rst              (I_rst            ), // �t?�����`��
    .I_bps_tx_clk_en    (W_bps_tx_clk_en    ), // ��f?�e��?�i�S�v??�ϯ�H?
    .I_bps_rx_clk_en    (                   ), // ��f������?�i�S�v??�ϯ�H?
    .O_bps_tx_clk       (W_bps_tx_clk       ), // ?�e��?�i�S�v?��??
    .O_bps_rx_clk       (                   )  // ������?�i�S�v?��??
);
endmodule
