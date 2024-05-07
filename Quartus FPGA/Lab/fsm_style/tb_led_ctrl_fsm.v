`timescale 1ns/1ns
module tb_led_ctrl ();

reg clk ;  // 50MHz (20ns)
reg rstn ;
wire [3:0] led;

// DUT instant
led_ctrl_fsm dut (
	.clk	(clk),
	.rstn	(rstn),
	.led	(led)
);
// clock generator
always #10 clk = ~clk;
// testbench
initial
begin
// reg initial value setting
	clk = 1'b0;
	rstn = 1'b0;
	#25 rstn = 1'b1;
	@(posedge led[1])
	$stop;
end

endmodule