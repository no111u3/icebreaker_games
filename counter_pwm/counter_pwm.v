/* Generate pwm signal */

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
	input clk,
	input wire [4:0] cmp,
	output reg [4:0] cnt,
	output wire overflow,
	output wire equal,
);
	wire high_bit = cnt[4];
	reg prev_high_bit = 1'b0;
	always @(posedge clk) begin
		prev_high_bit <= high_bit;
	end

	always @(posedge clk) begin
		cnt <= cnt + 1'b1;
	end

	assign overflow = prev_high_bit & ~high_bit;
	assign equal = cmp == cnt;

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

	wire cnt_plus = BTN1;
	wire cnt_minus = BTN2;
	wire start_stop = BTN3;

	wire [4:0] cmp;
	wire [4:0] cnt;

	assign {LED5, LED4, LED3, LED2, LED1} = cmp[4:0];

	wire overflow;
	wire equal;

	BiDirCnt pwm_cmp(.cnt_plus(cnt_plus), .cnt_minus(cnt_minus), .clk(CLK), .cnt(cmp));

	reg [10:0] clock_sourse = 0;
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
		else
			clock_sourse <= 1'b0;

	assign clock = clock_sourse[10];

	Cnt pwm_cnt(.clk(clock),
		.cmp(cmp), .cnt(cnt), .overflow(overflow), .equal(equal));

	reg led_one = 1'b0;
	reg led_two = 1'b0;

	always @(posedge clock) begin
		if (overflow) begin
			led_one <= 1'b1;
			led_two <= 1'b0;
		end
		if (equal) begin
			led_one <= 1'b0;
			led_two <= 1'b1;
		end
	end

	assign {LEDG_N, LEDR_N} = {~led_one, ~led_two};

endmodule