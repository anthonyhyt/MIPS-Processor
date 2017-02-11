/*
  Yiheng Chi
  chi14@purdue.edu

  types for hazard control unit
*/
`ifndef HAZARD_CONTROL_UNIT_TYPES_PKG_VH
`define HAZARD_CONTROL_UNIT_TYPES_PKG_VH

package hazard_control_unit_types_pkg;

  // PCselect (next PC input MUX control signal) choices
  typedef enum logic [1:0] {
    PCNPC,
    PCBPC,
    PCJPC,
    PCPTA
  } pcselect_t;

endpackage

`endif //HAZARD_CONTROL_UNIT_TYPES_PKG_VH
