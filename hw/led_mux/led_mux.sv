module led_mux (
    input clk,
    input resetn,
    input [7:0] busin_led3,busin_led2,busin_led1,busin_led0, 
    output logic [7:0] busout_sseg,
    output logic [3:0] busout_led
);
localparam N = 16;

// N - bit counter to generate refresh frequency led
logic[N-1:0] q_reg,q_next;

always_ff @( posedge clk or negedge resetn ) begin : counter
    if(!resetn) q_reg <= 0;
    else q_reg <= q_next;
end
assign q_next = q_reg + 1;
//**********************
always_comb begin : Decoder
    case (q_reg[15:14])
        2'b00: begin
            busout_led = 4'b1110;
            busout_sseg = busin_led0;
        end
        2'b01: begin
            busout_led = 4'b1101;
            busout_sseg = busin_led1;
        end
        2'b10: begin
            busout_led = 4'b1011;
            busout_sseg = busin_led2;
        end
        2'b11: begin
            busout_led = 4'b0111;
            busout_sseg = busin_led3;
        end
    endcase
end





    
    
endmodule