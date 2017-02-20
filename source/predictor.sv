`include "control_unit_types_pkg.vh"

import control_unit_types_pkg::*;

module predictor (
  input logic CLK, nRST, ABtaken,
  input logic [1:0] prindex,
  input opfunc_t opfunc,
  output logic PRresult
);

  logic re1, re2, re3, re4, en1, en2, en3, en4;

  assign en1 = prindex==2'b00 & (opfunc == OBNE | opfunc == OBEQ);
  assign en2 = prindex==2'b01 & (opfunc == OBNE | opfunc == OBEQ);
  assign en3 = prindex==2'b10 & (opfunc == OBNE | opfunc == OBEQ);
  assign en4 = prindex==2'b11 & (opfunc == OBNE | opfunc == OBEQ);

  apredictor  PRE1(CLK, nRST, ABtaken, en1, re1);
  apredictor  PRE2(CLK, nRST, ABtaken, en2, re2);
  apredictor  PRE3(CLK, nRST, ABtaken, en3, re3);
  apredictor  PRE4(CLK, nRST, ABtaken, en4, re4);

  always_comb
  begin:output_select
    casez(prindex)
      2'b00: PRresult = re1;
      2'b01: PRresult = re2;
      2'b10: PRresult = re3;
      2'b11: PRresult = re4;
      default: PRresult = 1'b0;
  end

endmodule
