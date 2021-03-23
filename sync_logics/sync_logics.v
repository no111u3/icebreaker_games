/* Synchronized logics */

module DFFAR (
	input reset,
	input clock,
	input [1:0] data,
	output reg [1:0] q,
);

	always @(posedge clock or posedge reset) begin
		if (reset) begin
			q <= 0;
		end else begin
			q <= data;
		end
	end

endmodule

module Counter (
	input reset,
	input clock,
	input wire [1:0] in,
	output reg [1:0] cnt,
);

	always @(posedge clock or posedge reset) begin
		if (reset)
			cnt <= 2'b00;
		else
			begin
				if (|in)
					cnt <= in;
				else
					cnt <= cnt + 1'b1;
			end
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
);

	wire [1:0] out_pair1;
	wire [1:0] out_pair2;
	wire [1:0] out_pair3;

	assign {LEDR_N, LEDG_N} = ~out_pair1;
	assign {LED4, LED3} = out_pair2;
	assign {LED2, LED5} = out_pair3;

	wire [1:0] data = {BTN2, BTN1};
	wire reset = ~BTN_N;
	wire clock = BTN3;

	DFFAR dffar(.reset(reset), .clock(clock), .data(data), .q(out_pair1));
	Counter counter(.reset(reset), .clock(clock), .in(data), .cnt(out_pair2));

	always @(posedge clock) begin
		out_pair3 = out_pair2 + 2;
	end

endmodule