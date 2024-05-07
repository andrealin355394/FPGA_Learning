module led_ctrl_cnt (clk,rstn,led);
input clk;  // 50MHz (20ns)
input rstn;
output [3:0] led;

reg [31:0] cnt_1pps;
reg	[1:0]  cnt_4s;  // 4 sec counter 
wire       onepps;
// 1pps generator (counter)
always@(posedge clk or negedge rstn)
begin
	if(~rstn)
		cnt_1pps <= 'h0; // width = 32bit 
	else if(cnt_1pps == 'd49999999) // 50MHz -1 
		cnt_1pps <= 'h0;
	else
		cnt_1pps <= cnt_1pps + 1'b1;
end
// pusle width 20ns, pulse period : 1 second
assign onepps = (cnt_1pps == 'd49999999) ? 1'b1 : 1'b0;
// 4sec generator (counter) style 1
always@(posedge clk or negedge rstn)
begin
	if(~rstn)
		cnt_4s <= 'h0; // width = 32bit 
	else if(onepps) begin
		if(cnt_4s == 'd3)
			cnt_4s <= 'h0;
		else
			cnt_4s <= cnt_4s + 1'b1;
	end
	else
		cnt_4s <= cnt_4s;	
end
// 4sec generator (counter) style 2
//always@(posedge clk or negedge rstn)
//begin
//	if(~rstn)
//		cnt_4s <= 'h0; // width = 32bit 
//	else if((cnt_4s == 'd3)&& onepps) // 50MHz -1 
//		cnt_4s <= 'h0;
//	else if(onepps)
//		cnt_4s <= cnt_4s + 1'b1;
//	else
//		cnt_4s <= cnt_4s;	
//end
// same as
//always@(posedge clk or negedge rstn)
//begin
//	if(~rstn)
//		cnt_4s <= 'h0; // width = 32bit 
//	else if(onepps)
//		cnt_4s <= cnt_4s + 1'b1;
//	else
//		cnt_4s <= cnt_4s;
//end

assign led[0] = (cnt_4s == 'h0) ? 1'b1 : 1'b0;
assign led[1] = (cnt_4s == 'h1) ? 1'b1 : 1'b0;
assign led[2] = (cnt_4s == 'h2) ? 1'b1 : 1'b0;
assign led[3] = (cnt_4s == 'h3) ? 1'b1 : 1'b0;
endmodule