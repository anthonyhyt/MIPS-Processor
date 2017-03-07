//interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

//packages
`include "caches_types_pkg.vh"
`include "cpu_types_pkg.vh"

module dcache (
  input logic CLK, nRST,
  datapath_cache_if.dcache dcif,
  caches_if.dcache cif
);
  //types import
  import caches_types_pkg::*;
  import cpu_types_pkg::*;


