`timescale 1ns/1ps
module picorv32_soc_top (
  input clk,
  input resetn,

  output       tmds_clk_n,
  output       tmds_clk_p,
  output [2:0] tmds_d_n,
  output [2:0] tmds_d_p,

  output  flash_clk,
  output  flash_csb,
  inout   flash_mosi,
  inout   flash_miso,

  input  ser_rx,
  output ser_tx,
  inout [6:0] gpio,
  output[7:0] sseg,
  output[3:0] led
);

    picorv32_soc (.*);

endmodule