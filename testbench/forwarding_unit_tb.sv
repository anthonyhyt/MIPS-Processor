/*
  Yiheng Chi
  chi14@purdue.edu

  forwarding unit test bench
*/

// interface
`include "forwarding_unit_if.vh"

// types
`include "cpu_types_pkg.vh"
`include "forwarding_unit_tpes_pkg.vh"

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

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  forwarding_unit_if f();
  // test program
  test PROG(f);
  // DUT
  forwarding_unit DUT(f);

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

  task
