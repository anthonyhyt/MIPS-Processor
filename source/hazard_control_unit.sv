/*
  Yiheng Chi
  chi14@purdue.edu

  hazard control unit source code
*/

// interface include
`include "hazard_control_unit_if.vh"

// include types
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"
`include "hazard_control_unit_types_pkg.vh"

module hazard_control_unit (
  hazard_control_unit_if.hc hcif
);
  // import types
  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;
  import hazard_control_unit_types_pkg::*;

  // local signals
  opfunc_t o;
  logic use_s_t,    use_s;
  logic lduse_s,    lduse_t;
  logic hzd_lwsw,   hzd_lduse,  hzd_br;
  logic hzd_jr,     hzd_j,      hzd_jal;

  // assign local signals
  assign o = hcif.IDopfunc;

  assign use_s_t = (o == OTHERR || o == OBEQ || o == OBNE);
  assign use_s = (o == OJR || o == OSL || o == OLW || o == OSW || o == OTHERI);

  assign lduse_s = (hcif.IDrs == hcif.EXrt);
  assign lduse_t = (hcif.IDrt == hcif.EXrt);

  assign hzd_lwsw   = (hcif.MMopfunc == OLW || hcif.MMopfunc == OSW);
  assign hzd_lduse  = (hcif.EXopfunc == OLW &&
                      ((use_s_t || use_s) && lduse_s ||
                      use_s_t && lduse_t));
  assign hzd_br     = (hcif.MMopfunc == OBEQ && hcif.MMequal ||
                      hcif.MMopfunc == OBNE && !hcif.MMequal);
  assign hzd_jr     = (hcif.EXopfunc == OJR && !hzd_br);
  assign hzd_j      = (hcif.EXopfunc == OJ && !hzd_br);
  assign hzd_jal    = (hcif.EXopfunc == OJAL && !hzd_br);

  // take care of hazard outputs
  always_comb begin
    hcif.PCselect = PCNPC;
    hcif.PCEN = hcif.ihit;
    hcif.IFIDEN = hcif.ihit;
    hcif.IDEXEN = hcif.ihit;
    hcif.EXMMEN = hcif.ihit;
    hcif.MMWBEN = hcif.ihit;
    hcif.IFIDflush = 1'b0;
    hcif.IDEXflush = 1'b0;
    hcif.EXMMflush = 1'b0;
    if (hzd_lwsw == 1'b1) begin
      hcif.PCEN = hcif.ihit && hcif.dhit;
      hcif.IFIDEN = hcif.ihit && hcif.dhit;
      hcif.IDEXEN = hcif.ihit && hcif.dhit;
      hcif.EXMMEN = hcif.dhit;
      hcif.MMWBEN = hcif.dhit;
      hcif.EXMMflush = !hcif.ihit && hcif.dhit;
    end
    if (hzd_lduse == 1'b1) begin
      hcif.PCEN = 1'b0;
      hcif.IFIDEN = 1'b0;
      hcif.IDEXflush = 1'b1;
    end
    if (hzd_br == 1'b1) begin
      hcif.PCselect = PCBPC;
      hcif.IFIDflush = 1'b1;
      hcif.IDEXflush = 1'b1;
      hcif.EXMMflush = 1'b1;
    end
    if (hzd_jr == 1'b1) begin
      hcif.PCselect = PCPTA;
      hcif.IFIDflush = 1'b1;
      hcif.IDEXflush = 1'b1;
    end
    if (hzd_j == 1'b1 || hzd_jal == 1'b1) begin
      hcif.PCselect = PCJPC;
      hcif.IFIDflush = 1'b1;
      hcif.IDEXflush = 1'b1;
    end
  end

endmodule
