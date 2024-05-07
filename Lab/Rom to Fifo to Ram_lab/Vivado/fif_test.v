`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/16 10:44:40
// Design Name: 
// Module Name: fif_test
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


module fif_test(
    input reset,
    input trclk,
    input rvclk,
    output [31:0]q 
    );
    
    reg [63:0]wrctrlstate,rdctrlstate;
    reg [63:0]next_state_fi,next_state_fo; 
    parameter IDLE   = 'h00490064006c0065000a;
    parameter WRITE  = 'h00570072006900740065;
    parameter INCADR = 'h0049006e0043006100720064;
    parameter WAIT   = 'h0057006100690074;
    parameter DONE   = 'h0044006f006e0065;
   
////rom////////////////
    reg [31:0]rom_out;
    reg [7:0]rom_addr;
////fifo///////////////
    reg[31:0] fifo_in;
    reg fifo_wreq,fifo_wrfull;
    reg[31:0] fifo_out;
    reg fifo_rdeq,fifo_rdempty;
////ram////////////////
    reg [31:0]ram_in;
    reg [7:0]ram_addr;
    reg ram_wren,ram_rden;
    reg [8:0] word_count;  
    /////////ROM TO FIFO/////////////
    always@(posedge trclk)begin     //stste reg
        if(reset)begin
            wrctrlstate <= IDLE;
        end
        else begin 
            wrctrlstate <= next_state_fi;
        end 
    end  
    always@(posedge trclk)begin         //next stste logic
        case(wrctrlstate)
            IDLE:
                if(fifo_wreq == 1)
                    next_state_fi <= WRITE;               
                else
                    next_state_fi <= INCADR;
            //WRITE:
                
            //INCADR:
            //WAIT:
            //DONE:
            
        endcase
    end       
    
    
endmodule
