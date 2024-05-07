`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 16:04:20
// Design Name: 
// Module Name: Block_rom
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


module Block_rom(
    input trclk,
    input reset,
    input[31:0] rom_out,
    input fifo_wrfull,
    output reg[7:0] rom_addr ='h0 ,    
    output reg[31:0] fifo_in = 'b0,
    output reg fifo_wreq = 'b0
    );
    reg [63:0]wrctrlstate ='b0;
    reg [63:0]rdctrlstate ='b0;
    reg [63:0]next_state_fi ='b0;
    reg [63:0]next_state_fo ='b0; 
    //reg flag;
    parameter IDLE   = 'h49646c65;
    parameter WRITE  = 'h5772697465;
    parameter INCADR = 'h496e43617264;
    parameter WAIT   = 'h57616974;
    parameter DONE   = 'h446f6e65;
    
    reg [31:0] cunter ='b0;
    
    always@(posedge trclk)begin     //stste reg
        if(reset)
        begin
            wrctrlstate <= IDLE;       
        end
        else begin 
            wrctrlstate <= next_state_fi;
        end 
    end
    
    always@(*)begin         //next stste logic
        case(wrctrlstate)
            IDLE:   
                begin
                next_state_fi = WRITE; 
                end              
            WRITE:     
                begin
                if(rom_addr =='hff) //if(fifo_wrfull || rom_addr =='hff)
                    next_state_fi = DONE;               
                else
                    next_state_fi = INCADR; 
                    end               
            INCADR: 
                begin
                if(fifo_wrfull)
                    next_state_fi = WAIT;
                else
                    next_state_fi = WRITE;
                    end
            WAIT:  
                begin
                    if(fifo_wrfull)
                        next_state_fi <= WAIT;   
                    else
                        next_state_fi <= WRITE;     
                end            
            DONE:   begin
                next_state_fi <=DONE;
                    end
        endcase
    end
    
    always@(*)begin     //output logic
        case(wrctrlstate)
            IDLE:
                begin
                 rom_addr ='h0;
                end
            WRITE:
                begin
                fifo_wreq = 'b1;
                fifo_in = rom_out;
                end
            INCADR:
                begin
                fifo_wreq = 'b0;
                rom_addr = rom_addr + 'b1;
                end
            WAIT:
                begin
                fifo_wreq = 'b0; 
                end
            DONE:
                begin
                fifo_wreq = 'b0; 
                end
        endcase
    end    
endmodule
