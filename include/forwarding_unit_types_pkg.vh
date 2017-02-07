/*
  Yiheng Chi
  chi14@purdue.edu

  types for forwarding unit
*/
`ifndef FORWARDING_UNIT_TYPES_PKG_VH
`define FORWARDING_UNIT_TYPES_PKG_VH
package forwarding_unit_types_pkg;

  // forward mux A control signal choices
  typedef enum logic [1:0] {
    FABUSA,
    FABUSW,
    FAALU,
    FAPORTB
  } fwda_t;

  // forward mux B control signal choices
  typedef enum logic [1:0] {
    FBBUSB,
    FBBUSW,
    FBALU,
    FBPORTB
  } fwdb_t;

endpackage
`endif //FORWARDING_UNIT_TYPES_PKG_VH
