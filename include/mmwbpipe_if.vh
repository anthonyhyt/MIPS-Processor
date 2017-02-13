`ifndef "MMWBPIPE_IF_VH"
`define "MMWBPIPE_IF_VH"

`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

interface mmwbpipe_if;

  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;

  //control signal
  memtoreg_t MemtoReg;
  logic RegWEN, en, equal;
  logic halt;

  //register signal
  regbits_t rd;

  //pipeline signal
  word_t portB, npc, ALUOut, load;

  modport mm (
    input MemtoReg, RegWEN,
          en, equal, halt,
          rd, portB, npc, ALUOut, load
  );

  modport wb (
    output MemtoReg, RegWEN, equal, halt,
          rd, portB, npc, ALUOut, load
  );

endinterface

`endif //"MMWBPIPE_IF_VH"
