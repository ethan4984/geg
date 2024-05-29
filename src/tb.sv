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

logic [4:0] RRCH1_IDX;
logic [31:0] RRCH1_VAL;
logic RRCH1_RESP;

logic [4:0] RRCH2_IDX;
logic [31:0] RRCH2_VAL;
logic RRCH2_RESP;

logic [4:0] RWCH1_IDX;
logic [31:0] RWCH1_VAL;

register_file register_file (
  .CLK(CLK), .RSTN(RSTN),
  .RCH1_IDX(RRCH1_IDX), .RCH1_VAL(RRCH1_VAL), .RCH1_RESP(RRCH1_RESP),
  .RCH2_IDX(RRCH2_IDX), .RCH2_VAL(RRCH2_VAL), .RCH2_RESP(RRCH2_RESP),
  .WCH1_IDX(RWCH1_IDX), .WCH1_VAL(RWCH1_VAL)
);

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
