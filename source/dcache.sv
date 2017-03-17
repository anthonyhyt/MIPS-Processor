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
  //types import
  import caches_types_pkg::*;
  import cpu_types_pkg::*;

  //variable declaration -----------------------------------------

  //counter signals
    //flush counter signal
  logic flctup;
  logic [4:0] flnum;
    //hit counter signal
  logic hitctup, hitctdn, hitctout;
  word_t hitnum;

  //signal for entering final flush phase
  logic flushing;

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
  word_t cacheout;              //data selected from cache to store
  word_t memaddr, cacheaddr, dpaddr;//address select variables

  //major component instantiation and declaration -----------------
  dc_set_t dcbuf [7:0];
  logic lru [7:0];
  flex_counter #(.BITS(32)) HITCT (
    CLK, nRST,
    hitctup, hitctdn, hitnum
  );
  flex_counter #(.BITS(5)) CLRCT (
    CLK, nRST,
    flctup, 1'b0, flnum
  );
  dcache_cu DCU (
    CLK, nRST,
    dirty,
    dhit, cif.dwait,
    dcif.dmemREN, dcif.dmemWEN, dcif.halt,
    cif.dREN, cif.dWEN,
    flctup, flnum, hitctup, hitctdn, hitctout,
    cublof, invalid,
    flushing, dcif.flushed
  );

  //variable cast -------------------------------------------------
  dc_pc_t addr;
  assign addr = dc_pc_t'(dcif.dmemaddr);

  //data caches configuration -------------------------------------
    //assignment for unused signals in multicore
  assign cif.ccwrite = 1'b0;
  assign cif.cctrans = 1'b0;

    //dirties signal generation
  assign dirty = dcbuf[ind][waysel].dcdirty & dcbuf[ind][waysel].dcvalid;

    //dhit generation
  assign dhit0 = (addr.dcpctag == dcbuf[ind][0].dctag) & dcbuf[ind][0].dcvalid;
  assign dhit1 = (addr.dcpctag == dcbuf[ind][1].dctag) & dcbuf[ind][1].dcvalid;
  assign dhit = dhit0 | dhit1;
  assign dcif.dhit = dhit;

    //cache store source select
  assign srcsel = dhit ? dcif.dmemstore : cif.dload;

    //word_t in cache select
    //!!! all word_t select should use these signals
  assign ind = flushing ? flnum[3:1] : addr.dcpcind;
  assign waysel = flushing ? flnum[0] : (dhit ? ~dhit0 : lru[ind]);
  assign blksel = dhit ? addr.dcpcblof : cublof;

    //data load to datapath select
  assign dcif.dmemload = dcbuf[ind][~dhit0].dcblock[addr.dcpcblof];

    //data store to mem select
  assign cacheout = dcbuf[ind][waysel].dcblock[cublof];
  assign cif.dstore = hitctout ? hitnum : cacheout;

    //memory address select
  assign cacheaddr = {dcbuf[ind][waysel].dctag, ind, cublof, 2'b00};//write back use address in cache tag
  assign dpaddr = {dcif.dmemaddr[31:3], cublof, 2'b00};             //load value use address from datapath
  assign memaddr = cif.dWEN ? cacheaddr : dpaddr;
  assign cif.daddr = hitctout ? 32'h00003100 : memaddr;

    //data caches flip-flops
  assign cacheWEN = ~flushing & (dhit ? dcif.dmemWEN : ~cif.dwait & cif.dREN);
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) begin
      dcbuf <= '{default: '0};
    end else if (cacheWEN) begin
      dcbuf[ind][waysel].dctag <= addr.dcpctag;
      dcbuf[ind][waysel].dcblock[blksel] <= srcsel;
      if (dcif.dmemWEN & dhit)
        dcbuf[ind][waysel].dcdirty <= 1'b1;
      else if (~cif.dwait & blksel & cif.dREN) begin
        dcbuf[ind][waysel].dcvalid <= 1'b1;
        dcbuf[ind][waysel].dcdirty <= 1'b0;
      end else if (invalid)
        dcbuf[ind][waysel].dcvalid <= 1'b0;
    end else if (invalid)
      dcbuf[ind][waysel].dcvalid <= 1'b0;
  end

    //lru flip-flops
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST)
      lru <= '{default: '0};
    else if (dhit & (dcif.dmemREN | dcif.dmemWEN))
      lru[ind] <= dhit0;
  end

endmodule
