`ifndef EXMMPIPE_IF_VH
`define EXMMPIPE_IF_VH

`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

interface exmmpipe_if;

  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;

  //control signal
  opfunc_t opfunc;
  memtoreg_t MemtoReg;
  logic RegWEN, dWENi, dRENi, en, equal;
  logic halt, flush, taken, datomic;

  //register signal
  regbits_t rd;

  //pipeline signal
  word_t portB, npc, bpc, ALUOut, store;

  modport ex (
    input opfunc, MemtoReg, RegWEN,
          dWENi, dRENi, en, equal, halt, taken, datomic,
          rd, portB, npc, bpc, ALUOut, store, flush
  );

  modport mm (
    output opfunc, MemtoReg, RegWEN,
          dWENi, dRENi, equal, halt, taken, datomic,
          rd, portB, npc, bpc, ALUOut, store
  );

endinterface

`endif //"EXMMPIPE_IF_VH"
