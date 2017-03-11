module flex_counter
#(
  parameter BITS = 4
)
(
  input logic CLK, nRST, clear, countup, countdown,
  output logic [BITS - 1:0] count_out
);

  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST)
      count_out <= '0;
    else if (clear)
      count_out <= '0;
    else if (countup)
      count_out <= count_out + 1;
    else if (countdown)
      count_out <= count_out - 1;
  end

endmodule
