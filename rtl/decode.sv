`include "core.svh"

module decode # (
  parameter XCNT = 32,
  parameter XLEN = 32
) (
  input logic CLK,
  input logic RSTN,

  input instr_t INSTR,

  input logic DECODE_ENABLED,
  output logic DECODE_HAZARD,
  output logic DECODE_VALID,
  output logic VALID_INSTRUCTION,

  output logic [3:0] EX_ALU_OP,
  output logic [XLEN-1:0] EX_ALU_OP1,
  output logic [XLEN-1:0] EX_ALU_OP2,

  output logic JAL,
  output logic JALR,
  output logic BRANCH,

  output logic [XLEN-1:0] NEXT_PC,
  input logic [XLEN-1:0] PC,

  output logic [$clog2(XCNT)-1:0] READ_SEL1,
  output logic [$clog2(XCNT)-1:0] READ_SEL2,
  output logic [$clog2(XCNT)-1:0] WB_SEL
);

`define INSTRR_INSTANTIATE(OP) \
  EX_ALU_OP <= OP; \
  READ_SEL1 <= INSTRR.RS1; \
  READ_SEL2 <= INSTRR.RS1; \
  WB_SEL <= INSTRR.RD; \
  VALID_INSTRUCTION <= 1;

task instrr (input instrr_t INSTRR);
  if(INSTRR.RS1 == WB_SEL|| INSTRR.RS2 == WB_SEL) begin
    DECODE_HAZARD <= 1;
    NEXT_PC <= PC;
  end else begin 
    case(INSTRR.FUNC3)
      3'b000: begin
        case(INSTRR.FUNC7)
          7'b0000000: begin // ADD
            `INSTRR_INSTANTIATE(`ALU_OP_ADD);
          end
          7'b0100000: begin // SUB
            `INSTRR_INSTANTIATE(`ALU_OP_SUB);
          end
          default: VALID_INSTRUCTION <= 0;
        endcase
      end
      3'b001: begin  // SLL
        if(INSTRR.FUNC7 != 7'b000000) VALID_INSTRUCTION <= 0;
        else begin
            `INSTRR_INSTANTIATE(`ALU_OP_SLL);
        end
      end
      3'b010: begin  // SLT
        if(INSTRR.FUNC7 != 7'b000000) VALID_INSTRUCTION <= 0;
        else begin
            `INSTRR_INSTANTIATE(`ALU_OP_SLT);
        end
      end
      3'b011: begin  // SLTU
        if(INSTRR.FUNC7 != 7'b000000) VALID_INSTRUCTION <= 0;
        else begin
            `INSTRR_INSTANTIATE(`ALU_OP_SLTU);
        end
      end
      3'b100: begin // XOR
        if(INSTRR.FUNC7 != 7'b000000) VALID_INSTRUCTION <= 0;
        else begin
            `INSTRR_INSTANTIATE(`ALU_OP_XOR);
        end
      end
      3'b101: begin
        case(INSTRR.FUNC7)
          7'b0000000: begin // SRL
            `INSTRR_INSTANTIATE(`ALU_OP_SRL);
          end
          7'b0100000: begin // SRA
            `INSTRR_INSTANTIATE(`ALU_OP_SRA);
          end
          default: VALID_INSTRUCTION <= 0;
        endcase
      end
      3'b110: begin // OR
        if(INSTRR.FUNC7 != 7'b000000) VALID_INSTRUCTION <= 0;
        else begin
            `INSTRR_INSTANTIATE(`ALU_OP_OR);
        end
      end
      3'b111: begin  // AND
        if(INSTRR.FUNC7 != 7'b000000) VALID_INSTRUCTION <= 0;
        else begin
            `INSTRR_INSTANTIATE(`ALU_OP_AND);
        end
      end
    endcase
  end
endtask

task instrb (input instrb_t INSTRB);
  VALID_INSTRUCTION <= 0;
endtask

task instri (input instri_t INSTRB);
  VALID_INSTRUCTION <= 0;
endtask

always @(posedge CLK) begin
  if(!RSTN) begin
    if(DECODE_ENABLED) begin
      case(INSTR.RAW[6:0])
        `RV32I_OPCODE_R: instrr(INSTR);
        `RV32I_OPCODE_B: instrb(INSTR);
        `RV32I_OPCODE_I: instri(INSTR);
        default: VALID_INSTRUCTION <= 0;
      endcase

      DECODE_VALID <= 1;
    end
  end else begin
    DECODE_VALID <= 0;
    DECODE_HAZARD <= 0;
  end
end

endmodule
