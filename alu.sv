`include "alu.svh"

module alu(operation, operand0, operand1, dest);

input logic [3:0] operation;
input logic [31:0] operand0;
input logic [31:0] operand1;
output logic [31:0] dest;

always @(operation or operand0 or operand1 or dest) begin
	case(operation)
		`ALU_OPERATION_ADD: begin
			dest = operand0 + operand1;
		end
		`ALU_OPERATION_SUB: begin
			dest = operand0 - operand1;
		end
		`ALU_OPERATION_MUL: begin
			dest = operand0 * operand1;
		end
		`ALU_OPERATION_OR: begin
			dest = operand0 | operand1;
		end
		`ALU_OPERATION_NOT: begin
			dest = ~operand0;
		end
		`ALU_OPERATION_XOR: begin
			dest = operand0 ^ operand1;
		end
		`ALU_OPERATION_AND: begin
			dest = operand0 & operand1;
		end
		`ALU_OPERATION_LEFT_SHIFT: begin
			dest = operand0 << operand1;
		end
		`ALU_OPERATION_RIGHT_SHIFT: begin
			dest = operand0 >> operand1;
		end
	endcase
end

endmodule
