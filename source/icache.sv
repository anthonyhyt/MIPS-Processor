/*
  Yiheng Chi
  chi14@purdue.edu

  instruction cache source code
*/

// interface
`include "caches_if.vh"
`include "datapath_cache_if.vh"

// all types
`include "cpu_types_pkg.vh"
`include "caches_types_pkg.vh"

module icache (
  input logic CLK, nRST,
  caches_if.icache c,
  datapath_cache_if.icache dc
);
  /*
  dc:
    input   imemREN, imemaddr,
    output  ihit, imemload

  c:
    input   iwait, iload,
    output  iREN, iaddr
  */

  // import types
  import cpu_types_pkg::*;
  import caches_types_pkg::*;

  // declare cache unpacked frames
  ic_frame_t cache [15:0];

  // casted pc
  ic_pc_t ICpc;

  // cast input address
  assign ICpc = ic_pc_t'(dc.imemaddr);

  // assign datapath side output signals
  assign dc.imemload = cache[ICpc.icpcind].icblock;
  assign dc.ihit = (cache[ICpc.icpcind].icvalid &&
                    cache[ICpc.icpcind].ictag == ICpc.icpctag);

  // cache content update logic
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST == 0) begin
      cache <= '{default:'0};
    end else if (!c.iwait) begin
      cache[ICpc.icpcind].icvalid = 1'b1;
      cache[ICpc.icpcind].ictag = ICpc.icpctag;
      cache[ICpc.icpcind].icblock = c.iload;
    end
  end

  // state machine state names
  typedef enum logic [1:0] {
    ICIDLE, ICREAD
  } ic_state_t;

  // state machine
  ic_state_t state, nxstate;

  // state machine next state logic
  always_comb begin: ic_state_transition
    casez(state)
      ICIDLE: begin
        if (dc.imemREN && !dc.ihit) nxstate = ICREAD;
        else nxstate = state;
      end
      ICREAD: begin
        if (dc.imemREN && !c.iwait) nxstate = ICIDLE;
        else nxstate = state;
      end
      default: nxstate = state;
    endcase
  end

  // state machine transition logic
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST == 0) state <= ICIDLE;
    else state <= nxstate;
  end

  // state machine output logic
  always_comb begin: ic_state_output
    casez(state)
      ICIDLE: begin
        c.iREN = 1'b0;
        c.iaddr = '0;
      end
      ICREAD: begin
        c.iREN = 1'b1;
        c.iaddr = dc.imemaddr;
      end
      default: begin
        c.iREN = 1'b0;
        c.iaddr = '0;
      end
    endcase
  end

endmodule
