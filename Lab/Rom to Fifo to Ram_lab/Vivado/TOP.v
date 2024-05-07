`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 17:17:47
// Design Name: 
// Module Name: TOP
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


module TOP(
        input trclk,
        input rvclk,
        input reset,
        output [31:0]q
    );
    ///rom to logic
    wire [31:0]fifo_in,rom_out;
    wire fifo_wreq,fifo_wrfull;
    wire [7:0]rom_addr;
        
      blk_mem_gen_rom u0(.clka(trclk),
                        .addra(rom_addr),
                        .douta(rom_out)
                        );
                        
      Block_rom u1(.trclk(trclk),
                    .reset(reset),
                    .rom_out(rom_out),
                    .fifo_wrfull(fifo_wrfull),
                    .rom_addr(rom_addr),
                    .fifo_in(fifo_in),
                    .fifo_wreq(fifo_wreq));  
                    
                  
//      ///logic a to fifo to logic b
       wire ram_wren,ram_rden;      
        wire [31:0]fifo_out;
        wire fifo_rdempty; 
        wire fifo_rdeq;
        fifo_generator_0 u2(
                          .full(fifo_wrfull),///////to logic a 
                          .din(fifo_in),
                          .wr_en(fifo_wreq),
                          .empty(fifo_rdempty),///////to logic b
                          .dout(fifo_out),
                          .rd_en(fifo_rdeq),
                          .wr_clk(trclk),   ////////clk
                          .rd_clk(rvclk));      
                          
                                          
        //logic b to ram
        wire [8:0] word_count;
        wire [7:0] ram_addr;        
        wire [31:0]ram_in; 
               
                 
        Block_RAM u3(.rvclk(rvclk),
                  .reset(reset),
                  .ram_addr(ram_addr),
                  .fifo_out(fifo_out),
                  .ram_in(ram_in),
                  .fifo_rdempty(fifo_rdempty),
                  .fifo_rdeq(fifo_rdeq),
                  .ram_rden(ram_rden),
                  .ram_wren(ram_wren),
                  .word_count(word_count));
                                          

        blk_mem_gen_ram u4(.clka(rvclk),
                        .addra(ram_addr),
                        .dina(ram_in),
                        .ena(ram_wren),
                        .wea(ram_wren),
                        .douta(q));
                        
                 
endmodule

////////////////////////////////TB//////////////////////////////
module TOP_TB();

reg trclk,rvclk,reset;
wire [31:0]q;

always #5 trclk = ~trclk;
always #20 rvclk = ~rvclk; 

TOP test1(
            .trclk(trclk),
            .rvclk(rvclk),
            .reset(reset),
            .q(q));
                                        
    initial begin
        trclk = 'b0;
        rvclk = 'b0;
        reset = 'b1;
        #25 reset = 'b0;
               
    end            
    
endmodule

