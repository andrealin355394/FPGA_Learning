`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/28 15:12:59
// Design Name: 
// Module Name: ddr3_controller
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


module ddr3_controller(
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
    output          init_calib_complete,
    input           sys_clk_i       ,
    input           clk_ref_i       ,
    input           ddr3_read_valid ,
    
    input           rst_n           ,
    input   [27:0]  app_addr_rd_min ,
    input   [27:0]  app_addr_rd_max ,
    input   [7:0]   rd_bust_len     ,
    input   [27:0]  app_addr_wr_min ,
    input   [27:0]  app_addr_wr_max ,
    input   [7:0]   wr_bust_len     ,
    
    input           wr_clk          ,
    input           rd_clk          ,
    input           rd_req          ,
    input           wr_en           ,
    input   [15:0]  wr_data         ,
    input   [15:0]  rd_data          
    );
    
    //wire defined
    wire                app_rdy         ;   //mig ip core ready
    wire                app_wdf_rdy     ;   //mig wirte data ready
    wire                app_rd_data_valid   ;   //read data valid
    wire    [27:0]      app_addr            ;   //ddr3 address
    wire    [2:0]       app_cmd             ;   //user commad
    wire                app_en              ;   //mig ip enable 
    wire    [127:0]     app_rd_data         ;   // user read data
    wire                app_rd_data_end     ;   //end of read data
    wire    [127:0]     app_wdf_data        ;   //user write data
    wire                app_wdf_end         ;   //user write data end
    wire    [15:0]      app_wdf_mask        ;   // write data mask
    wire                app_sr_active       ;   //
    wire                app_ref_ack         ;   // reflash req
    wire                app_zq_ack          ;   //zq calib req
    wire                ui_clk              ;   //user clk
    wire                ui_clk_sync_rst     ;   //user reset
    wire    [9:0]       wfifo_rcount        ;   //fifo less data count
    wire    [9:0]       rfifo_wcount        ;   //wfifo write data less
    
    
//*********************************************************
//************************main code   ***********************
//*********************************************************    

//read write module

ddr3_rw u_ddr3_rw(
    .ui_clk             (ui_clk),
    .ui_clk_sync_rst    (ui_clk_sync_rst | ~rst_n),
    
    //mig port
    .init_calib_complete    (init_calib_complete),//ddr3 initial flga
    .app_rdy                (app_rdy           ),
    .app_wdf_rdy            (app_wdf_rdy       ),
    .app_rd_data_valid      (app_rd_data_valid ),
    .app_addr               (app_addr          ),
    .app_en                 (app_en            ),
    .app_wdf_wren           (app_wdf_wren      ),
    .app_wdf_end            (app_wdf_end       ),
    .app_cmd                (app_cmd           ),

    //ddr3 address
    .app_addr_rd_min        (app_addr_rd_min),
    .app_addr_rd_max        (app_addr_rd_max),
    .rd_bust_len            (rd_bust_len    ),
    .app_addr_wr_min        (app_addr_wr_min),
    .app_addr_wr_max        (app_addr_wr_max),
    .wr_bust_len            (wr_bust_len    ),
    
    // user port
    .rfifo_wren             (rfifo_wren     ),
    .ddr3_read_valid        (ddr3_read_valid),
    .wfifo_rcount           (wfifo_rcount   ),
    .rfifo_wcount           (rfifo_wcount   )  
);

// mig ip core moudle 
mig_7series_0 u_mig_7series_0(
    //Memory interface ports
    .ddr3_addr         (ddr3_addr   ),
    .ddr3_ba           (ddr3_ba     ),
    .ddr3_cas_n        (ddr3_cas_n  ),
    .ddr3_ck_n         (ddr3_ck_n   ),
    .ddr3_ck_p         (ddr3_ck_p   ),
    .ddr3_cke          (ddr3_cke    ),
    .ddr3_ras_n        (ddr3_ras_n  ),
    .ddr3_reset_n      (ddr3_reset_n), 
    .ddr3_we_n         (ddr3_we_n   ),
    .ddr3_dq           (ddr3_dq     ),
    .ddr3_dqs_n        (ddr3_dqs_n  ),
    .ddr3_dqs_p        (ddr3_dqs_p  ),
    .ddr3_cs_n         (ddr3_cs_n   ),
    .ddr3_dm           (ddr3_dm     ),
    .ddr3_odt          (ddr3_odt    ),
    //application interface ports
    .app_addr               (app_addr           ),
    .app_cmd                (app_cmd            ),
    .app_en                 (app_en             ),
    .app_wdf_data           (app_wdf_data       ),
    .app_wdf_end            (app_wdf_end        ),
    .app_wdf_wren           (app_wdf_wren       ),
    .app_rd_data            (app_rd_data        ),
    .app_rd_data_end        (app_rd_data_end    ),
    .app_rd_data_valid      (app_rd_data_valid  ),
    .init_calib_complete    (init_calib_complete),
    .app_rdy                (app_rdy            ),
    .app_sr_req             (0         ),
    .app_ref_req            (0        ),
    .app_zq_req             (0         ),
    .app_sr_active          (app_sr_active      ),
    .app_ref_ack            (app_ref_ack        ),
    .app_zq_ack             (app_zq_ack         ),
    .ui_clk                 (ui_clk             ),
    .ui_clk_sync_rst        (ui_clk_sync_rst    ),
    .app_wdf_mask           (16'b0       ),   
    //system clock port
    .sys_clk_i              (sys_clk_i),
    //Reference Clock ports
    .clk_ref_i              (clk_ref_i),
    .sys_rst                (rst_n)
);


ddr3_fifo_ctrl u_ddr3_fifo_ctrl(
    .rst_n              (rst_n)      ,
    //input ports
    .wr_clk              (wr_clk      )         ,
    .rd_clk              (rd_clk      )         ,
    .ui_clk              (ui_clk      )         ,
    .wr_en               (wr_en       )         ,
    .wrdata              (wrdata      )         ,
    .rfifo_din           (rfifo_din   )         ,
    .rdata_req           (rdata_req   )         ,
    .rfifo_wren          (rfifo_wren  )         ,
    .wfifo_rden          (wfifo_rden  )         ,
    .wfifo_dout          (wfifo_dout  )         ,
    .wfifo_rcount        (wfifo_rcount)         ,
    .rfifo_wcount        (rfifo_wcount)         ,
    .rddata              (rddata      )           
);
endmodule
