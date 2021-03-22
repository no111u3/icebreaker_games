/* Arithmetic and logical operations */

module simple_add_sub (
	input wire operand_a,
	input wire operand_b,
	output wire [1:0] out_sum,
	output wire [1:0] out_diff,
);
	assign out_sum = operand_a + operand_b;
	assign out_diff = operand_a - operand_b;

endmodule

module simple_shift (
	input wire operand_a,
	input wire operand_b,
	output wire [1:0] out_shl,
	output wire [1:0] out_shr,
	output wire [1:0] out_sar,
);
	assign out_shl = operand_a << operand_b;
	assign out_shr = operand_a >> operand_b;
	assign out_sar = operand_a >>> operand_b;

endmodule

module simple_bit_logic (
	input wire operand_a,
	input wire operand_b,
	output wire out_bit_and,
	output wire out_bit_or,
	output wire out_bit_xor,
	output wire out_bit_not,
);
	assign out_bit_and = operand_a & operand_b;
	assign out_bit_or = operand_a | operand_b;
	assign out_bit_xor = operand_a ^ operand_b;
	assign out_bit_not = ~operand_a;

endmodule

module simple_bool_logic (
	input wire operand_a,
	input wire operand_b,
	output wire out_bool_and,
	output wire out_bool_or,
	output wire out_bool_not,
);
	assign out_bool_and = operand_a && operand_b;
	assign out_bool_or = operand_a || operand_b;
	assign out_bool_not = !operand_a;

endmodule

module simple_mux(
	input wire [1:0] operand_a,
	input wire [1:0] operand_b,
	output wire [1:0] out_mux,
	input wire sel_in,
);

	assign out_mux = sel_in ? operand_a : operand_b;
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

	assign {LEDR_N, LEDG_N} = out_pair1;
	assign {LED4, LED3} = out_pair2;
	assign {LED2, LED5} = out_pair3;

	wire operand_a = BTN1;
	wire operand_b = BTN2;
	wire [1:0] out_sum;
	wire [1:0] out_diff;

	simple_add_sub add_sub(.operand_a(operand_a), .operand_b(operand_b), .out_sum(out_sum), .out_diff(out_diff));

	wire [1:0] out_shl;
	wire [1:0] out_shr;
	wire [1:0] out_sar;

	simple_mux mux_sum_diff(.operand_a(out_sum), .operand_b(out_diff), .out_mux(out_pair1), .sel_in(BTN3));

	simple_shift shift(.operand_a(operand_a),
		.operand_b(operand_b),
		.out_shl(out_shl), 
		.out_shr(out_shr), 
		.out_sar(out_sar));

	wire [1:0] out_bit_and_or;
	wire [1:0] out_bit_xor_not;

	wire [1:0] shift_out;

	simple_mux mux_shl_shr(.operand_a(out_shl), .operand_b(out_shr), .out_mux(shift_out), .sel_in(BTN_N));

	simple_bit_logic bit_logic(.operand_a(operand_a),
		.operand_b(operand_b),
		.out_bit_and(out_bit_and_or[1]),
		.out_bit_or(out_bit_and_or[0]),
		.out_bit_xor(out_bit_xor_not[1]),
		.out_bit_not(out_bit_xor_not[0]));

	wire [1:0] bit_logic_out;

	simple_mux mux_bit_logic(.operand_a(out_bit_and_or),
		.operand_b(out_bit_xor_not), .out_mux(bit_logic_out), .sel_in(BTN_N));

	simple_mux mux_sar_bit_logic(.operand_a(out_sar),
		.operand_b(bit_logic_out), .out_mux(out_pair3), .sel_in(BTN3));

	wire [1:0] out_bool_and_or;
	wire [1:0] out_bool_not;

	assign out_bool_not[1] = 1'b0;

	simple_bool_logic bool_logic(.operand_a(operand_a),
		.operand_b(operand_b),
		.out_bool_and(out_bool_and_or[1]),
		.out_bool_or(out_bool_and_or[0]),
		.out_bool_not(out_bool_not[0]));

	wire [1:0] bool_logic_out;

	simple_mux mux_bool_logic(.operand_a(out_bool_and_or),
		.operand_b(out_bool_not), .out_mux(bool_logic_out), .sel_in(BTN_N));

	simple_mux mux_shit_bool_logic(.operand_a(bool_logic_out),
		.operand_b(shift_out), .out_mux(out_pair2), .sel_in(BTN3));

endmodule