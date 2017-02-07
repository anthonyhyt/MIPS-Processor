/*
  Yiheng Chi
  chi14@purdue.edu

  forwarding unit test bench
*/

// interface
`include "forwarding_unit_if.vh"

// types
`include "cpu_types_pkg.vh"
`include "forwarding_unit_types_pkg.vh"

// mapped timing needs this
`timescale 1 ns / 1 ns

module forwarding_unit_tb;

  // import types
  import cpu_types_pkg::*;
  import forwarding_unit_types_pkg::*;

  // clock period
  parameter PERIOD = 10;

  // signals
  logic CLK = 0;
  logic [1:0] fa, fb;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  forwarding_unit_if f();
  // test program
  test PROG(f);
  // DUT
`ifndef MAPPED
  forwarding_unit DUT(f);
`else
  //assign fa = f.fwdA[1:0];
  //assign fb = f.fwdB[1:0];
  forwarding_unit DUT(
    .\fuif.EXrs (f.EXrs),
    .\fuif.EXrt (f.EXrt),
    .\fuif.MMrd (f.MMrd),
    .\fuif.WBrd (f.WBrd),
    .\fuif.MMregWEN (f.MMregWEN),
    .\fuif.WBregWEN (f.WBregWEN),
    .\fuif.MMisLUI (f.MMisLUI),
    .\fuif.fwdA (fa),
    .\fuif.fwdB (fb)
  );
`endif


  task init;
    begin
      f.EXrs = '0;
      f.EXrt = '0;
      f.MMrd = '0;
      f.WBrd = '0;
      f.MMregWEN = 1'b0;
      f.WBregWEN = 1'b0;
      f.MMisLUI = 1'b0;
    end
  endtask

  task set_inputs;
    input regbits_t EXrs;
    input regbits_t EXrt;
    input regbits_t MMrd;
    input regbits_t WBrd;
    input logic MMregWEN;
    input logic WBregWEN;
    input logic MMisLUI;
    begin
      f.EXrs = EXrs;
      f.EXrt = EXrt;
      f.MMrd = MMrd;
      f.WBrd = WBrd;
      f.MMregWEN = MMregWEN;
      f.WBregWEN = WBregWEN;
      f.MMisLUI = MMisLUI;
      @(negedge CLK);
      @(posedge CLK);
    end
  endtask

  task check_outputs;
    input [1:0] fwdA;
    input [1:0] fwdB;
    begin
`ifndef MAPPED
      if (f.fwdA == fwdA) $display ("[Info] fwdA is set correctly");
      else $display ("[ERROR] fwdA is not set correctly");
      if (f.fwdB == fwdB) $display ("[Info] fwdB is set correctly");
      else $display ("[ERROR] fwdB is not set correctly");
      $display(" ");
`else
      if (fa == fwdA) $display ("[Info] fwdA is set correctly");
      else $display ("[ERROR] fwdA is not set correctly");
      if (fb == fwdB) $display ("[Info] fwdB is set correctly");
      else $display ("[ERROR] fwdB is not set correctly");
      $display(" ");
`endif
    end
  endtask

endmodule

program test (
  forwarding_unit_if.tb f
);

  import forwarding_unit_types_pkg::*;

initial
begin
  init;

  $display("Test 1: fwdA no forward, fwdB no forward");
  set_inputs(4, 5, 6, 7, 1, 1, 1);
  check_outputs(FABUSA, FBBUSB);

  $display("Test 2: fwdA no forward, fwdB no forward");
  set_inputs(4, 5, 4, 5, 0, 0, 1);
  check_outputs(FABUSA, FBBUSB);

  $display("Test 3: fwdA no forward, fwdB from MM ALU");
  set_inputs(4, 5, 5, 7, 1, 1, 0);
  check_outputs(FABUSA, FBALU);

  $display("Test 4: fwdA from MM ALU, fwdB no forward");
  set_inputs(4, 5, 4, 5, 1, 0, 0);
  check_outputs(FAALU, FBBUSB);

  $display("Test 5: fwdA from WB busW, fwdB no forward");
  set_inputs(4, 5, 6, 4, 1, 1, 1);
  check_outputs(FABUSW, FBBUSB);

  $display("Test 6: fwdA no forward, fwdB from WB busW");
  set_inputs(6, 5, 6, 5, 0, 1, 1);
  check_outputs(FABUSA, FBBUSW);

  $display("Test 7: fwdA from MM portB, fwdB no forward");
  set_inputs(4, 5, 4, 7, 1, 1, 1);
  check_outputs(FAPORTB, FBBUSB);

  $display("Test 8: fwdA no forward, fwdB from MM portB");
  set_inputs(4, 5, 5, 7, 1, 1, 1);
  check_outputs(FABUSA, FBPORTB);

  $display("Test 9: fwdA from MM ALU, fwdB from WB busW");
  set_inputs(4, 5, 4, 5, 1, 1, 0);
  check_outputs(FAALU, FBBUSW);

  $display("Test 10: fwdA from WB busW, fwdB from MM portB");
  set_inputs(4, 6, 6, 4, 1, 1, 1);
  check_outputs(FABUSW, FBPORTB);

  $display("Test 11: both bubbles");
  set_inputs(0, 0, 0, 0, 1, 1, 1);
  check_outputs(FABUSA, FBBUSB);

  $display("Test 12: both from MM ALU");
  set_inputs(4, 4, 4, 7, 1, 1, 0);
  check_outputs(FAALU, FBALU);

  $display("Test 13: both from WB busW");
  set_inputs(7, 7, 6, 7, 1, 1, 1);
  check_outputs(FABUSW, FBBUSW);

  $display("Test 14: both from MM portB");
  set_inputs(6, 6, 6, 7, 1, 1, 1);
  check_outputs(FAPORTB, FBPORTB);
end
endprogram


