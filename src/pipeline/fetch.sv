/* 
* Signal descriptions:
* VALID whether or not the output of this stage is valid or not
* STALLED whether or not this stage is stalled
* NEXT_STALLED whether or not the following stage is stalled
*
* When a stage stalls it will create a ripple that will travel backwards
* to all previous stages
*/

module fetch (
  input logic CLK,
  input logic RSTN,

  input logic [31:0] PC,
  output logic [31:0] INSTR,

  // pipeline flow 
  output logic VALID,
  output logic STALLED,
  input logic NEXT_STALLED
);

reg [31:0] MEM [0:255];

always @(posedge CLK) begin
  STALLED <= VALID && !NEXT_STALLED;

  if(!RSTN && !STALLED) begin
    INSTR <= MEM[PC];
    VALID <= 1;
  end
end

always @(posedge CLK) begin
  if(RSTN) begin
    VALID <= 0;
  end
end

endmodule
