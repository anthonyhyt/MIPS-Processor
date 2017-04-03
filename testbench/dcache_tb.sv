/*
  Yiheng chi
  chi14@purdue.edu

  data cache test bench
*/

// interface
`include "caches_if.vh"
`include "datapath_cache_if.vh"
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"

// all types
`include "cpu_types_pkg.vh"

// timing
`timescale 1 ns / 1 ns

module dcache_tb;

  //import types
  import cpu_types_pkg::*;

  // clock period
  parameter PERIOD = 20;

  // signals
  logic CLK = 0, RAM_CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;
  always #(PERIOD/4) RAM_CLK++;

  // interface
  caches_if c [1:0] ();
  cache_control_if cc(c[0], c[1]);
  cpu_ram_if r();

endmodule
