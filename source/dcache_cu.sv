module dcache_cu (
  input logic CLK, nRST,
  input logic dirty0, dirty1, dirties, dhit, lru, dwait, flush,
  input logic [3:0] count,
  output logic dREN, dWEN, clr_ct_en, hit_ct_en, hit_ct_o_en,
  output logic cclear, halt, block_offset
);

  typedef enum logic [3:0] {
    IDLE, IDLE2, WB1, WB2, READ1, READ2,
    COUNT, FLUSH1, FLUSH2, CTSTORE, HALT
  } state_t;

  state_t state, nxtstate;
  logic dirty;

  assign dirty = ~lru & dirty0 | lru & dirty1;

  always_comb
  begin:transition_logic
    casez(state)
      IDLE: begin
        if ((dREN | dWEN) & ~dwait) begin
          if (dirty)
            nxtstate = WB1;
          else
            nxtstate = READ1;
        end else if (flush) begin
          if (dirties)
            nxtstate = COUNT;
          else
            nxtstate = CTSTORE;
        end else
          nxtstate = state;
      end

  end


  always_ff (posedge CLK, negedge nRST)
  begin
    if (~nRST)
      state <= IDLE;
    else
      state <= nxtstate;
  end

endmodule
