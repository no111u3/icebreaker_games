/* Arithmetic and logical operations with always blocks */

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

	wire operand_a = BTN1;
	wire operand_b = BTN2;

	wire [1:0] option = {~BTN_N, BTN3};

	wire [1:0] out_sum;
	wire [1:0] out_diff;

	simple_add_sub add_sub(.operand_a(operand_a),
		.operand_b(operand_b), .out_sum(out_sum), .out_diff(out_diff));

	wire [1:0] out_shl;
	wire [1:0] out_shr;
	wire [1:0] out_sar;

	simple_shift shift(.operand_a(operand_a),
		.operand_b(operand_b),
		.out_shl(out_shl), 
		.out_shr(out_shr), 
		.out_sar(out_sar));

	wire [1:0] out_bit_and_or;
	wire [1:0] out_bit_xor_not;

	simple_bit_logic bit_logic(.operand_a(operand_a),
		.operand_b(operand_b),
		.out_bit_and(out_bit_and_or[1]),
		.out_bit_or(out_bit_and_or[0]),
		.out_bit_xor(out_bit_xor_not[1]),
		.out_bit_not(out_bit_xor_not[0]));

	wire [1:0] out_bool_and_or;
	wire [1:0] out_bool_not;

	assign out_bool_not[1] = 1'b0;

	simple_bool_logic bool_logic(.operand_a(operand_a),
		.operand_b(operand_b),
		.out_bool_and(out_bool_and_or[1]),
		.out_bool_or(out_bool_and_or[0]),
		.out_bool_not(out_bool_not[0]));

	always @* begin
		case (option)
			0: begin
				out_pair1 = out_sum;
				out_pair2 = out_diff;
				out_pair3 = out_shl;
				LED1 = 1'b0;
			end
			1: begin
				out_pair1 = out_shr;
				out_pair2 = out_sar;
				out_pair3 = out_bit_and_or;
				LED1 = 1'b0;
			end
			2: begin
				out_pair1 = out_bit_xor_not;
				out_pair2 = out_bool_and_or;
				out_pair3 = out_bool_not;
				LED1 = 1'b0;
			end
			3: begin
				out_pair1 = 2'b00;
				out_pair2 = 2'b00;
				out_pair3 = 2'b00;
				LED1 = 1'b1;
			end
		endcase
	end

endmodule