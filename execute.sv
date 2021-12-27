`include "execute.svh"
`include "registers.svh"
`include "alu.svh"

module execute (
	input logic clk, 
	input logic reset,
	input logic enabled, 
	output logic stalled, 
	output logic valid, 
	input logic next_enabled, 
	input logic next_stalled, 
	input logic prev_valid, 
	input operation_t operation, 
	output write_back_t wb
);

logic [3:0] alu_operation;
logic [31:0] alu_operand0;
logic [31:0] alu_operand1;
logic [31:0] alu_result;

task alu;
	input [3:0] operation;
	input [31:0] operand0;
	input [31:0] operand1;
	output [31:0] dest;
	begin
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
			`ALU_OPERATION_LOGICAL_LEFT_SHIFT: begin
				dest = operand0 << operand1;
			end
			`ALU_OPERATION_LOGICAL_RIGHT_SHIFT: begin
				dest = operand0 >> operand1;
			end
			`ALU_OPERATION_ARITHMETIC_LEFT_SHIFT: begin
				dest = operand0 <<< operand1;
			end
			`ALU_OPERATION_ARITHMETIC_RIGHT_SHIFT: begin
				dest = operand0 >>> operand1;
			end
		endcase
	end
endtask

always_comb begin
	stalled = (valid && !next_stalled);
end

always @(posedge clk) begin
	if(reset) begin
		valid <= 0;
	end else begin
		if(enabled) begin
			case(operation.operation_type)
				`OPERATION_ALU: begin
					alu(operation.operation_function, operation.operand0, operation.operand1, wb.data);
					wb.operation = `REGISTER_OPERATION_GPR;
					wb.rs = operation.dest;
				end
				`OPERATION_MEM: begin
					$display("mem operation"); 
				end
				`OPERATION_BRANCH: begin
					$display("branch operation"); 
				end
				default: begin
					$display("unkwown operation");
				end
			endcase
			valid <= prev_valid;
		end else if(next_enabled) begin
			valid <= 0;
		end
	end

	if(!pipeline.execute_hazard && pipeline.wb_hazard) begin
		pipeline.execute_hazard <= 1;
		pipeline.wb_hazard <= 0;
	end
end

endmodule
