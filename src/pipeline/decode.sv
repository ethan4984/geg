`include "pipeline/alu.svh"
`include "pipeline/instr.svh"

module decode (
  input logic CLK,
  input logic RSTN,
  input instr_t INSTR,
  output logic VALID,
  output op_t OP
);

task instrr (input instrr_t INSTR, output op_t OP);
  case(INSTR.FUNC3)
    3'b000: begin 
      case(INSTR.FUNC7)
        7'b0000000: begin // add
          `INSTRR_INSTANTIATE_OP(`ALU_OP_ADD);
        end
        7'b0100000: begin // SUB
         //`INSTRR_INSTANTIATE_OP(`ALU_OP_SUB);
        end
        default: VALID <= 0;
      endcase
    end
    3'b001: begin  // SLL
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
    end
    3'b010: begin  // SLT
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
    end
    3'b011: begin  // SLTU
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
    end
    3'b100: begin // XOR
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
    end
    3'b101: begin 
      case(INSTR.FUNC7)
        7'b0000000: begin // SRL
        end
        7'b0100000: begin // SRA
        end
        default: VALID <= 0;
      endcase
    end
    3'b110: begin // OR
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
    end
    3'b111: begin  // AND
      if(INSTR.FUNC7 != 7'b000000) VALID <= 0;
    end
  endcase
endtask

always @(posedge CLK) begin
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

endmodule
