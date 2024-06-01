//  Branching and fetching how do we update the instruction pointer
//  accordingly. 

module core # (
  parameter XLEN = 32,
  parameter XCNT = 32
) (
  input logic CLK,
  input logic RSTN,

  input logic CORE_STALL,

  output logic [31:0] RCH1_ADDR,
  input logic [31:0] RCH1_DATA
);

logic [XLEN-1:0] INSTR;
logic [XLEN-1:0] PC;
logic [XLEN-1:0] NEXT_PC;

assign INSTR = RCH1_DATA;
assign RCH1_ADDR = PC;

logic FETCH_STALL, FETCH_VALID, FETCH_HAZARD, FETCH_ENABLED;
logic DECODE_STALL, DECODE_VALID, DECODE_HAZARD, DECODE_ENABLED;
logic EXECUTE_STALL, EXECUTE_VALID, EXECUTE_HAZARD, EXECUTE_ENABLED;
logic WB_STALL, WB_VALID, WB_HAZARD, WB_ENABLED;

assign FETCH_STALL = DECODE_STALL || FETCH_HAZARD;
assign DECODE_STALL = EXECUTE_STALL || DECODE_HAZARD;
assign EXECUTE_STALL = WB_STALL || EXECUTE_HAZARD;
assign WB_STALL = WB_HAZARD;

assign FETCH_ENABLED = !FETCH_STALL && !CORE_STALL;
assign DECODE_ENABLED = !DECODE_STALL && FETCH_VALID;
assign EXECUTE_ENABLED = !EXECUTE_STALL && DECODE_VALID;
assign WB_ENABLED = !WB_STALL && EXECUTE_VALID;

always @(posedge CLK) begin
  if(!RSTN) begin
    if(FETCH_ENABLED) begin
      PC <= PC + 4;
    end else begin
      PC <= NEXT_PC;
    end

    FETCH_VALID <= 1;
  end else begin
    PC <= 0;
    FETCH_HAZARD <= 0;
    FETCH_VALID <= 0;
  end
end

logic [3:0] EX_ALU_OP;
logic [XLEN-1:0] EX_ALU_OP1;
logic [XLEN-1:0] EX_ALU_OP2;
logic [XLEN-1:0] EX_ALU_RESULT;

logic JAL, JALR, BRANCH, VALID_INSTRUCTION;

logic [$clog2(XCNT)-1:0] READ_SEL1, READ_SEL2, WB_WRITE_SEL;
logic [XLEN-1:0] READ_DATA1, READ_DATA2, WB_WRITE_DATA;

decode decode (
  .CLK(CLK), .RSTN(RSTN), .INSTR(INSTR),
  .DECODE_ENABLED(DECODE_ENABLED), .DECODE_HAZARD(DECODE_HAZARD),
  .VALID_INSTRUCTION(VALID_INSTRUCTION), .EX_ALU_OP(EX_ALU_OP), 
  .EX_ALU_OP1(EX_ALU_OP1), .EX_ALU_OP2(EX_ALU_OP2), .JAL(JAL), 
  .JALR(JALR), .BRANCH(BRANCH), .READ_SEL1(READ_SEL1), .READ_SEL2(READ_SEL2),
  .WB_SEL(WB_WRITE_SEL), .DECODE_VALID(DECODE_VALID), .NEXT_PC(NEXT_PC),
  .PC(PC)
);

ex ex (
  .CLK(CLK), .RSTN(RSTN),
  .EXECUTE_ENABLED(EXECUTE_ENABLED), .EXECUTE_HAZARD(EXECUTE_HAZARD),
  .EX_ALU_OP(EX_ALU_OP), .EX_ALU_OP1(EX_ALU_OP1), .EX_ALU_OP2(EX_ALU_OP2),
  .JAL(JAL), .JALR(JALR), .BRANCH(BRANCH), .EXECUTE_VALID(EXECUTE_VALID),
  .VALID_INSTRUCTION(VALID_INSTRUCTION)
);

wb wb (
 .CLK(CLK), .RSTN(RSTN),
 .READ_SEL1(READ_SEL1), .READ_SEL2(READ_SEL2), .WB_WRITE_SEL(WB_WRITE_SEL), 
 .READ_DATA1(READ_DATA1), .READ_DATA2(READ_DATA2), .WB_WRITE_DATA(WB_WRITE_DATA),
 .WB_ENABLED(WB_ENABLED), .WB_HAZARD(WB_HAZARD), .WB_VALID(WB_VALID)
);

endmodule
