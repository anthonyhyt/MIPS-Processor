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

  // service registers and wire
  logic iserve, dserve;
  logic iserve_w;

  // busRead and busReadX registers
  logic [1:0] busRd, busRdX;

  // serving cache addr register
  word_t serveaddr;
  word_t daddr0, daddr1;

  // state machine state names
  typedef enum logic [3:0] {
    CCREQ, CCARB, CCSNP, CCCTR1, CCCTR2, CCCTC1, CCCTC2, CCRTC1, CCRTC2, CCERR9,
    CCERR10, CCERR11, CCERR12, CCERR13, CCERR14, CCERR15
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
      serveaddr <= '0;
      daddr0 <= '0;
      daddr1 <= '0;
    // iserve change
    end else if (state == CCREQ && c.ramstate == FREE) begin
      if (c.iREN[0] && ~c.iREN[1]) iserve <= 1'b0;
      else if (c.iREN[1] && ~c.iREN[0]) iserve <= 1'b1;
      //else if (c.iREN[0] && c.iREN[1]) iserve <= iserve + 1;
      else iserve <= iserve;
      dserve <= dserve;
      serveaddr <= serveaddr;
      daddr0 <= daddr0;
      daddr1 <= daddr1;
    end else if (state == CCREQ && c.ramstate == ACCESS) begin
      if (c.iREN[0] && c.iREN[1]) iserve <= iserve + 1;
      else iserve <= iserve;
      dserve <= dserve;
      serveaddr <= serveaddr;
      daddr0 <= daddr0;
      daddr1 <= daddr1;
    // dserve change
    end else if (state == CCARB) begin
      if (c.dWEN[0] && ~c.cctrans[0]) begin
        dserve <= 1'b0;
        serveaddr <= c.daddr[0];
      end else if (c.dWEN[1] && ~c.cctrans[1]) begin
        dserve <= 1'b1;
        serveaddr <= c.daddr[1];
      end else if (c.cctrans[0] && c.ccwrite[0]) begin
        dserve <= 1'b0;
        serveaddr <= c.daddr[0];
      end else if (c.cctrans[1] && c.ccwrite[1]) begin
        dserve <= 1'b1;
        serveaddr <= c.daddr[1];
      end else if (c.cctrans[0]) begin
        dserve <= 1'b0;
        serveaddr <= c.daddr[0];
      end else begin
        dserve <= 1'b1;
        serveaddr <= c.daddr[1];
      end
      daddr0 <= c.daddr[0];
      daddr1 <= c.daddr[1];
      iserve <= iserve;
    end else if (state == CCCTR1 || state == CCCTC1 || state == CCRTC1) begin
      if (c.ramstate == ACCESS) serveaddr <= serveaddr + 4;
      else serveaddr <= serveaddr;
      iserve <= iserve;
      dserve <= dserve;
      daddr0 <= daddr0;
      daddr1 <= daddr1;
    end else begin
      iserve <= iserve;
      dserve <= dserve;
      serveaddr <= serveaddr;
      daddr0 <= daddr0;
      daddr1 <= daddr1;
    end
  end

  // busRead and busReadX register logic
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST == 0) begin
      busRd <= '0;
      busRdX <= '0;
    end else if (state == CCARB) begin
      busRd[0] <= c.cctrans[0] & ~c.ccwrite[0];
      busRd[1] <= c.cctrans[1] & ~c.ccwrite[1];
      busRdX[0] <= c.cctrans[0] & c.ccwrite[0];
      busRdX[1] <= c.cctrans[1] & c.ccwrite[1];
    end else begin
      busRd <= busRd;
      busRdX <= busRdX;
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
        if (c.dWEN[0] || c.dWEN[1]) nxstate = CCCTR1;
        else nxstate = CCSNP;
      end
      CCSNP: begin
        if (c.ccwrite[~dserve]) nxstate = CCCTC1;
        else nxstate = CCRTC1;
      end
      CCCTR1: begin
        if (c.ramstate == ACCESS || ~c.dWEN[dserve]) nxstate = CCCTR2;
        else nxstate = state;
      end
      CCCTR2: begin
        if (~c.dWEN[dserve]) nxstate = CCREQ;
        else nxstate = state;
      end
      CCCTC1: begin
        if (c.ramstate == ACCESS || (~c.dWEN[dserve] && ~c.dREN[dserve]))
          nxstate = CCCTC2;
        else nxstate = state;
      end
      CCCTC2: begin
        if (~c.dWEN[dserve] && ~c.dREN[dserve])
          nxstate = CCREQ;
        else nxstate = state;
      end
      CCRTC1: begin
        if (c.ramstate == ACCESS || (~c.dWEN[dserve] && ~c.dREN[dserve]))
          nxstate = CCRTC2;
        else nxstate = state;
      end
      CCRTC2: begin
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
        if (busRdX[0] && busRdX[1] && c.daddr[0] != c.daddr[1]) begin
          c.ccinv = '1;
          c.ccsnoopaddr[0] = daddr1;
          c.ccsnoopaddr[1] = daddr0;
        end else begin
          c.ccinv[dserve] = 1'b0;
          c.ccinv[~dserve] = busRdX[dserve];
          c.ccsnoopaddr[0] = serveaddr;
          c.ccsnoopaddr[1] = serveaddr;
        end
      end
      CCCTR1: begin
        c.ramWEN = c.dWEN[dserve];
        c.ramREN = 1'b0;
        c.ramaddr = serveaddr;
        c.ramstore = c.dstore[dserve];
        c.iwait = '1;
        c.dwait[dserve] = (c.ramstate != ACCESS);
        c.dwait[~dserve] = 1'b1;
        c.iload = '0;
        c.dload = '0;
        c.ccwait = '1;
        c.ccinv = '0;
        c.ccsnoopaddr[0] = serveaddr;
        c.ccsnoopaddr[1] = serveaddr;
      end
      CCCTR2: begin
        c.ramWEN = c.dWEN[dserve];
        c.ramREN = 1'b0;
        c.ramaddr = serveaddr;
        c.ramstore = c.dstore[dserve];
        c.iwait = '1;
        c.dwait[dserve] = (c.ramstate != ACCESS);
        c.dwait[~dserve] = 1'b1;
        c.iload = '0;
        c.dload = '0;
        c.ccwait = '1;
        c.ccinv = '0;
        c.ccsnoopaddr[0] = serveaddr;
        c.ccsnoopaddr[1] = serveaddr;
      end
      CCCTC1: begin
        c.ramWEN = c.dREN[dserve];
        c.ramREN = 1'b0;
        c.ramaddr = serveaddr;
        c.ramstore = c.dstore[~dserve];
        c.iwait = '1;
        c.dwait[0] = (c.ramstate != ACCESS);
        c.dwait[1] = (c.ramstate != ACCESS);
        c.iload = '0;
        c.dload[dserve] = c.dstore[~dserve];
        c.dload[~dserve] = '0;
        c.ccwait = '1;
        c.ccinv[dserve] = 1'b0;
        c.ccinv[~dserve] = busRdX[dserve];
        c.ccsnoopaddr[0] = serveaddr;
        c.ccsnoopaddr[1] = serveaddr;
      end
      CCCTC2: begin
        c.ramWEN = c.dREN[dserve];
        c.ramREN = 1'b0;
        c.ramaddr = serveaddr;
        c.ramstore = c.dstore[~dserve];
        c.iwait = '1;
        c.dwait[0] = (c.ramstate != ACCESS);
        c.dwait[1] = (c.ramstate != ACCESS);
        c.iload = '0;
        c.dload[dserve] = c.dstore[~dserve];
        c.dload[~dserve] = '0;
        c.ccwait = '1;
        c.ccinv[dserve] = 1'b0;
        c.ccinv[~dserve] = busRdX[dserve];
        c.ccsnoopaddr[0] = serveaddr;
        c.ccsnoopaddr[1] = serveaddr;
      end
      CCRTC1: begin
        c.ramWEN = 1'b0;
        c.ramREN = c.dREN[dserve];
        c.ramaddr = serveaddr;
        c.ramstore = '0;
        c.iwait = '1;
        c.dwait[dserve] = (c.ramstate != ACCESS);
        c.dwait[~dserve] = 1'b1;
        c.iload = '0;
        c.dload[dserve] = c.ramload;
        c.dload[~dserve] = '0;
        c.ccwait = '1;
        c.ccinv[dserve] = 1'b0;
        c.ccinv[~dserve] = busRdX[dserve];
        c.ccsnoopaddr[0] = serveaddr;
        c.ccsnoopaddr[1] = serveaddr;
      end
      CCRTC2: begin
        c.ramWEN = 1'b0;
        c.ramREN = c.dREN[dserve];
        c.ramaddr = serveaddr;
        c.ramstore = '0;
        c.iwait = '1;
        c.dwait[dserve] = (c.ramstate != ACCESS);
        c.dwait[~dserve] = 1'b1;
        c.iload = '0;
        c.dload[dserve] = c.ramload;
        c.dload[~dserve] = '0;
        c.ccwait = '1;
        c.ccinv[dserve] = 1'b0;
        c.ccinv[~dserve] = busRdX[dserve];
        c.ccsnoopaddr[0] = serveaddr;
        c.ccsnoopaddr[1] = serveaddr;
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
