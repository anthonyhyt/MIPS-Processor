/*
  Yiheng Chi
  chi14@purdue.edu

  request unit test bench
*/

// import necessary files
`include "request_unit_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this
`timescale 1 ns / 1 ns

// import types
import cpu_types_pkg::*;

module request_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0;
  logic nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  request_unit_if r();
  // test program
  test PROG(CLK, r);
  // DUT
  request_unit DUT(CLK, nRST, r);

  // initialize signals
  task init;
    begin
      r.dWENi = 1'b0;
      r.dRENi = 1'b0;
      r.ihit = 1'b0;
      r.dhit = 1'b0;
      nRST = 1'b0;
      @(posedge CLK);
      @(negedge CLK);
      nRST = 1'b1;
    end
  endtask

  // asynchronously reset
  task rst;
    begin
      @(negedge CLK);
      nRST = 1'b0;
      @(negedge CLK);
      nRST = 1'b1;
    end
  endtask

  // simulated ihit high
  task set_ihit;
    begin
      @(posedge CLK);
      r.ihit = 1'b1;
    end
  endtask

  // simulated dhit high
  task set_dhit;
    begin
      @(posedge CLK);
      r.dhit = 1'b1;
    end
  endtask

endmodule

program test(
  input logic CLK,
  request_unit_if.tb ruif
);

initial
begin
  // Initialize
  init;

  // Testing when ihit is high, next dREN* should be dREN
  @(posedge CLK);
  ruif.dRENi = 1'b1;
  set_ihit;
  @(posedge CLK);
  if (ruif.dRENo == 1'b1) $display("INFO: dRENo sets correctly");
  else $display("ERROR: dRENo doesn't set");

  // Testing when dhit is high, next dREN* should be masked out to 0
  ruif.ihit =1'b0;
  set_dhit;
  @(posedge CLK);
  if (ruif.dRENo == 1'b0) $display("INFO: dRENo masks out correctly");
  else $display("ERROR: dRENo doesn't mask out");

  // Testing when ihit is high again, next dREN* should not be masked out
  // anymore
  set_ihit;
  @(posedge CLK);
  if (ruif.dRENo == 1'b1) $display("INFO: dRENo sets correctly");
  else $display("ERROR: dRENo doesn't set");

  // Finish
  rst;
end

endprogram
