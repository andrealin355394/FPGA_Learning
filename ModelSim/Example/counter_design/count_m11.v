module count_m11 ( RSTN,CLK,CNT_O);
input RSTN;
input CLK;
output [3:0] CNT_O;

reg [3:0] CNT_O;

always@(posedge CLK or negedge RSTN)
begin
	if(~RSTN)
		CNT_O <= 4'h0;
	else if(CNT_O == 4'hB)
		CNT_O <= 4'h0;
	else 
		CNT_O <= CNT_O + 4'h1;
end

endmodule
