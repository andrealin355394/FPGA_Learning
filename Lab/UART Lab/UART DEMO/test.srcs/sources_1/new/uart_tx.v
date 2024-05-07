`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/05 14:22:12
// Design Name: 
// Module Name: uart_rx
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

module uart_tx
    (
        input          I_clk           , 
        input          I_rst           ,
        input          I_tx_start      , 
        input          I_bps_tx_clk    , 
        input   [7:0]  I_para_data     , 
        output  reg    O_rs232_txd     , 
        output  reg    O_bps_tx_clk_en , 
        output  reg    O_tx_done         
    );
    
parameter IDLE     =       'h49646c65;
parameter START_B  =    'h53544152545f42;
parameter B_0      =       'h425f30;
parameter B_1      =       'h425f31;
parameter B_2      =       'h425f32;
parameter B_3      =       'h425f33;
parameter B_4      =       'h425f34;
parameter B_5      =       'h425f35;
parameter B_6      =       'h425f36;
parameter B_7      =       'h425f37;
parameter STOP_B   =    'h53544f505f42;
parameter WAIT     =    'h57414954;

reg [63:0]curr_state ='b0 ,  next_state = 'b0;


// flag  for  data transmiting

reg R_transmiting = 1'b0;
// logic for flag transmiting
always@(posedge I_clk)
begin
    if(I_rst)
        R_transmiting <= 1'b0;
    else if(O_tx_done)
        R_transmiting <=1'b0;
    else if(I_tx_start)
        R_transmiting <= 1'b1;        
end   
 
// FSM state logic

always@(posedge I_clk)
begin
    if(I_rst)
        curr_state = IDLE;
    else
        curr_state = next_state;         
end

//FSM next state logic 

always@(*)
begin
    case(curr_state)
        IDLE:
            begin
                if(R_transmiting)
                begin
                    next_state = START_B;
                end
                else
                    next_state = IDLE;   
            end 
        START_B :
            begin
                if(I_bps_tx_clk)
                
                    next_state = B_0;
                else
                    next_state = curr_state;    
            end
        B_0     :
            begin
                if(I_bps_tx_clk)
                    next_state = B_1;
                else
                    next_state = curr_state;            
            end   
        B_1     :
            begin
                if(I_bps_tx_clk)
                    next_state = B_2;
                else
                    next_state = curr_state;
            end
        B_2     :
            begin
                if(I_bps_tx_clk)
                    next_state = B_3;
                else
                    next_state = curr_state;
            end
        B_3     :
            begin
                if(I_bps_tx_clk)
                    next_state = B_4;
                else
                    next_state = curr_state;
            end
        B_4     :
            begin
                if(I_bps_tx_clk)
                    next_state = B_5;
                else
                    next_state = curr_state;
            end
        B_5     :
            begin
                if(I_bps_tx_clk)
                    next_state = B_6;
                else
                    next_state = curr_state;
            end
        B_6     :
            begin
                if(I_bps_tx_clk)
                    next_state = B_7;
                else
                    next_state = curr_state;
            end
        B_7     :
            begin
                if(I_bps_tx_clk)
                    next_state = STOP_B;
                else
                    next_state = curr_state;
            end
        STOP_B  :
            begin
                if(I_bps_tx_clk)
                    next_state = WAIT;
                else
                    next_state = curr_state;
            end
        WAIT:
            begin
                if(I_tx_start)
                    next_state = START_B;
                else
                    next_state = curr_state;                            
            end 
    endcase
end    
// output logic     
always@(*)
begin
    case(curr_state)
        IDLE:
            begin
                O_bps_tx_clk_en = 1'b0  ;
                O_rs232_txd  = 1'b0    ;
                O_tx_done    = 1'b0    ;
            end 
        START_B :
            begin
                O_bps_tx_clk_en = 1'b1  ;
                O_rs232_txd  = 1'b0    ;
                O_tx_done    = 1'b0    ;  
            end
        B_0     :
            begin  
                O_tx_done      = 1'b0    ;
                O_rs232_txd    = I_para_data[0];        
            end   
        B_1     :
            begin
                O_tx_done   = 1'b0    ;
                O_rs232_txd  = I_para_data[1]; 
            end
        B_2     :
            begin
                O_tx_done    = 1'b0    ;
                O_rs232_txd  = I_para_data[2];
            end
        B_3     :
            begin
                O_tx_done    = 1'b0    ;
                O_rs232_txd  = I_para_data[3];
            end
        B_4     :
            begin
                O_tx_done    = 1'b0    ;
                O_rs232_txd  = I_para_data[4];
            end
        B_5     :
            begin
                O_tx_done    = 1'b0    ;
                O_rs232_txd  = I_para_data[5];
            end
        B_6     :
            begin
                O_tx_done    = 1'b0    ;
                O_rs232_txd  = I_para_data[6];
            end
        B_7     :
            begin
                O_tx_done    = 1'b0    ;
                O_rs232_txd  = I_para_data[7];
            end
        STOP_B  :
            begin
                O_tx_done    = 1'b1    ;
                O_rs232_txd  = 1'b1    ;
            end
        WAIT    :
            begin
                O_tx_done    = 1'b1    ;
                O_rs232_txd  = 1'b0    ;
                O_bps_tx_clk_en = 1'b0 ;   
            end      
    endcase         
end
 
endmodule
