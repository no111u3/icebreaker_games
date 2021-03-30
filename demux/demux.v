/* Demux */

module demux(
	input wire signal,
	input wire [2:0] addr,
	output reg [6:0] out,
);

	/*
	 	Other variant
	 	always @*
	 		out = signal << addr;
	 */
	always @* begin
		case (addr)
			3'd0: out = {6'b0, signal};
			3'd1: out = {5'b0, signal, 1'b0};
			3'd2: out = {4'b0, signal, 2'b0};
			3'd3: out = {3'b0, signal, 3'b0};
			3'd4: out = {2'b0, signal, 4'b0};
			3'd5: out = {1'b0, signal, 5'b0};
			3'd6: out = {signal, 6'b0};
			default: out = 7'b0;
		endcase
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
	input CLK,
);
	wire [6:0] out;
	wire [2:0] addr = {BTN3, BTN2, BTN1};

	wire led_r;
	wire led_g;
	assign {LEDR_N, LEDG_N} = {~led_r, ~led_g};

	assign {LED5, LED4, LED3, LED2, LED1, led_r, led_g} = out;

	reg [20:0] counter;

	always @(posedge CLK)
		counter <= counter + 1;

	wire signal = counter[20];

	demux led_select(.signal(signal), .addr(addr), .out(out));

endmodule