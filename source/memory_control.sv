/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input logic CLK, nRST,
  cache_control_if ccif
);

  coherence_control CC(CLK, nRST, ccif);
/*
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;


  // ready signals - inverse of wait signals
  logic [CPUS-1:0] iready, dready;
  assign ccif.iwait = ~iready;
  assign ccif.dwait = ~dready;

  // cache outputs
  assign iready = (ccif.iREN & ~ccif.dREN & ~ccif.dWEN) &
                  (ccif.ramstate == ACCESS);
  assign dready = (ccif.dREN | ccif.dWEN) &
                  (ccif.ramstate == ACCESS);
  assign ccif.iload = ccif.ramload;
  assign ccif.dload = ccif.ramload;

  // ram outputs
  assign ccif.ramstore = ccif.dstore;
  assign ccif.ramaddr = (ccif.dREN | ccif.dWEN) ? ccif.daddr : ccif.iaddr;
  assign ccif.ramWEN = ccif.dWEN;
  assign ccif.ramREN = (ccif.iREN | ccif.dREN) & ~ccif.dWEN;

  // coherence outputs to cache - unused for singlecycle
  assign ccif.ccwait = '0;
  assign ccif.ccinv = '0;
  assign ccif.ccsnoopaddr = '0;
*/

endmodule
