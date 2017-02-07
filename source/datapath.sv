/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
// component interfaces
`include "register_file_if.vh"
`include "control_unit_if.vh"
`include "request_unit_if.vh"
`include "alu_if.vh"
`include "pc_if.vh"
//pipeline interface
`include "ifidpipe_if.vh"
`include "idexpipe_if.vh"
`include "exmmpipe_if.vh"
`include "mmwbpipe_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;


  // interfaces
  register_file_if  rfif();
  control_unit_if   cuif();
  request_unit_if   ruif();
  alu_if            aif();
  pc_if             pcif();
  // pipeline interface
  ifidpipe_if       ifif();
  ifidpipe_if       id1if();
  idexpipe_if       id2if();
  idexpipe_if       ex1if();
  exmmpipe_if       ex2if();
  exmmpipe_if       mm1if();
  mmwbpipe_if       mm2if();
  mmwbpipe_if       wbif();


  // components instanciations
  register_file           REF(CLK, nRST, rfif);
  control_unit            CTR(cuif);
  //****request_unit            REQ(CLK, nRST, ruif);
  alu                     ALU(aif);
  pc #(.PC_INIT(PC_INIT)) PC(CLK, nRST, pcif);
  // pipeline
  idifpipe                IFID(CLK, nRST, ifif, id1if);
  idexpipe                IDEX(CLK, nRST, id2if, ex1if);
  exmmpipe                EXMM(CLK, nRST, ex2if, mm1if);
  mmwbpipe                MMWB(CLK, nRST, mm2if, wbif);

  // existing input/output signals
    /*
            dpif.
      input   ihit, imemload, dhit, dmemload,
      output  halt, imemREN, imemaddr, dmemREN, dmemWEN, datomic,
              dmemstore, dmemaddr

            rfif.
      input   WEN, wsel, rsel1, rsel2, wdat,
      output  rdat1, rdat2

            cuif.
      input   instr,
      output  opfunc, RegDst, ALUSrc, MemtoReg, RegWEN, dWENi, dRENi,
              ALUOp, ExtOp, halt

            ruif.
      input   dRENi, dWENi, ihit, dhit,
      output  dRENo, dWENo, iRENo

            aif.
      input   port_a, port_b, aluop,
      output  port_o, flag_negative, flag_overflow, flag_zero

            pcif.
      input   WEN, pci,
      output  pco
    */

  // signals declarations
    // control_unit related:
  regbits_t rs, rt, rd;
  logic [IMM_W-1:0] imm16;

    // register_file related:
  regbits_t rw, ra, rb;
  word_t busA, busB, busW;

    // ALU logic related:
  word_t imm32, port_b, ALUo;
  logic equal;

    // next PC logic related:
  word_t npc, bpc, jpc;

    // casted instructions
  r_t rti;
  i_t iti;
  j_t jti;


  // cast input instruction
  assign rti = r_t'(id1if.instr);
  assign iti = i_t'(id1if.instr);
  assign jti = j_t'(id1if.instr);

  // connections
    //IF and ID pipeline related:
  assign ifif.instr = dpif.imemload;
  assign ifif.npc = npc;
    //ID and EX pipeline related:
  assign id2if.opfunc
  assign id2if.RegDst
  assign id2if.MemtoReg
  assign id2if.ALUSrc
  assign id2if.RegWEN
  assign id2if.dWENi
  assign id2if.dRENi
  assign id2if.ALUOp
  assign id2if.ExtOp
  assign id2if.halt
  assign id2if.rt
  assign id2if.rd
  assign id2if.shamt = rti.shamt;
  assign id21f.imm = iti.imm;
    // control_unit input related:
  assign cuif.instr = id1if.instr;
  assign cuif.ihit = dpif.ihit;
  assign cuif.dhit = dpif.dhit;
  assign rs = rti.rs;
  assign rt = rti.rt;
  assign rd = rti.rd;
  //assign imm16 = iti.imm;

    // register_file input related:
  assign rfif.WEN = cuif.RegWEN;
  assign rfif.wsel = rw;
  assign rfif.rsel1 = ra;
  assign rfif.rsel2 = rb;
  assign rfif.wdat = busW;

  assign ra = rs;
  assign rb = rt;
  always_comb begin
    if (cuif.RegDst == RD) rw = rd;
    else if (cuif.RegDst == RT) rw = rt;
    else if (cuif.RegDst == R31) rw = '1;
    else rw = '0; // RERROR: write to R[0] when error occurs
  end
  always_comb begin
    if (cuif.MemtoReg == ALUO) busW = ALUo;
    else if (cuif.MemtoReg == DLOAD) busW = dpif.dmemload;
    else if (cuif.MemtoReg == PORTB) busW = port_b;
    else busW = npc; // NPC
  end

    // register_file output related:
  assign busA = rfif.rdat1;
  assign busB = rfif.rdat2;

    // extender related:
  always_comb begin
    if (cuif.ExtOp == ZEROEXT) imm32 = {16'b0, imm16};
    else if (cuif.ExtOp == SIGNEXT) imm32 = {{16{imm16[IMM_W-1]}}, imm16};
    else if (cuif.ExtOp == SHAMEXT) imm32 = {{(WORD_W-SHAM_W){1'b0}}, rti.shamt};
    else imm32 = {imm16, 16'b0}; // LUIEXT
  end

    // ALU input related:
  assign port_b = (cuif.ALUSrc == 1'b0) ? busB : imm32;
  assign aif.port_a = busA;
  assign aif.port_b = port_b;
  assign aif.aluop = cuif.ALUOp;

    // ALU output related:
  assign ALUo = aif.port_o;
  assign equal = aif.flag_zero;

    // PC input related:
  assign npc = pcif.pco + 4;
  assign bpc = npc + (imm32 << 2);
  assign jpc = {npc[WORD_W-1:ADDR_W+2], (jti.addr << 2)};
  assign pcif.WEN = (dpif.ihit == 1'b1 && cuif.halt == 1'b0) ? 1'b1 : 1'b0;
  always_comb begin
    if (cuif.opfunc == OJR) pcif.pci = busA;
    else if (cuif.opfunc == OBEQ && equal == 1'b1) pcif.pci = bpc;
    else if (cuif.opfunc == OBNE && equal == 1'b0) pcif.pci = bpc;
    else if (cuif.opfunc == OJ) pcif.pci = jpc;
    else if (cuif.opfunc == OJAL) pcif.pci = jpc;
    else pcif.pci = npc; // OTHERR, OTHERI, OTHERJ
  end

    // request_unit input related:
  assign ruif.dRENi = cuif.dRENi;
  assign ruif.dWENi = cuif.dWENi;

    // datapath input related:
  assign ruif.ihit = dpif.ihit;
  assign ruif.dhit = dpif.dhit;

    // datapath output related:
  assign dpif.imemREN = ruif.iRENo;
  assign dpif.dmemREN = ruif.dRENo;
  assign dpif.dmemWEN = ruif.dWENo;
  assign dpif.dmemstore = busB;
  assign dpif.imemaddr = pcif.pco;
  assign dpif.dmemaddr = ALUo;
  assign dpif.datomic = '0; // unused

    // make halt signal a reg
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST == 0)
      dpif.halt <= 1'b0;
    else if (cuif.halt == 1'b1)
      dpif.halt <= cuif.halt;
  end

endmodule
