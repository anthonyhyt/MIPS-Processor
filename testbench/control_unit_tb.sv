/*
  Yiheng Chi
  chi14@purdue.edu

  control unit test bench
*/

// interface
`include "control_unit_if.vh"

// types
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

// mapped timing needs this
`timescale 1 ns / 1 ns

module control_unit_tb;

  // import types
  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;

  // clock period
  parameter PERIOD = 10;

  // signals
  logic CLK = 0, nRST;
  r_t rti;
  i_t iti;
  j_t jti;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  control_unit_if c();
  // test program
  test PROG(c);
  // DUT
  control_unit DUT(c);

  task init;
    begin
      cuif.instr = '0;
    end
  endtask

  task dispr;
    begin
      $display ("R type instr:");
      $display ("opcode: %b, rs: %b, rt: %b, rd: %b, shamt: %b, funct %b",
                rti.opcode, rti.rs, rti.rt, rti.rd, rti.shamt, rti.funct);
    end
  endtask

  task dispi;
    begin
      $display ("I type instr:");
      $display ("opcode: %b, rs: %b, rt: %b, imm: %b", iti.opcode, iti.rs,
                iti.rt, iti.imm);
    end
  endtask

  task dispj;
    begin
      $display ("J type instr");
      $display ("opcode: %b, addr: %b", jti.opcode, jti.addr);
    end
  endtask

  task dispo;
    begin
      $display ("Output:");
      $display ("RegDst: %b, ALUSrc: %b, MemtoReg: %b, RegWEN: %b, dWENi: %b, dRENi: %b",
                c.RegDst, c.ALUSrc, c.MemtoReg, c.RegWEN,
                c.dWENi, c.dRENi);
      $display ("opfunc: %b, ALUOp: %b, ExtOp: %b, halt: %b", c.opfunc,
                c.ALUOp, c.ExtOp, c.halt);
      $display("");
    end
  endtask

  task testr;
    input funct_t funct;
    begin
      rti.opcode = RTYPE;
      rti.rs = 1;
      rti.rt = 2;
      rti.rd = 3;
      rti.shamt = 2;
      rti.funct = funct;
      c.instr = word_t'(rti);
      @(negedge CLK);
      @(posedge CLK);
    end
  endtask

  task testi;
    input opcode_t opcode;
    begin
      iti.opcode = opcode;
      iti.rs = 5;
      iti.rt = 6;
      iti.imm = '1;
      c.instr = word_t'(iti);
      @(negedge CLK);
      @(posedge CLK);
    end
  endtask

  task testj;
    input opcode_t opcode;
    begin
      jti.opcode = opcode;
      jti.addr = '1;
      c.instr = word_t'(jti);
      @(negedge CLK);
      @(posedge CLK);
    end
  endtask

endmodule

program test (
  control_unit_if.tb c
);
  import cpu_types_pkg::*;
initial
begin
  init;

  // Test all R type
  testr(SLL);
  dispr;
  dispo;
  testr(SRL);
  dispr;
  dispo;
  testr(JR);
  dispr;
  dispo;
  testr(ADD);
  dispr;
  dispo;
  testr(ADDU);
  dispr;
  dispo;
  testr(SUB);
  dispr;
  dispo;
  testr(SUBU);
  dispr;
  dispo;
  testr(AND);
  dispr;
  dispo;
  testr(OR);
  dispr;
  dispo;
  testr(XOR);
  dispr;
  dispo;
  testr(NOR);
  dispr;
  dispo;
  testr(SLT);
  dispr;
  dispo;
  testr(SLTU);
  dispr;
  dispo;

  // Test all I type
  testi(BEQ);
  dispi;
  dispo;
  testi(BNE);
  dispi;
  dispo;
  testi(ADDI);
  dispi;
  dispo;
  testi(ADDIU);
  dispi;
  dispo;
  testi(SLTI);
  dispi;
  dispo;
  testi(SLTIU);
  dispi;
  dispo;
  testi(ANDI);
  dispi;
  dispo;
  testi(ORI);
  dispi;
  dispo;
  testi(XORI);
  dispi;
  dispo;
  testi(LUI);
  dispi;
  dispo;
  testi(LW);
  dispi;
  dispo;
  testi(SW);
  dispi;
  dispo;
  testi(HALT);
  dispi;
  dispo;

  // Test all J type
  testj(J);
  dispj;
  dispo;
  testj(JAL);
  dispj;
  dispo;
end

endprogram
