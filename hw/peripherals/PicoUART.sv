module PicoUART (
 input clk,
 input resetn,
 input ser_rx,
 input mem_s_valid,
 input [31:0] mem_s_addr,
 input [31:0] mem_s_wdata,
 input [3:0] mem_s_wstrb,
 output ser_tx,
 output mem_s_ready,
 output [31:0] mem_s_rdata
);

 wire [31:0] reg_dat_do;
 wire [31:0] reg_div_do;
 
 assign mem_s_rdata = mem_s_addr[2] ?
                      reg_div_do :
                      reg_dat_do;
 
 wire reg_dat_sel = mem_s_valid && ~mem_s_addr[2];
 wire reg_div_sel = mem_s_valid && mem_s_addr[2];
 
 wire reg_dat_wait;
 
 assign mem_s_ready = reg_div_sel || (reg_dat_sel && ~reg_dat_wait);
 
 simpleuart u_simpleuart (
   .clk(clk),
   .resetn(resetn),
   .ser_tx(ser_tx),
   .ser_rx(ser_rx),
   .reg_div_we({4{reg_div_sel}} & mem_s_wstrb),
   .reg_div_di(mem_s_wdata),
   .reg_div_do(reg_div_do),
   .reg_dat_we(reg_dat_sel & mem_s_wstrb[0]),
   .reg_dat_re(reg_dat_sel & ~(|mem_s_wstrb)),
   .reg_dat_di(mem_s_wdata),
   .reg_dat_do(reg_dat_do),
   .reg_dat_wait(reg_dat_wait)
 );

endmodule
