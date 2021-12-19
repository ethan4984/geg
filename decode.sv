`include "decode.svh"
`include "execute.svh"

module decode(clk, instruction);

input logic clk;
input instruction_t instruction;

operation_t operation;
execute execute(clk, operation);

task rtype_function0(input instr_t instr);
	begin
		case(instr.func7)
			7'b0000000: begin // add
				operation.operation_type <= `OPERATION_ALU;
				operation.operation_function <= `ALU_OPERATION_ADD;
				operation.operand0 <= registers.gprs[instr.rs1];
				operation.operand1 <= registers.gprs[instr.rs2];
				operation.rs1 <= instr.rs1;
				operation.rs2 <= instr.rs2;
				operation.dest <= instr.rd;
			end
			7'b0100000: begin // sub
				operation.operation_type <= `OPERATION_ALU;
				operation.operation_function <= `ALU_OPERATION_SUB;
				operation.operand0 <= registers.gprs[instr.rs1];
				operation.operand1 <= registers.gprs[instr.rs2];
				operation.rs1 <= instr.rs1;
				operation.rs2 <= instr.rs2;
				operation.dest <= instr.rd;
			end
			default: $display("unknown func7");
		endcase
	end
endtask

task rtype_function1(input instr_t instr);
	begin
		case(instr.func7)
			7'b0000000: begin // sll
				operation.operation_type <= `OPERATION_ALU;
				operation.operation_function <= `ALU_OPERATION_LOGICAL_LEFT_SHIFT;
				operation.operand0 <= registers.gprs[instr.rs1];
				operation.operand1 <= registers.gprs[instr.rs2];
				operation.rs1 <= instr.rs1;
				operation.rs2 <= instr.rs2;
				operation.dest <= instr.rd;
			end
			default: $display("unknown func7");
		endcase
	end
endtask

task rtype_function2(input instr_t instr);
	begin
		case(instr.func7)
			7'b0000000: begin // slt
			end
			default: $display("unknown func7");
		endcase
	end
endtask

task rtype_function3(input instr_t instr);
	begin
		case(instr.func7)
			7'b0000000: begin // sltu
			end
			default: $display("unknown func7");
		endcase
	end
endtask

task rtype_function4(input instr_t instr);
	begin
		case(instr.func7)
			7'b0000000: begin // xor
				operation.operation_type <= `OPERATION_ALU;
				operation.operation_function <= `ALU_OPERATION_XOR;
				operation.operand0 <= registers.gprs[instr.rs1];
				operation.operand1 <= registers.gprs[instr.rs2];
				operation.rs1 <= instr.rs1;
				operation.rs2 <= instr.rs2;
				operation.dest <= instr.rd;
			end
			default: $display("unknown func7");
		endcase
	end
endtask

task rtype_function5(input instr_t instr);
	begin
		case(instr.func7)
			7'b0000000: begin // srl
				operation.operation_type <= `OPERATION_ALU;
				operation.operation_function <= `ALU_OPERATION_LOGICAL_RIGHT_SHIFT;
				operation.operand0 <= registers.gprs[instr.rs1];
				operation.operand1 <= registers.gprs[instr.rs2];
				operation.rs1 <= instr.rs1;
				operation.rs2 <= instr.rs2;
				operation.dest <= instr.rd;
			end
			7'b0100000: begin //  sra
				operation.operation_type <= `OPERATION_ALU;
				operation.operation_function <= `ALU_OPERATION_ARITHMETIC_RIGHT_SHIFT;
				operation.operand0 <= registers.gprs[instr.rs1];
				operation.operand1 <= registers.gprs[instr.rs2];
				operation.rs1 <= instr.rs1;
				operation.rs2 <= instr.rs2;
				operation.dest <= instr.rd;
			end
			default: $display("unknown func7");
		endcase
	end
endtask

task rtype_function6(input instr_t instr);
	begin
		case(instr.func7)
			7'b0000000: begin // or
				operation.operation_type <= `OPERATION_ALU;
				operation.operation_function <= `ALU_OPERATION_OR;
				operation.operand0 <= registers.gprs[instr.rs1];
				operation.operand1 <= registers.gprs[instr.rs2];
				operation.rs1 <= instr.rs1;
				operation.rs2 <= instr.rs2;
				operation.dest <= instr.rd;
			end
			default: $display("unknown func7");
		endcase
	end
endtask

task rtype_function7(input instr_t instr);
	begin
		case(instr.func7) 
			7'b0000000: begin // and
				operation.operation_type <= `OPERATION_ALU;
				operation.operation_function <= `ALU_OPERATION_AND;
				operation.operand0 <= registers.gprs[instr.rs1];
				operation.operand1 <= registers.gprs[instr.rs2];
				operation.rs1 <= instr.rs1;
				operation.rs2 <= instr.rs2;
				operation.dest <= instr.rd;
			end
			default: $display("unknown func7");
		endcase
	end
endtask

task rtype_instruction(input instr_t instr);
	begin
		case(instr.func3)
			3'b000: rtype_function0(instr);
			3'b001: rtype_function1(instr); 
			3'b010: rtype_function2(instr);
			3'b011: rtype_function3(instr);
			3'b100: rtype_function4(instr);
			3'b101: rtype_function5(instr);
			3'b110: rtype_function6(instr);
			3'b111: rtype_function7(instr);
		endcase
	end
endtask

task itype_instruction(input insti_t insti);
	begin
		$display("type i");
	end
endtask

task btype_instruction(input instb_t instr);
	begin
		$display("type b");
	end
endtask

task stype_instruction(input insts_t insts);
	begin
		$display("type s");
	end
endtask

always @(posedge clk) begin
	case(instruction.instr.opcode)
		`OPCODE_R_TYPE: rtype_instruction(instruction.instr);
		`OPCODE_MI_TYPE: itype_instruction(instruction.insti);
		`OPCODE_I_TYPE: itype_instruction(instruction.insti);
		`OPCODE_B_TYPE: btype_instruction(instruction.instu);
		`OPCODE_S_TYPE: stype_instruction(instruction.insts);
		default: $display("unkown opcode");
	endcase
end

endmodule
