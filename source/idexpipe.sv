//interface include
`include "idexpipe_if.vh"

//include types
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

module idexpipe (
  input logic CLK, nRST,
  idexpipe_if.id idif,
  idexpipe_if.ex exif
);

  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) begin
      exif.opfunc <= opfunct'('0);
      exif.RegDst <= regdst'('0);
      exif.MemtoReg <= memtoreg_t'('0);
      exif.ALUSrc <= '0;
      exif.RegWEN <= '0;
      exif.dWENi <= '0;
      exif.dRENi <= '0;
      exif.ALUop <= aluop_t'('0);
      exif.ExtOp <= extop_t'('0);
      exif.halt <= '0;
      exif.rt <= regbits_t'('0);
      exif.rd <= regbits_t'('0);
      exif.shamt <= '0;
      exif.imm <= '0;
    end else if (idif.ihit) begin
      exif.opfunc <= idif.opfunc;
      exif.RegDst <= idif.RegDst;
      exif.MemtoReg <= idif.MemtoReg;
      exif.ALUSrc <= idif.ALUSrc;
      exif.RegWEN <= idif.RegWEN;
      exif.dWENi <= idif.dWENi;
      exif.dRENi <= idif.dRENi;
      exif.ALUop <= idif.ALUOp;
      exif.ExtOp <= idif.ExtOp;
      exif.halt <= idif.halt;
      exif.rt <= idif.rt;
      exif.rd <= idif.rd;
      exif.shamt <= idif.shamt;
      exif.imm <= idif.imm;
    end
  end

endmodule
