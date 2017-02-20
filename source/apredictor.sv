module apredictor (
  input logic CLK, nRST, ABtaken, en,
  output logic result
);

  typedef enum logic [1:0] {
    SNOTTAKEN = 2'b00,  //strong not taken
    WNOTTAKEN = 2'b01,  //weak not taken
    STAKEN = 2'b11,     //strong taken
    WTAKEN = 1'b10      //weak taken
  } state_t;

  state_t state, nxtstate;

  always_comb
  begin:state_output
    casez(state)
      SNOTTAKEN:  result = 1'b0;
      WNOTTAKEN:  result = 1'b0;
      STAKEN:     result = 1'b1;
      WTAKEN:     result = 1'b1;
    endcase

  end

  always_comb
  begin:state_transition
    casez(state)
      SNOTTAKEN:  begin
        if (ABtaken)
          nxtstate = WNOTTAKEN;
        else
          nxtstate = state;
      end
      WNOTTAKEN:  begin
        if (ABtaken)
          nxtstate = STAKEN;
        else
          nxtstate = SNOTTAKEN;
      end
      STAKEN:  begin
        if (~ABtaken)
          nxtstate = WTAKEN;
        else
          nxtstate = state;
      end
      WTAKEN:  begin
        if (~ABtaken)
          nxtstate = SNOTTAKEN;
        else
          nxtstate = STAKEN;
      end
      default:  nxtstate = state;
    endcase
  end

  always_ff @ (posedge CLK, negedge nRST)
  begin
    if (~nRST)
      state <= SNOTTAKEN;
    else if (en)
      state <= nxtstate;
  end

endmodule
