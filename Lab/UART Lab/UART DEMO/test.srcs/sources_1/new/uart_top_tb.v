`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/08 10:16:05
// Design Name: 
// Module Name: uart_top_tb
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


module uart_top_tb();


reg clk,rst;
 
initial
begin
clk = 1'b1;
rst = 1'b1;
#50 
rst = 1'b0;
end
always #5 clk = ~ clk;


uart_top u0(
                .I_clk(clk),
                .I_rst(rst)    
                    );

endmodule
