/*
  Yiheng Chi
  chi14@purdue.edu

  arithmetic logic unit interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  logic     flag_negative, flag_overflow, flag_zero;
  aluop_t   aluop;
  word_t    port_a, port_b, port_o;

  // arithmetic logic unit ports
  modport alu (
    input   port_a, port_b, aluop,
    output  port_o, flag_negative, flag_overflow, flag_zero
  );
  // register file tb
  modport tb (
    input  port_o, flag_negative, flag_overflow, flag_zero,
    output   port_a, port_b, aluop
  );
endinterface

`endif //ALU_IF_VH

