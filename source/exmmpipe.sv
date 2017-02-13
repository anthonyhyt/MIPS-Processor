//interface include
`include "exmmpipe_if.vh"

//include types
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

import cpu_types_pkg::*;
import control_unit_types_pkg::*;

module exmmpipe (
  input logic CLK, nRST,
  input word_t ininstr,
  output word_t outinstr,
  exmmpipe_if.ex exif,
  exmmpipe_if.mm mmif
);

  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) begin
      outinstr <= '0;
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
    end else if (exif.en) begin
      if (exif.flush) begin
        outinstr <= '0;
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
      end else begin
        outinstr <= ininstr;
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
      end
    end
  end

endmodule
