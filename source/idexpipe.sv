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

  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;

  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) begin
      exif.opfunc <= opfunc_t'('0);
      exif.RegDst <= regdst_t'('0);
      exif.MemtoReg <= memtoreg_t'('0);
      exif.ALUSrc <= '0;
      exif.RegWEN <= '0;
      exif.dWENi <= '0;
      exif.dRENi <= '0;
      exif.ALUOp <= aluop_t'('0);
      exif.ExtOp <= extop_t'('0);
      exif.halt <= '0;
      exif.rt <= regbits_t'('0);
      exif.rd <= regbits_t'('0);
      exif.shamt <= '0;
      exif.imm <= '0;
      exif.busB <= word_t'('0);
      exif.busA <= word_t'('0);
      exif.npc <= word_t'('0);
    end else if (idif.en) begin
      exif.opfunc <= idif.opfunc;
      exif.RegDst <= idif.RegDst;
      exif.MemtoReg <= idif.MemtoReg;
      exif.ALUSrc <= idif.ALUSrc;
      exif.RegWEN <= idif.RegWEN;
      exif.dWENi <= idif.dWENi;
      exif.dRENi <= idif.dRENi;
      exif.ALUOp <= idif.ALUOp;
      exif.ExtOp <= idif.ExtOp;
      exif.halt <= idif.halt;
      exif.rt <= idif.rt;
      exif.rd <= idif.rd;
      exif.shamt <= idif.shamt;
      exif.imm <= idif.imm;
      exif.busA <= idif.busA;
      exif.busB <= idif.busB;
      exif.npc <= idif.npc;
    end
  end

endmodule
