`include "decode.svh"
`include "alu.svh"

module main;

logic clk;
always #10 clk = ~clk;

instruction_t instruction;

initial begin
	clk <= 1'b1;

	for(int i = 0; i < 256; i++) begin
		registers.gprs[i] = 0;
	end

	$finish;
end

fetch fetcher(clk, instruction);
decode decoder(clk, instruction);

endmodule
