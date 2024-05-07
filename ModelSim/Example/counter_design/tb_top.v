`timescale 1ns/1ns
module tb_top();
reg	rstn;
reg clk;
wire CMP_O;
wire DAT_O;
// clock genertor
always #10 clk = ~clk;
// duv inst
top duv (
	.RSTN	(rstn),
	.CLK	(clk),
	.CMP_O	(CMP_O),
	.DAT_O	(DAT_O)
	);
initial
begin
    clk = 1'b0; // clk init value
	rstn = 1'b0;
	#30 rstn = 1'b1; // 30ns rstn = 1'b1
	repeat(100) begin
	@(posedge clk);  // wait 100 clocl cycle
	end

	$stop; // => for simulator
end
endmodule
