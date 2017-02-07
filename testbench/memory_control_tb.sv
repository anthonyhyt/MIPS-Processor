/*
  Yiheng Chi
  chi14@purdue.edu

  memory control test bench
*/

// interfaces
`include "caches_if.vh"
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"

// types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;
  // clock period
  parameter PERIOD = 20;

  //signals
  logic CLK = 1, RAM_CLK = 1, nRST;
  integer ind;

  // clock
  always #(PERIOD/2) CLK++;
  always #(PERIOD/4) RAM_CLK++;

  // interface
  caches_if cif();
  caches_if cif2();
  cache_control_if ccif(cif, cif2);
  cpu_ram_if ramif();

  // test program
  test PROG(CLK, nRST, cif);

  // DUT and ram
`ifndef MAPPED
  memory_control DUT(ccif);
  ram RAM(RAM_CLK, nRST, ramif);
`else
  memory_control DUT(
    .\ccif.iREN (ccif.iREN),
    .\ccif.dREN (ccif.dREN),
    .\ccif.dWEN (ccif.dWEN),
    .\ccif.dstore (ccif.dstore),
    .\ccif.iaddr (ccif.iaddr),
    .\ccif.daddr (ccif.daddr),
    .\ccif.ramload (ccif.ramload),
    .\ccif.ramstate (ccif.ramstate),
    .\ccif.ccwrite (ccif.ccwrite),
    .\ccif.cctrans (ccif.cctrans),
    .\ccif.iwait (ccif.iwait),
    .\ccif.dwait (ccif.dwait),
    .\ccif.iload (ccif.iload),
    .\ccif.dload (ccif.dload),
    .\ccif.ramstore (ccif.ramstore),
    .\ccif.ramaddr (ccif.ramaddr),
    .\ccif.ramWEN (ccif.ramWEN),
    .\ccif.ramREN (ccif.ramREN),
    .\ccif.ccwait (ccif.ccwait),
    .\ccif.ccinv (ccif.ccinv),
    .\ccif.ccsnoopaddr (ccif.ccsnoopaddr)
  );
  ram RAM(
    .\CLK (RAM_CLK),
    .\nRST (nRST),
    .\ramif.ramaddr (ramif.ramaddr),
    .\ramif.ramstore (ramif.ramstore),
    .\ramif.ramREN (ramif.ramREN),
    .\ramif.ramWEN (ramif.ramWEN),
    .\ramif.ramstate (ramif.ramstate),
    .\ramif.ramload (ramif.ramload)
  );
`endif

  // DUT to RAM wires connection
  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramstore = ccif.ramstore;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;

  assign ccif.ramstate = ramif.ramstate;
  assign ccif.ramload = ramif.ramload;

  // CPU to RAM wires connection
  assign ramif.memaddr = ccif.ramaddr;
  assign ramif.memstore = ccif.ramstore;
  assign ramif.memREN = ccif.ramREN;
  assign ramif.memWEN = ccif.ramWEN;

  // tasks
  // initialize signals
  task init;
  begin
    ind = 0;

    cif.iREN = 1'b0;
    cif.dREN = 1'b0;
    cif.dWEN = 1'b0;
    cif.dstore = 32'b0;
    cif.iaddr = 32'b0;
    cif.daddr = 32'b0;
    cif.ccwrite = '0;
    cif.cctrans = '0;

    cif2.iREN = 1'b0;
    cif2.dREN = 1'b0;
    cif2.dWEN = 1'b0;
    cif2.dstore = 32'b0;
    cif2.iaddr = 32'b0;
    cif2.daddr = 32'b0;
    cif2.ccwrite = '0;
    cif2.cctrans = '0;

    nRST = 1'b0;
    @(posedge CLK);
    @(negedge CLK);
    nRST = 1'b1;
  end
  endtask

  // instruction read
  task iread;
    input [31:0] addr;
  begin
    cif.iREN = 1'b1;
    cif.iaddr = addr;
  end
  endtask

  // data read
  task dread;
    input [31:0] addr;
  begin
    cif.dREN = 1'b1;
    cif.daddr = addr;
  end
  endtask

  // data write
  task dwrite;
    input [31:0] addr;
    input [31:0] store;
  begin
    cif.dWEN = 1'b1;
    cif.daddr = addr;
    cif.dstore = store;
  end
  endtask

  // reset all enable signals
  task rst;
  begin
    cif.iREN = 1'b0;
    cif.dREN = 1'b0;
    cif.dWEN = 1'b0;
    @(posedge CLK);
    @(posedge CLK);
  end
  endtask

  // read first n instructions of ram
  task iread_n;
    input n;
  begin
    if (n == 50) begin
      for (ind = 0; ind < 50; ind++) begin
        iread(ind*4);
        @(negedge cif.iwait);
        #(1*PERIOD);
        $display("Inst #%d: %h", ind+1, cif.iload);
        rst;
      end
    end else if (n == 100) begin
      for (ind = 0; ind < 50; ind++) begin
        iread(ind*4);
        @(negedge cif.iwait);
        #(1*PERIOD);
        $display("Inst #%d: %h", ind+1, cif.iload);
        rst;
      end
    end else begin
      for (ind = 0; ind < 10; ind++) begin
        iread(ind*4);
        @(negedge cif.iwait);
        #(1*PERIOD);
        $display("Inst #%d: %h", ind+1, cif.iload);
        rst;
      end
    end
  end
  endtask

  // read first n data of ram
  task dread_n;
    input n;
  begin
    if (n == 50) begin
      for (ind = 0; ind < 50; ind++) begin
        dread(ind*4);
        @(negedge cif.dwait);
        #(1*PERIOD);
        $display("Data #%d: %h", ind+1, cif.dload);
        rst;
      end
    end else if (n == 100) begin
      for (ind = 0; ind < 50; ind++) begin
        dread(ind*4);
        @(negedge cif.dwait);
        #(1*PERIOD);
        $display("Data #%d: %h", ind+1, cif.dload);
        rst;
      end
    end else begin
      for (ind = 0; ind < 10; ind++) begin
        dread(ind*4);
        @(negedge cif.dwait);
        #(1*PERIOD);
        $display("Data #%d: %h", ind+1, cif.dload);
        rst;
      end
    end
  end
  endtask

  // write to the first 10 words
  task write_10;
    input [31:0] store;
  begin
    for (ind = 0; ind < 10; ind++) begin
      dwrite(ind*4, store);
      @(negedge cif.dwait);
      #(1*PERIOD);
      rst;
    end
  end
  endtask

  // try read instruction and data simultaneously
  task ri_rd;
  begin
    iread('0);
    dread('0);
    @(negedge cif.dwait);
    #(1*PERIOD);
    if (cif.iwait == 1'b0)
      $display("ERORR: iwait is 0 when dREN is set!");
    cif.dREN = 1'b0;
    @(negedge cif.iwait);
    #(1*PERIOD);
    rst;
  end
  endtask

  // try read instruction and write data simultaneously
  task ri_wd;
  begin
    iread('0);
    dwrite('0, 32'h00BADACC);
    @(negedge cif.dwait);
    #(1*PERIOD);
    if (cif.iwait == 1'b0)
      $display("ERROR: iwait is 0 when dWEN is set!");
    cif.dWEN = 1'b0;
    @(negedge cif.iwait);
    #(1*PERIOD);
    rst;
  end
  endtask

  // dump from ram
  task automatic dump_memory();
    string filename = "mem.hex";
    int memfd;

    //syif.addr = 0;
    //syif.WEN = 0;
    //syif.REN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      dread(i<<2);
      //syif.addr = i << 2;
      //syif.REN = 1;
      //repeat (4) @(posedge CLK);
      @(negedge cif.dwait);
      #(1*PERIOD);
      if (cif.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      cif.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask


endmodule

program test(
  input logic CLK, nRST,
  caches_if cif
);

initial
begin

  $display("Initializing...");
  init;

  $display("Initialization done. Testing...");
  $display("Reading first 10 instructions...");
  iread_n(10);
  $display("Reading first 10 data...");
  dread_n(10);
  $display("Writing first 10 data...");
  write_10(32'hDEADBEEF);
  $display("Reading first 10 data...");
  dread_n(10);

  $display("Testing 2 simultaneous signals...");
  ri_rd;
  ri_wd;

  $display("Dumping from memory...");
  dump_memory;

end
endprogram
