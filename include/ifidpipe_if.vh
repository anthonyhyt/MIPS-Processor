`ifndef IFIDPIPE_IF_VH
`define IFIDPIPE_IF_VH

`include "cpu_types_pkg.vh"

interface ifidpipe_if;

  import cpu_types_pkg::*;

  logic flush, en, taken;
  word_t instr, npc;

  modport instr_f (
    input instr, npc, en, flush, taken
  );

  modport id (
    output instr, npc, taken
  );

endinterface

`endif //"IFIDPIPE_IF_VH"

