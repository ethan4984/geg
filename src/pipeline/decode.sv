// TODO
// 
//  - Rudimentary but logical mmu
//  - Centralised? model to read and write to architectural registers
//      A critical thing to remember is the fact that, any register can be
//      read from at any stage in the pipeline because rather of the
//      guarantees of hazard detection and stalling. The write back stage will
//      be the 

`include "pipeline/alu.svh"
`include "pipeline/instr.svh"

module decode (
  input logic CLK,
  input logic RSTN,
  input instr_t INSTR,
  output op_t OP,

  output logic VALID,
  output logic STALLED,

  input logic NEXT_STALLED
);

task instrr (input instrr_t INSTR, output op_t OP);
  case(INSTR.FUNC3)
    3'b000: begin 
      case(INSTR.FUNC7)
        7'b0000000: begin // ADD
          `INSTRR_INSTANTIATE_OP(`ALU_OP_ADD);
          VALID <= 1;
        end
        7'b0100000: begin // SUB
         `INSTRR_INSTANTIATE_OP(`ALU_OP_SUB);
          VALID <= 1;
        end
        default: VALID <= 0;
      endcase
    end
    3'b001: begin  // SLL
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
      VALID <= 1;
    end
    3'b010: begin  // SLT
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
      VALID <= 1;
    end
    3'b011: begin  // SLTU
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
      VALID <= 1;
    end
    3'b100: begin // XOR
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
      VALID <= 1;
    end
    3'b101: begin 
      case(INSTR.FUNC7)
        7'b0000000: begin // SRL
          VALID <= 1;
        end
        7'b0100000: begin // SRA
          VALID <= 1;
        end
        default: VALID <= 0;
      endcase
    end
    3'b110: begin // OR
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
      VALID <= 1;
    end
    3'b111: begin  // AND
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
      VALID <= 1;
    end
  endcase
endtask

always @(posedge CLK) begin
  STALLED <= VALID && !NEXT_STALLED;

  if(!RSTN) begin
    case(INSTR.RAW[05:0])
      `RV32I_OPCODE_R: instrr(INSTR, OP);
      `RV32I_OPCODE_I: begin
      end
      `RV32I_OPCODE_L: begin
      end
      `RV32I_OPCODE_S: begin
      end
      `RV32I_OPCODE_B: begin
      end
      default: VALID <= 0;
    endcase
  end
end

always @(posedge CLK) begin
  if(RSTN) begin
    VALID <= 0;
  end
end

endmodule
