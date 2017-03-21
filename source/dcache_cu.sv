module dcache_cu (
  input logic CLK, nRST,
  input logic dirty,
  input logic dhit, dwait,
  input logic dmemREN, dmemWEN, flush,      //signal from dp
  output logic dREN, dWEN,                  //signal to mem
  output logic flctup,                      //flush counter
  input logic [4:0] flctout,
  output logic hitctup, hitctdn, hitctout,  //hit counter
  output logic blof, invalid,
  output logic flushing, halt
);

  typedef enum logic [3:0] {
    IDLE, WB1, WB2, MISSCT, READ1, READ2,
    FLSTART, FLUSH1, FLUSH2, FLCT, CTSTORE, HALT
  } state_t;

  state_t state, nxtstate;
  logic miss;

  //some combinational logic
  assign miss = (dmemREN | dmemWEN) & ~dhit;

  always_comb
  begin:output_logic
    dREN = 1'b0;
    dWEN = 1'b0;
    flctup = 1'b0;
    hitctup = 1'b0;
    hitctout = 1'b0;
    flushing = 1'b0;
    halt = 1'b0;
    blof = 1'b0;
    invalid = 1'b0;
    hitctdn = 1'b0;
    casez(state)
      //normal operation
      IDLE: begin
        hitctup = 1'b1;
      end
      WB1: begin
        dWEN = 1'b1;
        invalid = 1'b1;
      end
      WB2: begin
        dWEN = 1'b1;
        blof = 1'b1;
      end
      MISSCT: begin
        dREN = 1'b1;
        invalid = 1'b1;
        hitctdn = 1'b1;
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
      CTSTORE: begin
        dWEN = 1'b1;
        hitctout = 1'b1;
      end
      HALT: halt = 1'b1;
    endcase
  end

  always_comb
  begin:transition_logic
    casez(state)
      //normal operation
      IDLE:    nxtstate = miss ? (dirty ? WB1 : MISSCT) :
                        (flush ? FLSTART : state);
      WB1:     nxtstate = ~dwait ? WB2 : state;
      WB2:     nxtstate = ~dwait ? MISSCT : state;
      MISSCT:  nxtstate = ~dwait ? READ2 : READ1;
      READ1:   nxtstate = ~dwait ? READ2 : state;
      READ2:   nxtstate = ~dwait ? IDLE : state;
      //flush and halt operation
      FLSTART: nxtstate = flctout != 5'h10 ? (dirty ? FLUSH1 : FLCT) : CTSTORE;
      FLUSH1:  nxtstate = ~dwait ? FLUSH2 : state;
      FLUSH2:  nxtstate = ~dwait ? FLCT : state;
      FLCT:    nxtstate = FLSTART;
      CTSTORE: nxtstate = ~dwait ? HALT : state;
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
