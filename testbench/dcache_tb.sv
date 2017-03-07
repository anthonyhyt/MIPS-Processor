/*
  Yiheng Chi
  chi14@purdue.edu

  data cache test bench
*/

// interface
`include "caches_if.vh"
`include "datapath_cache_if.vh"

// all types
`include "cpu_types_pkg.vh"
`include "caches_types_pkg.vh"

// timing
`timescale 1 ns / 1 ns

module dcache_tb;

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
  // DUT <IMPORTANT! Please modify DUT declaration below before use>
  dcache DUT(CLK, nRST, c, dc);

  // initialize input signals
  task init;
    begin
      c.ccwait = '0;
      c.ccinv = '0;
      c.ccsnoopaddr = '0;
      c.dwait = 1'b1;
      c.dload = 32'h00000000;
      dc.halt = 1'b0;
      dc.dmemREN = 1'b0;
      dc.dmemWEN = 1'b0;
      dc.datomic = 1'b0;
      dc.dmemstore = 32'h00000000;
      dc.dmemaddr = 32'h00000000;
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

  // wait 1 cycle
  task wc;
    begin
      @(posedge CLK);
      @(negedge CLK);
    end
  endtask

  // reset all flag
  task rstf;
    begin
      c.dwait = 1'b1;
      dc.dmemREN = 1'b0;
      dc.dmemWEN = 1'b0;
      wc;
    end
  endtask

  // load word
  task lw;
    input logic [31:0] addr;
    begin
      dc.dmemaddr = addr;
      dc.dmemREN = 1'b1;
      wc;
    end
  endtask

  // store word
  task sw;
    input logic [31:0] addr;
    input logic [31:0] word;
    begin
      dc.dmemaddr = addr;
      dc.dmemstore = word;
      dc.dmemWEN = 1'b1;
      wc;
    end
  endtask

  // load mem
  task lm;
    input logic [31:0] word;
    begin
      if (c.dREN != 1'b1) $display ("ERROR: dREN isn't set when loading");
      c.dload = word;
      c.dwait = 1'b0;
      wc;
      c.dwait = 1'b1;
    end
  endtask

  // store mem
  task sm;
    begin
      if (c.dWEN != 1'b1) $display ("ERROR: dWEN isn't set when storing");
      $display ("Stored a word: %h", c.dstore);
      c.dwait = 1'b0;
      wc;
      c.dwait = 1'b1;
    end
  endtask

  // display all output signals
  task disp;
    begin
      $display ("dc.dhit = %b, dc.dmemload = %h", dc.dhit, dc.dmemload);
      $display ("c.dREN  = %b, c.daddr     = %h", c.dREN, c.daddr);
      $display ("c.dWEN  = %b, c.dstore    = %h", c.dWEN, c.dstore);
    end
  endtask

  // flush
  task flush;
    begin
      dc.halt = 1'b1;
      c.dwait = 1'b0;
      @(posedge dc.flushed);
      $display ("Successfully flushed");
    end
  endtask

endmodule

program test;
initial
begin
  init;

  // load from 0b0000, 0b0100, 0b1000, 0b1100 - misses followed by hits
  $display ("Loading 4 words - first round");
  lw(32'h00000000);
  disp;
  lm(32'hAAAAAAAA);
  disp;
  lm(32'hBBBBBBBB);
  disp;
  rstf;
  lw(32'h00000004);
  disp;
  rstf;
  lw(32'h00000008);
  disp;
  lm(32'hCCCCCCCC);
  disp;
  lm(32'hDDDDDDDD);
  disp;
  rstf;
  lw(32'h0000000C);
  disp;
  rstf;

  // store to 0b0000, 0b0100, 0b1000, 0b1100 - all hits
  $display ("Saving 4 words - first round");
  sw(32'h00000000, 32'hAAAA0000);
  disp;
  sw(32'h00000004, 32'hBBBB0000);
  disp;
  sw(32'h00000008, 32'hCCCC0000);
  disp;
  sw(32'h0000000C, 32'hDDDD0000);
  disp;

  // store to 0h10000000, 0h10000004, 0h10000008, 0h1000000C
  // - misses followed by hits
  $display ("Saving 4 words - second round");
  sw(32'h10000000, 32'h11110000);
  disp;
  lm(32'h11111111);
  disp;
  lm(32'h22222222);
  disp;
  rstf;
  sw(32'h10000004, 32'h22220000);
  disp;
  rstf;
  sw(32'h10000008, 32'h33330000);
  disp;
  lm(32'h33333333);
  disp;
  lm(32'h44444444);
  disp;
  rstf;
  sw(32'h1000000C, 32'h44440000);
  disp;
  rstf;

  // store to 0h20000000, 0h20000004, 0h20000008, 0h2000000C
  // - write back, misses followed by hits
  $display ("Saving 4 words - third round");
  sw(32'h20000000, 32'h55550000);
  disp;
  sm;
  disp;
  lm(32'h55555555);
  disp;
  lm(32'h66666666);
  disp;
  rstf;
  sw(32'h20000004, 32'h66660000);
  disp;
  rstf;
  sw(32'h20000008, 32'h77770000);
  disp;
  sm;
  disp;
  lm(32'h77777777);
  disp;
  lm(32'h88888888);
  disp;
  rstf;
  sw(32'h2000000C, 32'h88880000);
  disp;
  rstf;

  // flush
  flush;

end
endprogram

