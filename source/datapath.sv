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
  //request_unit            REQ(CLK, nRST, ruif);
  alu                     ALU(aif);
  pc #(.PC_INIT(PC_INIT)) PC(CLK, nRST, pcif);
  // pipeline
  ifidpipe                IFID(CLK, nRST, ifif, id1if);
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
  assign id2if.opfunc = cuif.opfunc;
  assign id2if.RegDst = cuif.RegDst;
  assign id2if.MemtoReg = cuif.MemtoReg;
  assign id2if.ALUSrc = cuif.ALUSrc;
  assign id2if.RegWEN = cuif.RegWEN;
  assign id2if.dWENi = cuif.dWENi;
  assign id2if.dRENi = cuif.dRENi;
  assign id2if.ALUOp = cuif.ALUOp;
  assign id2if.ExtOp = cuif.ExtOp;
  assign id2if.halt = cuif.halt;
  assign id2if.rt = rt;
  assign id2if.rd = rd;
  assign id2if.shamt = rti.shamt;
  assign id2if.imm = iti.imm;
  assign id2if.busA = busA;
  assign id2if.busB = busB;
  assign id2if.npc = id1if.npc;
    //EX and MM pipeline related:
  assign ex2if.opfunc = ex1if.opfunc;
  assign ex2if.MemtoReg = ex1if.MemtoReg;
  assign ex2if.RegWEN = ex1if.RegWEN;
  assign ex2if.dWENi = ex1if.dWENi;
  assign ex2if.dRENi = ex1if.dRENi;
  assign ex2if.equal = equal;
  assign ex2if.halt = ex1if.halt;
  assign ex2if.rd = rw;
  assign ex2if.portB = port_b;
  assign ex2if.npc = ex1if.npc;
  assign ex2if.ALUOut = ALUo;
  assign ex2if.store = busB;
    //MM and WB pipeline related:
  assign mm2if.opfunc = mm1if.opfunc;
  assign mm2if.MemtoReg = mm1if.MemtoReg;
  assign mm2if.RegWEN = mm1if.RegWEN;
  assign mm2if.equal = mm1if.equal;
  assign mm2if.halt = mm1if.halt;
  assign mm2if.rd = mm1if.rd;
  assign mm2if.portB = mm1if.portB;
  assign mm2if.npc = mm1if.npc;
  assign mm2if.ALUOut = mm1if.ALUOut;
  assign mm2if.load = dpif.dmemload;
    //ihit and dhit signal
  assign ifif.ihit = dpif.ihit;
  assign id2if.ihit = dpif.ihit;
  assign ex2if.ihit = dpif.ihit;
  assign mm2if.ihit = dpif.ihit;
  assign mm1if.dhit = dpif.dhit;
  assign mm2if.dhit = dpif.dhit;
    // control_unit input related:
  assign cuif.instr = id1if.instr;
  assign cuif.ihit = dpif.ihit;
  assign cuif.dhit = dpif.dhit;
  assign rs = rti.rs;
  assign rt = rti.rt;
  assign rd = rti.rd;
  assign imm16 = ex1if.imm;

    // register_file input related:
  assign rfif.WEN = wbif.RegWEN;
  assign rfif.wsel = wbif.rd;
  assign rfif.rsel1 = ra;
  assign rfif.rsel2 = rb;
  assign rfif.wdat = busW;

  assign ra = rti.rs;
  assign rb = rti.rt;
  always_comb begin
    if (ex1if.RegDst == RD) rw = ex1if.rd;
    else if (ex1if.RegDst == RT) rw = ex1if.rt;
    else if (ex1if.RegDst == R31) rw = '1;
    else rw = '0; // RERROR: write to R[0] when error occurs
  end
  always_comb begin
    if (wbif.MemtoReg == ALUO) busW = wbif.ALUOut;
    else if (wbif.MemtoReg == DLOAD) busW = wbif.load;
    else if (wbif.MemtoReg == PORTB) busW = wbif.portB;
    else busW = wbif.npc; // NPC
  end

    // register_file output related:
  assign busA = rfif.rdat1;
  assign busB = rfif.rdat2;

    // extender related:
  always_comb begin
    if (ex1if.ExtOp == ZEROEXT) imm32 = {16'b0, imm16};
    else if (ex1if.ExtOp == SIGNEXT) imm32 = {{16{imm16[IMM_W-1]}}, imm16};
    else if (ex1if.ExtOp == SHAMEXT) imm32 = {{(WORD_W-SHAM_W){1'b0}}, ex1if.shamt};
    else imm32 = {imm16, 16'b0}; // LUIEXT
  end

    // ALU input related:
  assign port_b = (ex1if.ALUSrc == 1'b0) ? ex1if.busB : imm32;
  assign aif.port_a = ex1if.busA;
  assign aif.port_b = port_b;
  assign aif.aluop = ex1if.ALUOp;

    // ALU output related:
  assign ALUo = aif.port_o;
  assign equal = aif.flag_zero;

    // PC input related:
  assign npc = pcif.pco + 4;
  assign bpc = ex1if.npc + (imm32 << 2);
  assign jpc = {id1if.npc[WORD_W-1:ADDR_W+2], (jti.addr << 2)};
  assign pcif.WEN = (dpif.ihit == 1'b1 && cuif.halt == 1'b0) ? 1'b1 : 1'b0;
  always_comb begin
    if (wbif.opfunc == OJR) pcif.pci = ex1if.busA;
    else if (wbif.opfunc == OBEQ && equal == 1'b1) pcif.pci = bpc;
    else if (wbif.opfunc == OBNE && equal == 1'b0) pcif.pci = bpc;
    else if (wbif.opfunc == OJ) pcif.pci = jpc;
    else if (wbif.opfunc == OJAL) pcif.pci = jpc;
    else pcif.pci = wbif.npc; // OTHERR, OTHERI, OTHERJ
  end

    // request_unit input related:
  //assign ruif.dRENi = mm1if.dRENi;
  //assign ruif.dWENi = mm1if.dWENi;

    // datapath input related:
  //assign ruif.ihit = dpif.ihit;
  //assign ruif.dhit = dpif.dhit;

    // datapath output related:
  assign dpif.imemREN = 1'b1;
  assign dpif.dmemREN = mm1if.dRENi;
  assign dpif.dmemWEN = mm1if.dWENi;
  assign dpif.dmemstore = mm1if.store;
  assign dpif.imemaddr = pcif.pco;
  assign dpif.dmemaddr = mm1if.ALUOut;
  assign dpif.datomic = '0; // unused

    // make halt signal a reg
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST == 0)
      dpif.halt <= 1'b0;
    else if (cuif.halt == 1'b1)
      dpif.halt <= wbif.halt;
  end

endmodule
