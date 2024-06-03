module wb # (
  parameter XCNT = 32,
  parameter XLEN = 32
) (
  input logic CLK,
  input logic RSTN,

  input logic WB_ENABLED,
  output logic WB_HAZARD,
  output logic WB_VALID,

  output logic RELEASE_HAZARD,

  input logic [$clog2(XCNT)-1:0] WB_WRITE_SEL,
  input logic [XLEN-1:0] WB_WRITE_DATA,

  input logic [$clog2(XCNT)-1:0] READ_SEL1, 
  input logic [$clog2(XCNT)-1:0] READ_SEL2,

  output logic [XLEN-1:0] READ_DATA1, 
  output logic [XLEN-1:0] READ_DATA2
);

logic [$clog2(XCNT)-1:0] REGS [XLEN-1:0];

assign READ_DATA1 = REGS[READ_SEL1];
assign READ_DATA2 = REGS[READ_SEL2];

always @(posedge CLK) begin
  if(!RSTN) begin
    REGS[WB_WRITE_SEL] <= WB_WRITE_DATA;

    WB_VALID <= 1;
    WB_HAZARD <= 0;
  end else begin
    for(integer i = 0; i < XCNT; i++) begin
      REGS[i] <= 0;
    end

    WB_VALID <= 0;
    WB_HAZARD <= 0;
  end
end

endmodule
