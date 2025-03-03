module PicoMux_1_4 #(
 parameter PICOS0_ADDR_BASE = 32'h0000_0000,
 parameter PICOS0_ADDR_MASK = 32'hC000_0000,
 parameter PICOS1_ADDR_BASE = 32'h4000_0000,
 parameter PICOS1_ADDR_MASK = 32'hC000_0000,
 parameter PICOS2_ADDR_BASE = 32'h8000_0000,
 parameter PICOS2_ADDR_MASK = 32'hC000_0000,
 parameter PICOS3_ADDR_BASE = 32'hC000_0000,
 parameter PICOS3_ADDR_MASK = 32'hC000_0000
) (
 input picos0_ready,
 input [31:0] picos0_rdata,
 input picos1_ready,
 input [31:0] picos1_rdata,
 input picom_valid,
 input [31:0] picom_addr,
 input [31:0] picom_wdata,
 input [3:0] picom_wstrb,
 input picos2_ready,
 input [31:0] picos2_rdata,
 input picos3_ready,
 input [31:0] picos3_rdata,
 output logic picos0_valid,
 output logic [31:0] picos0_addr,
 output logic [31:0] picos0_wdata,
 output logic [3:0] picos0_wstrb,
 output logic picos1_valid,
 output logic [31:0] picos1_addr,
 output logic [31:0] picos1_wdata,
 output logic [3:0] picos1_wstrb,
 output logic picom_ready,
 output logic [31:0] picom_rdata,
 output logic picos2_valid,
 output logic [31:0] picos2_addr,
 output logic [31:0] picos2_wdata,
 output logic [3:0] picos2_wstrb,
 output logic picos3_valid,
 output logic [31:0] picos3_addr,
 output logic [31:0] picos3_wdata,
 output logic [3:0] picos3_wstrb
);
 logic picos0_match = ~|((picom_addr ^ PICOS0_ADDR_BASE) & PICOS0_ADDR_MASK);
 logic picos1_match = ~|((picom_addr ^ PICOS1_ADDR_BASE) & PICOS1_ADDR_MASK);
 logic picos2_match = ~|((picom_addr ^ PICOS2_ADDR_BASE) & PICOS2_ADDR_MASK);
 logic picos3_match = ~|((picom_addr ^ PICOS3_ADDR_BASE) & PICOS3_ADDR_MASK);
 
 logic picos0_sel = picos0_match;
 logic picos1_sel = picos1_match & (~picos0_match);
 logic picos2_sel = picos2_match & (~picos0_match) & (~picos1_match);
 logic picos3_sel = picos3_match & (~picos0_match) & (~picos1_match) & (~picos2_match);
 
 // master
 assign picom_rdata = picos0_sel ? picos0_rdata :
                      picos1_sel ? picos1_rdata :
                      picos2_sel ? picos2_rdata :
                      picos3_sel ? picos3_rdata :
                      32'b0;
 
 assign picom_ready = picos0_sel ? picos0_ready :
                      picos1_sel ? picos1_ready :
                      picos2_sel ? picos2_ready :
                      picos3_sel ? picos3_ready :
                      1'b0;
 
 // slave 0
 assign picos0_valid = picom_valid & picos0_sel;
 assign picos0_addr = picom_addr;
 assign picos0_wdata = picom_wdata;
 assign picos0_wstrb = picom_wstrb;
 
 // slave 1
 assign picos1_valid = picom_valid & picos1_sel;
 assign picos1_addr = picom_addr;
 assign picos1_wdata = picom_wdata;
 assign picos1_wstrb = picom_wstrb;
 
 // slave 2
 assign picos2_valid = picom_valid & picos2_sel;
 assign picos2_addr = picom_addr;
 assign picos2_wdata = picom_wdata;
 assign picos2_wstrb = picom_wstrb;
 
 // slave 3
 assign picos3_valid = picom_valid & picos3_sel;
 assign picos3_addr = picom_addr;
 assign picos3_wdata = picom_wdata;
 assign picos3_wstrb = picom_wstrb;
endmodule