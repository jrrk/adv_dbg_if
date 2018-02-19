// Copyright 2015 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

import ariane_pkg::*;

module dbg_wrap
#(
    parameter NB_CORES             = 1,
    parameter AXI_ADDR_WIDTH       = 32,
    parameter AXI_DATA_WIDTH       = 64,
    parameter AXI_ID_MASTER_WIDTH  = 10,
    parameter AXI_ID_SLAVE_WIDTH   = 10,
    parameter AXI_USER_WIDTH       = 0
  )
(
    // Clock and Reset
    input logic         clk,
    input logic         rst_n,
    input  logic        testmode_i,

    AXI_BUS.Master      dbg_master,
    // CPU signals
    output logic [15:0] cpu_addr_o, 
    input  logic [31:0] cpu_data_i, 
    output logic [31:0] cpu_data_o,
    input  logic        cpu_bp_i,
    output logic        cpu_stall_o,
    output logic        cpu_stb_o,
    output logic        cpu_we_o,
    input  logic        cpu_ack_i,
  // JTAG signals
    input  logic        tck_i,
    input  logic        trstn_i,
    input  logic        tms_i,
    input  logic        tdi_i,
    output logic        tdo_o
  );

  //----------------------------------------------------------------------------//
  // Advanced Debug Unit
  //----------------------------------------------------------------------------//

  // TODO: remove the debug connections to the core
  adv_dbg_if
  #(
    .NB_CORES           ( 1                   ),
    .AXI_ADDR_WIDTH     ( AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH     ( AXI_DATA_WIDTH      ),
    .AXI_USER_WIDTH     ( AXI_USER_WIDTH      ),
    .AXI_ID_WIDTH       ( AXI_ID_MASTER_WIDTH )
    )
  adv_dbg_if_i
  (
    .tms_pad_i   ( tms_i           ),
    .tck_pad_i   ( tck_i           ),
    .trstn_pad_i ( trstn_i         ),
    .tdi_pad_i   ( tdi_i           ),
    .tdo_pad_o   ( tdo_o           ),
    .tdo_padoe_o ( tdo_padoe_o     ),

    .test_mode_i ( testmode_i      ),

    // CPU signals
    .cpu_addr_o           ( cpu_addr_o           ), 
    .cpu_data_i           ( cpu_data_i           ),
    .cpu_data_o           ( cpu_data_o           ),
    .cpu_bp_i             ( cpu_bp_i             ),
    .cpu_stall_o          ( cpu_stall_o          ),
    .cpu_stb_o            ( cpu_stb_o            ),
    .cpu_we_o             ( cpu_we_o             ),
    .cpu_ack_i            ( cpu_ack_i            ),
    .cpu_clk_i            ( clk                  ),

    .axi_aclk             ( clk                  ),
    .axi_aresetn          ( rst_n                ),

    .axi_master_aw_valid  ( dbg_master.aw_valid  ),
    .axi_master_aw_addr   ( dbg_master.aw_addr   ),
    .axi_master_aw_prot   ( dbg_master.aw_prot   ),
    .axi_master_aw_region ( dbg_master.aw_region ),
    .axi_master_aw_len    ( dbg_master.aw_len    ),
    .axi_master_aw_size   ( dbg_master.aw_size   ),
    .axi_master_aw_burst  ( dbg_master.aw_burst  ),
    .axi_master_aw_lock   ( dbg_master.aw_lock   ),
    .axi_master_aw_cache  ( dbg_master.aw_cache  ),
    .axi_master_aw_qos    ( dbg_master.aw_qos    ),
    .axi_master_aw_id     ( dbg_master.aw_id     ),
    .axi_master_aw_user   ( dbg_master.aw_user   ),
    .axi_master_aw_ready  ( dbg_master.aw_ready  ),

    .axi_master_ar_valid  ( dbg_master.ar_valid  ),
    .axi_master_ar_addr   ( dbg_master.ar_addr   ),
    .axi_master_ar_prot   ( dbg_master.ar_prot   ),
    .axi_master_ar_region ( dbg_master.ar_region ),
    .axi_master_ar_len    ( dbg_master.ar_len    ),
    .axi_master_ar_size   ( dbg_master.ar_size   ),
    .axi_master_ar_burst  ( dbg_master.ar_burst  ),
    .axi_master_ar_lock   ( dbg_master.ar_lock   ),
    .axi_master_ar_cache  ( dbg_master.ar_cache  ),
    .axi_master_ar_qos    ( dbg_master.ar_qos    ),
    .axi_master_ar_id     ( dbg_master.ar_id     ),
    .axi_master_ar_user   ( dbg_master.ar_user   ),
    .axi_master_ar_ready  ( dbg_master.ar_ready  ),

    .axi_master_w_valid   ( dbg_master.w_valid   ),
    .axi_master_w_data    ( dbg_master.w_data    ),
    .axi_master_w_strb    ( dbg_master.w_strb    ),
    .axi_master_w_user    ( dbg_master.w_user    ),
    .axi_master_w_last    ( dbg_master.w_last    ),
    .axi_master_w_ready   ( dbg_master.w_ready   ),

    .axi_master_r_valid   ( dbg_master.r_valid   ),
    .axi_master_r_data    ( dbg_master.r_data    ),
    .axi_master_r_resp    ( dbg_master.r_resp    ),
    .axi_master_r_last    ( dbg_master.r_last    ),
    .axi_master_r_id      ( dbg_master.r_id      ),
    .axi_master_r_user    ( dbg_master.r_user    ),
    .axi_master_r_ready   ( dbg_master.r_ready   ),

    .axi_master_b_valid   ( dbg_master.b_valid   ),
    .axi_master_b_resp    ( dbg_master.b_resp    ),
    .axi_master_b_id      ( dbg_master.b_id      ),
    .axi_master_b_user    ( dbg_master.b_user    ),
    .axi_master_b_ready   ( dbg_master.b_ready   )
    );

endmodule
