/*
  Yiheng Chi
  chi14@purdue.edu

  instruction cache test bench
*/

// interfaces
`include "caches_if.vh"
`include "datapath_cache_if.vh"

// all types
`include "cpu_types_pkg.vh"
`include "caches_types_pkg.vh"

// timing
`timescale 1 ns / 1 ns

module icache_tb;

  // import types
  import cpu_types_pkg::*;
  import caches_types_pkg::*;

  // clock period
  parameter PERIOD = 10;

  // signals
  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if c();
  datapath_cache_if dc();
  // test program
  test PROG();
  // DUT
  icache DUT(CLK, nRST, c, dc);

  // initialize input signals
  task init;
    begin
      c.iwait = 1'b1;
      c.iload = 32'h00000000;
      dc.imemREN = 1'b0;
      dc.imemaddr = 32'h00000000;
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

  // load word
  task lw;
    input logic [31:0] addr;
    begin
      dc.imemaddr = addr;
      dc.imemREN = 1'b1;
      @(posedge CLK);
      @(negedge CLK);
    end
  endtask

  // reset imemREN
  task rstREN;
    begin
      dc.imemREN = 1'b0;
      @(posedge CLK);
      @(negedge CLK);
    end
  endtask

  // send loaded word
  task sdw;
    input logic [31:0] word;
    begin
      c.iload = word;
      c.iwait = 1'b0;
      @(posedge CLK);
      @(negedge CLK);
    end
  endtask

  // reset iwait
  task iwait;
    begin
      c.iwait = 1'b1;
      @(posedge CLK);
      @(negedge CLK);
    end
  endtask

  // display all output signals
  task disp;
    begin
      $display ("dc.ihit = %b, dc.imemload = %h", dc.ihit, dc.imemload);
      $display ("c.iREN  = %b, c.iaddr     = %h", c.iREN, c.iaddr);
    end
  endtask

endmodule


program test;
initial
begin
  init;

  // load from 0b0000, 0b0100, 0b1000, 0b1100 - all misses
  $display ("Loading 4 words - first round");
  lw(32'h00000000);
  disp;
  sdw(32'hAAAAAAAA);
  disp;
  rstREN;
  iwait;
  lw(32'h00000004);
  disp;
  sdw(32'hBBBBBBBB);
  disp;
  rstREN;
  iwait;
  lw(32'h00000008);
  disp;
  sdw(32'hCCCCCCCC);
  disp;
  rstREN;
  iwait;
  lw(32'h0000000C);
  disp;
  sdw(32'hDDDDDDDD);
  disp;
  rstREN;
  iwait;

  // load from 0b0000, 0b0100, 0b1000, 0b1100 - all hits
  $display ("Loading 4 words - second round");
  lw(32'h00000000);
  disp;
  rstREN;
  lw(32'h00000004);
  disp;
  rstREN;
  lw(32'h00000008);
  disp;
  rstREN;
  lw(32'h0000000C);
  disp;
  rstREN;

  // load from 0h10000000 - miss
  $display ("Loading word that overwrite 1st frame");
  lw(32'h10000000);
  disp;
  sdw(32'hDEADBEEF);
  disp;
  rstREN;
  iwait;

  rst;

end
endprogram

