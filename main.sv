`include "decode.svh"
`include "alu.svh"

module main;

logic clk, reset;
always #10 clk = ~clk;

logic fetch_enabled, fetch_valid, fetch_stalled;
logic decode_enabled, decode_valid, decode_stalled;
logic execute_enabled, execute_valid, execute_stalled;
logic wb_enabled, wb_valid, wb_stalled;

assign fetch_enabled = !fetch_stalled;
assign decode_enabled = (fetch_valid && !decode_stalled);
assign execute_enabled = (decode_valid && !execute_stalled);
assign wb_enabled = (execute_valid);

instruction_t instruction;
operation_t operation;
write_back_t wb;

fetch fetch (
	.reset(reset), 
	.clk(clk), 
	.enabled(fetch_enabled),
	.stalled(fetch_stalled),
	.valid(fetch_valid),
	.next_enabled(decode_enabled),
	.next_stalled(decode_stalled),
	.instruction(instruction)
);

decode decode (
	.reset(reset),
	.clk(clk),
	.enabled(decode_enabled),
	.stalled(decode_stalled),
	.valid(decode_valid),
	.next_enabled(execute_enabled),
	.next_stalled(execute_stalled),
	.prev_valid(fetch_valid),
	.instruction(instruction),
	.operation(operation)
);

execute execute (
	.reset(reset),
	.clk(clk),
	.enabled(execute_enabled),
	.stalled(execute_stalled),
	.valid(execute_valid),
	.next_enabled(wb_enabled),
	.next_stalled(wb_stalled), 
	.prev_valid(decode_valid),
	.operation(operation),
	.wb(wb)
);

write_back write_back (
	.reset(reset),
	.clk(clk), 
	.enabled(wb_enabled),
	.stalled(wb_stalled),
	.valid(wb_valid),
	.prev_valid(execute_valid),
	.wb(wb)
);

initial begin
	clk <= 1;

	registers.gprs[0] = 0;
	for(int i = 1; i < 256; i++) begin
		registers.gprs[i] = i;
	end

	registers.pc = 0;
	registers.flags = 0;

	reset = 1;
	#10;
	reset = 0;

	$readmemh("mem.dat", fetch.memory);

	#1000;

	$finish;
end

endmodule
