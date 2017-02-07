/*
  Yiheng Chi
  chi14@purdue.edu

  register file source code
*/

// import necessary files
`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

// register_file module
module register_file(
  input logic CLK, nRST,
  register_file_if.rf rfif
);

// import types
import cpu_types_pkg::*;

// declare unpacked regs
word_t regs [31:0];

// register_file's write logic
always_ff @ (negedge CLK, negedge nRST) begin
  if (nRST == 0) begin
    regs <= '{default:'0}; // why default?
  end else if (rfif.WEN != 0 && rfif.wsel != 0) begin
    regs[rfif.wsel] <= rfif.wdat;
  end // take care of else condition?
end

// register_file's read logic
always_comb begin
  rfif.rdat1 = regs[rfif.rsel1];
  rfif.rdat2 = regs[rfif.rsel2];
end

endmodule
