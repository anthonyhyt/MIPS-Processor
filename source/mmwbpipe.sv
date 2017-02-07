`include "mmwbpipe_if.vh"

//include types
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

module mmwbpipe (
  input logic CLK, nRST,
  mmwbpipe_if.mm mmif,
  mmwbpipe_if.wb wbif
);

  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;

  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) begin
      wbif.opfunc <= opfunc_t'('0);
      wbif.MemtoReg <= memtoreg_t'('0);
      wbif.RegWEN <= '0;
      wbif.equal <= '0;
      wbif.halt <= '0;
      wbif.rd <= regbits_t'('0);
      wbif.portB <= word_t'('0);
      wbif.npc <= word_t'('0);
      wbif.ALUOut <= word_t'('0);
      wbif.load <= word_t'('0);
    end else if (mmif.ihit) begin
      wbif.opfunc <= mmif.opfunc;
      wbif.MemtoReg <= mmif.MemtoReg;
      wbif.RegWEN <= mmif.RegWEN;
      wbif.equal <= mmif.equal;
      wbif.halt <= mmif.halt;
      wbif.rd <= mmif.rd;
      wbif.portB <= mmif.portB;
      wbif.npc <= mmif.npc;
      wbif.ALUOut <= mmif.ALUOut;
    end else if (mmif.dhit) begin
      wbif.load <= mmif.load;
    end
  end

endmodule
