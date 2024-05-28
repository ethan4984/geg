`include "pipeline/instr.svh"
`include "pipeline/alu.svh"

module alu (
  input logic CLK,
  input logic RSTN,
  input op_t OP
);

always @(posedge CLK) begin
  if(!RSTN && OP.CLASS == `OP_CLASS_ALU) begin
    case(OP.FUNC)
      `ALU_OP_ADD: begin
      end
      `ALU_OP_SUB: begin
      end
    endcase
  end
end

endmodule
