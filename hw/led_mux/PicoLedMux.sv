module PicoLedMux (
    input clk,
    input resetn,
    input busin_valid,
    input [31:0] busin_addr,
    input [31:0] busin_wdata,
    input [3:0] busin_wstrb,
    output logic busout_ready,
    output logic [31:0] busout_rdata,
    
    output logic [7:0] busout_sseg,
    output logic [3:0] busout_led
);
logic[31:0] data_reg,data_next;
led_mux u_led_mux ( .clk(clk),
                    .resetn(resetn), 
                    .busout_sseg(busout_sseg),
                    .busout_led(busout_led),
                    .busin_led3(data_reg[31:24]),
                    .busin_led2(data_reg[23:16]),
                    .busin_led1(data_reg[15:8]),
                    .busin_led0(data_reg[7:0])
                    );


always_ff @( posedge clk or negedge resetn  ) begin : data_register
    if(!resetn) 
        data_reg <= 32'b0;
    else 
        data_reg <= data_next;
end

always_comb begin
    busout_ready = 1'b0;
    busout_rdata = 0;
    data_next = data_reg;
    if(busin_valid && !busout_ready)begin
        busout_ready = 1'b1;
        if (busin_wstrb[3]) data_next[31:24] = busin_wdata[31:24];
        if (busin_wstrb[2]) data_next[23:16] = busin_wdata[24:16];
        if (busin_wstrb[1]) data_next[15: 8] = busin_wdata[15: 8];
        if (busin_wstrb[0]) data_next[ 7: 0] = busin_wdata[ 7: 0];

        busout_rdata = data_reg;
    end
    

end






    
    
endmodule