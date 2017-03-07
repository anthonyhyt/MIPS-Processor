module flex_counter
#(
  parameter NUM_CNT_BITS = 4
)
(
  input logic CLK, nRST, clear, count_enable,
  output logic [NUM_CNT_BITS - 1:0] count_out
);

  always_ff @ (posedge CLK, negedge nRST)
  begin
  if (~nRST)
    count_out <= '0;
  else if (clear)
    count_out <= '0;
  else if (count_enable)
    count_out <= count_out + 1;
  end

endmodule
