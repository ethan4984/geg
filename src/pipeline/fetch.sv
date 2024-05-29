/* 
* Signal descriptions:
* VALID whether or not the output of this stage is valid or not
* STALLED whether or not this stage is stalled
* NEXT_STALLED whether or not the following stage is stalled
*
* When a stage stalls it will create a ripple that will travel backwards
* to all previous stages immediately stalling them. To stall a stage, he
* must set WAIT high. But why exactly does STALLED need to exist if HALT
* exists, because that is how NEXT_STALLED is fed into the previous stage and
* the stage can stall for reasons other than just HALT being fed high
*/

/*
* the program counter should obviously be an input to this module
* but there are some things to consider, how will we handle branching?
* And how will we increment the program counter
*/

module fetch (
  input logic CLK,
  input logic RSTN,

  input logic [31:0] PC,
  output logic [31:0] INSTR,

  // pipeline flow 
  input logic HALT,
  input logic NEXT_STALLED,
  output logic VALID,
  output logic STALLED
);

assign STALLED = NEXT_STALLED || HALT;

logic [31:0] MEM [0:255];

always @(posedge CLK) begin
  if(!RSTN && !STALLED) begin
    INSTR <= MEM[PC >> 2];
    VALID <= 1;
  end
end

always @(posedge CLK) begin
  if(RSTN) begin
    VALID <= 0;
  end
end

endmodule
