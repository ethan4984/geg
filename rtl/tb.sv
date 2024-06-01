module tb;

logic CLK;
logic RSTN;

initial CLK <= 1'b0;
initial RSTN <= 1'b1;
initial CORE_STALL <= 1'b0; 

always #10 CLK = ~CLK;

logic [31:0] RCH1_ADDR;
logic [31:0] RCH1_DATA;
logic [31:0] MEM [0:255];

always @(posedge CLK) begin 
  RCH1_DATA <= MEM[RCH1_ADDR >> 2];
end

logic CORE_STALL;

core core (
  .CLK(CLK), .RSTN(RSTN),
  .CORE_STALL(CORE_STALL),
  .RCH1_ADDR(RCH1_ADDR), .RCH1_DATA(RCH1_DATA)
);

initial begin
  $dumpfile("ARIOSTO.vcd");
  $dumpvars(0, tb);

  $readmemh("mem.dat", MEM);

  # 20;

  RSTN <= 0;

  # 180

  $finish;
end

endmodule
