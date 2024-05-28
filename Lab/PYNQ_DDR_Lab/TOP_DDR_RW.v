`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/27 14:26:13
// Design Name: 
// Module Name: TOP_DDR_RW
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


module TOP_DDR_RW(
    input           sys_clk         ,       //50Mhz        
    input           sys_rst_n       ,       // L active

    // ddr io
    inout   [15:0]  ddr3_dq         ,       //ddr3 data
    //inout     [31:0]      ddr3_dq                     ,              
    inout   [1:0]   ddr3_dps_n      ,       //ddr3 dps neg
    inout   [1:0]   ddr3_dps_p      ,       // ddr3 dps pos
    //inout   [3:0]         ddr3_dps_n      ,
    //inout   [3:0]         ddr3_dps_n      ,
    output  [13:0]  ddr3_addr       ,       //ddr3 addr  
    output  [2:0]   ddr3_ba         ,       // ddr3 bank
    output          ddr3_ras_n      ,       //ddr3 row 
    output          ddr3_cad_n      ,       //ddr3 colum
    output          ddr3_we_n       ,       //ddr3 write enable
    output          ddr3_reset_n    ,       //ddr3 reset
    output  [0:0]   ddr3_clk_p      ,       //ddr3 clk pos
    output  [0:0]   ddr3_clk_n      ,       //ddr3 clk neg
    output  [0:0]   ddr3_cke        ,       //ddr3 clk enable
    output  [0:0]   ddr3_cs_n       ,       //ddr3 chip enable 
    output  [1:0]   ddr3_dm         ,       //ddr3_dm
    //output  [3:0]   ddr3_dm
    output  [0:0]   ddr3_odt        ,       //ddr3_odt         
    
    //user
    output  [1:0]   led             //              led 
    );

//wire define
wire                clk_50m                     ;
wire                clk_200m                    ;
wire                init_calib_complete         ;    //ddr initail done flag
wire                error                       ;

wire    [15:0]      rd_data                     ;
wire    [15:0]      we_data                     ;
wire    [27:0]      app_addr_rd_min             ;
wire    [27:0]      app_addr_rd_max             ;
wire    [7:0]       rd_bust_len                 ;
wire    [27:0]      app_addr_wr_min             ;
wire    [27:0]      app_addr_wr_max             ;
wire    [7:0]       wr_bust_len                 ;
wire                wr_en                       ;
wire                locked                      ;    


//*********************************************************
//************************main code   ***********************
//*********************************************************

assign app_addr_rd_min  =   28'd0;
assign app_addr_rd_max  =   28'd1024;       //read max address
assign rd_bust_len      =   8'd64;          // one time read data len
assign app_addr_wr_min  =   28'd0;
assign app_addr_wr_max  =   28'd1024;       //write max address
assign wr_bust_len      =   8'd64;          //one time wrtie data len

//reset single 
assign rst_n    =   locked && sys_rst_n;

// read wrtie module 

ddr3_controller u_ddr3_controller(
    //mig
    .init_calib_complete    (init_calib_complete),   //ddr3 initail done flag
    //ddr3 address value
    .app_addr_rd_min        (app_addr_rd_min),
    .app_addr_rd_max        (app_addr_rd_max),
    .rd_bust_len            (rd_bust_len),   
    .app_addr_wr_min        (app_addr_wr_min),
    .app_addr_wr_max        (app_addr_wr_max),
    .wr_bust_len            (wr_bust_len),
    //memory interface port
    .ddr3_dq                (ddr3_dq     ),
    .ddr3_dps_n             (ddr3_dps_n  ),
    .ddr3_dps_p             (ddr3_dps_p  ),
    .ddr3_addr              (ddr3_addr   ),
    .ddr3_ba                (ddr3_ba     ),
    .ddr3_ras_n             (ddr3_ras_n  ),
    .ddr3_cad_n             (ddr3_cad_n  ),
    .ddr3_we_n              (ddr3_we_n   ),
    .ddr3_reset_n           (ddr3_reset_n),
    .ddr3_clk_p             (ddr3_clk_p  ),
    .ddr3_clk_n             (ddr3_clk_n  ),
    .ddr3_cke               (ddr3_cke    ),
    .ddr3_cs_n              (ddr3_cs_n   ),
    .ddr3_dm                (ddr3_dm     ),
    .ddr3_odt               (ddr3_odt    ),
    
    //system clock ports
    .sys_clk_i              (clk_200m)  ,
    .rst_n                  (rst_n)     ,
    //refence Clock Ports
    .clk_ref_i              (clk_200m)  ,
    .ddr3_read_valid        (1'b1)      ,
    // user port
    .rd_req                 (re_req)    ,   //read fifo
    .wr_clk                 (clk_50m)   ,
    .rd_clk                 (clk_50m)   ,
    .wr_en                  (wr_en)     ,
    .wr_data                (wr_data)    ,
    .rd_data                (rd_data)              

);

test_data u_test_data(
    .clk_50m                (clk_50m)   ,
    .rst_n                  (rst_n)     ,
    .init_calib_complete    (init_calib_complete),
    .rd_data                (rd_data)   ,
    .rd_req                 (rd_req)    ,
    .wr_data                (wr_data)   ,
    .wr_en                  (wr_en)     ,
    .error                  (error)     
);

led_disp u_led_disp(
    .clk_50m                (clk_50m)   ,
    .rst_n                  (rst_n)     ,
    //ddr3 init failed or rd wr data wrong are the failed
    .init_calib_complete    (init_calib_complete) ,
    .led(led)     
);

clk_wiz_0   u_clk_wiz(
    //clk out port
    .clk_out1               (clk_200m)  ,
    .clk_out2               (clk_50m),
    .reset                  (~sys_rst_n),
    .locked                 (locked)    ,
    .clk_in1                (sys_clk)
);


endmodule
