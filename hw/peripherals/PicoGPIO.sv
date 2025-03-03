module PicoGPIO (
 input clk,
 input resetn,
 input busin_valid,
 input [31:0] busin_addr,
 input [31:0] busin_wdata,
 input [3:0] busin_wstrb,
 output logic busout_ready,
 output logic [31:0] busout_rdata,
 inout [31:0] io
);

 logic [31:0] data_reg,data_next;
 logic [31:0] ie_reg,ie_next;
 logic [31:0] oe_reg, oe_next; 

    always_ff @(posedge clk or negedge resetn) begin : Register
        if (!resetn) begin
            data_reg<= 32'b0;
            oe_reg <= 32'b0;
            ie_reg <= 32'b0;
        end else begin
            data_reg <= data_next;
            oe_reg <= oe_next;
            ie_reg <= ie_next;
        end
    end

    always_comb begin 
        busout_ready = 1'b0;
        busout_rdata = 32'b0;
        oe_next = oe_reg;
        ie_next = ie_reg;
        data_next = data_reg;
            if (busin_valid && !busout_ready) begin
                busout_ready = 1'b1;
                case(busin_addr[3:2])
                /* Address = 0x8000_0000 : Register Output enable : Write */
                2'b00: begin
                    if (busin_wstrb[3]) oe_next[31:24] = busin_wdata[31:24];
                    if (busin_wstrb[2]) oe_next[24:16] = busin_wdata[24:16];
                    if (busin_wstrb[1]) oe_next[15: 8] = busin_wdata[15: 8];
                    if (busin_wstrb[0]) oe_next[ 7: 0] = busin_wdata[ 7: 0];
                    // Read and write won't happen at same transaction so no issue on late updating
                    busout_rdata = oe_reg;
                end
                /* Adress = 0x8000_0004 : Register Input enable */
                2'b01: begin
                    if (busin_wstrb[3]) ie_next[31:24] = busin_wdata[31:24];
                    if (busin_wstrb[2]) ie_next[24:16] = busin_wdata[24:16];
                    if (busin_wstrb[1]) ie_next[15: 8] = busin_wdata[15: 8];
                    if (busin_wstrb[0]) ie_next[ 7: 0] = busin_wdata[ 7: 0];
                    // Read and write won't happen at same transaction so no issue on late updating
                    busout_rdata = ie_reg;
                end
                /* Adress = 0x8000_0008 : Register Output Data */
                2'b10: begin

                    if (busin_wstrb[3]) data_next[31:24] = busin_wdata[31:24];
                    if (busin_wstrb[2]) data_next[24:16] = busin_wdata[24:16];
                    if (busin_wstrb[1]) data_next[15: 8] = busin_wdata[15: 8];
                    if (busin_wstrb[0]) data_next[ 7: 0] = busin_wdata[ 7: 0];
                    // Read and write won't happen at same transaction so no issue on late updating
                    busout_rdata = data_reg;
                end
                /* Adress = 0x8000_000C : Register Input Data */
                default: begin 
                    busout_rdata = io;
                end
                endcase
            end
    end
 // three-state-buffer
 genvar i;
 generate
     for (i = 0; i < 32; i = i + 1) begin
         assign io[i] = (oe_reg[i] && !ie_reg[i]) ? data_reg[i] : 1'bz;
     end

 endgenerate
endmodule
