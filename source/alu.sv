/*
  Yiheng Chi
  chi14@purdue.edu

  arithmetic logic unit source code
*/

// import necessary files
`include "alu_if.vh"
`include "cpu_types_pkg.vh"

// alu module
module alu(
  alu_if.alu a
);

// import types
import cpu_types_pkg::*;

assign a.flag_negative = a.port_o[31];
assign a.flag_zero = (a.port_o == 0) ? 1'b1 : 1'b0;

// alu's combinational logic
always_comb begin
  a.flag_overflow = 1'b0;
  //a.flag_negative = a.port_o[31];
  //a.flag_zero = (a.port_o == 32'b0);
  casez(a.aluop)
    ALU_SLL: begin
      a.port_o = a.port_a << a.port_b;
    end
    ALU_SRL: begin
      a.port_o = a.port_a >> a.port_b;
    end
    ALU_ADD: begin
      a.port_o = a.port_a + a.port_b;
      a.flag_overflow = (a.port_a[31]~^a.port_b[31]) && (a.port_a[31]^a.port_o[31]);
      // (a xnor b) and (a xor o)
    end
    ALU_SUB: begin
      a.port_o = a.port_a - a.port_b;
      a.flag_overflow = (a.port_a[31]^a.port_b[31]) && (a.port_a[31]^a.port_o[31]);
      // (a xor b) and (a xor o)
    end
    ALU_AND: begin
      a.port_o = a.port_a & a.port_b;
    end
    ALU_OR: begin
      a.port_o = a.port_a | a.port_b;
    end
    ALU_XOR: begin
      a.port_o = a.port_a ^ a.port_b;
    end
    ALU_NOR: begin
      a.port_o = ~(a.port_a | a.port_b);
    end
    ALU_SLT: begin
      a.port_o = 32'b0;
      a.port_o[0] = $signed(a.port_a) < $signed(a.port_b);
    end
    ALU_SLTU: begin
      a.port_o = 32'b0;
      a.port_o[0] = a.port_a < a.port_b;
    end
    default: begin
      a.port_o = 32'b0;
    end
  endcase
end

endmodule

