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
`include "forwarding_unit_if.vh"
`include "hazard_control_unit_if.vh"
`include "branch_buffer_if.vh"
`include "predictor_if.vh"
//pipeline interface
`include "ifidpipe_if.vh"
`include "idexpipe_if.vh"
`include "exmmpipe_if.vh"
`include "mmwbpipe_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"
`include "control_unit_types_pkg.vh"
`include "forwarding_unit_types_pkg.vh"
`include "hazard_control_unit_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;
  import control_unit_types_pkg::*;
  import forwarding_unit_types_pkg::*;
  import hazard_control_unit_types_pkg::*;
  // pc init
  parameter PC_INIT = 0;

  // interfaces
  register_file_if        rfif();
  control_unit_if         cuif();
  request_unit_if         ruif();
  alu_if                  aif();
  pc_if                   pcif();
  forwarding_unit_if      fuif();
  hazard_control_unit_if  huif();
  branch_buffer_if        bbif();
  predictor_if            bpif();
  // pipeline interface
  ifidpipe_if             ifif();
  ifidpipe_if             id1if();
  idexpipe_if             id2if();
  idexpipe_if             ex1if();
  exmmpipe_if             ex2if();
  exmmpipe_if             mm1if();
  mmwbpipe_if             mm2if();
  mmwbpipe_if             wbif();

  // instruction passing wire
  word_t idinstr, exinstr, mminstr, wbinstr;

  // components instanciations
  register_file           REF(CLK, nRST, rfif);
  control_unit            CTR(cuif);
  //request_unit            REQ(CLK, nRST, ruif);
  alu                     ALU(aif);
  pc #(.PC_INIT(PC_INIT)) PC(CLK, nRST, pcif);
  forwarding_unit         FU(fuif);
  hazard_control_unit     HU(huif);
  branch_buffer           BB(CLK, nRST, bbif);
  predictor               BP(CLK, nRST, bpif);
  // pipeline
  ifidpipe                IFID(CLK, nRST, ifif, id1if);
  idexpipe                IDEX(CLK, nRST, idinstr, exinstr, id2if, ex1if);
  exmmpipe                EXMM(CLK, nRST, exinstr, mminstr, ex2if, mm1if);
  mmwbpipe                MMWB(CLK, nRST, mminstr, wbinstr, mm2if, wbif);

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
  word_t imm32, port_a, port_b, ALUo;
  logic equal;

    // next PC logic related:
  word_t npc, bpc, jpc;

    // forwarding unit signal
  word_t EXstore;

    // branch related:
  word_t mmpc;
  logic PRtaken;

    // casted instructions
  r_t rti, exrti, mmrti, wbrti;
  i_t iti, exiti, mmiti, wbiti;
  j_t jti, exjti, mmjti, wbjti;

  // cast input instruction:
  assign rti = r_t'(id1if.instr);
  assign iti = i_t'(id1if.instr);
  assign jti = j_t'(id1if.instr);
    //used only for debugging
  assign idinstr = id1if.instr;
  assign exrti = r_t'(exinstr);
  assign exiti = i_t'(exinstr);
  assign exjti = j_t'(exinstr);
  assign mmrti = r_t'(mminstr);
  assign mmiti = i_t'(mminstr);
  assign mmjti = j_t'(mminstr);
  assign wbrti = r_t'(wbinstr);
  assign wbiti = i_t'(wbinstr);
  assign wbjti = j_t'(wbinstr);

  // connections
    //IF and ID pipeline related:
  assign ifif.instr = dpif.imemload;
  assign ifif.npc = npc;
  assign ifif.taken = PRtaken;
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
  assign id2if.jaddr = jti.addr;
  assign id2if.taken = id1if.taken;
  assign id2if.rs = rs;
  assign id2if.rt = rt;
  assign id2if.rd = rd;
  assign id2if.shamt = rti.shamt;
  assign id2if.imm = iti.imm;
  assign id2if.busA = rfif.rdat1;
  assign id2if.busB = rfif.rdat2;
  assign id2if.npc = id1if.npc;
    //EX and MM pipeline related:
  assign ex2if.opfunc = ex1if.opfunc;
  assign ex2if.MemtoReg = ex1if.MemtoReg;
  assign ex2if.RegWEN = ex1if.RegWEN;
  assign ex2if.dWENi = ex1if.dWENi;
  assign ex2if.dRENi = ex1if.dRENi;
  assign ex2if.equal = equal;
  assign ex2if.halt = ex1if.halt;
  assign ex2if.taken = ex1if.taken;
  assign ex2if.rd = rw;
  assign ex2if.portB = port_b;
  assign ex2if.npc = ex1if.npc;
  assign ex2if.ALUOut = ALUo;
  assign ex2if.store = EXstore;
    //MM and WB pipeline related:
  assign mm2if.MemtoReg = mm1if.MemtoReg;
  assign mm2if.RegWEN = mm1if.RegWEN;
  assign mm2if.equal = mm1if.equal;
  assign mm2if.halt = mm1if.halt;
  assign mm2if.rd = mm1if.rd;
  assign mm2if.portB = mm1if.portB;
  assign mm2if.npc = mm1if.npc;
  assign mm2if.ALUOut = mm1if.ALUOut;
  assign mm2if.load = dpif.dmemload;
    //pipe control signal
  assign ifif.flush = huif.IFIDflush;
  assign id2if.flush = huif.IDEXflush;
  assign ex2if.flush = huif.EXMMflush;
  assign ifif.en = huif.IFIDEN;
  assign id2if.en = huif.IDEXEN;
  assign ex2if.en = huif.EXMMEN;
  assign mm2if.en = huif.MMWBEN;
    // control_unit input related:
  assign cuif.instr = id1if.instr;
  assign cuif.ihit = dpif.ihit;
  assign cuif.dhit = dpif.dhit;
  assign rs = rti.rs;
  assign rt = rti.rt;
  assign rd = rti.rd;
  assign imm16 = ex1if.imm;

    // forwarding unit input related:
  assign fuif.EXrs = ex1if.rs;
  assign fuif.EXrt = ex1if.rt;
  assign fuif.MMrd = mm1if.rd;
  assign fuif.WBrd = wbif.rd;
  assign fuif.MMregWEN = mm1if.RegWEN;
  assign fuif.WBregWEN = wbif.RegWEN;
  assign fuif.MMisLUI = mm1if.opfunc == OLUI;

    // forwarding unit output related:
  assign aif.port_a = port_a;
  always_comb
  begin:fwdA
    casez(fuif.fwdA)
      FABUSA:  port_a = ex1if.busA;
      FABUSW:  port_a = busW;
      FAALU:   port_a = mm1if.ALUOut;
      FAPORTB: port_a = mm1if.portB;
    endcase
  end
  always_comb
  begin:fwdB
    casez(fuif.fwdB)
      FBBUSB:  EXstore = ex1if.busB;
      FBBUSW:  EXstore = busW;
      FBALU:   EXstore = mm1if.ALUOut;
      FBPORTB: EXstore = mm1if.portB;
    endcase
  end

    // hazard control unit related:
  assign huif.IDrs = rs;
  assign huif.IDrt = rt;
  assign huif.EXrt = ex1if.rt;
  assign huif.IDopfunc = cuif.opfunc;
  assign huif.EXopfunc = ex1if.opfunc;
  assign huif.MMopfunc = mm1if.opfunc;
  assign huif.ihit = dpif.ihit;
  assign huif.dhit = dpif.dhit;
  assign huif.MMequal = mm1if.equal;
  assign huif.PRtaken = PRtaken;
  assign huif.MMtaken = mm1if.taken;

    //branch prediction
    //predictor
  assign mmpc = mm1if.npc - 4;
  assign PRtaken = bpif.PRresult & bbif.PRvalid & (bbif.PRtag == pcif.pco[31:4]);
  assign bpif.mmprindex = mmpc[3:2];
  assign bpif.ifprindex = pcif.pco[3:2];
  assign bpif.opfunc = mm1if.opfunc;
  assign bpif.ABtaken = huif.ABtaken;
    //branch buffer
  assign bbif.MMopfunc = mm1if.opfunc;
  assign bbif.MMbpc = mm1if.bpc;
  assign bbif.MMpc = mmpc;
  assign bbif.IFpcindex = pcif.pco[3:2];

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
  //assign busA = ex1if.busA;
  //assign busB = ex1if.busB;

    // extender related:
  always_comb begin
    if (ex1if.ExtOp == ZEROEXT) imm32 = {16'b0, imm16};
    else if (ex1if.ExtOp == SIGNEXT) imm32 = {{16{imm16[IMM_W-1]}}, imm16};
    else if (ex1if.ExtOp == SHAMEXT) imm32 = {{(WORD_W-SHAM_W){1'b0}}, ex1if.shamt};
    else imm32 = {imm16, 16'b0}; // LUIEXT
  end

    // ALU input related:
  assign port_b = (ex1if.ALUSrc == 1'b0) ? EXstore : imm32;
  //assign aif.port_a = ex2if.busA; // move to forwarding unit output part
  assign aif.port_b = port_b;
  assign aif.aluop = ex1if.ALUOp;

    // ALU output related:
  assign ALUo = aif.port_o;
  assign equal = aif.flag_zero;

    // PC input related:
  assign npc = pcif.pco + 4;
  assign ex2if.bpc = ex1if.npc + {{14{imm16[IMM_W-1]}}, imm16, 2'b00};
  assign jpc = {ex1if.npc[WORD_W-1:ADDR_W+2], ex1if.jaddr, 2'b00};
  assign pcif.WEN = huif.PCEN;
  always_comb begin
    casez(huif.PCselect)
      PCPTA: pcif.pci = port_a;
      PCBPC: pcif.pci = mm1if.bpc;
      PCJPC: pcif.pci = jpc;
      PCNPC: pcif.pci = npc;
      PRBPC: pcif.pci = bbif.PRbpc;
      PRMPC: pcif.pci = mm1if.npc;
      default: pcif.pci = npc;
    endcase
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
  assign dpif.halt = wbif.halt;
  /*
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST == 0)
      dpif.halt <= 1'b0;
    else if (wbif.halt == 1'b1)
      dpif.halt <= 1'b1;
      //dpif.halt <= wbif.halt
  end
  */
endmodule
