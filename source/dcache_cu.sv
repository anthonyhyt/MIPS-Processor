module dcache_cu (
  input logic CLK, nRST,
  input logic dirty, dirties, needWB,
  input logic dhit, dwait,
  input logic dmemREN, dmemWEN, flush,
  input logic [3:0] count,
  output logic dREN, dWEN,
  output logic flctup, flctclr, hitctup, hitctdn, hitctout,
  output logic blof, invalid, dhitidle,
  output logic flushing, halt
);

  typedef enum logic [3:0] {
    IDLE, WB1, WB2, READ1, READ2,
    FLUSH1, FLUSH2, CTSTORE, HALT
  } state_t;

  state_t state, nxtstate;
  logic statechange, nxtstatechange;

  //detect state change
  assign nxtstatechange = (state != nxtstate);
  //combinational output
  assign flctclr = ~flushing;

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
    dhitidle = 1'b0;
    casez(state)
      //normal operation
      IDLE: begin
        hitctup = (dmemREN | dmemWEN) & dhit;
        dhitidle = dhit;
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
        invalid = statechange;
        dWEN = needWB;
        flctup = ~needWB;
        flushing = 1'b1;
      end
      FLUSH2: begin
        dWEN = 1'b1;
        flushing = 1'b1;
        blof = 1'b1;
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
      IDLE: begin
        if ((dmemREN | dmemWEN) & ~dhit)
          nxtstate = dirty ? WB1 : READ1;
        else if (flush)
          nxtstate = dirties ? FLUSH1 : CTSTORE;
        else
          nxtstate = state;
      end
      WB1:     nxtstate = ~dwait ? WB2 : state;
      WB2:     nxtstate = ~dwait ? READ1 : state;
      READ1:   nxtstate = ~dwait ? READ2 : state;
      READ2:   nxtstate = ~dwait ? IDLE : state;
      //flush and halt operation
      FLUSH1: begin
        if (~dirties | count == 5'h10)
          nxtstate = CTSTORE;
        else
          nxtstate = ~dwait ? FLUSH2 :  state;
      end
      FLUSH2:  nxtstate = ~dwait ? FLUSH1 : state;
      CTSTORE: nxtstate = ~dwait ? HALT : state;
      HALT:    nxtstate = IDLE;
      default: nxtstate = IDLE;
    endcase
  end

  //ff for a state machine and an state change detector
  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST) begin
      state <= IDLE;
      statechange <= 1'b0;
    end else begin
      state <= nxtstate;
      statechange <= 1'b1;
    end
  end

endmodule
