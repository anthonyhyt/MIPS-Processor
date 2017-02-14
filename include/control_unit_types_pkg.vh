/*
  Yiheng Chi
  chi14@purdue.edu

  types for control unit
*/
`ifndef CONTROL_UNIT_TYPES_PKG_VH
`define CONTROL_UNIT_TYPES_PKG_VH
package control_unit_types_pkg;

  // RegDst (rw input MUX control signal) choices
  typedef enum logic [1:0] {
    RD,
    RT,
    R31,
    RERROR
  } regdst_t;

  // MemtoReg (busW input MUX control signal) choices
  typedef enum logic [1:0] {
    ALUO,
    DLOAD,
    PORTB,
    NPC
  } memtoreg_t;

  // ExtOp (extender mode control signal) choices
  typedef enum logic [1:0] {
    ZEROEXT,
    SIGNEXT,
    SHAMEXT,
    LUIEXT
  } extop_t;

  // opfunc (opcode/funct) choices
  typedef enum logic [3:0] {
    OJUNK,
    OJR,
    OSL,
    OBEQ,
    OBNE,
    OSW,
    OLW,
    OLUI,
    OJ,
    OJAL,
    OTHERR,
    OTHERI,
    OTHERJ,
    OERROR13,
    OERROR14,
    OERROR15
  } opfunc_t;

endpackage
`endif //CONTROL_UNIT_TYPES_PKG_VH
