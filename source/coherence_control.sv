/*
  Yiheng Chi
  chi14@purdue.edu

  coherence control source code
*/

// interfaces
`include "caches_if.vh"
`include "cache_control_if.vh"

// types
`include "cpu_types_pkg.vh"

module coherence_control (
  input logic CLK, nRST,
  cache_control_if.cc c
);
  // type import
  import cpu_types_pkg::*;

  // service registers
  logic iserve, dserve;
  logic iserve_w;

  // state machine state names
  typedef enum logic [2:0] {
    CCREQ, CCARB, CCSNP, CCCTR, CCCTC, CCRTC, CCERR0, CCERR1
  } cc_state_t;

  // state machine
  cc_state_t state, nxstate;

  // instruction service wire assignment
  assign iserve_w = ^c.iREN ? c.iREN[1] : iserve;

  // service register logic
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST == 0) begin
      iserve <= 1'b0;
      dserve <= 1'b0;
    // iserve change
    end else if (state == CCREQ && c.ramstate == FREE) begin
      if (c.iREN[0] && ~c.iREN[1]) iserve <= 1'b0;
      else if (c.iREN[1] && ~c.iREN[0]) iserve <= 1'b1;
      //else if (c.iREN[0] && c.iREN[1]) iserve <= iserve + 1;
      else iserve <= iserve;
      dserve <= dserve;
    end else if (state == CCREQ && c.ramstate == ACCESS) begin
      if (c.iREN[0] && c.iREN[1]) iserve <= iserve + 1;
      else iserve <= iserve;
      dserve <= dserve;
    // dserve change
    end else if (state == CCARB) begin
      if (c.dWEN[0] && ~c.cctrans[0]) dserve <= 1'b0;
      else if (c.dWEN[1] && ~c.cctrans[1]) dserve <= 1'b1;
      else if (c.cctrans[0]) dserve <= 1'b0;
      else dserve <= 1'b1;
      iserve <= iserve;
    end else begin
      iserve <= iserve;
      dserve <= dserve;
    end
  end

  // state machine next state logic
  always_comb begin: cc_state_transition
    casez(state)
      CCREQ: begin
        if (c.cctrans[0] || c.cctrans[1] || c.dWEN[0] || c.dWEN[1])
          nxstate = CCARB;
        else nxstate = state;
      end
      CCARB: begin
        if (c.dWEN[0] || c.dWEN[1]) nxstate = CCCTR;
        else nxstate = CCSNP;
      end
      CCSNP: begin
        if (c.ccwrite[~dserve]) nxstate = CCCTC;
        else nxstate = CCRTC;
      end
      CCCTR: begin
        if (~c.dWEN[dserve]) nxstate = CCREQ;
        else nxstate = state;
      end
      CCCTC: begin
        if (~c.dWEN[dserve] && ~c.dREN[dserve])
          nxstate = CCREQ;
        else nxstate = state;
      end
      CCRTC: begin
        if (~c.dWEN[dserve] && ~c.dREN[dserve]) nxstate = CCREQ;
        else nxstate = state;
      end
      default: nxstate = state;
    endcase
  end

  // state machine transition logic
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST == 0) state <= CCREQ;
    else state <= nxstate;
  end

  // state machine output logic
  always_comb begin: cc_state_output
    casez(state)
      CCREQ: begin
        c.ramWEN = 1'b0;
        c.ramREN = c.iREN[0] | c.iREN[1];
        c.ramaddr = c.iaddr[iserve_w];
        c.ramstore = '0;
        c.iwait[iserve_w] = (c.ramstate != ACCESS);
        c.iwait[~iserve_w] = 1'b1;
        c.dwait = '1;
        c.iload[iserve_w] = c.ramload;
        c.iload[~iserve_w] = '0;
        c.dload = '0;
        c.ccwait = '0;
        c.ccinv = '0;
        c.ccsnoopaddr = '0;
      end
      CCARB: begin
        c.ramWEN = 1'b0;
        c.ramREN = 1'b0;
        c.ramaddr = '0;
        c.ramstore = '0;
        c.iwait = '1;
        c.dwait = '1;
        c.iload = '0;
        c.dload = '0;
        c.ccwait = '0;
        c.ccinv = '0;
        c.ccsnoopaddr = '0;
      end
      CCSNP: begin
        c.ramWEN = 1'b0;
        c.ramREN = 1'b0;
        c.ramaddr = '0;
        c.ramstore = '0;
        c.iwait = '1;
        c.dwait = '1;
        c.iload = '0;
        c.dload = '0;
        c.ccwait = '1;
        c.ccinv[dserve] = 1'b0;
        c.ccinv[~dserve] = c.cctrans[dserve] & c.ccwrite[dserve];
        c.ccsnoopaddr[0] = c.daddr[dserve];
        c.ccsnoopaddr[1] = c.daddr[dserve];
      end
      CCCTR: begin
        c.ramWEN = c.dREN[dserve] | c.dWEN[dserve];
        c.ramREN = 1'b0;
        c.ramaddr = c.daddr[dserve];
        c.ramstore = c.dstore[dserve];
        c.iwait = '1;
        c.dwait[dserve] = (c.ramstate != ACCESS);
        c.dwait[~dserve] = 1'b1;
        c.iload = '0;
        c.dload = '0;
        c.ccwait = '1;
        c.ccinv = '0;
        c.ccsnoopaddr[0] = c.daddr[dserve];
        c.ccsnoopaddr[1] = c.daddr[dserve];
      end
      CCCTC: begin
        c.ramWEN = c.dREN[dserve] | c.dWEN[dserve];
        c.ramREN = 1'b0;
        c.ramaddr = c.daddr[dserve];
        c.ramstore = c.dstore[~dserve];
        c.iwait = '1;
        c.dwait[0] = (c.ramstate != ACCESS);
        c.dwait[1] = (c.ramstate != ACCESS);
        c.iload = '0;
        c.dload[dserve] = c.dstore[~dserve];
        c.dload[~dserve] = '0;
        c.ccwait = '1;
        c.ccinv[dserve] = 1'b0;
        c.ccinv[~dserve] = c.cctrans[dserve] & c.ccwrite[dserve];
        c.ccsnoopaddr[0] = c.daddr[dserve];
        c.ccsnoopaddr[1] = c.daddr[dserve];
      end
      CCRTC: begin
        c.ramWEN = 1'b0;
        c.ramREN = 1'b1;
        c.ramaddr = c.daddr[dserve];
        c.ramstore = '0;
        c.iwait = '1;
        c.dwait[dserve] = (c.ramstate != ACCESS);
        c.dwait[~dserve] = 1'b1;
        c.iload = '0;
        c.dload[dserve] = c.ramload;
        c.dload[~dserve] = '0;
        c.ccwait = '1;
        c.ccinv[dserve] = 1'b0;
        c.ccinv[~dserve] = c.cctrans[dserve] & c.ccwrite[dserve];
        c.ccsnoopaddr[0] = c.daddr[dserve];
        c.ccsnoopaddr[1] = c.daddr[dserve];
      end
      default: begin
        c.ramWEN = 1'b0;
        c.ramREN = 1'b0;
        c.ramaddr = '0;
        c.ramstore = '0;
        c.iwait = '1;
        c.dwait = '1;
        c.iload = '0;
        c.dload = '0;
        c.ccwait = '0;
        c.ccinv = '0;
        c.ccsnoopaddr = '0;
      end
    endcase
  end

endmodule
