`ifndef "IFIDPIPE_IF_VH"
`define "IFIDPIPE_IF_VH"

`include "cpu_types_pkg.vh"

interface ifidpipe_if;

  import cpu_types_pkg::*;

  logic ifiden, ifidflush, ihit;
  word_t instr, npc;

  modport instr_f (
    input instr, npc, ihit
  );

  modport id (
    output instr, npc
  );

endinterface

`endif //"IFIDPIPE_IF_VH"

