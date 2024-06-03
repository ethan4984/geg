`include "core.svh"

module ex # (
  parameter XCNT = 32,
  parameter XLEN = 32
) (
  input logic CLK,
  input logic RSTN,

  input logic EXECUTE_ENABLED,
  output logic EXECUTE_VALID, 
  output logic EXECUTE_HAZARD,

  input logic [3:0] EX_ALU_OP,
  input logic [XLEN-1:0] EX_ALU_OP1,
  input logic [XLEN-1:0] EX_ALU_OP2,
  output logic [XLEN-1:0] EX_ALU_RESULT,
  input logic [$clog2(XLEN)-1:0] EX_RD_SEL,

  output logic [$clog2(XLEN)-1:0] WB_SEL,

  input logic JAL,
  input logic JALR,
  input logic BRANCH,
  input logic VALID_INSTRUCTION
);

always_comb begin
  if(JAL) begin
  end else if(JALR) begin
  end else if(BRANCH) begin
    case(EX_ALU_OP)
      `ALU_OP_EQ: begin
      end
      `ALU_OP_BNE: begin
      end
      `ALU_OP_BLT: begin
      end
      `ALU_OP_BGE: begin
      end
      `ALU_OP_BLTU: begin
      end
      `ALU_OP_BEGU: begin
      end
      default: begin
      end
    endcase
  end
end

always @(posedge CLK) begin
  if(!RSTN && EXECUTE_ENABLED) begin
    WB_SEL <= EX_RD_SEL;

    case(EX_ALU_OP)
      `ALU_OP_ADD: begin
        EX_ALU_RESULT <= EX_ALU_OP1 + EX_ALU_OP2;
      end
      `ALU_OP_SUB: begin
        EX_ALU_RESULT <= EX_ALU_OP1 - EX_ALU_OP2;
      end
      `ALU_OP_SLL: begin
        EX_ALU_RESULT <= EX_ALU_OP1 << EX_ALU_OP2[4:0];
      end
      `ALU_OP_SLT: begin
      end
      `ALU_OP_SLTU: begin
      end
      `ALU_OP_XOR: begin
        EX_ALU_RESULT <= EX_ALU_OP1 ^ EX_ALU_OP2;
      end
      `ALU_OP_SRL: begin
        EX_ALU_RESULT <= EX_ALU_OP1 >>> EX_ALU_OP2[4:0];
      end
      `ALU_OP_SRA: begin
        EX_ALU_RESULT <= $signed(EX_ALU_OP1) >>> EX_ALU_OP2[4:0];
      end
      `ALU_OP_OR: begin
        EX_ALU_RESULT <= EX_ALU_OP1 | EX_ALU_OP2;
      end
      `ALU_OP_AND: begin
        EX_ALU_RESULT <= EX_ALU_OP1 & EX_ALU_OP2;
      end
    endcase
    EXECUTE_VALID <= 1;
  end else begin
    EXECUTE_VALID <= 0;
    EXECUTE_HAZARD <= 0;
  end
end

endmodule
