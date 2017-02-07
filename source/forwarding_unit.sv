/*
  Yiheng Chi
  chi14@purdue.edu

  forwarding unit source code
*/

// interface include
`include "forwarding_unit_if.vh"

// include types
`include "cpu_types_pkg.vh"
`include "forwarding_unit_types_pkg.vh"

module forwarding_unit (
  forwarding_unit_if.fu fuif
);
  // type import
  import cpu_types_pkg::*;
  import forwarding_unit_types_pkg::*;

  // boolean signales
  logic MMtoRS, MMtoRT, WBtoRS, WBtoRT;

  // assign boolean
  assign MMtoRS  = (fuif.MMregWEN == 1'b1 && fuif.MMrd != 0 &&
                    fuif.MMrd == fuif.EXrs) ? 1'b1 : 1'b0;
  assign MMtoRT  = (fuif.MMregWEN == 1'b1 && fuif.MMrd != 0 &&
                    fuif.MMrd == fuif.EXrt) ? 1'b1 : 1'b0;
  assign WBtoRS  = (!MMtoRS && fuif.WBregWEN == 1'b1 && fuif.WBrd != 0 &&
                    fuif.WBrd == fuif.EXrs) ? 1'b1 : 1'b0;
  assign WBtoRT  = (!MMtoRT && fuif.WBregWEN == 1'b1 && fuif.WBrd != 0 &&
                    fuif.WBrd == fuif.EXrt) ? 1'b1 : 1'b0;

  // assign output signals based on input
  always_comb begin
    // rs
    if (MMtoRS == 1'b1) begin
      if (fuif.MMisLUI == 1'b1) fuif.fwdA = FAPORTB;
      else fuif.fwdA = FAALU;
    end else if (WBtoRS == 1'b1) fuif.fwdA = FABUSW;
    else fuif.fwdA = FABUSA;
    // rt
    if (MMtoRT == 1'b1) begin
      if (fuif.MMisLUI == 1'b1) fuif.fwdB = FBPORTB;
      else fuif.fwdB = FBALU;
    end else if (WBtoRT == 1'b1) fuif.fwdB = FBBUSW;
    else fuif.fwdB = FBBUSB;
  end

endmodule
