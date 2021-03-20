/* Control leds by buttons with wires and modules */

module cross (
	input wire [1:0] port_a,
	output wire [1:0] port_b,
);
	assign port_b[0] = port_a[1];
	assign port_b[1] = port_a[0];

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

	assign LED1 = BTN1;
	assign LED2 = BTN2;
	assign LED3 = BTN3;
	assign LED4 = BTN3;
	assign LED5 = BTN3;

	cross my_cross(.port_a({BTN_N, ~BTN_N}), .port_b({LEDR_N, LEDG_N}));

endmodule