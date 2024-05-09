`timescale 1ns / 1ps

module debounce_switch  #(
            parameter   WIDTH = 1, // width of input and output signal
            parameter   N = 3,     //length of shift regsiter 
            parameter   RATE = 125000   //clock division factor             
)(
            input clk,
            input rst,
            input [WIDTH-1:0] in,
            output  [WIDTH-1:0] out
);

reg [23:0] cnt_reg = 24'd0;
reg [N-1:0] debounce_reg[WIDTH-1:0]; 
reg [WIDTH-1:0] state;

/*
 * The synchronized output is the state register
 */
assign out = state;

integer k;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt_reg <= 0;
        state <= 0;
        // clear the register
        for (k = 0; k < WIDTH; k = k + 1) begin
            debounce_reg[k] <= 0;
        end
    end else begin
        if (cnt_reg < RATE) begin
            cnt_reg <= cnt_reg + 24'd1;
        end else begin
            cnt_reg <= 24'd0;
        end
        
        if (cnt_reg == 24'd0) begin
            for (k = 0; k < WIDTH; k = k + 1) begin //move the input to reg
                debounce_reg[k] <= {debounce_reg[k][N-2:0], in[k]};
            end
        end
        
        for (k = 0; k < WIDTH; k = k + 1) begin
            if (|debounce_reg[k] == 0) begin
                state[k] <= 0;
            end else if (&debounce_reg[k] == 1) begin
                state[k] <= 1;
            end else begin
                state[k] <= state[k];
            end
        end
    end
end

endmodule
