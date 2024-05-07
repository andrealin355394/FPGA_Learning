`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/05 15:46:40
// Design Name: 
// Module Name: baudrate_TB
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


module baudrate_TB;
reg clk,rst;
wire tx_clk, rx_clk;
//wire I_bps_tx_clk_en,I_bps_rx_clk_en;
reg I_bps_tx_clk_en , I_bps_rx_clk_en;
reg [12:0] cnt_rx,cnt_tx;

initial begin
clk = 1'b1;
rst = 1'b1;
cnt_rx = 1'b0;
cnt_tx =1'b0;
I_bps_tx_clk_en = 1'b1;
I_bps_rx_clk_en = 1'b1;

#50 
rst = 1'b0;

end
always #5  clk = ~ clk;

baudrate_gen u0(    .I_clk(clk),
                    .I_rst(rst),
                    .O_bps_tx_clk(tx_clk),
                    .O_bps_rx_clk(rx_clk),
                    .I_bps_tx_clk_en(I_bps_tx_clk_en),
                    .I_bps_rx_clk_en(I_bps_rx_clk_en)
                    ); 

endmodule
