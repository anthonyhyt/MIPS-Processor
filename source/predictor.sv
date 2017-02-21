`include "predictor_if.vh"
`include "control_unit_types_pkg.vh"

module predictor (
  input logic CLK, nRST,
  predictor_if.bp bpif
);

  import control_unit_types_pkg::*;

  logic re1, re2, re3, re4, en1, en2, en3, en4;

  assign en1 = bpif.mmprindex==2'b00 & (bpif.opfunc == OBNE | bpif.opfunc == OBEQ);
  assign en2 = bpif.mmprindex==2'b01 & (bpif.opfunc == OBNE | bpif.opfunc == OBEQ);
  assign en3 = bpif.mmprindex==2'b10 & (bpif.opfunc == OBNE | bpif.opfunc == OBEQ);
  assign en4 = bpif.mmprindex==2'b11 & (bpif.opfunc == OBNE | bpif.opfunc == OBEQ);

  apredictor  PRE1(CLK, nRST, bpif.ABtaken, en1, re1);
  apredictor  PRE2(CLK, nRST, bpif.ABtaken, en2, re2);
  apredictor  PRE3(CLK, nRST, bpif.ABtaken, en3, re3);
  apredictor  PRE4(CLK, nRST, bpif.ABtaken, en4, re4);

  always_comb
  begin:output_select
    casez(bpif.ifprindex)
      2'b00: bpif.PRresult = re1;
      2'b01: bpif.PRresult = re2;
      2'b10: bpif.PRresult = re3;
      2'b11: bpif.PRresult = re4;
      default: bpif.PRresult = 1'b0;
    endcase
  end

endmodule
