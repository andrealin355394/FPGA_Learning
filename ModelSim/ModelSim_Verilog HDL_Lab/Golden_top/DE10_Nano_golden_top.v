module DE10_Nano_golden_top(
      ///////// FPGA /////////
      input              FPGA_CLK1_50,	//振盪器
      input              FPGA_CLK2_50,  //振盪器
      input              FPGA_CLK3_50,  //振盪器
      ///////// KEY /////////
      input       [1:0]  KEY,	// 按鈕

      ///////// LED /////////	
      output      [7:0]  LED,	// 8顆LED

      ///////// SW /////////    
      input       [3:0]  SW     // 4個指撥開關
);







endmodule
