//interface include
`include "exmmpipe_if.vh"

//include types
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

module exmmpipe (
  input logic CLK, nRST,
  exmmpipe_if.ex exif,
  exmmpipe_if.mm mmif
);

  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;

  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) begin
      mmif.opfunc <= opfunc_t'('0);
      mmif.MemtoReg <= memtoreg_t'('0);
      mmif.RegWEN <= '0;
      mmif.dWENi <= '0;
      mmif.dRENi <= '0;
      mmif.equal <= '0;
      mmif.halt <= '0;
      mmif.rd <= regbits_t'('0);
      mmif.portB <= word_t'('0);
      mmif.npc <= word_t'('0);
      mmif.ALUOut <= word_t'(0);
      mmif.store <= word_t'(0);
    end else if (exif.ihit) begin
      mmif.opfunc <= exif.opfunc;
      mmif.MemtoReg <= exif.MemtoReg;
      mmif.RegWEN <= exif.RegWEN;
      mmif.dWENi <= exif.dWENi;
      mmif.dRENi <= exif.dRENi;
      mmif.equal <= exif.equal;
      mmif.halt <= exif.halt;
      mmif.rd <= exif.rd;
      mmif.portB <= exif.portB;
      mmif.npc <= exif.npc;
      mmif.ALUOut <= exif.ALUOut;
      mmif.store <= exif.store;
    end else if (mmif.dhit) begin
      mmif.opfunc <= opfunc_t'('0);
      mmif.MemtoReg <= memtoreg_t'('0);
      mmif.RegWEN <= '0;
      mmif.dWENi <= '0;
      mmif.dRENi <= '0;
      mmif.equal <= '0;
      mmif.halt <= '0;
      mmif.rd <= regbits_t'('0);
      mmif.portB <= word_t'('0);
      mmif.npc <= word_t'('0);
      mmif.ALUOut <= word_t'(0);
      mmif.store <= word_t'(0);
    end
  end

endmodule
