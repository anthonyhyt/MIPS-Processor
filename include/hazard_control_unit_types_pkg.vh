/*
  Yiheng Chi
  chi14@purdue.edu

  types for hazard control unit
*/
`ifndef HAZARD_CONTROL_UNIT_TYPES_PKG_VH
`define HAZARD_CONTROL_UNIT_TYPES_PKG_VH

package hazard_control_unit_types_pkg;

  // PCselect (next PC input MUX control signal) choices
  typedef enum logic [2:0] {
    PCNPC,
    PCBPC,
    PCJPC,
    PCPTA,
    PRBPC,
    PRMPC,
    PCERROR6,
    PCERROR7
  } pcselect_t;

endpackage

`endif //HAZARD_CONTROL_UNIT_TYPES_PKG_VH
