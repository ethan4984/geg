`include "execute.svh"
`include "registers.svh"

module execute(clk, operation);

input logic clk;
input operation_t operation;

logic [3:0] alu_operation;
logic [31:0] alu_operand0;
logic [31:0] alu_operand1;
logic [31:0] alu_result;

write_back_t wb;

alu alu(alu_operation, alu_operand0, alu_operand1, alu_result);
write_back write_back(clk, wb);

always @(posedge clk) begin
	case(operation.operation_type)
		`OPERATION_ALU: begin
			alu_operation <= operation.operation_function;
			alu_operand0 <= operation.operand0;
			alu_operand1 <= operation.operand1;
			wb.operation <= `REGISTER_OPERATION_GPR;
			wb.data <= alu_result;
			wb.rs <= operation.dest;
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
end

endmodule
