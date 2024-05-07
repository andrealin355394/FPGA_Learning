`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 16:04:20
// Design Name: 
// Module Name: Fifo16_32
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


module Fifo16_32(
    /////// rom ti fifo
    input trclk,
    input [31:0] fifo_in,
    input fifo_wreq,
    output reg fifo_wrfull,
    /////// fifo to ram
    input fifo_rdeq,
    input rvclk,
    output reg fifo_rdempty,
    output reg [31:0] fifo_out    
    );
    
    fifo_generator_0 u0(.full(fifo_wrfull),.din());
    
endmodule
