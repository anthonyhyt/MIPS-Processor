/*
  Yiheng chi
  chi14@purdue.edu

  data cache test bench
*/

// interface
`include "caches_if.vh"
`include "datapath_cache_if.vh"
//`include "cache_control_if.vh"
//`include "cpu_ram_if.vh"

// all types
`include "cpu_types_pkg.vh"
`include "caches_types_pkg.vh"

// timing
`timescale 1 ns / 1 ns

module dcache_tb;

  //import types
  import cpu_types_pkg::*;
  import caches_types_pkg::*;

  // clock period
  parameter PERIOD = 10;

  // signals
  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;
  //always #(PERIOD/4) RAM_CLK++;

  // interface
  caches_if c();
  datapath_cache_if dc();
  // test program
  test PROG();
  // DUT
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
      // make sure input signal is aligned with posedge of CLK
      // since signals are generated from datapath pipeline
      @(posedge CLK);
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
      #(PERIOD);
    end
  endtask

  // reset all flag
  task rstf;
    begin
      c.dwait = 1'b1;
      dc.dmemREN = 1'b0;
      dc.dmemWEN = 1'b0;
      c.ccwait = 1'b0;
      c.ccinv = 1'b0;
      c.ccsnoopaddr = '0;
      wc;
    end
  endtask

  task lwready;
    begin
      fork
      begin
        while (~dc.dhit)
          wc;
      end
      begin
        for (int i = 0; i < 20; i++) begin
          if (i == 19) $display ("ERROR: dhit not set after lw finished");
          #(PERIOD);
        end
      end
      join_any;
      disable fork;
      wc; // enable will be reset in next cycle when dhit provided
    end
  endtask

  // load word
  task lw;
    input logic [31:0] addr;
    begin
      dc.dmemaddr = addr;
      dc.dmemREN = 1'b1;
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
    end
  endtask

  // load mem
  task lm;
    input logic [31:0] word;
    begin
      if (c.dREN != 1'b1) $display ("ERROR: dREN isn't set when loading");
      c.dload = word;
      c.dwait = 1'b0;
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

  // send coherence control signals
  task scc;
    input logic ccwait;
    input logic ccinv;
    input logic [31:0] ccsnoopaddr;
    begin
      c.ccwait = ccwait;
      c.ccinv = ccinv;
      c.ccsnoopaddr = ccsnoopaddr;
    end
  endtask

  // display all output signals
  task disp;
    begin
      $display ("dc.dhit   = %b, dc.dmemload = %h", dc.dhit, dc.dmemload);
      $display ("c.dREN    = %b, c.daddr     = %h", c.dREN, c.daddr);
      $display ("c.dWEN    = %b, c.dstore    = %h", c.dWEN, c.dstore);
      $display ("c.cctrans = %b, c.ccwrite   = %b", c.cctrans, c.ccwrite);
    end
  endtask

  // flush
  task flush;
    begin
      dc.halt = 1'b1;
      c.dwait = 1'b0;
      fork
      begin
        @(posedge dc.flushed);
        $display ("Successfully flushed");
      end
      begin
        for (int i = 0; i < 1000; i++) begin
          if (i == 999) $display ("ERROR: Time out in flushing");
          #(PERIOD);
        end
      end
      join_any;
      disable fork;
    end
  endtask

endmodule

program test;
initial
begin
  init;

  // load from 0b0000, 0b0100, no coherence controller inference
  // miss followed by hit
  $display ("Loading 2 words - no cc");
  lw(32'h00000000);
  wc; // output cctrans
  disp;
  wc; // go to CCARB
  wc; // go to CCSNP
  scc(1'b1, 1'b0, 32'h00000000);
  wc; // go to CCRTC
  disp;
  lm(32'hAAAAAAAA);
  wc; // wait for load
  disp;
  lm(32'hBBBBBBBB);
  wc; // wait for load
  wc; // go to CCREQ
  disp;
  scc(1'b0, 1'b0, 32'h00000000);
  lwready;
  rstf;
  wc;

  // store to 0b0000, gets served
  // hit
  $display ("Saving 1 word - served");
  sw(32'h00000000, 32'hA0A0A0A0);
  wc; // output cctrans and ccwrite
  disp;
  wc; // go to CCARB
  wc; // go to CCSNP
  scc(1'b1, 1'b0, 32'h00000000);
  wc; // go to CCRTC
  disp;
  wc; // go to CCREQ
  rstf;
  wc;

  // the other cache read - goes to share
  // write back
  $display ("Other cache read - to share");
  wc; // go to CCARB
  wc; // go to CCSNP
  scc(1'b1, 1'b0, 32'h00000000);
  wc; // go to CCCTC
  disp;
  sm;
  disp;
  sm;
  disp;
  wc; // go to CCREQ
  rstf;
  wc;

  // the other cache write - goes to invalid
  $display ("Other cache write - to invalid");
  wc; // go to CCARB
  wc; // go to CCSNP
  scc(1'b1, 1'b1, 32'h00000000);
  wc; // go to CCRTC
  disp;
  wc; // go to CCREQ
  rstf;
  wc;

  // store to 0b0004 - not served
  $display ("Saving 1 word (loading) - not served");
  sw(32'h00000004, 32'hB0B0B0B0);
  wc; // output cctrans and ccwrite
  disp;
  wc; // go to CCARB
  wc; // go to CCSNP
  scc(1'b1, 1'b1, 32'h00000004);
  wc; // go to CCRTC
  disp;
  wc; // go to CCREQ
  scc(1'b0, 1'b0, 32'h00000000);
  wc;
  // store to 0b0004, continued - gets served
  // read, miss followed by hit
  $display ("Saving 1 word (loading) - served");
  disp;
  wc; // go to CCARB
  wc; // go to CCSNP
  scc(1'b1, 1'b0, 32'h00000000);
  wc; // go to CCRTC
  disp;
  lm(32'hAAAAAAAA);
  wc; // wait for load
  disp;
  lm(32'hBBBBBBBB);
  wc; // wait for load
  wc; // go to CCREQ
  scc(1'b0, 1'b0, 32'h00000000);
  wc;
  // store to 0b0004, continued - gets served
  // store, hit
  $display ("Saving 1 word (storing) - served");
  disp;
  wc; // go to CCARB
  wc; // go to CCSNP
  scc(1'b1, 1'b0, 32'h00000004);
  wc; // go to CCRTC
  disp;
  wc; // go to CCREQ
  rstf;
  wc;
  wc;

  // the other cache write - goes to invalid
  // write back
  $display ("Other cache write - to invalid");
  wc; // go to CCARB
  wc; // go to CCSNP
  scc(1'b1, 1'b1, 32'h00000000);
  wc; // go to CCCTC
  disp;
  sm;
  disp;
  sm;
  disp;
  wc; // go to CCREQ
  rstf;
  wc;

  // flush
  flush;

end
endprogram
