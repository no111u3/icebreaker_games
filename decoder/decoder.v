/* Binary decoder */

module decoder(
	input wire [2:0] addr,
	output reg [6:0] selector,
);

	always @*
		selector = 7'b0000001 << addr;

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
	input CLK,
);
	wire [6:0] out;
	wire [2:0] addr = {BTN3, BTN2, BTN1};

	wire led_r;
	wire led_g;
	assign {LEDR_N, LEDG_N} = {~led_r, ~led_g};

	assign {LED5, LED4, LED3, LED2, LED1, led_r, led_g} = out;

	decoder led_select(.addr(addr), .selector(out));

endmodule