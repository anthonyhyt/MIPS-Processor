/*
  Yiheng Chi
  chi14@purdue.edu

  request unit source code
*/

// import necessary files
`include "request_unit_if.vh"

// request unit module
module request_unit(
  input logic CLK, nRST,
  request_unit_if.ru ruif
);

// declare local reg for dREN & dWEN
//logic dmask;

// assign output wires
//assign ruif.dRENo = ruif.dRENi & ~dmask;
//assign ruif.dWENo = ruif.dWENi & ~dmask;
assign ruif.iRENo = 1'b1;

// request_unit's output logic
always_ff @ (posedge CLK, negedge nRST) begin
  if (nRST == 0) begin
    ruif.dRENo <= 1'b0;
    ruif.dWENo <= 1'b0;
    //dmask <= 1'b0;
  end else begin
    if (ruif.ihit == 1'b1) begin
      //dmask <= 1'b0;
      ruif.dRENo <= ruif.dRENi;
      ruif.dWENo <= ruif.dWENi;
    end else if (ruif.dhit == 1'b1) begin
      //dmask <= 1'b1;
      ruif.dRENo <= 1'b0;
      ruif.dWENo <= 1'b0;
    end
  end
end //always_ff


endmodule
