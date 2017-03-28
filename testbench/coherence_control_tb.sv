// interface
`include "caches_if.vh"
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"

// types
`include "cpu_types_pkg.vh"

`timescale 1 ns/1 ns

module coherence_control_tb;

  localparam PERIOD = 20;

  // clk and reset signal
  logic CLK = 1, RAM_CLK = 1, nRST;

  // clock generation
  always #(PERIOD/2) CLK++;
  always #(PERIOD/4) RAM_CLK++;

  // interface
  caches_if cif [1:0] ();
  cache_control_if ccif(cif[0], cif[1]);
  cpu_ram_if ramif();

  // test program
  test PROG(CLK, nRST, cif);

  // DUT and ram
  coherence_control DUT(CLK, nRST, ccif);
  ram RAM(RAM_CLK, nRST, ramif);

  // DUT to RAM wires connection
  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramstore = ccif.ramstore;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;
  assign ccif.ramstate = ramif.ramstate;
  assign ccif.ramload = ramif.ramload;

endmodule

program test(
  input logic CLK,
  output logic nRST,
  caches_if cif [1:0]
);

  import cpu_types_pkg::*;
  localparam PERIOD = 20;

  typedef enum logic [1:0] {
    I = '0, S = 2'b10, M = '1
  } msi_t;

  msi_t core [1:0];
  logic working, readOrWrite1, readOrWrite2;
  integer testcases;
  word_t dload1, dload2, iload1, iload2;

  initial
  begin
    init;
    working = 1;
    fork
    begin
      msiSignalOutput(core[0], readOrWrite1, cif[0].ccwait, cif[0].cctrans, cif[0].ccwrite);
      msiSignalOutput(core[1], readOrWrite2, cif[1].ccwait, cif[1].cctrans, cif[1].ccwrite);
    end
    begin
      //pure write request from core 1 to mem addr 0x00000000
      testcases++;
      core[0] = M;
      readOrWrite1 = 1;
      dreq1(readOrWrite1, 32'h00000000, 32'h12345678, dload1);
      core[0] = I;
      //pure write request from core 2 to mem addr 0x00000004
      testcases++;
      core[1] = M;
      readOrWrite2 = 1;
      dreq2(readOrWrite2, 32'h00000004, 32'h87654321, dload2);
      core[1] = I;

      //read request from both core at mem addr 0x00000000
      testcases++;
      readOrWrite1 = 0;
      readOrWrite2 = 0;
      fork
      begin
        dreq1(readOrWrite1, 32'h00000000, 32'h12345678, dload1);
        core[0] = S;
      end
      begin
        dreq2(readOrWrite2, 32'h00000000, 32'h12345678, dload2);
        core[1] = S;
      end
      begin
        while (cif[0].ccwait | cif[1].ccwait) #(PERIOD);
      end
      join

      //core 1 write to mem addr 0x00000000
      testcases++;
      core[0] = M;
      #(PERIOD * 2);
      while (cif[0].ccwait | cif[1].ccwait) #(PERIOD);
      core[1] = I;
      #(PERIOD);

      //core 2 write to mem addr 0x00000000
      testcases++;
      readOrWrite2 = 1;
      dreq2(readOrWrite2, 32'h00000000, 32'h5A5A5A5A, dload2);
      core[1] = M;
      core[0] = I;
      #(PERIOD);

      //instruction and data request happened simotaneourly
      testcases++;
      readOrWrite1 = 0;
      readOrWrite2 = 0;
      fork
      begin
        ireq1(32'h00000000, iload1);
      end
      begin
        ireq2(32'h00000004, iload2);
      end
      begin
        dreq1(readOrWrite1, 32'h00000000, 32'h12345678, dload1);
        core[0] = S;
      end
      begin
        dreq2(readOrWrite2, 32'h00000000, 32'h12345678, dload2);
        core[1] = S;
      end
      begin
        while (cif[0].ccwait | cif[1].ccwait) #(PERIOD);
      end
      join
      working = 0;
    end
    join

  end

  // tasks
  // initialize signals
  task init;
  begin
    cif[0].iREN = 1'b0;
    cif[0].dREN = 1'b0;
    cif[0].dWEN = 1'b0;
    cif[0].dstore = 32'b0;
    cif[0].iaddr = 32'b0;
    cif[0].daddr = 32'b0;
    cif[0].ccwrite = '0;
    cif[0].cctrans = '0;

    cif[1].iREN = 1'b0;
    cif[1].dREN = 1'b0;
    cif[1].dWEN = 1'b0;
    cif[1].dstore = 32'b0;
    cif[1].iaddr = 32'b0;
    cif[1].daddr = 32'b0;
    cif[1].ccwrite = '0;
    cif[1].cctrans = '0;

    testcases = 0;
    readOrWrite1 = 0;
    readOrWrite2 = 0;
    core = '{default: msi_t'('0)};

    nRST = 1'b0;
    @(negedge CLK);
    nRST = 1'b1;
    @(posedge CLK);
  end
  endtask

  task ireq1;
    parameter coreNum = 0;
    input word_t addr;
    output word_t iload;
  begin
    cif[coreNum].iaddr = addr;
    cif[coreNum].iREN = 1;
    while(cif[coreNum].iwait) #(PERIOD);
    iload = cif[coreNum].iload;
  end
  endtask

  task ireq2;
    parameter coreNum = 1;
    input word_t addr;
    output word_t iload;
  begin
    cif[coreNum].iaddr = addr;
    cif[coreNum].iREN = 1;
    while(cif[coreNum].iwait) #(PERIOD);
    iload = cif[coreNum].iload;
  end
  endtask

  task dreq1;
    parameter coreNum = 0;
    input logic readOrWrite;    //read: 0, write 1
    input word_t addr;
    input word_t dstore;
    output word_t dload;
  begin
    if (readOrWrite) begin
      cif[coreNum].dWEN = 1;
      cif[coreNum].dstore = dstore;
    end else begin
      cif[coreNum].dREN = 1;
      cif[coreNum].dstore = dstore;
    end
    cif[coreNum].daddr = addr;
    while(cif[coreNum].dwait) #(PERIOD);
    cif[coreNum].dWEN = 0;
    cif[coreNum].dREN = 0;
    dload = cif[coreNum].dload;
  end
  endtask

  task dreq2;
    parameter coreNum = 1;
    input logic readOrWrite;    //read: 0, write 1
    input word_t addr;
    input word_t dstore;
    output word_t dload;
  begin
    if (readOrWrite) begin
      cif[coreNum].dWEN = 1;
      cif[coreNum].dstore = dstore;
    end else begin
      cif[coreNum].dREN = 1;
      cif[coreNum].dstore = dstore;
    end
    cif[coreNum].daddr = addr;
    while(cif[coreNum].dwait) #(PERIOD);
    cif[coreNum].dWEN = 0;
    cif[coreNum].dREN = 0;
    dload = cif[coreNum].dload;
  end
  endtask

  task msiSignalOutput;
    input msi_t msi;
    input logic readOrWrite;
    input logic ccwait;
    output logic cctrans;
    output logic ccwrite;
  begin
    while (working) begin
    if (msi == I) begin
      if (ccwait) begin   //this core is servicing response
        cctrans = 0;
        ccwrite = 0;
      end else if (readOrWrite) begin //deal with processor request
        cctrans = 1;
        ccwrite = 1;
      end else begin
        cctrans = 1;
        ccwrite = 0;
      end
    end else if (msi == S) begin
      if (ccwait) begin
        cctrans = 0;
        ccwrite = 0;
      end else begin
        if (readOrWrite) begin
          cctrans = 1;
          ccwrite = 1;
        end else begin
          cctrans = 0;
          ccwrite = 0;
        end
      end
    end else if (msi == M) begin
      if (ccwait) begin
        cctrans = 0;
        ccwrite = 1;
      end else begin
        cctrans = 0;
        ccwrite = 0;
      end
    end
    #(PERIOD);
    end
  end
  endtask

endprogram
