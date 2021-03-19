/* Control leds by buttons */

module top (
	output LED1,
	output LED2,
	output LED3,
	output LED4,
	output LED5,

	input BTN1,
	input BTN2,
	input BTN3,
);

	assign LED1 = BTN1;
	assign LED2 = BTN2;
	assign LED3 = BTN3;
	assign LED4 = BTN3;
	assign LED5 = BTN3;

endmodule