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
  logic flushing;

  //cache flip flops signals
  logic cublof;                 //block offset from state machine
  logic dhit, dhit0, dhit1;     //dhit is combinational output
  logic idle;
  logic dirty, dirties;         //dirty signal
  logic invalid;                //invalid valid bit when WB start
    //specific word select
  logic [2:0] ind;              //ind select
  logic waysel, blksel;         //way select, block select
  word_t srcsel;                //source select for cache write
    //cache to mem select
  logic cacheWEN;
  word_t cacheaddr, dpaddr;     //address select variables

  //multicore variables
  logic pccwait, ccend;
  logic MStoI, MtoS;
  logic ccing, ccdhit;
  msi_t msi;

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
    dirty,
    dhit, cif.dwait,
    dcif.dmemREN, dcif.dmemWEN, dcif.halt,
    cif.ccwait, cif.ccwrite,
    cif.dREN, cif.dWEN,
    flctup, flnum,
    cublof, invalid, idle,
    flushing, dcif.flushed
  );

  //variable cast -------------------------------------------------
  dc_pc_t addr;
  assign addr = dc_pc_t'(cif.ccwait ? cif.ccsnoopaddr : dcif.dmemaddr);

  //data caches configuration -------------------------------------
    //MSI state generation
  assign msi = msi_t'({dcbuf[ind][waysel].dcvalid, dcbuf[ind][waysel].dcdirty});

    //msi signals to bus
  always_comb
  begin
    cif.cctrans = 0;
    cif.ccwrite = 0;
    if (msi == I1 | msi == I2) begin
      if (~cif.ccwait & dcif.dmemREN) begin
        cif.cctrans = 1;
        cif.ccwrite = 0;
      end else if (~cif.ccwait & dcif.dmemWEN) begin
        cif.cctrans = 1;
        cif.ccwrite = 1;
      end
    end else if (msi == S) begin
      if (~cif.ccwait & dcif.dmemWEN) begin
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

    //detect if under cc procedure
  assign ccend = ~cif.ccwait & pccwait;
  assign ccing = cif.ccwait | ~ccend & (cif.cctrans | cif.ccwrite);

    //set all msi state transition condition
  assign MStoI = invalid | (cif.ccwait & cif.ccinv);
  assign MtoS = msi == M & cif.ccwait & ~cif.ccinv;

    //dirties signal generation
  assign dirty = dcbuf[ind][waysel].dcdirty & dcbuf[ind][waysel].dcvalid;

    //dhit generation
  assign dhit0 = (addr.dcpctag == dcbuf[ind][0].dctag) & dcbuf[ind][0].dcvalid;
  assign dhit1 = (addr.dcpctag == dcbuf[ind][1].dctag) & dcbuf[ind][1].dcvalid;
  assign dhit = dhit0 | dhit1;
  assign ccdhit = ~ccing & dhit & idle;
  assign dcif.dhit = ccdhit;

    //cache store source select
  assign srcsel = dhit ? dcif.dmemstore : cif.dload;

    //word_t in cache select
  assign ind = flushing ? flnum[3:1] : addr.dcpcind;
  assign waysel = flushing ? flnum[0] : (ccdhit ? ~dhit0:lru[ind]);
  assign blksel = ccdhit ? addr.dcpcblof : cublof;

    //data load to datapath select
  assign dcif.dmemload = dcbuf[ind][~dhit0].dcblock[addr.dcpcblof];

    //data store to mem select
  assign cif.dstore = dcbuf[ind][waysel].dcblock[cublof];

    //memory address select
  assign cacheaddr = {dcbuf[ind][waysel].dctag, ind, cublof, 2'b00};//write back use address in cache tag
  assign dpaddr = {dcif.dmemaddr[31:3], cublof, 2'b00};             //load value use address from datapath
  assign cif.daddr = cif.dWEN ? cacheaddr : dpaddr;

    //data caches flip-flops
  assign cacheWEN = ~flushing & (ccdhit ? dcif.dmemWEN : ~cif.dwait & cif.dREN);
  always_comb
  begin
    nxtdcbuf = dcbuf;
    if (cacheWEN) begin
      nxtdcbuf[ind][waysel].dctag = addr.dcpctag;
      nxtdcbuf[ind][waysel].dcblock[blksel] = srcsel;
      if (dcif.dmemWEN & ccdhit)
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
    else if (ccdhit & (dcif.dmemREN | dcif.dmemWEN))
      lru[ind] <= dhit0;
  end

    //ccwait fall edge detector
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) pccwait <= '0;
    else pccwait <= cif.ccwait;
  end

endmodule
