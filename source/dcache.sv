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

  //variable declaration ---------------------------------

  //counter signals
    //counter clear
  logic clr_ct_clr;
    //counter enable signal
  logic hit_ct_en, clr_ct_en;
    //counter output
  logic hit_ct_o_en;
  word_t hit_num;
  logic [3:0] clr_num;

  //signal for entering final flush phase
  logic cclear;

  //variable meaning recognized by name
  logic block_offset_cu, dhit, dhit0, dhit1, dirty0, dirty1, dirties;

  //cache flip flops signals
  word_t datatocache;
  logic [2:0] index;
  logic WEN, invalidate, wayselect, blockselect;
  //dc_frame_t cur_frame;
  //dc_set_t cur_set;
  dc_block_t todp, tomem;
  word_t cacheout, memaddr, cacheaddr;

  //temp use variable for generation of dirties
  genvar i, j;
  logic [15:0] alldirties;

  //major component instantiation and declaration --------
  dc_set_t dcbuf [7:0];
  logic lru [7:0];
  flex_counter #(.BITS(32)) HITCT (
    CLK, nRST,
    1'b0, hit_ct_en & (dcif.dmemREN | dcif.dmemWEN), hit_num
  );
  flex_counter #(.BITS(4)) CLRCT (
    CLK, nRST,
    clr_ct_clr, clr_ct_en, clr_num
  );
  dcache_cu DCU (
    CLK, nRST,
    dirty0, dirty1, dirties, dhit, wayselect, cif.dwait, dcif.halt,
    dcif.dmemREN, dcif.dmemWEN, clr_num,
    cif.dREN, cif.dWEN, clr_ct_en, hit_ct_en, hit_ct_o_en,
    cclear, dcif.flushed, block_offset_cu, clr_ct_clr, invalidate
  );

  //variable cast ----------------------------------------
  dc_pc_t addr;
  assign addr = dc_pc_t'(dcif.dmemaddr);

  //data caches configuration ----------------------------
    //assignment for unused signals in multicore
  assign cif.ccwrite = 1'b0;
  assign cif.cctrans = 1'b0;

    //abbr for some signal
  assign WEN = ~cif.dwait & (dcif.dmemREN | dcif.dmemWEN) | dhit & dcif.dmemWEN;
  //alias  dcbuf[index] = cur_set;
  //alias  cur_frame = cur_set[lru[index]];
  assign dirty0 = dcbuf[index][0].dcdirty;
  assign dirty1 = dcbuf[index][1].dcdirty;

    //dirties signal generation
  assign dirties = |alldirties;
  generate
    for (i = 0; i < 8; i++) begin
      for (j = 0; j < 2; j++)
        assign alldirties[2*i+j] = (dcbuf[i][j].dcvalid & dcbuf[i][j].dcdirty);
    end
  endgenerate

    //dhit generation
  assign dhit0 = (addr.dcpctag == dcbuf[index][0].dctag) & dcbuf[index][0].dcvalid;
  assign dhit1 = (addr.dcpctag == dcbuf[index][1].dctag) & dcbuf[index][1].dcvalid;
  assign dhit = dhit0 | dhit1;
  assign dcif.dhit = dhit;

    //cache index select
  assign index = cclear ? clr_num[3:1] : addr.dcpcind;

    //cache store source select
  assign datatocache = cif.dwait ? dcif.dmemstore : cif.dload;
  assign wayselect = cif.dwait ? dhit1 : lru[index];
  assign blockselect = cif.dwait ? addr.dcpcblof : block_offset_cu;

    //data load to datapath select
  assign dcif.dmemload = dcbuf[index][dhit0][addr.dcpcblof];

    //data store to mem select
  assign tomem = lru[index]&~cclear | clr_num[0]&cclear ? dcbuf[index][1].dcblock : dcbuf[index][0].dcblock;
  assign cacheout = tomem[block_offset_cu];
  assign cif.dstore = hit_ct_o_en ? hit_num : cacheout;

    //memory address select
  assign cacheaddr = {dcbuf[index][clr_num[0]].dctag, clr_num[3:1], block_offset_cu, 2'b00};
  assign memaddr = cclear ? cacheaddr : dcif.dmemaddr;
  assign cif.daddr = hit_ct_o_en ? hit_num : memaddr;

    //data caches flip-flops
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST)
      dcbuf <= '{default: '0};
    else if (WEN) begin
      dcbuf[index][wayselect].dctag <= addr.dcpctag;
      dcbuf[index][wayselect].dcblock[blockselect] <= datatocache;
      if (dcif.dmemWEN & ~cif.dwait)
        dcbuf[index][wayselect].dcdirty <= 1'b1;
      else if (~cif.dwait & blockselect == 1'b1) begin
        dcbuf[index][wayselect].dcvalid <= 1'b1;
        dcbuf[index][wayselect].dcdirty <= 1'b0;
      end
    end
    if (invalidate)
      dcbuf[index][wayselect].dcvalid <= 1'b0;
  end

    //lru flip-flops
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST)
      lru <= '{default: '0};
    else if (WEN)
      lru[index] <= dhit0;
  end

endmodule
