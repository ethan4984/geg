module tb;

logic CLK;
logic RSTN;

initial CLK <= 1'b0;
initial RSTN <= 1'b1;

always #10 CLK = ~CLK;

initial begin
  $dumpfile("caput.vcd");
  $dumpvars(0, tb);

  # 100

  $finish;
end

endmodule
