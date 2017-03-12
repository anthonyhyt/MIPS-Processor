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
  logic flctclr;      //counter clear
  logic hitctup, hitctdn, flctup;    //counter enable signal
  logic hitctout;     //counter output
  word_t hitnum;        //cache hit counter
  logic [4:0] flnum;   //flush phase counter

  //signal for entering final flush phase
  logic flushing;

  //cache flip flops signals
  logic cublof;            //block offset from state machine
  logic dhit, dhit0, dhit1;         //dhit is combinational output
  logic dhitidle;                  //dhitidle output dhit only at idle state
  logic dirty, dirties;             //dirty signal
  logic invalid;                 //invalid valid bit when WB start
    //specific way select
  logic [2:0] ind;                //ind select
  logic waysel, blksel;     //way select, block select
  word_t srcsel;               //source select for cache write
  logic cacheWEN;                   //cache write enable
    //cache to mem select
  dc_block_t tomem;
  word_t cacheout;
  word_t memaddr, cacheaddr, dpaddr;//address select variables

  //temp use variable for generation of dirties
  genvar i, j;
  logic [15:0] alldirties;

  //major component instantiation and declaration -----------------
  dc_set_t dcbuf [7:0];
  logic lru [7:0];
  flex_counter #(.BITS(32)) HITCT (
    CLK, nRST,
    1'b0, hitctup, hitctdn, hitnum
  );
  flex_counter #(.BITS(5)) CLRCT (
    CLK, nRST,
    flctclr, flctup, 1'b0, flnum
  );
  dcache_cu DCU (
    CLK, nRST,
    dirty, dirties,
    dcbuf[ind][waysel].dcvalid & dcbuf[ind][waysel].dcdirty,
    dhit, cif.dwait,
    dcif.dmemREN, dcif.dmemWEN, dcif.halt, flnum,
    cif.dREN, cif.dWEN,
    flctup, flctclr, hitctup, hitctdn, hitctout,
    cublof, invalid, dhitidle,
    flushing, dcif.flushed
  );

  //variable cast -------------------------------------------------
  dc_pc_t addr;
  assign addr = dc_pc_t'(dcif.dmemaddr);

  //data caches configuration -------------------------------------
    //assignment for unused signals in multicore
  assign cif.ccwrite = 1'b0;
  assign cif.cctrans = 1'b0;

    //abbr for some signal
  assign cacheWEN = ~flushing & (dhitidle ? dcif.dmemWEN : ~cif.dwait & cif.dREN);
  assign dirty = dcbuf[ind][lru[ind]].dcdirty;

    //dirties signal generation
  assign dirties = |alldirties;
  generate
    for (i = 0; i < 8; i++) begin:outer
      for (j = 0; j < 2; j++) begin:inner
        assign alldirties[2*i+j] = (dcbuf[i][j].dcvalid & dcbuf[i][j].dcdirty);
      end
    end
  endgenerate

    //dhit generation
  assign dhit0 = (addr.dcpctag == dcbuf[ind][0].dctag) & dcbuf[ind][0].dcvalid;
  assign dhit1 = (addr.dcpctag == dcbuf[ind][1].dctag) & dcbuf[ind][1].dcvalid;
  assign dhit = dhit0 | dhit1;
  assign dcif.dhit = dhitidle;

    //cache store source select
  assign ind = flushing ? flnum[3:1] : addr.dcpcind;
  assign srcsel = dhitidle ? dcif.dmemstore : cif.dload;
  assign waysel = flushing ? flnum[0] : (dhitidle ? ~dhit0 : (cif.dREN | cif.dWEN) & lru[ind]);
  assign blksel = dhitidle ? addr.dcpcblof : cublof;

    //data load to datapath select
  assign dcif.dmemload = dcbuf[ind][~dhit0].dcblock[addr.dcpcblof];

    //data store to mem select
  assign tomem = lru[ind]&~flushing | waysel&flushing ? dcbuf[ind][1].dcblock : dcbuf[ind][0].dcblock;
  assign cacheout = tomem[cublof];
  assign cif.dstore = hitctout ? hitnum : cacheout;

    //memory address select
  assign cacheaddr = {dcbuf[ind][waysel].dctag, ind, cublof, 2'b00};//write back use address in cache tag
  assign dpaddr = {dcif.dmemaddr[31:3], cublof, 2'b00};   //load value used the address from datapath
  assign memaddr = cif.dWEN ? cacheaddr : dpaddr;
  assign cif.daddr = hitctout ? 32'h00003100 : memaddr;

    //data caches flip-flops
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) begin
      dcbuf <= '{default: '0};
    end else if (cacheWEN) begin
      dcbuf[ind][waysel].dctag <= addr.dcpctag;
      dcbuf[ind][waysel].dcblock[blksel] <= srcsel;
      if (dcif.dmemWEN & dhitidle)
        dcbuf[ind][waysel].dcdirty <= 1'b1;
      else if (~cif.dwait & blksel & cif.dREN) begin
        dcbuf[ind][waysel].dcvalid <= 1'b1;
        dcbuf[ind][waysel].dcdirty <= 1'b0;
      end
    end else if (invalid)
      dcbuf[ind][waysel].dcvalid <= 1'b0;
  end

    //lru flip-flops
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST)
      lru <= '{default: '0};
    else if (dhitidle & (dcif.dmemREN | dcif.dmemWEN))
      lru[ind] <= dhit0;
  end

endmodule
