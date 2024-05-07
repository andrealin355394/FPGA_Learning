`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/02 13:45:01
// Design Name: 
// Module Name: IIC_Demo
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


module IIC_Demo(
        input                I_clk           , 
        input                I_rst_n         , 
        input                 I_iic_send_en   , // iic send enable
    
        input        [6:0]   I_dev_addr      , // IIC device addr 
        input        [7:0]   I_word_addr     , // IICdevice word address , we using this address 
        input        [7:0]   I_write_data    , 
        output  reg          O_done_flag     , 
    
        // IIC device port 
        output               O_scl           , // IIC??的串行???
        inout                IO_sda            // IIC??的?向?据?

    );
endmodule
