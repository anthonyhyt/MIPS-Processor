/*
  Yiheng Chi
  chi14@purdue.edu

  branch buffer interface
*/
`ifndef BRANCH_BUFFER_IF_VH
`define BRANCH_BUFFER_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"
`include "branch_buffer_types_pkg.vh"

interface branch_buffer_if;

  // import types
  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;
  import branch_buffer_types_pkg::*;

  // input signals for branch buffer
  opfunc_t MMopfunc;
  word_t MMbpc, MMpc;
  logic [1:0] IFpcindex;
  // output signals for branch buffer
  word_t PRbpc;
  tag_t PRtag;
  logic PRvalid;

  modport bb (
    input MMopfunc, MMbpc, MMpc, IFpcindex,
    output PRbpc, PRtag, PRvalid
  );

  modport tb (
    input PRbpc, PRtag, PRvalid,
    output MMopfunc, MMbpc, MMpc, IFpcindex
  );

endinterface

`endif //BRANCH_BUFFER_IF_VH
