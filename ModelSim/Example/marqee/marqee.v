module marqee (
	clk,
	rstn,
	led_o
);
input	clk;	// 50MHz
input	rstn;
output [3:0] led_o;
reg [31:0] cnt;
// onepps generate
reg onepps;
reg	[2:0] cs,ns;
always@(posedge clk or negedge rstn)
begin
	if(~rstn) begin
		cnt <= 'h0;
		onepps <= 1'b0;
	end
	else if(cnt == 'd49999999) begin
		cnt <= 'h0;	
		onepps <= 1'b1;
	end
	else begin
		cnt <= cnt + 1'b1;
		onepps <= 1'b0;
	end
end

always@(posedge clk or negedge rstn)
begin
	if(~rstn) 
		cs <= 'h0;
	else if(onepps)
		cs <= ns;
	else
		cs <= cs;
end
parameter led1_light = 3'b000,
          led2_light = 3'b001,
          led3_light = 3'b010,
          led4_light = 3'b011;
always@(*)
begin
	case(cs)
	led1_light : ns = led2_light;
	led2_light : ns = led3_light;
	led3_light : ns = led4_light;
	led4_light : ns = led1_light;
	default    : ns = led1_light;
	endcase
end
		
assign led_o[0] = (cs == led1_light) ? 1'b1 : 1'b0;
assign led_o[1] = (cs == led2_light) ? 1'b1 : 1'b0;
assign led_o[2] = (cs == led3_light) ? 1'b1 : 1'b0;
assign led_o[3] = (cs == led4_light) ? 1'b1 : 1'b0;

endmodule