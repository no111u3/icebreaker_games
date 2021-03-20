/* 1 bit full adder */

module adder_1bit (
	output sum,
	output c_out,
	input a,
	input b,
	input c_in,
);

	assign sum = (a ^ b) ^ c_in;
	assign c_out = ((a ^ b) & c_in) ^ (a&b);

endmodule

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

	adder_1bit adder(.sum(LED4), .c_out(LED5), .a(BTN1), .b(BTN2), .c_in(BTN3));

endmodule