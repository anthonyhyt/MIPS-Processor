/*
  Yiheng Chi
  chi14@purdue.edu

  branch buffer types
*/
`ifndef BRANCH_BUFFER_TYPES_PKG_VH
`define BRANCH_BUFFER_TYPES_PKG_VH

// all types
`include "cpu_types_pkg.vh"

package branch_buffer_types_pkg;

  // import types
  import cpu_types_pkg::*;

  // tag width
  parameter IND_W = 2;
  parameter PAD_W = 2;
  parameter TAG_W = WORD_W - IND_W - PAD_W; //28

  // types
  typedef logic [TAG_W-1:0] tag_t;
  typedef logic [IND_W-1:0] ind_t;
  typedef logic [PAD_W-1:0] pad_t;

  // branch buffer struct
  typedef struct packed {
    logic   bufvalid;
    tag_t   buftag;
    word_t  buftarget;
  } buffer_t;

  // pc struct
  typedef struct packed {
    tag_t pctag;
    ind_t pcind;
    pad_t pcpad;
  } pc_t;

endpackage

`endif //BRANCH_BUFFER_TYPES_PKG_VH
