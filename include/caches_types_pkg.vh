/*
  Yiheng Chi
  chi14@purdue.edu

  caches types
*/
`ifndef CACHES_TYPES_PKG_VH
`define CACHES_TYPES_PKG_VH

// all types
`include "cpu_types_pkg.vh"

package caches_types_pkg;

  // import types
  import cpu_types_pkg::*;

  // field width
  parameter C_TAG_W = 26;
  parameter C_IIX_W = 4;
  parameter C_DIX_W = 3;
  parameter C_BOF_W = 2;

  // types
  typedef logic [C_TAG_W-1:0] c_tag_t;
  typedef logic [C_IIX_W-1:0] c_iix_t;
  typedef logic [C_DIX_W-1:0] c_dix_t;
  typedef logic [C_BOF_W-1:0] c_bof_t;

  // pc structs
  typedef struct packed {
    c_tag_t icpctag;
    c_iix_t icpcind;
    c_bof_t icpcbtof;
  } ic_pc_t;

  typedef struct packed {
    c_tag_t dcpctag;
    c_dix_t dcpcind;
    logic   dcpcblof;
    c_bof_t dcpcbtof;
  } dc_pc_t;

  // cache block struct
  typedef word_t [1:0] dc_block_t;

  // cache frame structs
  typedef struct packed {
    logic   icvalid;
    c_tag_t ictag;
    word_t  icblock;
  } ic_frame_t;

  typedef struct packed {
    logic      dcvalid;
    logic      dcdirty;
    c_tag_t    dctag;
    dc_block_t dcblock;
  } dc_frame_t;

  // cache set struct
  typedef dc_frame_t [1:0] dc_set_t;

endpackage

`endif //CACHES_TYPES_PKG_VH
