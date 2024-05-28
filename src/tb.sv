module tb;

logic CLK;
logic RSTN;

initial CLK <= 1'b0;
initial RSTN <= 1'b1;

always #10 CLK = ~CLK;

logic FETCH_VALID;
logic FETCH_STALLED;

logic DECODE_VALID; 
logic DECODE_STALLED;

logic EXECUTE_VALID; 
logic EXECUTE_STALLED;

logic [31:0] INSTR;
logic [31:0] PC;

fetch fetch (
  .CLK(CLK), .RSTN(RSTN),
  .PC(PC), .INSTR(INSTR),
  .VALID(FETCH_VALID), .STALLED(FETCH_STALLED),
  .NEXT_STALLED(DECODE_STALLED)
);

decode decode (
  .CLK(CLK), .RSTN(RSTN),
  .INSTR(INSTR), .VALID(DECODE_VALID),
  .STALLED(DECODE_STALLED), .NEXT_STALLED(EXECUTE_STALLED)
);

initial begin
  $dumpfile("caput.vcd");
  $dumpvars(0, tb);

  $readmemh("mem.dat", fetch.MEM);

  PC <= 0;
  EXECUTE_VALID <= 0;
  EXECUTE_STALLED <= 1;

  # 10

  RSTN <= 0;

  # 100

  $finish;
end

endmodule
