/*
* In the event of a branching instruction, the decoder halt will for a single
* cycle and set BRANCH high and set the appropriate immediate. The decoder
* must stop for a single cycle as it will be dealing with the instruction
* directly after the branch. Is this really the best way to about things?
* Perhaps a model in which the fetch stage fills up an instructions cache
* rather than just simply reading them in one at a time. If I read them into
* an instruction cache, thinking about it designing the cache will be
* interesting
*
* my current model the fetch stage has to be 
*/

module program_counter (
  input logic CLK,
  input logic RSTN,

  input logic BRANCH,
  input logic [11:0] IMM,

  output logic [31:0] PC
);

always @(posedge CLK) begin
  if(!RSTN) begin
    if(BRANCH) begin
      PC <= PC + (IMM << 2);
    end else begin
      PC <= PC + 4;
    end
  end
end

always @(posedge CLK) begin
  if(RSTN) begin
    PC <= 0;
  end
end

endmodule

/*
* Example usage:
* a module that requires access to architectural registers
* will be connected to this controller via a read and/or write
* channel, upon reading the module will set RESP high
*/ 

module register_file # (
  parameter XLEN = 32,
  parameter XCNT = 32
) (
  input logic CLK,
  input logic RSTN,

  // read channel 1

  input logic [$clog2(XCNT)-1:0] RCH1_IDX,
  input logic RCH1_RESP,
  output logic [XLEN-1:0] RCH1_VAL,

  // read channel 2

  input logic [$clog2(XCNT)-1:0] RCH2_IDX,
  input logic RCH2_RESP,
  output logic [XLEN-1:0] RCH2_VAL,

  // write channel 1

  input logic [$clog2(XCNT)-1:0] WCH1_IDX,
  output logic [XLEN-1:0] WCH1_VAL
);

reg [$clog2(XCNT)-1:0] regs[XLEN-1:0];

always @(posedge CLK) begin
  if(!RSTN) begin
    if(!RCH1_RESP) RCH1_VAL <= regs[RCH1_IDX];
    if(!RCH2_RESP) RCH2_VAL <= regs[RCH2_IDX];

    if((RCH1_RESP && WCH1_IDX != RCH1_IDX) || 
      (RCH2_RESP && WCH1_IDX != RCH2_IDX)) begin
      WCH1_VAL <= regs[WCH1_IDX];
    end
  end
end

always @(posedge CLK) begin
  if(RSTN) begin
    for(integer i = 0; i < $clog2(XCNT); i++) begin
      regs[i] <= 0;
    end
  end
end

endmodule
