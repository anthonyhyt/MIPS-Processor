/*
  Yiheng Chi
  chi14@purdue.edu

  forwarding unit interface
*/
`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "forwarding_unit_types_pkg.vh"

interface forwarding_unit_if;
  // import types
  import cpu_types_pkg::*;
  import forwarding_unit_types_pkg::*;

  // input signals for forwarding unit
  regbits_t EXrs, EXrt;
  regbits_t MMrd, WBrd;
  logic MMregWEN, WBregWEN;
  logic MMisLUI;
  // output signals for forwarding unit
  fwda_t fwdA;
  fwdb_t fwdB;

  modport fu (
    input EXrs, EXrt, MMrd, WBrd, MMregWEN, WBregWEN, MMisLUI,
    output fwdA, fwdB
  );

  modport tb (
    input fwdA, fwdB,
    output EXrs, EXrt, MMrd, WBrd, MMregWEN, WBregWEN, MMisLUI
  );

endinterface

`endif //FORWARDING_UNIT_IF_VH
