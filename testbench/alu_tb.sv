/*
  Yiheng Chi
  chi14@purdue.edu

  arithmetic logic unit test bench
*/

// import necessary files
`include "alu_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1 ns is too fast (?)
`timescale 1 ns / 1 ns

// import types
import cpu_types_pkg::*;

module alu_tb;

  parameter PERIOD = 10;

  logic CLK = 0;
  logic [31:0] tb_o;
  //integer tb_index;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_if a();
  // test program
  test PROG(a);
  // DUT
`ifndef MAPPED
  alu DUT(a);
`else
  alu DUT(
    .\a.flag_negative (a.flag_negative),
    .\a.flag_overflow (a.flag_overflow),
    .\a.flag_zero (a.flag_zero),
    .\a.aluop (a.aluop),
    .\a.port_a (a.port_a),
    .\a.port_b (a.port_b),
    .\a.port_o (a.port_o)
  );
`endif

  // initialize signals
  task init;
    begin
      a.flag_negative = 1'b0;
      a.flag_overflow = 1'b0;
      a.flag_zero = 1'b0;
      a.aluop = ALU_ADD;
      a.port_a = 32'b0;
      a.port_b = 32'b0;
      a.port_o = 32'b0;
    end
  endtask

  // tests
  task test_SLL;
    input [31:0] pa;
    input [31:0] pb;
    begin
      tb_o = pa << pb;
      #(1*PERIOD);
      a.port_a = pa;
      a.port_b = pb;
      a.aluop = ALU_SLL;
      #(1*PERIOD);
      assert (tb_o == a.port_o)
        $display ("SLL test passed: %d << %d", pa, pb);
      else
        $error ("SLL test failed: %d << %d", pa, pb);
      $display ("Flag bits: %1d %1d %1d", a.flag_negative, a.flag_overflow, a.flag_zero);
    end
  endtask

  task test_SRL;
    input [31:0] pa;
    input [31:0] pb;
    begin
      tb_o = pa >> pb;
      #(1*PERIOD);
      a.port_a = pa;
      a.port_b = pb;
      a.aluop = ALU_SRL;
      #(1*PERIOD);
      assert (tb_o == a.port_o)
        $display ("SRL test passed: %d >> %d", pa, pb);
      else
        $error ("SRL test failed: %d >> %d", pa, pb);
      $display ("Flag bits: %1d %1d %1d", a.flag_negative, a.flag_overflow, a.flag_zero);
    end
  endtask

  task test_ADD;
    input [31:0] pa;
    input [31:0] pb;
    begin
      tb_o = pa + pb;
      #(1*PERIOD);
      a.port_a = pa;
      a.port_b = pb;
      a.aluop = ALU_ADD;
      #(1*PERIOD);
      assert (tb_o == a.port_o)
        $display ("ADD test passed: %d + %d", pa, pb);
      else
        $error ("ADD test failed: %d + %d", pa, pb);
      $display ("Flag bits: %1d %1d %1d", a.flag_negative, a.flag_overflow, a.flag_zero);
    end
  endtask

  task test_SUB;
    input [31:0] pa;
    input [31:0] pb;
    begin
      tb_o = pa - pb;
      #(1*PERIOD);
      a.port_a = pa;
      a.port_b = pb;
      a.aluop = ALU_SUB;
      #(1*PERIOD);
      assert (tb_o == a.port_o)
        $display ("SUB test passed: %d - %d", pa, pb);
      else
        $error ("SUB test failed: %d - %d", pa, pb);
      $display ("Flag bits: %1d %1d %1d", a.flag_negative, a.flag_overflow, a.flag_zero);
    end
  endtask

  task test_AND;
    input [31:0] pa;
    input [31:0] pb;
    begin
      tb_o = pa & pb;
      #(1*PERIOD);
      a.port_a = pa;
      a.port_b = pb;
      a.aluop = ALU_AND;
      #(1*PERIOD);
      assert (tb_o == a.port_o)
        $display ("AND test passed: %d & %d", pa, pb);
      else
        $error ("AND test failed: %d & %d", pa, pb);
      $display ("Flag bits: %1d %1d %1d", a.flag_negative, a.flag_overflow, a.flag_zero);
    end
  endtask

  task test_OR;
    input [31:0] pa;
    input [31:0] pb;
    begin
      tb_o = pa | pb;
      #(1*PERIOD);
      a.port_a = pa;
      a.port_b = pb;
      a.aluop = ALU_OR;
      #(1*PERIOD);
      assert (tb_o == a.port_o)
        $display ("OR test passed: %d | %d", pa, pb);
      else
        $error ("OR test failed: %d | %d", pa, pb);
      $display ("Flag bits: %1d %1d %1d", a.flag_negative, a.flag_overflow, a.flag_zero);
    end
  endtask

  task test_XOR;
    input [31:0] pa;
    input [31:0] pb;
    begin
      tb_o = pa ^ pb;
      #(1*PERIOD);
      a.port_a = pa;
      a.port_b = pb;
      a.aluop = ALU_XOR;
      #(1*PERIOD);
      assert (tb_o == a.port_o)
        $display ("XOR test passed: %d ^ %d", pa, pb);
      else
        $error ("XOR test failed: %d ^ %d", pa, pb);
      $display ("Flag bits: %1d %1d %1d", a.flag_negative, a.flag_overflow, a.flag_zero);
    end
  endtask

  task test_NOR;
    input [31:0] pa;
    input [31:0] pb;
    begin
      tb_o = ~(pa | pb);
      #(1*PERIOD);
      a.port_a = pa;
      a.port_b = pb;
      a.aluop = ALU_NOR;
      #(1*PERIOD);
      assert (tb_o == a.port_o)
        $display ("NOR test passed: %d ~| %d", pa, pb);
      else
        $error ("NOR test failed: %d ~| %d", pa, pb);
      $display ("Flag bits: %1d %1d %1d", a.flag_negative, a.flag_overflow, a.flag_zero);
    end
  endtask

  task test_SLT;
    input [31:0] pa;
    input [31:0] pb;
    begin
      if ($signed(pa) < $signed(pb))
        tb_o = 1;
      else
        tb_o = 0;
      #(1*PERIOD);
      a.port_a = pa;
      a.port_b = pb;
      a.aluop = ALU_SLT;
      #(1*PERIOD);
      assert (tb_o == a.port_o)
        $display ("SLT test passed: %d < %d", pa, pb);
      else
        $error ("SLT test failed: %d < %d", pa, pb);
      $display ("Flag bits: %1d %1d %1d", a.flag_negative, a.flag_overflow, a.flag_zero);
    end
  endtask

  task test_SLTU;
    input [31:0] pa;
    input [31:0] pb;
    begin
      if (pa < pb)
        tb_o = 1;
      else
        tb_o = 0;
      #(1*PERIOD);
      a.port_a = pa;
      a.port_b = pb;
      a.aluop = ALU_SLTU;
      #(1*PERIOD);
      assert (tb_o == a.port_o)
        $display ("SLTU test passed: %d < %d", pa, pb);
      else
        $error ("SLTU test failed: %d < %d", pa, pb);
      $display ("Flag bits: %1d %1d %1d", a.flag_negative, a.flag_overflow, a.flag_zero);
    end
  endtask

endmodule

program test(
  alu_if.tb a
);

logic [31:0] tb_a, tb_b;

initial
begin
  init;

  tb_a = 32'h00000007;
  tb_b = 32'h00000007;

  test_SLL(tb_a, tb_b);
  test_SRL(tb_a, tb_b);
  test_ADD(tb_a, tb_b);
  test_SUB(tb_a, tb_b);
  test_AND(tb_a, tb_b);
  test_OR(tb_a, tb_b);
  test_XOR(tb_a, tb_b);
  test_NOR(tb_a, tb_b);
  test_SLT(tb_a, tb_b);
  test_SLTU(tb_a, tb_b);

  tb_a = 32'h80000007;
  tb_b = 32'h00000007;

  test_SLL(tb_a, tb_b);
  test_SRL(tb_a, tb_b);
  test_ADD(tb_a, tb_b);
  test_SUB(tb_a, tb_b);
  test_AND(tb_a, tb_b);
  test_OR(tb_a, tb_b);
  test_XOR(tb_a, tb_b);
  test_NOR(tb_a, tb_b);
  test_SLT(tb_a, tb_b);
  test_SLTU(tb_a, tb_b);

  tb_a = 32'h00000007;
  tb_b = 32'h80000007;

  test_SLL(tb_a, tb_b);
  test_SRL(tb_a, tb_b);
  test_ADD(tb_a, tb_b);
  test_SUB(tb_a, tb_b);
  test_AND(tb_a, tb_b);
  test_OR(tb_a, tb_b);
  test_XOR(tb_a, tb_b);
  test_NOR(tb_a, tb_b);
  test_SLT(tb_a, tb_b);
  test_SLTU(tb_a, tb_b);

  tb_a = 32'h80000007;
  tb_b = 32'h80000007;

  test_SLL(tb_a, tb_b);
  test_SRL(tb_a, tb_b);
  test_ADD(tb_a, tb_b);
  test_SUB(tb_a, tb_b);
  test_AND(tb_a, tb_b);
  test_OR(tb_a, tb_b);
  test_XOR(tb_a, tb_b);
  test_NOR(tb_a, tb_b);
  test_SLT(tb_a, tb_b);
  test_SLTU(tb_a, tb_b);

end

endprogram
