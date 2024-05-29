module tb;

logic CLK;
logic RSTN;

initial CLK <= 1'b0;
initial RSTN <= 1'b1;

always #10 CLK = ~CLK;

logic FETCH_VALID;
logic FETCH_HALT;
logic FETCH_STALLED;

logic DECODE_VALID; 
logic DECODE_HALT;
logic DECODE_STALLED;

logic EXECUTE_VALID; 
logic EXECUTE_HALT;
logic EXECUTE_STALLED;

logic [31:0] PC;
logic [31:0] INSTR;
logic [11:0] BRANCH_IMM;
logic BRANCH;

logic [4:0] RRCH1_IDX;
logic [31:0] RRCH1_VAL;
logic RRCH1_RESP;

logic [4:0] RRCH2_IDX;
logic [31:0] RRCH2_VAL;
logic RRCH2_RESP;

logic [4:0] RWCH1_IDX;
logic [31:0] RWCH1_VAL;

program_counter program_counter (
  .CLK(CLK), .RSTN(RSTN),
  .BRANCH(BRANCH), .IMM(BRANCH_IMM),
  .PC(PC)
);

register_file register_file (
  .CLK(CLK), .RSTN(RSTN),
  .RCH1_IDX(RRCH1_IDX), .RCH1_VAL(RRCH1_VAL), .RCH1_RESP(RRCH1_RESP),
  .RCH2_IDX(RRCH2_IDX), .RCH2_VAL(RRCH2_VAL), .RCH2_RESP(RRCH2_RESP),
  .WCH1_IDX(RWCH1_IDX), .WCH1_VAL(RWCH1_VAL)
);

fetch fetch (
  .CLK(CLK), .RSTN(RSTN), .INSTR(INSTR), .PC(PC),
  .HALT(FETCH_HALT), .VALID(FETCH_VALID), .STALLED(FETCH_STALLED),
  .NEXT_STALLED(DECODE_STALLED)
);

decode decode (
  .CLK(CLK), .RSTN(RSTN),
  .BRANCH(BRANCH), .BRANCH_IMM(BRANCH_IMM),
  .INSTR(INSTR), .VALID(DECODE_VALID), .HALT(DECODE_HALT),
  .STALLED(DECODE_STALLED), .NEXT_STALLED(EXECUTE_STALLED)
);

initial begin
  $dumpfile("caput.vcd");
  $dumpvars(0, tb);

  $readmemh("mem.dat", fetch.MEM);

  EXECUTE_HALT <= 0;
  FETCH_HALT <= 0;
  DECODE_HALT <= 0;

  EXECUTE_VALID <= 0;
  EXECUTE_STALLED <= 0;

  # 10

  RSTN <= 0;

  # 250

  $finish;
end

endmodule
