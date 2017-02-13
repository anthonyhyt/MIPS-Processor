`include "mmwbpipe_if.vh"

//include types
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

import cpu_types_pkg::*;
import control_unit_types_pkg::*;

module mmwbpipe (
  input logic CLK, nRST,
  input word_t ininstr,
  output word_t outinstr,
  mmwbpipe_if.mm mmif,
  mmwbpipe_if.wb wbif
);

  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) begin
      outinstr <= '0;
      wbif.MemtoReg <= memtoreg_t'('0);
      wbif.RegWEN <= '0;
      wbif.equal <= '0;
      wbif.halt <= '0;
      wbif.rd <= regbits_t'('0);
      wbif.portB <= word_t'('0);
      wbif.npc <= word_t'('0);
      wbif.ALUOut <= word_t'('0);
      wbif.load <= word_t'('0);
    end else if (mmif.en) begin
      outinstr <= ininstr;
      wbif.MemtoReg <= mmif.MemtoReg;
      wbif.RegWEN <= mmif.RegWEN;
      wbif.equal <= mmif.equal;
      wbif.halt <= mmif.halt;
      wbif.rd <= mmif.rd;
      wbif.portB <= mmif.portB;
      wbif.npc <= mmif.npc;
      wbif.ALUOut <= mmif.ALUOut;
      wbif.load <= mmif.load;
    end
  end

endmodule
