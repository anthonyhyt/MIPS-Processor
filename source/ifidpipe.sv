//interface include
`include "ifidpipe_if.vh"

module ifidpipe (
  input logic CLK, nRST,
  ifidpipe_if.instr_f ifif,
  ifidpipe_if.id idif
);

  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) begin
      idif.instr <= '0;
      idif.npc <= '0;
    end else if (ifif.en) begin
      if (ifif.flush) begin
        idif.instr <= '0;
        idif.npc <= '0;
      end else begin
        idif.instr <= ifif.instr;
        idif.npc <= ifif.npc;
      end
    end
  end

endmodule
