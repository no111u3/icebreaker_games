/* Get signal edges as event */

module BiDirCnt (
	input cnt_plus,
	input cnt_minus,
	input clk,
	output reg [4:0] cnt,
);
	wire signal = cnt_plus ^ cnt_minus;

	reg prev_signal;
	always @(posedge clk)
		prev_signal <= signal;

	wire front_edge = ~prev_signal & signal;

	wire dir = cnt_plus && ~cnt_minus;

	always @(posedge signal) begin
		if (dir)
			cnt <= cnt + 1;
		else 
			cnt <= cnt - 1;
	end

endmodule

module Cnt (
	input clock,
	output reg [4:0] cnt
);
	always @(posedge clock) begin
		cnt <= cnt + 1;
	end

endmodule

module top (
	output LED1,
	output LED2,
	output LED3,
	output LED4,
	output LED5,

	output LEDR_N,
	output LEDG_N,

	input BTN1,
	input BTN2,
	input BTN3,
	input BTN_N,
	input CLK,
);

	wire [4:0] counter;
	assign {LED5, LED4, LED3, LED2, LED1} = counter;

	wire cnt_plus = BTN1;
	wire cnt_minus = BTN2;
	wire start_stop = BTN3;

	wire [4:0] selector;

	BiDirCnt mux_pos(.cnt_plus(cnt_plus), .cnt_minus(cnt_minus), .clk(CLK), .cnt(selector));

	reg [31:0] clock_sourse = 0;
	reg enable = 1'b1;

	wire signal = start_stop;

	reg prev_signal;
	always @(posedge CLK)
		prev_signal <= signal;

	wire back_edge = prev_signal & ~signal;

	always @(posedge CLK)
		enable <= enable ^ back_edge;

	always @(posedge CLK)
		if (enable)
			clock_sourse <= clock_sourse + 1;

	assign clock = clock_sourse[selector];

	Cnt cnt(.clock(clock), .cnt(counter));

endmodule