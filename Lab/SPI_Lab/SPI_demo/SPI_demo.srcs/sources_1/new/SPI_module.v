`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/25 10:18:26
// Design Name: 
// Module Name: SPI_module
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


module SPI_module(
    input   I_clk,
    input   I_rst,
    input   I_tx_en,
    input   I_rx_en,
    input   [7:0]I_data_in,
    
    output reg [7:0]O_data_out,
    output reg  O_tx_done,
    output reg  O_rx_done,
    
    // spi 
    input   I_spi_miso,
    output reg  O_spi_cs,
    output reg  O_spi_sck,
    output reg  O_spi_mosi 
   
    );
    
    reg [63:0] R_curr_state = 'b0, R_next_state = 'b0;
    reg [63:0] T_curr_state = 'b0, T_next_state = 'b0;
    //RX state
    parameter   IDLE_R    =   'h49646c655f52  ;
    parameter   START_R   =   'h53544152545f52;
    parameter   R_0      =       'h525f30;
    parameter   R_1      =       'h525f31;
    parameter   R_2      =       'h525f32;
    parameter   R_3      =       'h525f33;
    parameter   R_4      =       'h525f34;
    parameter   R_5      =       'h525f35;
    parameter   R_6      =       'h525f36;
    parameter   R_7      =       'h525f37;
    parameter   R_8      =       'h525f38;
    parameter   R_9      =       'h525f39;
    parameter   R_10      =       'h525f3130;
    parameter   R_11      =       'h525f3131;
    parameter   R_12      =       'h525f3132;
    parameter   R_13      =       'h525f3133;
    parameter   R_14      =       'h525f3134;
    parameter   R_15      =       'h525f3135;
    parameter   STOP_R    =   'h53544f505f52  ; 
    parameter   WAIT_R    =   'h574149545f52 ;
    // TX state  
    parameter   IDLE_T    =   'h49646c655f54  ;
    parameter   START_T   =   'h53544152545f54;
    parameter   T_0      =       'h545f30;
    parameter   T_1      =       'h545f31;
    parameter   T_2      =       'h545f32;
    parameter   T_3      =       'h545f33;
    parameter   T_4      =       'h545f34;
    parameter   T_5      =       'h545f35;
    parameter   T_6      =       'h545f36;
    parameter   T_7      =       'h545f37;
    parameter   T_8      =       'h545f38;
    parameter   T_9      =       'h545f39;
    parameter   T_10      =       'h545f3130;
    parameter   T_11      =       'h545f3131;
    parameter   T_12      =       'h545f3132;
    parameter   T_13      =       'h545f3133;
    parameter   T_14      =       'h545f3134;
    parameter   T_15      =       'h545f3135;
    parameter   STOP_T    =   'h53544f505f54  ; 
    parameter   WAIT_T    =   'h574149545f54 ;
    
    
    
    //tx state logic
    //
    //
    //
    always@(posedge I_clk)
    begin
        if(I_rst)
            T_curr_state <= IDLE_T;
        else
            T_curr_state <= T_next_state;
    end
 
    always@(*)
    begin
        case(T_curr_state)
            IDLE_T      :
            begin
                if(I_tx_en)
                    T_next_state    =    START_T;
                else
                    T_next_state    =   T_curr_state;
            end
            START_T     :
            begin
                if(I_tx_en)
                    T_next_state    =    T_0;
                else
                    T_next_state    =   T_curr_state;
            end
            T_0         :
            begin
                if(I_tx_en)
                    T_next_state    =    T_1;
                else
                    T_next_state    =   T_curr_state;
            end
            T_1         :
            begin
                if(I_tx_en)
                    T_next_state    =    T_2;
                else
                    T_next_state    =   T_curr_state;
            end
            T_2         :
            begin
                if(I_tx_en)
                    T_next_state    =    T_3;
                else
                    T_next_state    =   T_curr_state;
            end
            T_3         :
            begin
                if(I_tx_en)
                    T_next_state    =    T_4;
                else
                    T_next_state    =   T_curr_state;
            end
            T_4         :
            begin
                if(I_tx_en)
                    T_next_state    =    T_5;
                else
                    T_next_state    =   T_curr_state;
            end
            T_5         :
            begin
                if(I_tx_en)
                    T_next_state    =    T_6;
                else
                    T_next_state    =   T_curr_state;
            end
            T_6         :
            begin
                if(I_tx_en)
                    T_next_state    =    T_7;
                else
                    T_next_state    =   T_curr_state;
            end
            T_7         :
            begin  
                if(I_tx_en)
                    T_next_state    =    T_8;
                else
                    T_next_state    =   T_curr_state;
            end
            T_8         :
            begin  
                if(I_tx_en)
                    T_next_state    =    T_9;
                else
                    T_next_state    =   T_curr_state;
            end
            T_9         :
            begin  
                if(I_tx_en)
                    T_next_state    =    T_10;
                else
                    T_next_state    =   T_curr_state;
            end
            T_10         :
            begin  
                if(I_tx_en)
                    T_next_state    =    T_11;
                else
                    T_next_state    =   T_curr_state;
            end
            T_11         :
            begin  
                if(I_tx_en)
                    T_next_state    =    T_12;
                else
                    T_next_state    =   T_curr_state;
            end
            T_12         :
            begin  
                if(I_tx_en)
                    T_next_state    =    T_13;
                else
                    T_next_state    =   T_curr_state;
            end           
            T_13         :
            begin  
                if(I_tx_en)
                    T_next_state    =    T_14;
                else
                    T_next_state    =   T_curr_state;
            end
            T_14         :
            begin  
                if(I_tx_en)
                    T_next_state    =    T_15;
                else
                    T_next_state    =   T_curr_state;
            end
            T_15         :
            begin  
                if(I_tx_en)
                    T_next_state    =    STOP_T;
                else
                    T_next_state    =   T_curr_state;
            end
            
            STOP_T      :
            begin
                if(I_tx_en)
                    T_next_state    =    WAIT_T;
                else
                    T_next_state    =   T_curr_state;
            end
            WAIT_T      :
            begin
                if(I_tx_en)
                    T_next_state    =    START_T;
                else
                    T_next_state    =   T_curr_state;
            end
        endcase
    end
         
    always@(*)
    begin
        case(T_curr_state)
            IDLE_T      :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                //O_spi_mosi  =   I_data_in[7]; 
                O_tx_done   =   1'b0;    
            end
            START_T     :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                //O_spi_mosi  =   I_data_in[7]; 
                O_tx_done   =   1'b0;
            end
            T_0         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_spi_mosi  =   I_data_in[7]; 
                O_tx_done   =   1'b0;  
            end
            T_1         :
            begin
                O_spi_sck   =   1'b1;
                O_tx_done   =   1'b0; 
            end
            T_2         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_spi_mosi  =   I_data_in[6]; 
                O_tx_done   =   1'b0;
            end
            T_3         :
            begin
                O_spi_sck   =   1'b1;
                O_tx_done   =   1'b0;
            end
            T_4         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_spi_mosi  =   I_data_in[5]; 
                O_tx_done   =   1'b0;
            end
            T_5         :
            begin
                O_spi_sck   =   1'b1;
                O_tx_done   =   1'b0;
            end
            T_6         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_spi_mosi  =   I_data_in[4]; 
                O_tx_done   =   1'b0;
            end
            T_7         :
            begin
                O_spi_sck   =   1'b1;
                O_tx_done   =   1'b0;  
            end
            T_8         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_spi_mosi  =   I_data_in[3]; 
                O_tx_done   =   1'b0;  
            end
            T_9         :
            begin
                O_spi_sck   =   1'b1;
                O_tx_done   =   1'b0;  
            end
            T_10         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_spi_mosi  =   I_data_in[2]; 
                O_tx_done   =   1'b0;  
            end
            T_11         :
            begin
                O_spi_sck   =   1'b1;
                O_tx_done   =   1'b0;  
            end
            T_12         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_spi_mosi  =   I_data_in[1]; 
                O_tx_done   =   1'b0;  
            end
            T_13         :
            begin 
                O_spi_sck   =   1'b1;
                O_tx_done   =   1'b0; 
            end
            T_14         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_spi_mosi  =   I_data_in[0]; 
                O_tx_done   =   1'b0;  
            end
            T_15         :
            begin  
                O_spi_sck   =   1'b1;
                O_tx_done   =   1'b1;
            end
            
            STOP_T      :
            begin
                O_spi_sck   =   1'b0;
                O_tx_done   =   1'b0;
                O_spi_mosi  =   1'b0; 
            end
            WAIT_T      :
            begin
                O_spi_sck   =   1'b1;
                O_spi_mosi  =   1'b0;
                O_tx_done   =   1'b0;
            end
        endcase   
    end
    
    //rx state logic
    //
    //
    //
    //
    //
    always@(posedge I_clk)
    begin
        if(I_rst)
            R_curr_state <= IDLE_R;
        else
            R_curr_state <= R_next_state;
    end
 
    always@(*)
    begin
        case(R_curr_state)
            IDLE_R      :
            begin
                if(I_rx_en)
                    R_next_state    =    START_R;
                else
                    R_next_state    =   R_curr_state;
            end
            START_R     :
            begin
                if(I_rx_en)
                    R_next_state    =    R_0;
                else
                    R_next_state    =   R_curr_state;
            end
            R_0         :
            begin
                if(I_rx_en)
                    R_next_state    =    R_1;
                else
                    R_next_state    =   R_curr_state;
            end
            R_1         :
            begin
                if(I_rx_en)
                    R_next_state    =    R_2;
                else
                    R_next_state    =   R_curr_state;
            end
            R_2         :
            begin
                if(I_rx_en)
                    R_next_state    =    R_3;
                else
                    R_next_state    =   R_curr_state;
            end
            R_3         :
            begin
                if(I_rx_en)
                    R_next_state    =    R_4;
                else
                    R_next_state    =   R_curr_state;
            end
            R_4         :
            begin
                if(I_rx_en)
                    R_next_state    =    R_5;
                else
                    R_next_state    =   R_curr_state;
            end
            R_5         :
            begin
                if(I_rx_en)
                    R_next_state    =    R_6;
                else
                    R_next_state    =   R_curr_state;
            end
            R_6         :
            begin
                if(I_rx_en)
                    R_next_state    =    R_7;
                else
                    R_next_state    =   R_curr_state;
            end
            R_7         :
            begin  
                if(I_rx_en)
                    R_next_state    =    R_8;
                else
                    R_next_state    =   R_curr_state;
            end
            R_8         :
            begin  
                if(I_rx_en)
                    R_next_state    =    R_9;
                else
                    R_next_state    =   R_curr_state;
            end
            R_9         :
            begin  
                if(I_rx_en)
                    R_next_state    =    R_10;
                else
                    R_next_state    =   R_curr_state;
            end
            R_10         :
            begin  
                if(I_rx_en)
                    R_next_state    =    R_11;
                else
                    R_next_state    =   R_curr_state;
            end
            R_11         :
            begin  
                if(I_rx_en)
                    R_next_state    =    R_12;
                else
                    R_next_state    =   R_curr_state;
            end
            R_12         :
            begin  
                if(I_rx_en)
                    R_next_state    =    R_13;
                else
                    R_next_state    =   R_curr_state;
            end           
            R_13         :
            begin  
                if(I_rx_en)
                    R_next_state    =    R_14;
                else
                    R_next_state    =   R_curr_state;
            end
            R_14         :
            begin  
                if(I_rx_en)
                    R_next_state    =    R_15;
                else
                    R_next_state    =   R_curr_state;
            end
            R_15         :
            begin  
                if(I_rx_en)
                    R_next_state    =    STOP_R;
                else
                    R_next_state    =   R_curr_state;
            end
            
            STOP_R      :
            begin
                if(I_rx_en)
                    R_next_state    =    WAIT_R;
                else
                    R_next_state    =   R_curr_state;
            end
            WAIT_R      :
            begin
                if(I_rx_en)
                    R_next_state    =    START_R;
                else
                    R_next_state    =   R_curr_state;
            end
        endcase
    end
         
    always@(*)
    begin
        case(R_curr_state)
            IDLE_R      :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_rx_done   =   1'b0;    
            end
            START_R     :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_rx_done   =   1'b0;
            end
            R_0         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_rx_done   =   1'b0;  
            end
            R_1         :
            begin
                O_spi_sck   =   1'b1;
                O_data_out[7]   =   I_spi_miso;
                O_rx_done   =   1'b0; 
            end
            R_2         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_rx_done   =   1'b0;
            end
            R_3         :
            begin
                O_spi_sck   =   1'b1;
                O_data_out[6]   =   I_spi_miso;
                O_rx_done   =   1'b0;
            end
            R_4         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_rx_done   =   1'b0;
            end
            R_5         :
            begin
                O_spi_sck   =   1'b1;
                O_data_out[5]   =   I_spi_miso;
                O_rx_done   =   1'b0;
            end
            R_6         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_rx_done   =   1'b0;
            end
            R_7         :
            begin
                O_spi_sck   =   1'b1;
                O_data_out[4]   =   I_spi_miso;
                O_rx_done   =   1'b0;  
            end
            R_8         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_rx_done   =   1'b0;  
            end
            R_9         :
            begin
                O_spi_sck   =   1'b1;
                O_data_out[3]   =   I_spi_miso;
                O_rx_done   =   1'b0;  
            end
            R_10         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_rx_done   =   1'b0;  
            end
            R_11         :
            begin
                O_spi_sck   =   1'b1;
                O_data_out[2]   =   I_spi_miso;
                O_rx_done   =   1'b0;  
            end
            R_12         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_rx_done   =   1'b0;  
            end
            R_13         :
            begin 
                O_spi_sck   =   1'b1;
                O_data_out[1]   =   I_spi_miso;
                O_rx_done   =   1'b0; 
            end
            R_14         :
            begin
                O_spi_sck   =   1'b0;
                O_spi_cs    =   1'b0;
                O_rx_done   =   1'b0;  
            end
            R_15         :
            begin  
                O_spi_sck   =   1'b1;
                O_data_out[0]   =   I_spi_miso;
                O_rx_done   =   1'b0;
            end
            
            STOP_R      :
            begin
                O_spi_sck   =   1'b0;
                O_rx_done   =   1'b1;
            end
            WAIT_R      :
            begin
                O_spi_sck   =   1'b0;
                O_rx_done   =   1'b1;
            end
        endcase   
    end    
    
endmodule
