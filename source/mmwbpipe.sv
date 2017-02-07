`include "mmwbpipe_if.vh"

//include types
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

module mmwbpipe (
  input logic CLK, nRST,
  mmwbpipe_if.mm mmif,
  mmwbpipe_if.wb wbif
);

  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) begin
      wbif.opfunc <= opfunct'('0);
      wbif.MemtoReg <= memtoreg_t'('0);
      wbif.RegWEN <= '0;
      wbif.equal <= '0
      wbif.halt <= '0;
      wbif.rd <= regbits_t'('0);
      wbif.portB <= word_t'('0);
      wbif.npc <= word_t'('0);
      wbif.ALUOut <= word_t'('0);
      wbif.load <= word_t'('0);
    end else if (mmif.ihit) begin
      wbif.opfunc <= opfunct'('0);
      wbif.MemtoReg <= memtoreg_t'('0);
      wbif.RegWEN <= '0;
      wbif.equal <= '0
      wbif.halt <= '0;
      wbif.rd <= regbits_t'('0);
      wbif.portB <= word_t'('0);
      wbif.npc <= word_t'('0);
      wbif.ALUOut <= word_t'('0);
    end else if (mmif.dhit) begin
      wbif.load <= mmif.load;
    end
  end

endmodule
