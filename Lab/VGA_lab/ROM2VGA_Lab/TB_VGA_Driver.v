`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 15:25:52
// Design Name: 
// Module Name: TB_VGA_Driver
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


module TB_VGA_Driver();


reg     I_clk;
reg     I_rst;

initial
begin
   I_clk = 'b0;
   I_rst = 'b0;
   #50
   I_rst = 'b1;
end

always #5 I_clk = ~I_clk;

VGA_Driver u0(
            .I_clk(I_clk),
            .I_rst(I_rst)
);


endmodule
