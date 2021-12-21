`include "registers.svh"

module registers;

reg [4:0] gprs[31:0];
reg [31:0] flags;
reg [31:0] pc;

endmodule

module write_back (
	input logic clk, 
	input logic reset,
	input logic enabled, 
	output logic stalled, 
	output logic valid, 
	input logic prev_valid, 
	input write_back_t wb
);

always @(posedge clk) begin
	if(reset) begin
		valid <= 0;
	end else if(enabled) begin
		case(wb.operation)
			`REGISTER_OPERATION_GPR: begin
				if(wb.rs != 0) begin
					$display("writing %d to register %d", wb.data, wb.rs);
					registers.gprs[wb.rs] = wb.data;
				end
			end
			`REGISTER_OPERATION_FLAGS: begin
				registers.flags = wb.data;
			end
			`REGISTER_OPERATION_PC: begin
				registers.pc = wb.data;
			end
			default: begin
				$display("unkown write back option");
			end
		endcase
		valid <= prev_valid;
	end
end

endmodule
