`ifndef IFIDPIPE_IF_VH
`define IFIDPIPE_IF_VH

`include "cpu_types_pkg.vh"

interface ifidpipe_if;

  import cpu_types_pkg::*;

  logic flush, en;
  word_t instr, npc;

  modport instr_f (
    input instr, npc, en, flush
  );

  modport id (
    output instr, npc
  );

endinterface

`endif //"IFIDPIPE_IF_VH"

