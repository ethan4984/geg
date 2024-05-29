`include "pipeline/alu.svh"
`include "pipeline/instr.svh"

module decode (
  input logic CLK,
  input logic RSTN,
  input instr_t INSTR,
  output op_t OP,

  output logic BRANCH,
  output logic [11:0] BRANCH_IMM,

  // pipeline flow
  input logic HALT,
  output logic VALID,
  output logic STALLED,
  input logic NEXT_STALLED
);

assign STALLED = NEXT_STALLED || HALT;

`define INSTRB_INSTANTIATE_OP(FUNCTION) \
  OP.CLASS <= `OP_CLASS_BRANCH; \
  OP.FUNC <= (FUNCTION); \
  OP.RS1 <= INSTR.RS1; \
  OP.RS2 <= INSTR.RS2; \
  OP.RD <= 0; \
  OP.IMM[3:0] <= INSTR.IMM2; \ // PRETTY RETARDED
  OP.IMM[9:4] <= INSTR.IMM3; \
  OP.IMM[10:10] <= INSTR.IMM4; \
  OP.IMM[11:11] <= INSTR.IMM1; \
  OP.IMM[20:12] <= 0; \
  BRANCH_IMM[3:0] <= INSTR.IMM2; \
  BRANCH_IMM[9:4] <= INSTR.IMM3; \
  BRANCH_IMM[10:10] <= INSTR.IMM1; \
  BRANCH_IMM[11:11] <= INSTR.IMM4; \
  BRANCH <= 1; \
  VALID <= 1;

task instrb (input instrb_t INSTR, output op_t OP);
  case(INSTR.FUNC3)
    3'b000: begin // BEQ
      `INSTRB_INSTANTIATE_OP(`BRANCH_CONDITION_EQ);
    end
    3'b001: begin // BNE
      `INSTRB_INSTANTIATE_OP(`BRANCH_CONDITION_NE);
    end
    3'b100: begin // BLT
      `INSTRB_INSTANTIATE_OP(`BRANCH_CONDITION_LT);
    end 
    3'b101: begin // BGE
      `INSTRB_INSTANTIATE_OP(`BRANCH_CONDITION_GE);
    end
    3'b110: begin // BLTU
      `INSTRB_INSTANTIATE_OP(`BRANCH_CONDITION_LTU);
    end
    3'b111: begin // BGEU
      `INSTRB_INSTANTIATE_OP(`BRANCH_CONDITION_GEU);
    end
    default: VALID <= 0;
  endcase
endtask

`define INSTRR_INSTANTIATE_OP(FUNCTION) \
  OP.CLASS <= `OP_CLASS_ALU; \
  OP.FUNC <= (FUNCTION); \
  OP.RS1 <= INSTR.RS1; \
  OP.RS2 <= INSTR.RS2; \
  OP.RD <= INSTR.RD; \
  OP.IMM <= 0; \
  VALID <= 1;

task instrr (input instrr_t INSTR, output op_t OP);
  case(INSTR.FUNC3)
    3'b000: begin 
      case(INSTR.FUNC7)
        7'b0000000: begin // ADD
          `INSTRR_INSTANTIATE_OP(`ALU_OP_ADD);
        end
        7'b0100000: begin // SUB
         `INSTRR_INSTANTIATE_OP(`ALU_OP_SUB);
        end
        default: VALID <= 0;
      endcase
    end
    3'b001: begin  // SLL
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
      `INSTRR_INSTANTIATE_OP(`ALU_OP_SLL);
    end
    3'b010: begin  // SLT
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
      `INSTRR_INSTANTIATE_OP(`ALU_OP_SLT);
    end
    3'b011: begin  // SLTU
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
      `INSTRR_INSTANTIATE_OP(`ALU_OP_SLTU);
    end
    3'b100: begin // XOR
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
      `INSTRR_INSTANTIATE_OP(`ALU_OP_XOR);
    end
    3'b101: begin 
      case(INSTR.FUNC7)
        7'b0000000: begin // SRL
          `INSTRR_INSTANTIATE_OP(`ALU_OP_SRL);
        end
        7'b0100000: begin // SRA
          `INSTRR_INSTANTIATE_OP(`ALU_OP_SRA);
        end
        default: VALID <= 0;
      endcase
    end
    3'b110: begin // OR
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
      `INSTRR_INSTANTIATE_OP(`ALU_OP_OR);
    end
    3'b111: begin  // AND
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
      `INSTRR_INSTANTIATE_OP(`ALU_OP_AND);
    end
  endcase
endtask

always @(posedge CLK) begin
  if(!RSTN) begin
    case(INSTR.RAW[6:0])
      `RV32I_OPCODE_R: instrr(INSTR, OP);
      `RV32I_OPCODE_I: begin
      end
      `RV32I_OPCODE_L: begin
      end
      `RV32I_OPCODE_S: begin
      end
      `RV32I_OPCODE_B: instrb(INSTR, OP);
      default: VALID <= 0;
    endcase
  end
end

always @(posedge CLK) begin
  if(RSTN) begin
    OP <= 0;
    VALID <= 0;
    BRANCH <= 0;
    BRANCH_IMM <= 0;
  end
end

endmodule
