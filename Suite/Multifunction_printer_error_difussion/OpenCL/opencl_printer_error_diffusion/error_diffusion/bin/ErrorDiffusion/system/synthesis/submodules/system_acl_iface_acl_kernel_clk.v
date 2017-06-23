// system_acl_iface_acl_kernel_clk.v

// Generated using ACDS version 16.0 222

`timescale 1 ps / 1 ps
module system_acl_iface_acl_kernel_clk (
		input  wire        pll_refclk_clk,           //        pll_refclk.clk
		input  wire        clk_clk,                  //               clk.clk
		input  wire        reset_reset_n,            //             reset.reset_n
		output wire        ctrl_waitrequest,         //              ctrl.waitrequest
		output wire [31:0] ctrl_readdata,            //                  .readdata
		output wire        ctrl_readdatavalid,       //                  .readdatavalid
		input  wire [0:0]  ctrl_burstcount,          //                  .burstcount
		input  wire [31:0] ctrl_writedata,           //                  .writedata
		input  wire [10:0] ctrl_address,             //                  .address
		input  wire        ctrl_write,               //                  .write
		input  wire        ctrl_read,                //                  .read
		input  wire [3:0]  ctrl_byteenable,          //                  .byteenable
		input  wire        ctrl_debugaccess,         //                  .debugaccess
		output wire        kernel_clk_clk,           //        kernel_clk.clk
		output wire        kernel_clk2x_clk,         //      kernel_clk2x.clk
		output wire        kernel_pll_locked_export  // kernel_pll_locked.export
	);

	wire         kernel_pll_outclk0_clk;                       // kernel_pll:outclk_0 -> global_routing_kernel_clk:s
	wire         kernel_pll_outclk1_clk;                       // kernel_pll:outclk_1 -> [counter:clk2x, global_routing_kernel_clk2x:s]
	wire         kernel_pll_locked_export_signal;              // kernel_pll:locked -> pll_lock_avs_0:lock
	wire         ctrl_m0_waitrequest;                          // mm_interconnect_0:ctrl_m0_waitrequest -> ctrl:m0_waitrequest
	wire  [31:0] ctrl_m0_readdata;                             // mm_interconnect_0:ctrl_m0_readdata -> ctrl:m0_readdata
	wire         ctrl_m0_debugaccess;                          // ctrl:m0_debugaccess -> mm_interconnect_0:ctrl_m0_debugaccess
	wire  [10:0] ctrl_m0_address;                              // ctrl:m0_address -> mm_interconnect_0:ctrl_m0_address
	wire         ctrl_m0_read;                                 // ctrl:m0_read -> mm_interconnect_0:ctrl_m0_read
	wire   [3:0] ctrl_m0_byteenable;                           // ctrl:m0_byteenable -> mm_interconnect_0:ctrl_m0_byteenable
	wire         ctrl_m0_readdatavalid;                        // mm_interconnect_0:ctrl_m0_readdatavalid -> ctrl:m0_readdatavalid
	wire  [31:0] ctrl_m0_writedata;                            // ctrl:m0_writedata -> mm_interconnect_0:ctrl_m0_writedata
	wire         ctrl_m0_write;                                // ctrl:m0_write -> mm_interconnect_0:ctrl_m0_write
	wire   [0:0] ctrl_m0_burstcount;                           // ctrl:m0_burstcount -> mm_interconnect_0:ctrl_m0_burstcount
	wire         mm_interconnect_0_pll_rom_s1_chipselect;      // mm_interconnect_0:pll_rom_s1_chipselect -> pll_rom:chipselect
	wire  [31:0] mm_interconnect_0_pll_rom_s1_readdata;        // pll_rom:readdata -> mm_interconnect_0:pll_rom_s1_readdata
	wire         mm_interconnect_0_pll_rom_s1_debugaccess;     // mm_interconnect_0:pll_rom_s1_debugaccess -> pll_rom:debugaccess
	wire   [7:0] mm_interconnect_0_pll_rom_s1_address;         // mm_interconnect_0:pll_rom_s1_address -> pll_rom:address
	wire   [3:0] mm_interconnect_0_pll_rom_s1_byteenable;      // mm_interconnect_0:pll_rom_s1_byteenable -> pll_rom:byteenable
	wire         mm_interconnect_0_pll_rom_s1_write;           // mm_interconnect_0:pll_rom_s1_write -> pll_rom:write
	wire  [31:0] mm_interconnect_0_pll_rom_s1_writedata;       // mm_interconnect_0:pll_rom_s1_writedata -> pll_rom:writedata
	wire         mm_interconnect_0_pll_rom_s1_clken;           // mm_interconnect_0:pll_rom_s1_clken -> pll_rom:clken
	wire  [31:0] mm_interconnect_0_counter_s_readdata;         // counter:slave_readdata -> mm_interconnect_0:counter_s_readdata
	wire         mm_interconnect_0_counter_s_waitrequest;      // counter:slave_waitrequest -> mm_interconnect_0:counter_s_waitrequest
	wire   [1:0] mm_interconnect_0_counter_s_address;          // mm_interconnect_0:counter_s_address -> counter:slave_address
	wire         mm_interconnect_0_counter_s_read;             // mm_interconnect_0:counter_s_read -> counter:slave_read
	wire   [3:0] mm_interconnect_0_counter_s_byteenable;       // mm_interconnect_0:counter_s_byteenable -> counter:slave_byteenable
	wire         mm_interconnect_0_counter_s_readdatavalid;    // counter:slave_readdatavalid -> mm_interconnect_0:counter_s_readdatavalid
	wire         mm_interconnect_0_counter_s_write;            // mm_interconnect_0:counter_s_write -> counter:slave_write
	wire  [31:0] mm_interconnect_0_counter_s_writedata;        // mm_interconnect_0:counter_s_writedata -> counter:slave_writedata
	wire  [31:0] mm_interconnect_0_pll_sw_reset_s_readdata;    // pll_sw_reset:slave_readdata -> mm_interconnect_0:pll_sw_reset_s_readdata
	wire         mm_interconnect_0_pll_sw_reset_s_waitrequest; // pll_sw_reset:slave_waitrequest -> mm_interconnect_0:pll_sw_reset_s_waitrequest
	wire         mm_interconnect_0_pll_sw_reset_s_read;        // mm_interconnect_0:pll_sw_reset_s_read -> pll_sw_reset:slave_read
	wire   [3:0] mm_interconnect_0_pll_sw_reset_s_byteenable;  // mm_interconnect_0:pll_sw_reset_s_byteenable -> pll_sw_reset:slave_byteenable
	wire         mm_interconnect_0_pll_sw_reset_s_write;       // mm_interconnect_0:pll_sw_reset_s_write -> pll_sw_reset:slave_write
	wire  [31:0] mm_interconnect_0_pll_sw_reset_s_writedata;   // mm_interconnect_0:pll_sw_reset_s_writedata -> pll_sw_reset:slave_writedata
	wire  [31:0] mm_interconnect_0_pll_lock_avs_0_s_readdata;  // pll_lock_avs_0:slave_readdata -> mm_interconnect_0:pll_lock_avs_0_s_readdata
	wire         mm_interconnect_0_pll_lock_avs_0_s_read;      // mm_interconnect_0:pll_lock_avs_0_s_read -> pll_lock_avs_0:slave_read
	wire  [31:0] mm_interconnect_0_version_id_0_s_readdata;    // version_id_0:slave_readdata -> mm_interconnect_0:version_id_0_s_readdata
	wire         mm_interconnect_0_version_id_0_s_read;        // mm_interconnect_0:version_id_0_s_read -> version_id_0:slave_read
	wire         rst_controller_reset_out_reset;               // rst_controller:reset_out -> kernel_pll:rst
	wire         pll_sw_reset_sw_reset_reset;                  // pll_sw_reset:sw_reset_n_out -> rst_controller:reset_in0
	wire         rst_controller_001_reset_out_reset;           // rst_controller_001:reset_out -> [counter:resetn, mm_interconnect_0:counter_clk_reset_reset_bridge_in_reset_reset]
	wire         rst_controller_002_reset_out_reset;           // rst_controller_002:reset_out -> [ctrl:reset, mm_interconnect_0:ctrl_reset_reset_bridge_in_reset_reset, pll_lock_avs_0:resetn, pll_rom:reset, pll_sw_reset:resetn, rst_translator:in_reset, version_id_0:resetn]
	wire         rst_controller_002_reset_out_reset_req;       // rst_controller_002:reset_req -> [pll_rom:reset_req, rst_translator:reset_req_in]

	system_acl_iface_acl_kernel_clk_kernel_pll kernel_pll (
		.refclk            (pll_refclk_clk),                  //            refclk.clk
		.rst               (rst_controller_reset_out_reset),  //             reset.reset
		.outclk_0          (kernel_pll_outclk0_clk),          //           outclk0.clk
		.outclk_1          (kernel_pll_outclk1_clk),          //           outclk1.clk
		.locked            (kernel_pll_locked_export_signal), //            locked.export
		.reconfig_to_pll   (),                                //   reconfig_to_pll.reconfig_to_pll
		.reconfig_from_pll ()                                 // reconfig_from_pll.reconfig_from_pll
	);

	acl_timer #(
		.WIDTH     (32),
		.S_WIDTH_A (2)
	) counter (
		.clk                 (kernel_clk_clk),                            //       clk.clk
		.clk2x               (kernel_pll_outclk1_clk),                    //     clk2x.clk
		.resetn              (~rst_controller_001_reset_out_reset),       // clk_reset.reset_n
		.slave_address       (mm_interconnect_0_counter_s_address),       //         s.address
		.slave_writedata     (mm_interconnect_0_counter_s_writedata),     //          .writedata
		.slave_read          (mm_interconnect_0_counter_s_read),          //          .read
		.slave_write         (mm_interconnect_0_counter_s_write),         //          .write
		.slave_byteenable    (mm_interconnect_0_counter_s_byteenable),    //          .byteenable
		.slave_waitrequest   (mm_interconnect_0_counter_s_waitrequest),   //          .waitrequest
		.slave_readdata      (mm_interconnect_0_counter_s_readdata),      //          .readdata
		.slave_readdatavalid (mm_interconnect_0_counter_s_readdatavalid)  //          .readdatavalid
	);

	global_routing global_routing_kernel_clk (
		.s (kernel_pll_outclk0_clk), //        clk.clk
		.g (kernel_clk_clk)          // global_clk.clk
	);

	global_routing global_routing_kernel_clk2x (
		.s (kernel_pll_outclk1_clk), //        clk.clk
		.g (kernel_clk2x_clk)        // global_clk.clk
	);

	altera_avalon_mm_bridge #(
		.DATA_WIDTH        (32),
		.SYMBOL_WIDTH      (8),
		.HDL_ADDR_WIDTH    (11),
		.BURSTCOUNT_WIDTH  (1),
		.PIPELINE_COMMAND  (0),
		.PIPELINE_RESPONSE (0)
	) ctrl (
		.clk              (clk_clk),                            //   clk.clk
		.reset            (rst_controller_002_reset_out_reset), // reset.reset
		.s0_waitrequest   (ctrl_waitrequest),                   //    s0.waitrequest
		.s0_readdata      (ctrl_readdata),                      //      .readdata
		.s0_readdatavalid (ctrl_readdatavalid),                 //      .readdatavalid
		.s0_burstcount    (ctrl_burstcount),                    //      .burstcount
		.s0_writedata     (ctrl_writedata),                     //      .writedata
		.s0_address       (ctrl_address),                       //      .address
		.s0_write         (ctrl_write),                         //      .write
		.s0_read          (ctrl_read),                          //      .read
		.s0_byteenable    (ctrl_byteenable),                    //      .byteenable
		.s0_debugaccess   (ctrl_debugaccess),                   //      .debugaccess
		.m0_waitrequest   (ctrl_m0_waitrequest),                //    m0.waitrequest
		.m0_readdata      (ctrl_m0_readdata),                   //      .readdata
		.m0_readdatavalid (ctrl_m0_readdatavalid),              //      .readdatavalid
		.m0_burstcount    (ctrl_m0_burstcount),                 //      .burstcount
		.m0_writedata     (ctrl_m0_writedata),                  //      .writedata
		.m0_address       (ctrl_m0_address),                    //      .address
		.m0_write         (ctrl_m0_write),                      //      .write
		.m0_read          (ctrl_m0_read),                       //      .read
		.m0_byteenable    (ctrl_m0_byteenable),                 //      .byteenable
		.m0_debugaccess   (ctrl_m0_debugaccess),                //      .debugaccess
		.s0_response      (),                                   // (terminated)
		.m0_response      (2'b00)                               // (terminated)
	);

	sw_reset #(
		.WIDTH             (32),
		.LOG2_RESET_CYCLES (10)
	) pll_sw_reset (
		.clk               (clk_clk),                                      //       clk.clk
		.resetn            (~rst_controller_002_reset_out_reset),          // clk_reset.reset_n
		.slave_write       (mm_interconnect_0_pll_sw_reset_s_write),       //         s.write
		.slave_writedata   (mm_interconnect_0_pll_sw_reset_s_writedata),   //          .writedata
		.slave_byteenable  (mm_interconnect_0_pll_sw_reset_s_byteenable),  //          .byteenable
		.slave_read        (mm_interconnect_0_pll_sw_reset_s_read),        //          .read
		.slave_readdata    (mm_interconnect_0_pll_sw_reset_s_readdata),    //          .readdata
		.slave_waitrequest (mm_interconnect_0_pll_sw_reset_s_waitrequest), //          .waitrequest
		.sw_reset_n_out    (pll_sw_reset_sw_reset_reset)                   //  sw_reset.reset_n
	);

	pll_lock_avs #(
		.WIDTH (32)
	) pll_lock_avs_0 (
		.clk            (clk_clk),                                     //         clk.clk
		.resetn         (~rst_controller_002_reset_out_reset),         //   clk_reset.reset_n
		.lock           (kernel_pll_locked_export_signal),             //        lock.export
		.lock_export    (kernel_pll_locked_export),                    // lock_export.export
		.slave_read     (mm_interconnect_0_pll_lock_avs_0_s_read),     //           s.read
		.slave_readdata (mm_interconnect_0_pll_lock_avs_0_s_readdata)  //            .readdata
	);

	version_id #(
		.WIDTH      (32),
		.VERSION_ID (-1598029823)
	) version_id_0 (
		.clk            (clk_clk),                                   //       clk.clk
		.resetn         (~rst_controller_002_reset_out_reset),       // clk_reset.reset_n
		.slave_read     (mm_interconnect_0_version_id_0_s_read),     //         s.read
		.slave_readdata (mm_interconnect_0_version_id_0_s_readdata)  //          .readdata
	);

	system_acl_iface_acl_kernel_clk_pll_rom pll_rom (
		.clk         (clk_clk),                                  //   clk1.clk
		.address     (mm_interconnect_0_pll_rom_s1_address),     //     s1.address
		.debugaccess (mm_interconnect_0_pll_rom_s1_debugaccess), //       .debugaccess
		.clken       (mm_interconnect_0_pll_rom_s1_clken),       //       .clken
		.chipselect  (mm_interconnect_0_pll_rom_s1_chipselect),  //       .chipselect
		.write       (mm_interconnect_0_pll_rom_s1_write),       //       .write
		.readdata    (mm_interconnect_0_pll_rom_s1_readdata),    //       .readdata
		.writedata   (mm_interconnect_0_pll_rom_s1_writedata),   //       .writedata
		.byteenable  (mm_interconnect_0_pll_rom_s1_byteenable),  //       .byteenable
		.reset       (rst_controller_002_reset_out_reset),       // reset1.reset
		.reset_req   (rst_controller_002_reset_out_reset_req)    //       .reset_req
	);

	system_acl_iface_acl_kernel_clk_mm_interconnect_0 mm_interconnect_0 (
		.clk_clk_clk                                   (clk_clk),                                      //                                 clk_clk.clk
		.global_routing_kernel_clk_global_clk_clk      (kernel_clk_clk),                               //    global_routing_kernel_clk_global_clk.clk
		.counter_clk_reset_reset_bridge_in_reset_reset (rst_controller_001_reset_out_reset),           // counter_clk_reset_reset_bridge_in_reset.reset
		.ctrl_reset_reset_bridge_in_reset_reset        (rst_controller_002_reset_out_reset),           //        ctrl_reset_reset_bridge_in_reset.reset
		.ctrl_m0_address                               (ctrl_m0_address),                              //                                 ctrl_m0.address
		.ctrl_m0_waitrequest                           (ctrl_m0_waitrequest),                          //                                        .waitrequest
		.ctrl_m0_burstcount                            (ctrl_m0_burstcount),                           //                                        .burstcount
		.ctrl_m0_byteenable                            (ctrl_m0_byteenable),                           //                                        .byteenable
		.ctrl_m0_read                                  (ctrl_m0_read),                                 //                                        .read
		.ctrl_m0_readdata                              (ctrl_m0_readdata),                             //                                        .readdata
		.ctrl_m0_readdatavalid                         (ctrl_m0_readdatavalid),                        //                                        .readdatavalid
		.ctrl_m0_write                                 (ctrl_m0_write),                                //                                        .write
		.ctrl_m0_writedata                             (ctrl_m0_writedata),                            //                                        .writedata
		.ctrl_m0_debugaccess                           (ctrl_m0_debugaccess),                          //                                        .debugaccess
		.counter_s_address                             (mm_interconnect_0_counter_s_address),          //                               counter_s.address
		.counter_s_write                               (mm_interconnect_0_counter_s_write),            //                                        .write
		.counter_s_read                                (mm_interconnect_0_counter_s_read),             //                                        .read
		.counter_s_readdata                            (mm_interconnect_0_counter_s_readdata),         //                                        .readdata
		.counter_s_writedata                           (mm_interconnect_0_counter_s_writedata),        //                                        .writedata
		.counter_s_byteenable                          (mm_interconnect_0_counter_s_byteenable),       //                                        .byteenable
		.counter_s_readdatavalid                       (mm_interconnect_0_counter_s_readdatavalid),    //                                        .readdatavalid
		.counter_s_waitrequest                         (mm_interconnect_0_counter_s_waitrequest),      //                                        .waitrequest
		.pll_lock_avs_0_s_read                         (mm_interconnect_0_pll_lock_avs_0_s_read),      //                        pll_lock_avs_0_s.read
		.pll_lock_avs_0_s_readdata                     (mm_interconnect_0_pll_lock_avs_0_s_readdata),  //                                        .readdata
		.pll_rom_s1_address                            (mm_interconnect_0_pll_rom_s1_address),         //                              pll_rom_s1.address
		.pll_rom_s1_write                              (mm_interconnect_0_pll_rom_s1_write),           //                                        .write
		.pll_rom_s1_readdata                           (mm_interconnect_0_pll_rom_s1_readdata),        //                                        .readdata
		.pll_rom_s1_writedata                          (mm_interconnect_0_pll_rom_s1_writedata),       //                                        .writedata
		.pll_rom_s1_byteenable                         (mm_interconnect_0_pll_rom_s1_byteenable),      //                                        .byteenable
		.pll_rom_s1_chipselect                         (mm_interconnect_0_pll_rom_s1_chipselect),      //                                        .chipselect
		.pll_rom_s1_clken                              (mm_interconnect_0_pll_rom_s1_clken),           //                                        .clken
		.pll_rom_s1_debugaccess                        (mm_interconnect_0_pll_rom_s1_debugaccess),     //                                        .debugaccess
		.pll_sw_reset_s_write                          (mm_interconnect_0_pll_sw_reset_s_write),       //                          pll_sw_reset_s.write
		.pll_sw_reset_s_read                           (mm_interconnect_0_pll_sw_reset_s_read),        //                                        .read
		.pll_sw_reset_s_readdata                       (mm_interconnect_0_pll_sw_reset_s_readdata),    //                                        .readdata
		.pll_sw_reset_s_writedata                      (mm_interconnect_0_pll_sw_reset_s_writedata),   //                                        .writedata
		.pll_sw_reset_s_byteenable                     (mm_interconnect_0_pll_sw_reset_s_byteenable),  //                                        .byteenable
		.pll_sw_reset_s_waitrequest                    (mm_interconnect_0_pll_sw_reset_s_waitrequest), //                                        .waitrequest
		.version_id_0_s_read                           (mm_interconnect_0_version_id_0_s_read),        //                          version_id_0_s.read
		.version_id_0_s_readdata                       (mm_interconnect_0_version_id_0_s_readdata)     //                                        .readdata
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (2),
		.OUTPUT_RESET_SYNC_EDGES   ("none"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (0),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~pll_sw_reset_sw_reset_reset),   // reset_in0.reset
		.reset_in1      (~reset_reset_n),                 // reset_in1.reset
		.clk            (),                               //       clk.clk
		.reset_out      (rst_controller_reset_out_reset), // reset_out.reset
		.reset_req      (),                               // (terminated)
		.reset_req_in0  (1'b0),                           // (terminated)
		.reset_req_in1  (1'b0),                           // (terminated)
		.reset_in2      (1'b0),                           // (terminated)
		.reset_req_in2  (1'b0),                           // (terminated)
		.reset_in3      (1'b0),                           // (terminated)
		.reset_req_in3  (1'b0),                           // (terminated)
		.reset_in4      (1'b0),                           // (terminated)
		.reset_req_in4  (1'b0),                           // (terminated)
		.reset_in5      (1'b0),                           // (terminated)
		.reset_req_in5  (1'b0),                           // (terminated)
		.reset_in6      (1'b0),                           // (terminated)
		.reset_req_in6  (1'b0),                           // (terminated)
		.reset_in7      (1'b0),                           // (terminated)
		.reset_req_in7  (1'b0),                           // (terminated)
		.reset_in8      (1'b0),                           // (terminated)
		.reset_req_in8  (1'b0),                           // (terminated)
		.reset_in9      (1'b0),                           // (terminated)
		.reset_req_in9  (1'b0),                           // (terminated)
		.reset_in10     (1'b0),                           // (terminated)
		.reset_req_in10 (1'b0),                           // (terminated)
		.reset_in11     (1'b0),                           // (terminated)
		.reset_req_in11 (1'b0),                           // (terminated)
		.reset_in12     (1'b0),                           // (terminated)
		.reset_req_in12 (1'b0),                           // (terminated)
		.reset_in13     (1'b0),                           // (terminated)
		.reset_req_in13 (1'b0),                           // (terminated)
		.reset_in14     (1'b0),                           // (terminated)
		.reset_req_in14 (1'b0),                           // (terminated)
		.reset_in15     (1'b0),                           // (terminated)
		.reset_req_in15 (1'b0)                            // (terminated)
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (0),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller_001 (
		.reset_in0      (~reset_reset_n),                     // reset_in0.reset
		.clk            (kernel_clk_clk),                     //       clk.clk
		.reset_out      (rst_controller_001_reset_out_reset), // reset_out.reset
		.reset_req      (),                                   // (terminated)
		.reset_req_in0  (1'b0),                               // (terminated)
		.reset_in1      (1'b0),                               // (terminated)
		.reset_req_in1  (1'b0),                               // (terminated)
		.reset_in2      (1'b0),                               // (terminated)
		.reset_req_in2  (1'b0),                               // (terminated)
		.reset_in3      (1'b0),                               // (terminated)
		.reset_req_in3  (1'b0),                               // (terminated)
		.reset_in4      (1'b0),                               // (terminated)
		.reset_req_in4  (1'b0),                               // (terminated)
		.reset_in5      (1'b0),                               // (terminated)
		.reset_req_in5  (1'b0),                               // (terminated)
		.reset_in6      (1'b0),                               // (terminated)
		.reset_req_in6  (1'b0),                               // (terminated)
		.reset_in7      (1'b0),                               // (terminated)
		.reset_req_in7  (1'b0),                               // (terminated)
		.reset_in8      (1'b0),                               // (terminated)
		.reset_req_in8  (1'b0),                               // (terminated)
		.reset_in9      (1'b0),                               // (terminated)
		.reset_req_in9  (1'b0),                               // (terminated)
		.reset_in10     (1'b0),                               // (terminated)
		.reset_req_in10 (1'b0),                               // (terminated)
		.reset_in11     (1'b0),                               // (terminated)
		.reset_req_in11 (1'b0),                               // (terminated)
		.reset_in12     (1'b0),                               // (terminated)
		.reset_req_in12 (1'b0),                               // (terminated)
		.reset_in13     (1'b0),                               // (terminated)
		.reset_req_in13 (1'b0),                               // (terminated)
		.reset_in14     (1'b0),                               // (terminated)
		.reset_req_in14 (1'b0),                               // (terminated)
		.reset_in15     (1'b0),                               // (terminated)
		.reset_req_in15 (1'b0)                                // (terminated)
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (1),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller_002 (
		.reset_in0      (~reset_reset_n),                         // reset_in0.reset
		.clk            (clk_clk),                                //       clk.clk
		.reset_out      (rst_controller_002_reset_out_reset),     // reset_out.reset
		.reset_req      (rst_controller_002_reset_out_reset_req), //          .reset_req
		.reset_req_in0  (1'b0),                                   // (terminated)
		.reset_in1      (1'b0),                                   // (terminated)
		.reset_req_in1  (1'b0),                                   // (terminated)
		.reset_in2      (1'b0),                                   // (terminated)
		.reset_req_in2  (1'b0),                                   // (terminated)
		.reset_in3      (1'b0),                                   // (terminated)
		.reset_req_in3  (1'b0),                                   // (terminated)
		.reset_in4      (1'b0),                                   // (terminated)
		.reset_req_in4  (1'b0),                                   // (terminated)
		.reset_in5      (1'b0),                                   // (terminated)
		.reset_req_in5  (1'b0),                                   // (terminated)
		.reset_in6      (1'b0),                                   // (terminated)
		.reset_req_in6  (1'b0),                                   // (terminated)
		.reset_in7      (1'b0),                                   // (terminated)
		.reset_req_in7  (1'b0),                                   // (terminated)
		.reset_in8      (1'b0),                                   // (terminated)
		.reset_req_in8  (1'b0),                                   // (terminated)
		.reset_in9      (1'b0),                                   // (terminated)
		.reset_req_in9  (1'b0),                                   // (terminated)
		.reset_in10     (1'b0),                                   // (terminated)
		.reset_req_in10 (1'b0),                                   // (terminated)
		.reset_in11     (1'b0),                                   // (terminated)
		.reset_req_in11 (1'b0),                                   // (terminated)
		.reset_in12     (1'b0),                                   // (terminated)
		.reset_req_in12 (1'b0),                                   // (terminated)
		.reset_in13     (1'b0),                                   // (terminated)
		.reset_req_in13 (1'b0),                                   // (terminated)
		.reset_in14     (1'b0),                                   // (terminated)
		.reset_req_in14 (1'b0),                                   // (terminated)
		.reset_in15     (1'b0),                                   // (terminated)
		.reset_req_in15 (1'b0)                                    // (terminated)
	);

endmodule
