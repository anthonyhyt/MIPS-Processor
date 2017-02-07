`ifndef "MMWBPIPE_IF_VH"
`define "MMWBPIPE_IF_VH"

`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

interface mmwbpipe_if;

  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;

  //control signal
  opfunc_t opfunc;
  memtoreg_t MemtoReg;
  logic RegWEN, ihit, dhit, equal;
  logic halt;

  //register signal
  regbits_t rd;

  //pipeline signal
  word_t portB, npc, ALUOut, load;

  modport mm (
    input opfunc, MemtoReg, RegWEN,
          ihit, dhit, equal, halt,
          rd, portB, npc, ALUOut, load
  );

  modport wb (
    output opfunc, MemtoReg, RegWEN, equal, halt,
          rd, portB, npc, ALUOut, load
  );

endinterface

`endif //"MMWBPIPE_IF_VH"
