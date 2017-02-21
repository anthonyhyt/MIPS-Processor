/*
  Yiheng Chi
  chi14@purdue.edu

  branch buffer source code
*/

// import necessary files
`include "branch_buffer_if.vh"
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"
`include "branch_buffer_types_pkg.vh"

// branch_buffer module
module branch_buffer (
  input logic CLK, nRST,
  branch_buffer_if.bb b
);

  // import types
  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;
  import branch_buffer_types_pkg::*;

  // declare unpacked buffers
  buffer_t bufs [3:0];

  // casted pc
  pc_t MMpc;

  // cast input MMpc
  assign MMpc = pc_t'(b.MMpc);

  // branch_buffer's read logic
  assign b.PRbpc = bufs[b.IFpcindex].buftarget;
  assign b.PRtag = bufs[b.IFpcindex].buftag;
  assign b.PRvalid = bufs[b.IFpcindex].bufvalid;

  // branch_buffer's write logic
  always_ff @ (negedge CLK, negedge nRST) begin
    if (nRST == 0) begin
      bufs <= '{default:'0};
    end else if (b.MMopfunc == OBEQ || b.MMopfunc == OBNE) begin
      bufs[MMpc.pcind].bufvalid <= 1'b1;
      bufs[MMpc.pcind].buftag <= MMpc.pctag;
      bufs[MMpc.pcind].buftarget <= b.MMbpc;
    end
  end

endmodule
