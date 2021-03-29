/* Segmen decoder */

module segment_decoder(
	input wire selector,
	output reg [4:0] segments,
);

	always @* begin
		case (selector)
			1'd0: segments = 5'b11110;
			1'd1: segments = 5'b00111;
		endcase
	end

endmodule

module top (
	output LED1,
	output LED2,
	output LED3,
	output LED4,
	output LED5,

	input BTN1,
	input CLK,
);
	wire [4:0] out;
	wire selector = BTN1;

	assign {LED5, LED4, LED3, LED2, LED1} = out;

	segment_decoder led_select(.selector(selector), .segments(out));

endmodule