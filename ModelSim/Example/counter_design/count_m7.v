module count_m7 ( RSTN,CLK,CNT_O,DAT_O);
input RSTN;
input CLK;
output [3:0] CNT_O;
output DAT_O;

reg [3:0] CNT_O;

always@(posedge CLK or negedge RSTN)
begin
	if(~RSTN)
		CNT_O <= 4'h0;
	else if(CNT_O == 4'h7)
		CNT_O <= 4'h0;
	else 
		CNT_O <= CNT_O + 4'h1;
end

assign DAT_O = (CNT_O >= 4'h2 && CNT_O <= 4'h5) ? 1'b1 : 1'b0;

endmodule
