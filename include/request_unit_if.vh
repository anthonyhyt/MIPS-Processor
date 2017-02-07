/*
  Yiheng Chi
  chi14@purdue.edu

  request unit interface
*/
`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface request_unit_if;
  // import types
  import cpu_types_pkg::*;

  // output signals for request unit
  logic     dRENo, dWENo, iRENo;
  // input signals for request unit
  logic     dRENi, dWENi;
  logic     ihit, dhit;

  // request unit ports
  modport ru (
    input   dRENi, dWENi, ihit, dhit,
    output  dRENo, dWENo, iRENo
  );
  // request unit tb
  modport tb (
    input   dRENo, dWENo, iRENo,
    output  dRENi, dWENi, ihit, dhit
  );
endinterface

`endif //REQUEST_UNIT_IF_VH
