/*
  Yiheng Chi
  chi14@purdue.edu

  hazard control unit interface
*/
`ifndef HAZARD_CONTROL_UNIT_IF_VH
`define HAZARD_CONTROL_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"
`include "hazard_control_unit_types_pkg.vh"

interface hazard_control_unit_if;

  // import types
  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;
  import hazard_control_unit_types_pkg::*;

  // input signals for hazard control unit
  regbits_t IDrs, IDrt, EXrt;
  opfunc_t IDopfunc, EXopfunc, MMopfunc;
  logic ihit, dhit, MMequal;
  // input signals added for branch predictor
  logic PRtaken, MMtaken;
  // output signals for hazard control unit
  pcselect_t PCselect;
  logic PCEN, IFIDEN, IDEXEN, EXMMEN, MMWBEN;
  logic IFIDflush, IDEXflush, EXMMflush;
  // output signals added for branch predictor
  logic ABtaken;

  modport hc (
    input IDrs, IDrt, EXrt, IDopfunc, EXopfunc, MMopfunc,
    input ihit, dhit, MMequal, PRtaken, MMtaken,
    output PCselect, PCEN, IFIDEN, IDEXEN, EXMMEN, MMWBEN,
    output IFIDflush, IDEXflush, EXMMflush, ABtaken
  );

  modport tb (
    input PCselect, PCEN, IFIDEN, IDEXEN, EXMMEN, MMWBEN,
    input IFIDflush, IDEXflush, EXMMflush, ABtaken,
    output IDrs, IDrt, EXrt, IDopfunc, EXopfunc, MMopfunc,
    output ihit, dhit, MMequal, PRtaken, MMtaken
  );

endinterface

`endif //HAZARD_CONTROL_UNIT_IF_VH
