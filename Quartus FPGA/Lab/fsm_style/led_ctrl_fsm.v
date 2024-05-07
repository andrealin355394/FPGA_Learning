module led_ctrl_fsm (clk,rstn,led);
input clk;  // 50MHz (20ns)
input rstn;
output [3:0] led;

// state definition
parameter S1 = 2'h0,
          S2 = 2'h1,
		  S3 = 2'h2,
		  S4 = 2'h3;
		  
// onepps generator
reg [31:0] cnt_1pps;
reg [1:0]  cs; // current state;
reg [1:0]  ns; // next state;

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

// FSM coding style
// part1 : sequential 

always@(posedge clk or negedge rstn)
begin
	if(~rstn)
		cs <= 'h0;
	else if(onepps) // 狀態改變時機
		cs <= ns;   // update state;
	else
		cs <= cs;
end
// part 2: combintation circuit
always@(*)
begin
	case(cs)
	S1: ns= S2;
	S2: ns= S3;
	S3: ns= S4;
	S4: ns= S1;
	default: ns = S1;
	endcase
end

assign led[0] = (cs == S1) ? 1'b1 : 1'b0;
assign led[1] = (cs == S2) ? 1'b1 : 1'b0;
assign led[2] = (cs == S3) ? 1'b1 : 1'b0;
assign led[3] = (cs == S4) ? 1'b1 : 1'b0;
endmodule
