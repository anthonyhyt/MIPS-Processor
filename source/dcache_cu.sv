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
    IDLE = 4'h0, WB1 = 4'h1, WB2 = 4'h3, READ1 = 4'h2, READ2 = 4'h4,
    FLUSH1 = 4'h8, FLUSH2 = 4'hC, CTSTORE = 4'hA, HALT = 4'hE
  } state_t;

  state_t state, nxtstate;
  logic statechange, miss;

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
        hitctup = (dmemREN | dmemWEN) & dhit;
      end
      WB1: begin
        dWEN = 1'b1;
        invalid = statechange;
      end
      WB2: begin
        dWEN = 1'b1;
        blof = 1'b1;
      end
      READ1: begin
        dREN = 1'b1;
        invalid = statechange;
        hitctdn = statechange;
      end
      READ2: begin
        dREN = 1'b1;
        blof = 1'b1;
      end
      //flush and halt operation
      FLUSH1: begin
        dWEN = dirty;
        flctup = ~dirty;
        flushing = 1'b1;
      end
      FLUSH2: begin
        dWEN = 1'b1;
        flushing = 1'b1;
        blof = 1'b1;
        invalid = statechange;
        flctup = statechange;
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
      IDLE:    nxtstate = miss ? (dirty ? WB1 : READ1) :
                        (flush ? FLUSH1 : state);
      WB1:     nxtstate = ~dwait ? WB2 : state;
      WB2:     nxtstate = ~dwait ? READ1 : state;
      READ1:   nxtstate = ~dwait ? READ2 : state;
      READ2:   nxtstate = ~dwait ? IDLE : state;
      //flush and halt operation
      FLUSH1:  nxtstate = flctout != 5'h10 ? (~dwait ? FLUSH2 : state) : CTSTORE;
      FLUSH2:  nxtstate = ~dwait ? FLUSH1 : state;
      CTSTORE: nxtstate = ~dwait ? HALT : state;
      HALT:    nxtstate = IDLE;
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

  always_ff @ (posedge CLK, negedge nRST)
  begin:statechangeff
    if (~nRST)
      statechange <= 1'b0;
    else
      statechange <= (state != nxtstate);
  end

endmodule
