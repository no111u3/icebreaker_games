/* Multiplexer for counter */

module BiDirCnt (
	input cnt_plus,
	input cnt_minus,
	output reg [4:0] cnt,
);
	wire clock = cnt_plus ^ cnt_minus;
	wire dir = cnt_plus && ~cnt_minus;

	always @(posedge clock) begin
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

	wire [4:0] selector;

	BiDirCnt mux_pos(.cnt_plus(cnt_plus), .cnt_minus(cnt_minus), .cnt(selector));

	reg [31:0] clock_sourse = 0;

	always @(posedge CLK) begin
		clock_sourse <= clock_sourse + 1;
	end

	assign clock = clock_sourse[selector];

	Cnt cnt(.clock(clock), .cnt(counter));

endmodule