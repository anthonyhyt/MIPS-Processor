/*
  Yiheng Chi
  chi14@purdue.edu

  hazard control unit test bench
*/

// interface
`include "hazard_control_unit_if.vh"

// types
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"
`include "hazard_control_unit_types_pkg.vh"

// mapped timing needs this
`timescale 1 ns / 1 ns

module hazard_control_unit_tb;

  // import types
  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;
  import hazard_control_unit_types_pkg::*;

  // clock period
  parameter PERIOD = 10;

  // signals
  logic CLK = 0;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  hazard_control_unit_if h();
  // test program
  test PROG(h);
  // DUT
  hazard_control_unit DUT(h);

  task init;
    begin
      h.IDrs = '0;
      h.IDrt = '0;
      h.EXrt = '0;
      h.IDopfunc = OTHERJ;
      h.EXopfunc = OTHERJ;
      h.MMopfunc = OTHERJ;
      h.ihit = 1'b0;
      h.dhit = 1'b0;
      h.MMequal = 1'b0;
    end
  endtask

  task disp;
    begin
      @(negedge CLK);
      @(posedge CLK);
      $display ("Enable signals (PC, IFID, IDEX, EXMM, MMWB):");
      $display ("[%b, %b, %b, %b, %b]", h.PCEN, h.IFIDEN, h.IDEXEN,
                h.EXMMEN, h.MMWBEN);
      $display ("Flush signals (IFIDflush, IDEXflush, EXMMflush):");
      $display ("[%b, %b, %b]", h.IFIDflush, h.IDEXflush, h.EXMMflush);
      $display ("PCselect = %d", h.PCselect);
      $display ("");
    end
  endtask

  task setr;
    input regbits_t IDrs;
    input regbits_t IDrt;
    input regbits_t EXrt;
    begin
      h.IDrs = IDrs;
      h.IDrt = IDrt;
      h.EXrt = EXrt;
    end
  endtask

  task setop;
    input opfunc_t IDopfunc;
    input opfunc_t EXopfunc;
    input opfunc_t MMopfunc;
    begin
      h.IDopfunc = IDopfunc;
      h.EXopfunc = EXopfunc;
      h.MMopfunc = MMopfunc;
    end
  endtask

  task setflag;
    input logic ihit;
    input logic dhit;
    input logic MMequal;
    begin
      h.ihit = ihit;
      h.dhit = dhit;
      h.MMequal = MMequal;
    end
  endtask

endmodule


program test (
  hazard_control_unit_if.tb h
);

  // import types
  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;
  import hazard_control_unit_types_pkg::*;

initial
begin
  init;

  // test normal case
  $display ("Type O - No Hazard");
  $display ("");

  $display ("Test 00: normal r-type & i-type");
  setr(4, 5, 6);
  setop(OTHERR, OTHERI, OTHERR);
  setflag(1'b1, 1'b0, 1'b1);
  disp;

  // test lw & sw
  $display ("Type I - Normal lw/sw");
  $display ("");

  $display ("Test 01: lw + no hit stall");
  setr(4, 5, 6);
  setop(OTHERR, OTHERI, OLW);
  setflag(1'b0, 1'b0, 1'b0);
  disp;

  $display ("Test 02: lw + dhit");
  setr(4, 5, 6);
  setop(OTHERR, OTHERI, OLW);
  setflag(1'b0, 1'b1, 1'b0);
  disp;

  $display ("Test 03: sw + ihit stall");
  setr(4, 5, 6);
  setop(OTHERR, OTHERI, OSW);
  setflag(1'b1, 1'b0, 1'b1);
  disp;

  $display ("Test 04: sw + ihit dhit");
  setr(4, 5, 6);
  setop(OTHERR, OTHERI, OSW);
  setflag(1'b1, 1'b1, 1'b1);
  disp;

  // test load-use
  $display ("Type II - Load-Use");
  $display ("");

  $display ("Test 05: lw + use rs");
  setr(4, 5, 4);
  setop(OTHERR, OLW, OTHERR);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 06: lw + use rs");
  setr(4, 5, 4);
  setop(OBEQ, OLW, OTHERR);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 07: lw + use rs");
  setr(4, 5, 4);
  setop(OJR, OLW, OTHERR);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 08: lw + use rs");
  setr(4, 5, 4);
  setop(OSL, OLW, OTHERR);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 09: lw + use rs");
  setr(4, 5, 4);
  setop(OLW, OLW, OTHERR);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 10: lw + use rs");
  setr(4, 5, 4);
  setop(OSW, OLW, OTHERR);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 11: lw + use rt");
  setr(4, 5, 5);
  setop(OTHERR, OLW, OTHERR);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 12: lw + use rt");
  setr(4, 5, 5);
  setop(OBNE, OLW, OTHERR);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 13: lw + not use rt");
  setr(4, 5, 5);
  setop(OTHERI, OLW, OTHERR);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  // test branch
  $display ("Type III - Branch");
  $display ("");

  $display ("Test 14: beq + equal");
  setr(4, 5, 6);
  setop(OTHERI, OTHERR, OBEQ);
  setflag(1'b1, 1'b0, 1'b1);
  disp;

  $display ("Test 15: beq + !equal");
  setr(4, 5, 6);
  setop(OTHERI, OTHERR, OBEQ);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 16: bne + equal");
  setr(4, 5, 6);
  setop(OTHERI, OTHERR, OBNE);
  setflag(1'b1, 1'b0, 1'b1);
  disp;

  $display ("Test 17: bne + !equal");
  setr(4, 5, 6);
  setop(OTHERI, OTHERR, OBNE);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  // test jr
  $display ("Type IV - Normal jr");
  $display ("");

  $display ("Test 18: jr + !branch");
  setr(4, 5, 6);
  setop(OTHERI, OJR, OTHERR);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 19: jr + branch");
  setr(4, 5, 6);
  setop(OTHERI, OJR, OBEQ);
  setflag(1'b1, 1'b0, 1'b1);
  disp;

  // test j
  $display ("Type V - Normal j");
  $display ("");

  $display ("Test 20: j + !branch");
  setr(4, 5, 6);
  setop(OTHERI, OJ, OTHERR);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 21: j + branch");
  setr(4, 5, 6);
  setop(OTHERI, OJ, OBEQ);
  setflag(1'b1, 1'b0, 1'b1);
  disp;

  // test jal
  $display ("Type VI - Normal jal");
  $display ("");

  $display ("Test 22: jal + !branch");
  setr(4, 5, 6);
  setop(OTHERI, OJAL, OTHERR);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 23: jal + branch");
  setr(4, 5, 6);
  setop(OTHERI, OJAL, OBEQ);
  setflag(1'b1, 1'b0, 1'b1);
  disp;

  // test combinations
  $display ("Type VII - Combinations");
  $display ("");

  $display ("Test 24: lw + Load-Use");
  setr(4, 5, 4);
  setop(OBNE, OLW, OLW);
  setflag(1'b1, 1'b1, 1'b0);
  disp;

  $display ("Test 25: sw + Load-Use");
  setr(4, 5, 5);
  setop(OTHERR, OLW, OSW);
  setflag(1'b0, 1'b1, 1'b0);
  disp;

  $display ("Test 26: sw + !Load-Use");
  setr(4, 5, 6);
  setop(OTHERR, OLW, OSW);
  setflag(1'b1, 1'b1, 1'b0);
  disp;

  $display ("Test 27: lw + jr + !dhit");
  setr(4, 5, 6);
  setop(OTHERR, OJR, OLW);
  setflag(1'b1, 1'b0, 1'b0);
  disp;

  $display ("Test 28: lw + jr + dhit");
  setr(4, 5, 6);
  setop(OTHERR, OJR, OLW);
  setflag(1'b1, 1'b1, 1'b0);
  disp;


end

endprogram
