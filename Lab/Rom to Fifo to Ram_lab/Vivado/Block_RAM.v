`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 16:04:20
// Design Name: 
// Module Name: Block_RAM
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


module Block_RAM(
    input rvclk,
    input reset,
    ///fifo to ram
    input [31:0] fifo_out,
    input fifo_rdempty,
    output reg  fifo_rdeq = 'b0,
    //ram out
    
    output reg[31:0] ram_in= 'b0,
    output reg [7:0] ram_addr= 'hff,
    output reg ram_wren= 'b0,
    output reg ram_rden= 'b0,
    output reg[8:0] word_count= 'b0
       
    );
    
    reg [63:0]wrctrlstate= 'b0;
    reg [63:0]rdctrlstate= 'b0;
    reg [63:0]next_state_fi,next_state_fo; 
    
    parameter IDLE   = 'h49646c65;
    parameter WRITE  = 'h5772697465;
    parameter INCADR = 'h496e43617264;
    parameter WAIT   = 'h57616974;
    parameter DONE   = 'h446f6e65;
    
    always@(posedge rvclk)begin     //stste reg
        if(reset)begin
            rdctrlstate <= IDLE;
        end
        else begin 
            rdctrlstate <= next_state_fo;
        end 
    end
    always@(*)begin         //next stste logic
        case(rdctrlstate)
             IDLE:   
                begin
                    if(!fifo_rdempty)
                        next_state_fo = INCADR;
                    else
                        next_state_fo = IDLE;
                end           
            INCADR:
                if(fifo_rdempty == 'b0) 
                    begin
                        next_state_fo = WRITE;  
                    end
                else
                    next_state_fo = WAIT;              
            WRITE:
                if(fifo_rdempty == 'b0)
                begin
                    next_state_fo = INCADR;
                end
                else
                    next_state_fo = WAIT;
            WAIT:
                if(fifo_rdempty == 'b0)
                    next_state_fo = WRITE;               
                else
                    next_state_fo = WAIT;
        endcase
    end
    
    always@(*)begin     //output logic
        case(rdctrlstate)
            IDLE:   
                begin
                fifo_rdeq = 'b0;
                ram_wren = 'b0;
                ram_rden = 'b0;
                end         
            WRITE: begin
                ram_in = fifo_out;
                ram_wren = 'b1;
                ram_rden = 'b1;
                fifo_rdeq = 'b0; 
                //word_count = word_count + 'b1;                           
                end
            INCADR: begin
                fifo_rdeq = 'b1;
                ram_addr = ram_addr + 'b1;
                ram_wren = 'b0;
                ram_rden = 'b0;
                end
            WAIT:
                begin
                ram_wren = 'b0;
                ram_rden = 'b0; 
                end  
        endcase
    end   
    
  ////////////////////////////////////////////////////////////////////////////   
     always@(posedge rvclk)begin     // word count  add one
        if(rdctrlstate == INCADR)begin
            word_count = word_count + 'b1;   
        end
        else begin 
            word_count = word_count;   
        end 
    end   
endmodule
