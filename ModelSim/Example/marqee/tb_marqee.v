`timescale 1ns/1ns
module tb_marquee();

reg	clk ;	// 50MHz
reg	rstn ;
wire [3:0] led_o;

marquee marquee (
	.clk	(clk	),
	.rstn	(rstn	),
	.led_o	(led_o	)
);
// clock generate
always #10 clk = ~clk;

initial
begin
	clk = 1'b0;
	rstn = 1'b0;
	#100 rstn = 1'b0;
	@(posedge led_o[0]); // led_o[0] assert , stop simulator
	$stop;

end

endmodule