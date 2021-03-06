//interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

//packages
`include "caches_types_pkg.vh"
`include "cpu_types_pkg.vh"

module dcache (
  input logic CLK, nRST,
  caches_if.dcache cif,
  datapath_cache_if.dcache dcif
);
  //types import and define
  import caches_types_pkg::*;
  import cpu_types_pkg::*;

  typedef enum logic [1:0] {
    I1 = 2'b00, I2 = 2'b01,  S = 2'b10, M = 2'b11
  } msi_t;

  //variable declaration -----------------------------------------

  //counter signals
    //flush counter signal
  logic flctup;
  logic [4:0] flnum;

  //signal for entering final flush phase
  logic flushing, dmemWEN, dmemREN;

  //cache flip flops signals
  logic cublof;                 //block offset from state machine
  logic dhit, dhit0, dhit1;     //dhit is combinational output
  logic dirty, dirties;         //dirty signal
  logic invalid;                //invalid valid bit when WB start
    //specific word select
  logic [2:0] ind;              //ind select
  logic waysel, blksel;         //way select, block select
  word_t srcsel;                //source select for cache write
    //cache to mem select
  logic cacheWEN;
  word_t cacheaddr, dpaddr, fladdr;     //address select variables

  //multicore variables
    //coherence signal
  logic pccwait, ccend;
  logic MStoI, MtoS;
  logic ccing, ccdhit;
  logic sameaddr, snoopable;
  msi_t msi, msireg;

    //synchronization signal
  logic llvalid, nxtllvalid;
  logic success, atomicWEN;
  word_t llreg, nxtllreg;

  //major component instantiation and declaration -----------------
  dc_set_t [7:0] dcbuf;
  dc_set_t [7:0] nxtdcbuf;
  logic lru [7:0];
  flex_counter #(.BITS(5)) CLRCT (
    CLK, nRST,
    flctup, 1'b0, flnum
  );
  dcache_cu DCU (
    CLK, nRST,
    dirty, sameaddr, snoopable,
    dhit, cif.dwait,
    dcif.dmemREN, dcif.dmemWEN, dcif.halt,
    cif.ccwait, cif.ccwrite, cif.ccinv,
    cif.dREN, cif.dWEN,
    flctup, flnum,
    cublof, invalid,
    flushing, dcif.flushed
  );

  //variable cast -------------------------------------------------
  dc_pc_t addr, snpaddr, dapaddr;
  assign addr = dc_pc_t'(cif.ccwait ? cif.ccsnoopaddr : dcif.dmemaddr);
  assign snpaddr = dc_pc_t'(cif.ccsnoopaddr);
  assign dapaddr = dc_pc_t'(dcif.dmemaddr);

  //data caches configuration -------------------------------------
    //MSI state generation
  assign msi = addr.dcpctag != dcbuf[ind][waysel].dctag ? I1 :
               msi_t'({dcbuf[ind][waysel].dcvalid, dcbuf[ind][waysel].dcdirty});

    //msi signals to bus
  always_comb
  begin
    cif.cctrans = 0;
    cif.ccwrite = 0;
    if (~dcif.flushed & ~ccend) begin
      if (msi == I1 | msi == I2) begin
        if (~cif.ccwait & dmemREN) begin
          cif.cctrans = 1;
          cif.ccwrite = 0;
        end else if (~cif.ccwait & dmemWEN) begin
          cif.cctrans = 1;
          cif.ccwrite = 0;
        end
      end else if (msi == S) begin
        if (~cif.ccwait & dmemWEN) begin
          cif.cctrans = 1;
          cif.ccwrite = 1;
        end
      end else if (msi == M) begin
        if (cif.ccwait) begin
          cif.cctrans = 0;
          cif.ccwrite = 1;
        end
      end
    end
  end

    //detect if under cc procedure
  assign ccend = ~cif.ccwait & pccwait;
  assign ccing = cif.ccwait | ~ccend & (cif.cctrans | cif.ccwrite);

    //set all msi state transition condition
  assign MStoI = (invalid | (cif.ccwait & cif.ccinv)) & (msi == S || msi == M);
  assign MtoS = msi == M & cif.ccwait & ~cif.ccinv;

    //block datapath request after halt
  assign dmemREN = ~flushing & dcif.dmemREN;
  assign dmemWEN = ~flushing & dcif.dmemWEN;

    //dirties signal generation
  assign dirty = dcbuf[ind][waysel].dcdirty & dcbuf[ind][waysel].dcvalid;
  assign sameaddr = fladdr == cif.ccsnoopaddr;

    //dhit generation
  assign dhit0 = (addr.dcpctag == dcbuf[ind][0].dctag) & dcbuf[ind][0].dcvalid;
  assign dhit1 = (addr.dcpctag == dcbuf[ind][1].dctag) & dcbuf[ind][1].dcvalid;
  assign dhit = dhit0 | dhit1;
  assign ccdhit = ~ccing & dhit & (msireg == S || msireg == M || dmemREN);
  assign dcif.dhit = ccdhit;

    //cache store source select
  assign srcsel = ccdhit ? dcif.dmemstore : cif.dload;

    //word_t in cache select
  assign ind = flushing ? ((cif.ccwait & snoopable) ? snpaddr.dcpcind : flnum[3:1]) : addr.dcpcind;
  assign waysel = flushing ? ((cif.ccwait & snoopable) ? ~dhit0 : flnum[0]) : (dhit ? ~dhit0 :
                  (dcbuf[ind][0].dcvalid & dcbuf[ind][1].dcvalid ? lru[ind] : dcbuf[ind][0].dcvalid));
  assign blksel = dhit ? addr.dcpcblof : cublof;

    //data load to datapath select
  assign dcif.dmemload = dcif.datomic & dmemWEN ? word_t'(success) : dcbuf[ind][~dhit0].dcblock[addr.dcpcblof];

    //data store to mem select
  assign cif.dstore = dcbuf[ind][waysel].dcblock[blksel];

    //memory address select
  assign cacheaddr = {dcbuf[ind][waysel].dctag, ind, cublof, 2'b00};//write back use address in cache tag
  assign dpaddr = flushing ? '0 : {dcif.dmemaddr[31:3], cublof, 2'b00};
  //assign cif.daddr = cif.dREN ? dpaddr : cacheaddr;
  assign cif.daddr = cif.dWEN ? cacheaddr : dpaddr;
  assign fladdr = {dcbuf[flnum[3:1]][flnum[0]].dctag, flnum[3:1], cublof, 2'b00};

    //load link register
  always_comb
  begin
    success = 1'b0;
    nxtllvalid = llvalid;
    nxtllreg = llreg;
    if (dmemREN & dcif.datomic & ccdhit) begin
      nxtllvalid = 1'b1;
      nxtllreg = dcif.dmemaddr;
    end else if (cif.ccwait & cif.ccinv & llreg == cif.ccsnoopaddr |
                 dmemWEN & ccdhit & llreg == dcif.dmemaddr) begin
      nxtllvalid = 1'b0;
    end
    if (dmemWEN & dcif.datomic & ccdhit &
        llvalid & llreg == dcif.dmemaddr) begin
      success = 1'b1;
    end
  end
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) begin
      llvalid <= 1'b0;
      llreg <= '0;
    end else begin
      llvalid <= nxtllvalid;
      llreg <= nxtllreg;
    end
  end

    //data caches flip-flops logic
  assign atomicWEN = dmemWEN & (dcif.datomic ? success : 1'b1);
  assign cacheWEN = ~flushing & (ccdhit ? atomicWEN : ~cif.dwait & cif.dREN);
  always_comb
  begin
    nxtdcbuf = dcbuf;
    if (cacheWEN) begin
      nxtdcbuf[ind][waysel].dctag = addr.dcpctag;
      nxtdcbuf[ind][waysel].dcblock[blksel] = srcsel;
      if (atomicWEN && ccdhit)
        nxtdcbuf[ind][waysel].dcdirty = 1'b1;
      else if (~cif.dwait & blksel & cif.dREN) begin
        nxtdcbuf[ind][waysel].dcvalid = 1'b1;
        nxtdcbuf[ind][waysel].dcdirty = 1'b0;
      end
    end
    if (MStoI)
      nxtdcbuf[ind][waysel].dcvalid = 1'b0;
    else if (MtoS) begin
      nxtdcbuf[ind][waysel].dcvalid = 1'b1;
      nxtdcbuf[ind][waysel].dcdirty = 1'b0;
    end
  end
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST)
      dcbuf <= '0;
    else
      dcbuf <= nxtdcbuf;
  end

    //lru flip-flops
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST)
      lru <= '{default: '0};
    else if (ccdhit & (dmemREN | dmemWEN))
      lru[ind] <= dhit0;
  end

    //ccwait fall edge detector
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) pccwait <= '0;
    else pccwait <= cif.ccwait;
  end

    //msi stage register
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) msireg <= I1;
    else if (~ccing) msireg <= msi;
    else msireg <= msireg;
  end

endmodule
