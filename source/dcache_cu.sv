module dcache_cu (
  input logic CLK, nRST,
  input logic dirty0, dirty1, dirties, dhit, lru, dwait, flush,
  input logic dmemREN, dmemWEN,
  input logic [3:0] count,
  output logic dREN, dWEN, clr_ct_en, hit_ctup, hit_ctdown, hit_ct_o_en,
  output logic cclear, halt, block_offset, clr_ct_clr
);

  typedef enum logic [3:0] {
    IDLE, WB1, WB2, READ1, READ2,
    COUNT, FLUSH1, FLUSH2, CTSTORE, HALT
  } state_t;

  state_t state, nxtstate;
  logic dirty;

  assign dirty = ~lru & dirty0 | lru & dirty1;
  assign clr_ct_clr = ~cclear;
  assign hit_ctdown = (state == IDLE) & (nxtstate == WB1);

  always_comb
  begin:output_logic
    dREN = 1'b0;
    dWEN = 1'b0;
    clr_ct_en = 1'b0;
    hit_ctup = 1'b0;
    hit_ct_o_en = 1'b0;
    cclear = 1'b0;
    halt = 1'b0;
    block_offset = 1'b0;
    casez(state)
      //normal operation
      IDLE: hit_ctup = dmemREN | dmemWEN;
      WB1: begin
        dWEN = 1'b1;
      end
      WB2: begin
        dWEN = 1'b1;
        block_offset = 1'b1;
      end
      READ1: dREN = 1'b1;
      READ2: begin
        dREN = 1'b1;
        block_offset = 1'b1;
      end
      //flush and halt operation
      COUNT: begin
        dWEN = 1'b1;
        cclear = 1'b1;
        clr_ct_en = 1'b1;
      end
      FLUSH1: begin
        dWEN = 1'b1;
        cclear = 1'b1;
      end
      FLUSH2: begin
        dWEN = 1'b1;
        cclear = 1'b1;
        block_offset = 1'b1;
      end
      CTSTORE: begin
        dWEN = 1'b1;
        hit_ct_o_en = 1'b1;
      end
      HALT: halt = 1'b1;
    endcase
  end

  always_comb
  begin:transition_logic
    casez(state)
      //normal operation
      IDLE: begin
        if ((dmemREN | dmemWEN) & ~dhit) begin
          if (dirty)
            nxtstate = WB1;
          else
            nxtstate = READ1;
        end else if (flush) begin
          if (dirties)
            nxtstate = FLUSH1;
          else
            nxtstate = CTSTORE;
        end else
          nxtstate = state;
      end
      WB1: begin
        if (~dwait)
          nxtstate = WB2;
        else
          nxtstate = state;
      end
      WB2: begin
        if (~dwait)
          nxtstate = READ1;
        else
          nxtstate = state;
      end
      READ1: begin
        if ( ~dwait)
          nxtstate = READ2;
        else
          nxtstate = state;
      end
      READ2: begin
        if (~dwait)
          nxtstate = IDLE;
        else
          nxtstate = state;
      end
      //flush and halt operation
      COUNT: begin
        if (~dwait)
          nxtstate = FLUSH2;
        else
          nxtstate = FLUSH1;
      end
      FLUSH1: begin
        if (~dwait)
          nxtstate = FLUSH2;
        else
          nxtstate = state;
      end
      FLUSH2: begin
        if (~dwait) begin
          if (~dirties | count == 4'hf)
            nxtstate = CTSTORE;
          else
            nxtstate = COUNT;
        end else
          nxtstate = state;
      end
      CTSTORE: begin
        if (~dwait)
          nxtstate = HALT;
        else
          nxtstate = state;
      end
      HALT: nxtstate = IDLE;
      default: nxtstate = IDLE;
    endcase
  end


  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST)
      state <= IDLE;
    else
      state <= nxtstate;
  end

endmodule
