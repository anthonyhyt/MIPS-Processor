`ifndef PREDICTOR_IF_VH
`define PREDICTOR_IF_VH

`include "control_unit_types_pkg.vh"

interface predictor_if;

  import control_unit_types_pkg::*;

  logic ABtaken, PRresult;
  logic [1:0] ifprindex, mmprindex;
  opfunc_t opfunc;

  modport bp (
    input ABtaken, ifprindex, mmprindex, opfunc,
    output PRresult
  );

  modport tb (
    input PRresult,
    output ABtaken, ifprindex, mmprindex, opfunc
  );

endinterface

`endif  //PREDICTOR_IF_VH
