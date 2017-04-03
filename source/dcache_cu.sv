module dcache_cu (
  input logic CLK, nRST,
  input logic dirty,
  input logic dhit, dwait,
  input logic dmemREN, dmemWEN, flush,      //signal from dp
  input logic ccwait, ccwrite,              //signal from mem
  output logic dREN, dWEN,                  //signal to mem
  output logic flctup,                      //flush counter
  input logic [4:0] flctout,
  output logic blof, invalid,
  output logic flushing, halt
);

  typedef enum logic [3:0] {
    IDLE, WB1, WB2, WB3, WB4, READ1, READ2,
    FLSTART, FLUSH1, FLUSH2, FLCT, HALT
  } state_t;

  state_t state, nxtstate;
  logic miss, meminvalid;

  //some combinational logic
  assign miss = (dmemREN | dmemWEN) & ~dhit;
  assign meminvalid = ccwait & ccwrite;

  always_comb
  begin:output_logic
    dREN = 1'b0;
    dWEN = 1'b0;
    flctup = 1'b0;
    flushing = 1'b0;
    halt = 1'b0;
    blof = 1'b0;
    invalid = 1'b0;
    casez(state)
      //normal operation
      IDLE: begin
      end
      WB1: begin
        dWEN = 1'b1;
        invalid = 1'b1;
      end
      WB2: begin
        dWEN = 1'b1;
        blof = 1'b1;
      end
      WB3: begin
        dWEN = 1'b1;
        invalid = 1'b1;
      end
      WB4: begin
        dWEN = 1'b1;
        blof = 1'b1;
      end
      READ1: begin
        dREN = 1'b1;
      end
      READ2: begin
        dREN = 1'b1;
        blof = 1'b1;
      end
      //flush and halt operation
      FLSTART: begin
        flushing = 1'b1;
      end
      FLUSH1: begin
        flushing = 1'b1;
        dWEN = 1'b1;
        invalid = 1'b1;
      end
      FLUSH2: begin
        flushing = 1'b1;
        dWEN = 1'b1;
        blof = 1'b1;
      end
      FLCT: begin
        flushing = 1'b1;
        flctup = 1'b1;
      end
      HALT: halt = 1'b1;
    endcase
  end

  always_comb
  begin:transition_logic
    casez(state)
      //normal operation
      IDLE:    nxtstate = miss & ~ccwait ? (dirty ? WB1 : READ1) :
                        (flush ? FLSTART : (meminvalid ? WB3 : state));
      WB1:     nxtstate = ~dwait ? WB2 : state;
      WB2:     nxtstate = ~dwait ? READ1 : state;
      WB3:     nxtstate = ~dwait ? WB4 : state;
      WB4:     nxtstate = ~dwait ? IDLE : state;
      READ1:   nxtstate = ~dwait ? READ2 : state;
      READ2:   nxtstate = ~dwait ? IDLE : state;
      //flush and halt operation
      FLSTART: nxtstate = flctout != 5'h10 ? (dirty ? FLUSH1 : FLCT) : HALT;
      FLUSH1:  nxtstate = ~dwait ? FLUSH2 : state;
      FLUSH2:  nxtstate = ~dwait ? FLCT : state;
      FLCT:    nxtstate = FLSTART;
      HALT:    nxtstate = state;
      default: nxtstate = IDLE;
    endcase
  end

  always_ff @ (posedge CLK, negedge nRST)
  begin:stateff
    if (~nRST)
      state <= IDLE;
    else
      state <= nxtstate;
  end

endmodule
