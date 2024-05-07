module top(RSTN,CLK,CMP_O,DAT_O);
input RSTN;
input CLK;
output CMP_O;
output DAT_O;
wire [3:0] CNT_M11_O;
wire [3:0] CNT_M7_O;
wire  DAT_O;
count_m11 U1 (
         .RSTN	(RSTN),
		 .CLK	(CLK),
		 .CNT_O	(CNT_M11_O)
              );

count_m7 U2 (
		.RSTN	(RSTN),
		.CLK	(CLK),
		.CNT_O	(CNT_M7_O),
		.DAT_O	(DAT_O)
			);
assign CMP_O = (CNT_M11_O > CNT_M7_O) ? 1'b1 : 1'b0;
endmodule
