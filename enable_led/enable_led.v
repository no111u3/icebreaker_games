/* Enable one red led on board */

module top (
	output LED1,
	output LED2,
	output LED3,
	output LED4,
	output LED5,
);

	assign LED1 = 1'b1;
	assign {LED2, LED3, LED4, LED5} = 4'b0000;

endmodule