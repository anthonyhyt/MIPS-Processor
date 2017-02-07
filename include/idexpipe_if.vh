`ifndef "IDEXPIPE_IF_VH"
`define "IDEXPIPE_IF_VH"

`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

interface idexpipe_if;

  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;

  //control signal
  opfunc_t opfunc;
  regdst_t RegDst;
  memtoreg_t MemtoReg;
  logic ALUSrc, RegWEN, dWENi, dRENi, ihit;
  aluop_t ALUOp;
  extop_t ExtOp;
  logic halt;

  //register signal and immediate field
  regbits_t rt, rd;
  logic [SHAM_W-1:0]  shamt;
  logic [IMM_W-1:0]   imm;

  //pipeline signal
  word_t busA, busB, npc;

  modport id (
    input opfunc, RegDst, MemtoReg, ALUSrc, RegWEN,
          dWENi, dRENi, ihit, ALUOp, ExtOp, halt,
          rt, rd, shamt, imm, busA, busB, npc
  );

  modport ex (
    output opfunc, RegDst, MemtoReg, ALUSrc, RegWEN,
          dWENi, dRENi, ALUOp, ExtOp, halt,
          rt, rd, shamt, imm, busA, busB, npc
  );

endinterface

`endif //"IDEXPIPE_IF_VH"
