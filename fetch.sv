`include "decode.svh"
`include "registers.svh"

module fetch (
	input logic clk, 
	input logic reset,
	input logic enabled, 
	output logic stalled, 
	output logic valid, 
	input logic next_enabled, 
	input logic next_stalled, 
	output instruction_t instruction
);

always_comb begin
	stalled = (valid && !next_stalled);
end

reg [31:0] memory [0:255];

always @(posedge clk) begin
	if(reset || registers.pc == 8) begin
		valid <= 0;
	end else begin
		if(enabled) begin
			instruction.raw = memory[registers.pc];
			registers.pc += 1;
			valid <= 1;
		end else if(next_enabled) begin 
			valid <= 0;
		end
	end
end

endmodule
