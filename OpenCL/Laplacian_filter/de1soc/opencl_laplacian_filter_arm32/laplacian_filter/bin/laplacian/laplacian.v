// (C) 1992-2016 Altera Corporation. All rights reserved.                         
// Your use of Altera Corporation's design tools, logic functions and other       
// software and tools, and its AMPP partner logic functions, and any output       
// files any of the foregoing (including device programming or simulation         
// files), and any associated documentation or information are expressly subject  
// to the terms and conditions of the Altera Program License Subscription         
// Agreement, Altera MegaCore Function License Agreement, or other applicable     
// license agreement, including, without limitation, that your use is for the     
// sole purpose of programming logic devices manufactured by Altera and sold by   
// Altera or its authorized distributors.  Please refer to the applicable         
// agreement for further details.                                                 
    

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

// altera message_off 10036
// altera message_off 10230
// altera message_off 10858
module laplacian_basic_block_0
	(
		input 		clock,
		input 		resetn,
		input 		start,
		input [31:0] 		input_iterations,
		input 		valid_in,
		output 		stall_out,
		output 		valid_out,
		input 		stall_in,
		output 		lvb_bb0_cmp6,
		input [31:0] 		workgroup_size
	);


// Values used for debugging.  These are swept away by synthesis.
wire _entry;
wire _exit;
 reg [31:0] _num_entry_NO_SHIFT_REG;
 reg [31:0] _num_exit_NO_SHIFT_REG;
wire [31:0] _num_live;

assign _entry = ((&valid_in) & ~((|stall_out)));
assign _exit = ((&valid_out) & ~((|stall_in)));
assign _num_live = (_num_entry_NO_SHIFT_REG - _num_exit_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		_num_entry_NO_SHIFT_REG <= 32'h0;
		_num_exit_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		if (_entry)
		begin
			_num_entry_NO_SHIFT_REG <= (_num_entry_NO_SHIFT_REG + 2'h1);
		end
		if (_exit)
		begin
			_num_exit_NO_SHIFT_REG <= (_num_exit_NO_SHIFT_REG + 2'h1);
		end
	end
end



// This section defines the behaviour of the MERGE node
wire merge_node_stall_in_0;
 reg merge_node_valid_out_0_NO_SHIFT_REG;
wire merge_node_stall_in_1;
 reg merge_node_valid_out_1_NO_SHIFT_REG;
wire merge_stalled_by_successors;
 reg merge_block_selector_NO_SHIFT_REG;
 reg merge_node_valid_in_staging_reg_NO_SHIFT_REG;
 reg is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
 reg invariant_valid_NO_SHIFT_REG;

assign merge_stalled_by_successors = ((merge_node_stall_in_0 & merge_node_valid_out_0_NO_SHIFT_REG) | (merge_node_stall_in_1 & merge_node_valid_out_1_NO_SHIFT_REG));
assign stall_out = merge_node_valid_in_staging_reg_NO_SHIFT_REG;

always @(*)
begin
	if ((merge_node_valid_in_staging_reg_NO_SHIFT_REG | valid_in))
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b1;
	end
	else
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b0;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_staging_reg_NO_SHIFT_REG))
			begin
				merge_node_valid_in_staging_reg_NO_SHIFT_REG <= valid_in;
			end
		end
		else
		begin
			merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (~(merge_stalled_by_successors))
		begin
			merge_node_valid_out_0_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_1_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
		end
		else
		begin
			if (~(merge_node_stall_in_0))
			begin
				merge_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_1))
			begin
				merge_node_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		invariant_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		invariant_valid_NO_SHIFT_REG <= (~(start) & (invariant_valid_NO_SHIFT_REG | is_merge_data_to_local_regs_valid_NO_SHIFT_REG));
	end
end


// This section implements a registered operation.
// 
wire local_bb0_cmp6_inputs_ready;
 reg local_bb0_cmp6_wii_reg_NO_SHIFT_REG;
 reg local_bb0_cmp6_valid_out_NO_SHIFT_REG;
wire local_bb0_cmp6_stall_in;
wire local_bb0_cmp6_output_regs_ready;
 reg local_bb0_cmp6_NO_SHIFT_REG;
wire local_bb0_cmp6_causedstall;

assign local_bb0_cmp6_inputs_ready = merge_node_valid_out_0_NO_SHIFT_REG;
assign local_bb0_cmp6_output_regs_ready = (~(local_bb0_cmp6_wii_reg_NO_SHIFT_REG) & (&(~(local_bb0_cmp6_valid_out_NO_SHIFT_REG) | ~(local_bb0_cmp6_stall_in))));
assign merge_node_stall_in_0 = (~(local_bb0_cmp6_wii_reg_NO_SHIFT_REG) & (~(local_bb0_cmp6_output_regs_ready) | ~(local_bb0_cmp6_inputs_ready)));
assign local_bb0_cmp6_causedstall = (local_bb0_cmp6_inputs_ready && (~(local_bb0_cmp6_output_regs_ready) && !(~(local_bb0_cmp6_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_cmp6_NO_SHIFT_REG <= 'x;
		local_bb0_cmp6_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_cmp6_NO_SHIFT_REG <= 'x;
			local_bb0_cmp6_valid_out_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_cmp6_output_regs_ready)
			begin
				local_bb0_cmp6_NO_SHIFT_REG <= (input_iterations == 32'hFFFFF0FD);
				local_bb0_cmp6_valid_out_NO_SHIFT_REG <= local_bb0_cmp6_inputs_ready;
			end
			else
			begin
				if (~(local_bb0_cmp6_stall_in))
				begin
					local_bb0_cmp6_valid_out_NO_SHIFT_REG <= local_bb0_cmp6_wii_reg_NO_SHIFT_REG;
				end
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_cmp6_wii_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_cmp6_wii_reg_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_cmp6_inputs_ready)
			begin
				local_bb0_cmp6_wii_reg_NO_SHIFT_REG <= 1'b1;
			end
		end
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
 reg branch_node_valid_out_NO_SHIFT_REG;
wire branch_var__output_regs_ready;
wire combined_branch_stall_in_signal;
 reg lvb_bb0_cmp6_reg_NO_SHIFT_REG;

assign branch_var__inputs_ready = (local_bb0_cmp6_valid_out_NO_SHIFT_REG & merge_node_valid_out_1_NO_SHIFT_REG);
assign branch_var__output_regs_ready = (~(stall_in) | ~(branch_node_valid_out_NO_SHIFT_REG));
assign local_bb0_cmp6_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign merge_node_stall_in_1 = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign lvb_bb0_cmp6 = lvb_bb0_cmp6_reg_NO_SHIFT_REG;
assign combined_branch_stall_in_signal = stall_in;
assign valid_out = branch_node_valid_out_NO_SHIFT_REG;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		branch_node_valid_out_NO_SHIFT_REG <= 1'b0;
		lvb_bb0_cmp6_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (branch_var__output_regs_ready)
		begin
			branch_node_valid_out_NO_SHIFT_REG <= branch_var__inputs_ready;
			lvb_bb0_cmp6_reg_NO_SHIFT_REG <= local_bb0_cmp6_NO_SHIFT_REG;
		end
		else
		begin
			if (~(combined_branch_stall_in_signal))
			begin
				branch_node_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

// altera message_off 10036
// altera message_off 10230
// altera message_off 10858
module laplacian_basic_block_1
	(
		input 		clock,
		input 		resetn,
		input [63:0] 		input_frame_in,
		input [63:0] 		input_frame_out,
		input [31:0] 		input_iterations,
		input [31:0] 		input_threshold,
		input 		input_wii_cmp6,
		input 		valid_in_0,
		output 		stall_out_0,
		input 		input_forked_0,
		input 		valid_in_1,
		output 		stall_out_1,
		input 		input_forked_1,
		output 		valid_out_0,
		input 		stall_in_0,
		output 		valid_out_1,
		input 		stall_in_1,
		input [31:0] 		workgroup_size,
		input 		start,
		input 		feedback_valid_in_13,
		output 		feedback_stall_out_13,
		input [39:0] 		feedback_data_in_13,
		input 		feedback_valid_in_0,
		output 		feedback_stall_out_0,
		input 		feedback_data_in_0,
		input 		feedback_valid_in_1,
		output 		feedback_stall_out_1,
		input 		feedback_data_in_1,
		output 		acl_pipelined_valid,
		input 		acl_pipelined_stall,
		output 		acl_pipelined_exiting_valid,
		output 		acl_pipelined_exiting_stall,
		input 		feedback_valid_in_12,
		output 		feedback_stall_out_12,
		input [23:0] 		feedback_data_in_12,
		output 		feedback_valid_out_12,
		input 		feedback_stall_in_12,
		output [23:0] 		feedback_data_out_12,
		output 		feedback_valid_out_0,
		input 		feedback_stall_in_0,
		output 		feedback_data_out_0,
		output 		feedback_valid_out_13,
		input 		feedback_stall_in_13,
		output [39:0] 		feedback_data_out_13,
		output 		feedback_valid_out_1,
		input 		feedback_stall_in_1,
		output 		feedback_data_out_1,
		output 		avm_local_bb1_ld__enable,
		input [255:0] 		avm_local_bb1_ld__readdata,
		input 		avm_local_bb1_ld__readdatavalid,
		input 		avm_local_bb1_ld__waitrequest,
		output [29:0] 		avm_local_bb1_ld__address,
		output 		avm_local_bb1_ld__read,
		output 		avm_local_bb1_ld__write,
		input 		avm_local_bb1_ld__writeack,
		output [255:0] 		avm_local_bb1_ld__writedata,
		output [31:0] 		avm_local_bb1_ld__byteenable,
		output [4:0] 		avm_local_bb1_ld__burstcount,
		output 		local_bb1_ld__active,
		input 		clock2x,
		input 		feedback_valid_in_3,
		output 		feedback_stall_out_3,
		input [63:0] 		feedback_data_in_3,
		input 		feedback_valid_in_6,
		output 		feedback_stall_out_6,
		input [127:0] 		feedback_data_in_6,
		output 		feedback_valid_out_3,
		input 		feedback_stall_in_3,
		output [63:0] 		feedback_data_out_3,
		output 		feedback_valid_out_6,
		input 		feedback_stall_in_6,
		output [127:0] 		feedback_data_out_6,
		input 		feedback_valid_in_8,
		output 		feedback_stall_out_8,
		input [63:0] 		feedback_data_in_8,
		output 		feedback_valid_out_8,
		input 		feedback_stall_in_8,
		output [63:0] 		feedback_data_out_8,
		output 		avm_local_bb1_st_c0_exe1_enable,
		input [255:0] 		avm_local_bb1_st_c0_exe1_readdata,
		input 		avm_local_bb1_st_c0_exe1_readdatavalid,
		input 		avm_local_bb1_st_c0_exe1_waitrequest,
		output [29:0] 		avm_local_bb1_st_c0_exe1_address,
		output 		avm_local_bb1_st_c0_exe1_read,
		output 		avm_local_bb1_st_c0_exe1_write,
		input 		avm_local_bb1_st_c0_exe1_writeack,
		output [255:0] 		avm_local_bb1_st_c0_exe1_writedata,
		output [31:0] 		avm_local_bb1_st_c0_exe1_byteenable,
		output [4:0] 		avm_local_bb1_st_c0_exe1_burstcount,
		output 		local_bb1_st_c0_exe1_active
	);


// Values used for debugging.  These are swept away by synthesis.
wire _entry;
wire _exit;
 reg [31:0] _num_entry_NO_SHIFT_REG;
 reg [31:0] _num_exit_NO_SHIFT_REG;
wire [31:0] _num_live;

assign _entry = ((valid_in_0 & valid_in_1) & ~((stall_out_0 | stall_out_1)));
assign _exit = ((valid_out_0 & valid_out_1) & ~((stall_in_0 | stall_in_1)));
assign _num_live = (_num_entry_NO_SHIFT_REG - _num_exit_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		_num_entry_NO_SHIFT_REG <= 32'h0;
		_num_exit_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		if (_entry)
		begin
			_num_entry_NO_SHIFT_REG <= (_num_entry_NO_SHIFT_REG + 2'h1);
		end
		if (_exit)
		begin
			_num_exit_NO_SHIFT_REG <= (_num_exit_NO_SHIFT_REG + 2'h1);
		end
	end
end



// This section defines the behaviour of the MERGE node
wire merge_node_stall_in_0;
 reg merge_node_valid_out_0_NO_SHIFT_REG;
wire merge_node_stall_in_1;
 reg merge_node_valid_out_1_NO_SHIFT_REG;
wire merge_stalled_by_successors;
 reg merge_block_selector_NO_SHIFT_REG;
 reg merge_node_valid_in_0_staging_reg_NO_SHIFT_REG;
 reg input_forked_0_staging_reg_NO_SHIFT_REG;
 reg local_lvm_forked_NO_SHIFT_REG;
 reg merge_node_valid_in_1_staging_reg_NO_SHIFT_REG;
 reg input_forked_1_staging_reg_NO_SHIFT_REG;
 reg is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
 reg invariant_valid_NO_SHIFT_REG;

assign merge_stalled_by_successors = ((merge_node_stall_in_0 & merge_node_valid_out_0_NO_SHIFT_REG) | (merge_node_stall_in_1 & merge_node_valid_out_1_NO_SHIFT_REG));
assign stall_out_0 = merge_node_valid_in_0_staging_reg_NO_SHIFT_REG;
assign stall_out_1 = merge_node_valid_in_1_staging_reg_NO_SHIFT_REG;

always @(*)
begin
	if ((merge_node_valid_in_0_staging_reg_NO_SHIFT_REG | valid_in_0))
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b1;
	end
	else
	begin
		if ((merge_node_valid_in_1_staging_reg_NO_SHIFT_REG | valid_in_1))
		begin
			merge_block_selector_NO_SHIFT_REG = 1'b1;
			is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b1;
		end
		else
		begin
			merge_block_selector_NO_SHIFT_REG = 1'b0;
			is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b0;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		input_forked_0_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_0_staging_reg_NO_SHIFT_REG <= 1'b0;
		input_forked_1_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_1_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_0_staging_reg_NO_SHIFT_REG))
			begin
				input_forked_0_staging_reg_NO_SHIFT_REG <= input_forked_0;
				merge_node_valid_in_0_staging_reg_NO_SHIFT_REG <= valid_in_0;
			end
		end
		else
		begin
			merge_node_valid_in_0_staging_reg_NO_SHIFT_REG <= 1'b0;
		end
		if (((merge_block_selector_NO_SHIFT_REG != 1'b1) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_1_staging_reg_NO_SHIFT_REG))
			begin
				input_forked_1_staging_reg_NO_SHIFT_REG <= input_forked_1;
				merge_node_valid_in_1_staging_reg_NO_SHIFT_REG <= valid_in_1;
			end
		end
		else
		begin
			merge_node_valid_in_1_staging_reg_NO_SHIFT_REG <= 1'b0;
		end
	end
end

always @(posedge clock)
begin
	if (~(merge_stalled_by_successors))
	begin
		case (merge_block_selector_NO_SHIFT_REG)
			1'b0:
			begin
				if (merge_node_valid_in_0_staging_reg_NO_SHIFT_REG)
				begin
					local_lvm_forked_NO_SHIFT_REG <= input_forked_0_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_forked_NO_SHIFT_REG <= input_forked_0;
				end
			end

			1'b1:
			begin
				if (merge_node_valid_in_1_staging_reg_NO_SHIFT_REG)
				begin
					local_lvm_forked_NO_SHIFT_REG <= input_forked_1_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_forked_NO_SHIFT_REG <= input_forked_1;
				end
			end

			default:
			begin
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (~(merge_stalled_by_successors))
		begin
			merge_node_valid_out_0_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_1_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
		end
		else
		begin
			if (~(merge_node_stall_in_0))
			begin
				merge_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_1))
			begin
				merge_node_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		invariant_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		invariant_valid_NO_SHIFT_REG <= (~(start) & (invariant_valid_NO_SHIFT_REG | is_merge_data_to_local_regs_valid_NO_SHIFT_REG));
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c1_eni1_valid_out;
wire local_bb1_c1_eni1_stall_in;
wire local_bb1_c1_eni1_inputs_ready;
wire local_bb1_c1_eni1_stall_local;
wire [15:0] local_bb1_c1_eni1;

assign local_bb1_c1_eni1_inputs_ready = merge_node_valid_out_0_NO_SHIFT_REG;
assign local_bb1_c1_eni1[7:0] = 8'bx;
assign local_bb1_c1_eni1[8] = local_lvm_forked_NO_SHIFT_REG;
assign local_bb1_c1_eni1[15:9] = 7'bx;
assign local_bb1_c1_eni1_valid_out = local_bb1_c1_eni1_inputs_ready;
assign local_bb1_c1_eni1_stall_local = local_bb1_c1_eni1_stall_in;
assign merge_node_stall_in_0 = (|local_bb1_c1_eni1_stall_local);

// Register node:
//  * latency = 4
//  * capacity = 4
 logic rnode_1to5_forked_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_1to5_forked_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_1to5_forked_0_NO_SHIFT_REG;
 logic rnode_1to5_forked_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_1to5_forked_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_1to5_forked_1_NO_SHIFT_REG;
 logic rnode_1to5_forked_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic rnode_1to5_forked_0_reg_5_NO_SHIFT_REG;
 logic rnode_1to5_forked_0_valid_out_0_reg_5_NO_SHIFT_REG;
 logic rnode_1to5_forked_0_stall_in_0_reg_5_NO_SHIFT_REG;
 logic rnode_1to5_forked_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_1to5_forked_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to5_forked_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to5_forked_0_stall_in_0_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_1to5_forked_0_valid_out_0_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_1to5_forked_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_lvm_forked_NO_SHIFT_REG),
	.data_out(rnode_1to5_forked_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_1to5_forked_0_reg_5_fifo.DEPTH = 5;
defparam rnode_1to5_forked_0_reg_5_fifo.DATA_WIDTH = 1;
defparam rnode_1to5_forked_0_reg_5_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to5_forked_0_reg_5_fifo.IMPL = "ll_reg";

assign rnode_1to5_forked_0_reg_5_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_1_NO_SHIFT_REG;
assign merge_node_stall_in_1 = rnode_1to5_forked_0_stall_out_reg_5_NO_SHIFT_REG;
assign rnode_1to5_forked_0_stall_in_0_reg_5_NO_SHIFT_REG = (rnode_1to5_forked_0_stall_in_0_NO_SHIFT_REG | rnode_1to5_forked_0_stall_in_1_NO_SHIFT_REG);
assign rnode_1to5_forked_0_valid_out_0_NO_SHIFT_REG = rnode_1to5_forked_0_valid_out_0_reg_5_NO_SHIFT_REG;
assign rnode_1to5_forked_0_valid_out_1_NO_SHIFT_REG = rnode_1to5_forked_0_valid_out_0_reg_5_NO_SHIFT_REG;
assign rnode_1to5_forked_0_NO_SHIFT_REG = rnode_1to5_forked_0_reg_5_NO_SHIFT_REG;
assign rnode_1to5_forked_1_NO_SHIFT_REG = rnode_1to5_forked_0_reg_5_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_c1_enter_c1_eni1_valid_out_0;
wire local_bb1_c1_enter_c1_eni1_stall_in_0;
wire local_bb1_c1_enter_c1_eni1_valid_out_1;
wire local_bb1_c1_enter_c1_eni1_stall_in_1;
wire local_bb1_c1_enter_c1_eni1_inputs_ready;
wire local_bb1_c1_enter_c1_eni1_stall_local;
wire local_bb1_c1_enter_c1_eni1_input_accepted;
wire [15:0] local_bb1_c1_enter_c1_eni1;
wire local_bb1_c1_exit_c1_exi7_enable;
wire local_bb1_c1_exit_c1_exi7_entry_stall;
wire local_bb1_c1_enter_c1_eni1_valid_bit;
wire local_bb1_c1_exit_c1_exi7_output_regs_ready;
wire local_bb1_c1_exit_c1_exi7_valid_in;
wire local_bb1_c1_exit_c1_exi7_phases;
wire local_bb1_c1_enter_c1_eni1_inc_pipelined_thread;
wire local_bb1_c1_enter_c1_eni1_dec_pipelined_thread;
wire local_bb1_c1_enter_c1_eni1_fu_stall_out;

assign local_bb1_c1_enter_c1_eni1_inputs_ready = local_bb1_c1_eni1_valid_out;
assign local_bb1_c1_enter_c1_eni1 = local_bb1_c1_eni1;
assign local_bb1_c1_enter_c1_eni1_input_accepted = (local_bb1_c1_enter_c1_eni1_inputs_ready && !(local_bb1_c1_exit_c1_exi7_entry_stall));
assign local_bb1_c1_enter_c1_eni1_valid_bit = local_bb1_c1_enter_c1_eni1_input_accepted;
assign local_bb1_c1_enter_c1_eni1_inc_pipelined_thread = 1'b1;
assign local_bb1_c1_enter_c1_eni1_dec_pipelined_thread = ~(1'b0);
assign local_bb1_c1_enter_c1_eni1_fu_stall_out = (~(local_bb1_c1_enter_c1_eni1_inputs_ready) | local_bb1_c1_exit_c1_exi7_entry_stall);
assign local_bb1_c1_enter_c1_eni1_stall_local = (local_bb1_c1_enter_c1_eni1_stall_in_0 | local_bb1_c1_enter_c1_eni1_stall_in_1);
assign local_bb1_c1_enter_c1_eni1_valid_out_0 = local_bb1_c1_enter_c1_eni1_inputs_ready;
assign local_bb1_c1_enter_c1_eni1_valid_out_1 = local_bb1_c1_enter_c1_eni1_inputs_ready;
assign local_bb1_c1_eni1_stall_in = (|local_bb1_c1_enter_c1_eni1_fu_stall_out);

// This section implements an unregistered operation.
// 
wire local_bb1_c0_eni1_stall_local;
wire [95:0] local_bb1_c0_eni1;

assign local_bb1_c0_eni1[7:0] = 8'bx;
assign local_bb1_c0_eni1[8] = rnode_1to5_forked_0_NO_SHIFT_REG;
assign local_bb1_c0_eni1[95:9] = 87'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_c1_ene1_stall_local;
wire local_bb1_c1_ene1;

assign local_bb1_c1_ene1 = local_bb1_c1_enter_c1_eni1[8];

// This section implements an unregistered operation.
// 
wire SFC_1_VALID_1_1_0_stall_local;
wire SFC_1_VALID_1_1_0;

assign SFC_1_VALID_1_1_0 = local_bb1_c1_enter_c1_eni1_valid_bit;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop13_insert0_stall_local;
wire [39:0] local_bb1_vectorpop13_insert0;

assign local_bb1_vectorpop13_insert0[3:0] = 4'h7;
assign local_bb1_vectorpop13_insert0[39:4] = 36'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop13_insert1_stall_local;
wire [39:0] local_bb1_vectorpop13_insert1;

assign local_bb1_vectorpop13_insert1[7:0] = local_bb1_vectorpop13_insert0[7:0];
assign local_bb1_vectorpop13_insert1[39:8] = 32'hFFFFF0FD;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop13_vectorpop13_insert1_stall_local;
wire [39:0] local_bb1_vectorpop13_vectorpop13_insert1;
wire local_bb1_vectorpop13_vectorpop13_insert1_fu_valid_out;
wire local_bb1_vectorpop13_vectorpop13_insert1_fu_stall_out;

acl_pop local_bb1_vectorpop13_vectorpop13_insert1_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_c1_ene1),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpop13_insert1),
	.stall_out(local_bb1_vectorpop13_vectorpop13_insert1_fu_stall_out),
	.valid_in(SFC_1_VALID_1_1_0),
	.valid_out(local_bb1_vectorpop13_vectorpop13_insert1_fu_valid_out),
	.stall_in(local_bb1_vectorpop13_vectorpop13_insert1_stall_local),
	.data_out(local_bb1_vectorpop13_vectorpop13_insert1),
	.feedback_in(feedback_data_in_13),
	.feedback_valid_in(feedback_valid_in_13),
	.feedback_stall_out(feedback_stall_out_13)
);

defparam local_bb1_vectorpop13_vectorpop13_insert1_feedback.COALESCE_DISTANCE = 1;
defparam local_bb1_vectorpop13_vectorpop13_insert1_feedback.DATA_WIDTH = 40;
defparam local_bb1_vectorpop13_vectorpop13_insert1_feedback.STYLE = "REGULAR";

assign local_bb1_vectorpop13_vectorpop13_insert1_stall_local = ~(local_bb1_c1_exit_c1_exi7_enable);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop13_extract0_stall_local;
wire [3:0] local_bb1_vectorpop13_extract0;

assign local_bb1_vectorpop13_extract0[3:0] = local_bb1_vectorpop13_vectorpop13_insert1[3:0];

// This section implements an unregistered operation.
// 
wire local_bb1_c1_ene1_valid_out_0;
wire local_bb1_c1_ene1_stall_in_0;
wire local_bb1_c1_ene1_valid_out_3;
wire local_bb1_c1_ene1_stall_in_3;
wire SFC_1_VALID_1_1_0_valid_out_0;
wire SFC_1_VALID_1_1_0_stall_in_0;
wire SFC_1_VALID_1_1_0_valid_out_1;
wire SFC_1_VALID_1_1_0_stall_in_1;
wire local_bb1_vectorpop13_extract0_valid_out;
wire local_bb1_vectorpop13_extract0_stall_in;
wire local_bb1_vectorpop13_extract1_valid_out;
wire local_bb1_vectorpop13_extract1_stall_in;
wire local_bb1_vectorpop13_extract1_inputs_ready;
wire local_bb1_vectorpop13_extract1_stall_local;
wire [31:0] local_bb1_vectorpop13_extract1;

assign local_bb1_vectorpop13_extract1_inputs_ready = (local_bb1_c1_enter_c1_eni1_valid_out_0 & local_bb1_c1_enter_c1_eni1_valid_out_1);
assign local_bb1_vectorpop13_extract1[31:0] = local_bb1_vectorpop13_vectorpop13_insert1[39:8];
assign local_bb1_c1_ene1_valid_out_0 = 1'b1;
assign local_bb1_c1_ene1_valid_out_3 = 1'b1;
assign SFC_1_VALID_1_1_0_valid_out_0 = 1'b1;
assign SFC_1_VALID_1_1_0_valid_out_1 = 1'b1;
assign local_bb1_vectorpop13_extract0_valid_out = 1'b1;
assign local_bb1_vectorpop13_extract1_valid_out = 1'b1;
assign local_bb1_c1_enter_c1_eni1_stall_in_0 = 1'b0;
assign local_bb1_c1_enter_c1_eni1_stall_in_1 = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_1to2_bb1_c1_ene1_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c1_ene1_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c1_ene1_0_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c1_ene1_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c1_ene1_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c1_ene1_1_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c1_ene1_0_reg_2_inputs_ready_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c1_ene1_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c1_ene1_0_valid_out_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c1_ene1_0_stall_in_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c1_ene1_0_stall_out_reg_2_NO_SHIFT_REG;

acl_data_fifo rnode_1to2_bb1_c1_ene1_0_reg_2_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to2_bb1_c1_ene1_0_reg_2_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to2_bb1_c1_ene1_0_stall_in_0_reg_2_NO_SHIFT_REG),
	.valid_out(rnode_1to2_bb1_c1_ene1_0_valid_out_0_reg_2_NO_SHIFT_REG),
	.stall_out(rnode_1to2_bb1_c1_ene1_0_stall_out_reg_2_NO_SHIFT_REG),
	.data_in(local_bb1_c1_ene1),
	.data_out(rnode_1to2_bb1_c1_ene1_0_reg_2_NO_SHIFT_REG)
);

defparam rnode_1to2_bb1_c1_ene1_0_reg_2_fifo.DEPTH = 1;
defparam rnode_1to2_bb1_c1_ene1_0_reg_2_fifo.DATA_WIDTH = 1;
defparam rnode_1to2_bb1_c1_ene1_0_reg_2_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_1to2_bb1_c1_ene1_0_reg_2_fifo.IMPL = "shift_reg";

assign rnode_1to2_bb1_c1_ene1_0_reg_2_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_c1_ene1_stall_in_3 = 1'b0;
assign rnode_1to2_bb1_c1_ene1_0_stall_in_0_reg_2_NO_SHIFT_REG = ~(local_bb1_c1_exit_c1_exi7_enable);
assign rnode_1to2_bb1_c1_ene1_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_1to2_bb1_c1_ene1_0_NO_SHIFT_REG = rnode_1to2_bb1_c1_ene1_0_reg_2_NO_SHIFT_REG;
assign rnode_1to2_bb1_c1_ene1_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_1to2_bb1_c1_ene1_1_NO_SHIFT_REG = rnode_1to2_bb1_c1_ene1_0_reg_2_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire SFC_1_VALID_1_2_0_inputs_ready;
 reg SFC_1_VALID_1_2_0_valid_out_0_NO_SHIFT_REG;
wire SFC_1_VALID_1_2_0_stall_in_0;
 reg SFC_1_VALID_1_2_0_valid_out_1_NO_SHIFT_REG;
wire SFC_1_VALID_1_2_0_stall_in_1;
 reg SFC_1_VALID_1_2_0_valid_out_2_NO_SHIFT_REG;
wire SFC_1_VALID_1_2_0_stall_in_2;
 reg SFC_1_VALID_1_2_0_valid_out_3_NO_SHIFT_REG;
wire SFC_1_VALID_1_2_0_stall_in_3;
 reg SFC_1_VALID_1_2_0_valid_out_4_NO_SHIFT_REG;
wire SFC_1_VALID_1_2_0_stall_in_4;
 reg SFC_1_VALID_1_2_0_valid_out_5_NO_SHIFT_REG;
wire SFC_1_VALID_1_2_0_stall_in_5;
wire SFC_1_VALID_1_2_0_output_regs_ready;
 reg SFC_1_VALID_1_2_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_1_VALID_1_2_0_causedstall;

assign SFC_1_VALID_1_2_0_inputs_ready = 1'b1;
assign SFC_1_VALID_1_2_0_output_regs_ready = local_bb1_c1_exit_c1_exi7_enable;
assign SFC_1_VALID_1_1_0_stall_in_0 = 1'b0;
assign SFC_1_VALID_1_2_0_causedstall = (1'b1 && (1'b0 && !(~(local_bb1_c1_exit_c1_exi7_enable))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		SFC_1_VALID_1_2_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (SFC_1_VALID_1_2_0_output_regs_ready)
		begin
			SFC_1_VALID_1_2_0_NO_SHIFT_REG <= SFC_1_VALID_1_1_0;
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb1_keep_going_c1_ene1_inputs_ready;
 reg local_bb1_keep_going_c1_ene1_valid_out_0_NO_SHIFT_REG;
wire local_bb1_keep_going_c1_ene1_stall_in_0;
 reg local_bb1_keep_going_c1_ene1_valid_out_1_NO_SHIFT_REG;
wire local_bb1_keep_going_c1_ene1_stall_in_1;
 reg local_bb1_keep_going_c1_ene1_valid_out_2_NO_SHIFT_REG;
wire local_bb1_keep_going_c1_ene1_stall_in_2;
 reg local_bb1_keep_going_c1_ene1_valid_out_3_NO_SHIFT_REG;
wire local_bb1_keep_going_c1_ene1_stall_in_3;
wire local_bb1_keep_going_c1_ene1_output_regs_ready;
wire local_bb1_keep_going_c1_ene1_keep_going;
wire local_bb1_keep_going_c1_ene1_fu_valid_out;
wire local_bb1_keep_going_c1_ene1_fu_stall_out;
 reg local_bb1_keep_going_c1_ene1_NO_SHIFT_REG;
wire local_bb1_keep_going_c1_ene1_feedback_pipelined;
wire local_bb1_keep_going_c1_ene1_causedstall;

acl_pipeline local_bb1_keep_going_c1_ene1_pipelined (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb1_c1_ene1),
	.stall_out(local_bb1_keep_going_c1_ene1_fu_stall_out),
	.valid_in(SFC_1_VALID_1_1_0),
	.valid_out(local_bb1_keep_going_c1_ene1_fu_valid_out),
	.stall_in(~(local_bb1_c1_exit_c1_exi7_enable)),
	.data_out(local_bb1_keep_going_c1_ene1_keep_going),
	.initeration_in(feedback_data_in_0),
	.initeration_valid_in(feedback_valid_in_0),
	.initeration_stall_out(feedback_stall_out_0),
	.not_exitcond_in(feedback_data_in_1),
	.not_exitcond_valid_in(feedback_valid_in_1),
	.not_exitcond_stall_out(feedback_stall_out_1),
	.pipeline_valid_out(acl_pipelined_valid),
	.pipeline_stall_in(acl_pipelined_stall),
	.exiting_valid_out(acl_pipelined_exiting_valid)
);

defparam local_bb1_keep_going_c1_ene1_pipelined.FIFO_DEPTH = 1;
defparam local_bb1_keep_going_c1_ene1_pipelined.STYLE = "SPECULATIVE";

assign local_bb1_keep_going_c1_ene1_inputs_ready = 1'b1;
assign local_bb1_keep_going_c1_ene1_output_regs_ready = local_bb1_c1_exit_c1_exi7_enable;
assign acl_pipelined_exiting_stall = acl_pipelined_stall;
assign local_bb1_c1_ene1_stall_in_0 = 1'b0;
assign SFC_1_VALID_1_1_0_stall_in_1 = 1'b0;
assign local_bb1_keep_going_c1_ene1_causedstall = (SFC_1_VALID_1_1_0 && (1'b0 && !(~(local_bb1_c1_exit_c1_exi7_enable))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_keep_going_c1_ene1_NO_SHIFT_REG <= 'x;
		local_bb1_keep_going_c1_ene1_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_keep_going_c1_ene1_valid_out_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_keep_going_c1_ene1_valid_out_2_NO_SHIFT_REG <= 1'b0;
		local_bb1_keep_going_c1_ene1_valid_out_3_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_keep_going_c1_ene1_output_regs_ready)
		begin
			local_bb1_keep_going_c1_ene1_NO_SHIFT_REG <= local_bb1_keep_going_c1_ene1_keep_going;
			local_bb1_keep_going_c1_ene1_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb1_keep_going_c1_ene1_valid_out_1_NO_SHIFT_REG <= 1'b1;
			local_bb1_keep_going_c1_ene1_valid_out_2_NO_SHIFT_REG <= 1'b1;
			local_bb1_keep_going_c1_ene1_valid_out_3_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb1_keep_going_c1_ene1_stall_in_0))
			begin
				local_bb1_keep_going_c1_ene1_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_keep_going_c1_ene1_stall_in_1))
			begin
				local_bb1_keep_going_c1_ene1_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_keep_going_c1_ene1_stall_in_2))
			begin
				local_bb1_keep_going_c1_ene1_valid_out_2_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_keep_going_c1_ene1_stall_in_3))
			begin
				local_bb1_keep_going_c1_ene1_valid_out_3_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_1to2_bb1_vectorpop13_extract0_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract0_0_stall_in_0_NO_SHIFT_REG;
 logic [3:0] rnode_1to2_bb1_vectorpop13_extract0_0_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract0_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract0_0_stall_in_1_NO_SHIFT_REG;
 logic [3:0] rnode_1to2_bb1_vectorpop13_extract0_1_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract0_0_reg_2_inputs_ready_NO_SHIFT_REG;
 logic [3:0] rnode_1to2_bb1_vectorpop13_extract0_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract0_0_valid_out_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract0_0_stall_in_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract0_0_stall_out_reg_2_NO_SHIFT_REG;

acl_data_fifo rnode_1to2_bb1_vectorpop13_extract0_0_reg_2_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to2_bb1_vectorpop13_extract0_0_reg_2_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to2_bb1_vectorpop13_extract0_0_stall_in_0_reg_2_NO_SHIFT_REG),
	.valid_out(rnode_1to2_bb1_vectorpop13_extract0_0_valid_out_0_reg_2_NO_SHIFT_REG),
	.stall_out(rnode_1to2_bb1_vectorpop13_extract0_0_stall_out_reg_2_NO_SHIFT_REG),
	.data_in(local_bb1_vectorpop13_extract0),
	.data_out(rnode_1to2_bb1_vectorpop13_extract0_0_reg_2_NO_SHIFT_REG)
);

defparam rnode_1to2_bb1_vectorpop13_extract0_0_reg_2_fifo.DEPTH = 1;
defparam rnode_1to2_bb1_vectorpop13_extract0_0_reg_2_fifo.DATA_WIDTH = 4;
defparam rnode_1to2_bb1_vectorpop13_extract0_0_reg_2_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_1to2_bb1_vectorpop13_extract0_0_reg_2_fifo.IMPL = "shift_reg";

assign rnode_1to2_bb1_vectorpop13_extract0_0_reg_2_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_vectorpop13_extract0_stall_in = 1'b0;
assign rnode_1to2_bb1_vectorpop13_extract0_0_stall_in_0_reg_2_NO_SHIFT_REG = ~(local_bb1_c1_exit_c1_exi7_enable);
assign rnode_1to2_bb1_vectorpop13_extract0_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_1to2_bb1_vectorpop13_extract0_0_NO_SHIFT_REG = rnode_1to2_bb1_vectorpop13_extract0_0_reg_2_NO_SHIFT_REG;
assign rnode_1to2_bb1_vectorpop13_extract0_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_1to2_bb1_vectorpop13_extract0_1_NO_SHIFT_REG = rnode_1to2_bb1_vectorpop13_extract0_0_reg_2_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_1to2_bb1_vectorpop13_extract1_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract1_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_1to2_bb1_vectorpop13_extract1_0_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract1_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract1_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract1_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract1_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_1to2_bb1_vectorpop13_extract1_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract1_0_valid_out_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract1_0_stall_in_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_vectorpop13_extract1_0_stall_out_reg_2_NO_SHIFT_REG;

acl_data_fifo rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to2_bb1_vectorpop13_extract1_0_stall_in_0_reg_2_NO_SHIFT_REG),
	.valid_out(rnode_1to2_bb1_vectorpop13_extract1_0_valid_out_0_reg_2_NO_SHIFT_REG),
	.stall_out(rnode_1to2_bb1_vectorpop13_extract1_0_stall_out_reg_2_NO_SHIFT_REG),
	.data_in(local_bb1_vectorpop13_extract1),
	.data_out(rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_NO_SHIFT_REG)
);

defparam rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_fifo.DEPTH = 1;
defparam rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_fifo.DATA_WIDTH = 32;
defparam rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_fifo.IMPL = "shift_reg";

assign rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_vectorpop13_extract1_stall_in = 1'b0;
assign rnode_1to2_bb1_vectorpop13_extract1_0_stall_in_0_reg_2_NO_SHIFT_REG = ~(local_bb1_c1_exit_c1_exi7_enable);
assign rnode_1to2_bb1_vectorpop13_extract1_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_1to2_bb1_vectorpop13_extract1_0_NO_SHIFT_REG = rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_NO_SHIFT_REG;
assign rnode_1to2_bb1_vectorpop13_extract1_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG = rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_NO_SHIFT_REG;
assign rnode_1to2_bb1_vectorpop13_extract1_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_1to2_bb1_vectorpop13_extract1_2_NO_SHIFT_REG = rnode_1to2_bb1_vectorpop13_extract1_0_reg_2_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop12_insert0_stall_local;
wire [23:0] local_bb1_vectorpop12_insert0;

assign local_bb1_vectorpop12_insert0[11:0] = 12'h77D;
assign local_bb1_vectorpop12_insert0[23:12] = 12'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_var__stall_local;
wire [3:0] local_bb1_var_;

assign local_bb1_var_ = (rnode_1to2_bb1_vectorpop13_extract0_0_NO_SHIFT_REG & 4'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp4_stall_local;
wire local_bb1_cmp4;

assign local_bb1_cmp4 = ($signed(rnode_1to2_bb1_vectorpop13_extract1_0_NO_SHIFT_REG) > $signed(32'hFFFFFFFF));

// This section implements an unregistered operation.
// 
wire local_bb1_idxprom5_stall_local;
wire [63:0] local_bb1_idxprom5;

assign local_bb1_idxprom5[32] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[33] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[34] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[35] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[36] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[37] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[38] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[39] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[40] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[41] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[42] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[43] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[44] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[45] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[46] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[47] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[48] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[49] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[50] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[51] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[52] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[53] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[54] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[55] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[56] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[57] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[58] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[59] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[60] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[61] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[62] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[63] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG[31];
assign local_bb1_idxprom5[31:0] = rnode_1to2_bb1_vectorpop13_extract1_1_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_inc45_stall_local;
wire [31:0] local_bb1_inc45;

assign local_bb1_inc45 = (rnode_1to2_bb1_vectorpop13_extract1_2_NO_SHIFT_REG + 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop12_insert1_stall_local;
wire [23:0] local_bb1_vectorpop12_insert1;

assign local_bb1_vectorpop12_insert1[15:0] = local_bb1_vectorpop12_insert0[15:0];
assign local_bb1_vectorpop12_insert1[19:16] = 4'h7;
assign local_bb1_vectorpop12_insert1[23:20] = local_bb1_vectorpop12_insert0[23:20];

// This section implements an unregistered operation.
// 
wire local_bb1_first_cleanup_stall_local;
wire local_bb1_first_cleanup;

assign local_bb1_first_cleanup = ((local_bb1_var_ & 4'h1) != 4'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp4_xor_stall_local;
wire local_bb1_cmp4_xor;

assign local_bb1_cmp4_xor = (local_bb1_cmp4 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1_arrayidx6_stall_local;
wire [63:0] local_bb1_arrayidx6;

assign local_bb1_arrayidx6 = ((input_frame_in & 64'hFFFFFFFFFFFFFC00) + (local_bb1_idxprom5 << 6'h2));

// This section implements an unregistered operation.
// 
wire local_bb1_arrayidx43_stall_local;
wire [63:0] local_bb1_arrayidx43;

assign local_bb1_arrayidx43 = ((input_frame_out & 64'hFFFFFFFFFFFFFC00) + (local_bb1_idxprom5 << 6'h2));

// This section implements an unregistered operation.
// 
wire local_bb1_cmp_stall_local;
wire local_bb1_cmp;

assign local_bb1_cmp = (local_bb1_inc45 == input_iterations);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop12_vectorpop12_insert1_stall_local;
wire [23:0] local_bb1_vectorpop12_vectorpop12_insert1;
wire local_bb1_vectorpop12_vectorpop12_insert1_fu_valid_out;
wire local_bb1_vectorpop12_vectorpop12_insert1_fu_stall_out;

acl_pop local_bb1_vectorpop12_vectorpop12_insert1_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(rnode_1to2_bb1_c1_ene1_1_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpop12_insert1),
	.stall_out(local_bb1_vectorpop12_vectorpop12_insert1_fu_stall_out),
	.valid_in(SFC_1_VALID_1_2_0_NO_SHIFT_REG),
	.valid_out(local_bb1_vectorpop12_vectorpop12_insert1_fu_valid_out),
	.stall_in(local_bb1_vectorpop12_vectorpop12_insert1_stall_local),
	.data_out(local_bb1_vectorpop12_vectorpop12_insert1),
	.feedback_in(feedback_data_in_12),
	.feedback_valid_in(feedback_valid_in_12),
	.feedback_stall_out(feedback_stall_out_12)
);

defparam local_bb1_vectorpop12_vectorpop12_insert1_feedback.COALESCE_DISTANCE = 1;
defparam local_bb1_vectorpop12_vectorpop12_insert1_feedback.DATA_WIDTH = 24;
defparam local_bb1_vectorpop12_vectorpop12_insert1_feedback.STYLE = "REGULAR";

assign local_bb1_vectorpop12_vectorpop12_insert1_stall_local = ~(local_bb1_c1_exit_c1_exi7_enable);

// This section implements an unregistered operation.
// 
wire local_bb1_xor_stall_local;
wire local_bb1_xor;

assign local_bb1_xor = (local_bb1_first_cleanup ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp6_phi_decision537_or_stall_local;
wire local_bb1_cmp6_phi_decision537_or;

assign local_bb1_cmp6_phi_decision537_or = (input_wii_cmp6 | local_bb1_cmp4_xor);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u0_stall_local;
wire local_bb1_var__u0;

assign local_bb1_var__u0 = (input_wii_cmp6 | local_bb1_cmp);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop12_extract0_stall_local;
wire [11:0] local_bb1_vectorpop12_extract0;

assign local_bb1_vectorpop12_extract0[11:0] = local_bb1_vectorpop12_vectorpop12_insert1[11:0];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop12_extract1_stall_local;
wire [3:0] local_bb1_vectorpop12_extract1;

assign local_bb1_vectorpop12_extract1[3:0] = local_bb1_vectorpop12_vectorpop12_insert1[19:16];

// This section implements an unregistered operation.
// 
wire local_bb1_first_cleanup_xor_or_stall_local;
wire local_bb1_first_cleanup_xor_or;

assign local_bb1_first_cleanup_xor_or = (local_bb1_cmp6_phi_decision537_or | local_bb1_xor);

// This section implements an unregistered operation.
// 
wire local_bb1_notexit_stall_local;
wire local_bb1_notexit;

assign local_bb1_notexit = (local_bb1_var__u0 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1_or_stall_local;
wire local_bb1_or;

assign local_bb1_or = (local_bb1_var__u0 | local_bb1_xor);

// This section implements an unregistered operation.
// 
wire local_bb1_masked_stall_local;
wire local_bb1_masked;

assign local_bb1_masked = (local_bb1_var__u0 & local_bb1_first_cleanup);

// This section implements an unregistered operation.
// 
wire local_bb1_coalesce_counter_lobit_stall_local;
wire [11:0] local_bb1_coalesce_counter_lobit;

assign local_bb1_coalesce_counter_lobit = (local_bb1_vectorpop12_extract0 >> 12'hB);

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exi1_stall_local;
wire [319:0] local_bb1_c1_exi1;

assign local_bb1_c1_exi1[15:0] = 16'bx;
assign local_bb1_c1_exi1[27:16] = local_bb1_vectorpop12_extract0;
assign local_bb1_c1_exi1[319:28] = 292'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_next_initerations_stall_local;
wire [3:0] local_bb1_next_initerations;

assign local_bb1_next_initerations = (local_bb1_vectorpop12_extract1 >> 4'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_cleanups_shl_stall_local;
wire [3:0] local_bb1_cleanups_shl;

assign local_bb1_cleanups_shl[3:1] = 3'h0;
assign local_bb1_cleanups_shl[0] = local_bb1_or;

// This section implements an unregistered operation.
// 
wire local_bb1_next_coalesce_select_stall_local;
wire [11:0] local_bb1_next_coalesce_select;

assign local_bb1_next_coalesce_select = ((local_bb1_coalesce_counter_lobit & 12'h1) ^ 12'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exi2_stall_local;
wire [319:0] local_bb1_c1_exi2;

assign local_bb1_c1_exi2[31:0] = local_bb1_c1_exi1[31:0];
assign local_bb1_c1_exi2[32] = local_bb1_keep_going_c1_ene1_NO_SHIFT_REG;
assign local_bb1_c1_exi2[319:33] = local_bb1_c1_exi1[319:33];

// This section implements an unregistered operation.
// 
wire local_bb1_var__u1_stall_local;
wire [3:0] local_bb1_var__u1;

assign local_bb1_var__u1 = ((local_bb1_next_initerations & 4'h7) & 4'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_next_cleanups_stall_local;
wire [3:0] local_bb1_next_cleanups;

assign local_bb1_next_cleanups = (rnode_1to2_bb1_vectorpop13_extract0_1_NO_SHIFT_REG << (local_bb1_cleanups_shl & 4'h1));

// This section implements an unregistered operation.
// 
wire local_bb1_next_coalesce_stall_local;
wire [11:0] local_bb1_next_coalesce;

assign local_bb1_next_coalesce = (local_bb1_vectorpop12_extract0 - (local_bb1_next_coalesce_select & 12'h1));

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exi3_stall_local;
wire [319:0] local_bb1_c1_exi3;

assign local_bb1_c1_exi3[39:0] = local_bb1_c1_exi2[39:0];
assign local_bb1_c1_exi3[40] = local_bb1_cmp4;
assign local_bb1_c1_exi3[319:41] = local_bb1_c1_exi2[319:41];

// This section implements an unregistered operation.
// 
wire local_bb1_last_initeration_stall_local;
wire local_bb1_last_initeration;

assign local_bb1_last_initeration = ((local_bb1_var__u1 & 4'h1) != 4'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush13_insert0_stall_local;
wire [39:0] local_bb1_vectorpush13_insert0;

assign local_bb1_vectorpush13_insert0[3:0] = local_bb1_next_cleanups;
assign local_bb1_vectorpush13_insert0[39:4] = 36'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush12_insert0_stall_local;
wire [23:0] local_bb1_vectorpush12_insert0;

assign local_bb1_vectorpush12_insert0[11:0] = local_bb1_next_coalesce;
assign local_bb1_vectorpush12_insert0[23:12] = 12'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exi4_stall_local;
wire [319:0] local_bb1_c1_exi4;

assign local_bb1_c1_exi4[63:0] = local_bb1_c1_exi3[63:0];
assign local_bb1_c1_exi4[127:64] = (local_bb1_arrayidx6 & 64'hFFFFFFFFFFFFFFFC);
assign local_bb1_c1_exi4[319:128] = local_bb1_c1_exi3[319:128];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush13_insert1_stall_local;
wire [39:0] local_bb1_vectorpush13_insert1;

assign local_bb1_vectorpush13_insert1[7:0] = local_bb1_vectorpush13_insert0[7:0];
assign local_bb1_vectorpush13_insert1[39:8] = local_bb1_inc45;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush12_insert1_stall_local;
wire [23:0] local_bb1_vectorpush12_insert1;

assign local_bb1_vectorpush12_insert1[15:0] = local_bb1_vectorpush12_insert0[15:0];
assign local_bb1_vectorpush12_insert1[19:16] = (local_bb1_next_initerations & 4'h7);
assign local_bb1_vectorpush12_insert1[23:20] = local_bb1_vectorpush12_insert0[23:20];

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exi5_stall_local;
wire [319:0] local_bb1_c1_exi5;

assign local_bb1_c1_exi5[127:0] = local_bb1_c1_exi4[127:0];
assign local_bb1_c1_exi5[128] = local_bb1_first_cleanup_xor_or;
assign local_bb1_c1_exi5[319:129] = local_bb1_c1_exi4[319:129];

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exi6_stall_local;
wire [319:0] local_bb1_c1_exi6;

assign local_bb1_c1_exi6[191:0] = local_bb1_c1_exi5[191:0];
assign local_bb1_c1_exi6[255:192] = (local_bb1_arrayidx43 & 64'hFFFFFFFFFFFFFFFC);
assign local_bb1_c1_exi6[319:256] = local_bb1_c1_exi5[319:256];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush12_insert1_valid_out;
wire local_bb1_vectorpush12_insert1_stall_in;
wire local_bb1_last_initeration_valid_out;
wire local_bb1_last_initeration_stall_in;
wire local_bb1_c1_exi7_valid_out;
wire local_bb1_c1_exi7_stall_in;
wire local_bb1_first_cleanup_valid_out_1;
wire local_bb1_first_cleanup_stall_in_1;
wire local_bb1_vectorpush13_insert1_valid_out;
wire local_bb1_vectorpush13_insert1_stall_in;
wire local_bb1_notexit_valid_out;
wire local_bb1_notexit_stall_in;
wire local_bb1_c1_exi7_inputs_ready;
wire local_bb1_c1_exi7_stall_local;
wire [319:0] local_bb1_c1_exi7;

assign local_bb1_c1_exi7_inputs_ready = (local_bb1_keep_going_c1_ene1_valid_out_1_NO_SHIFT_REG & rnode_1to2_bb1_vectorpop13_extract1_0_valid_out_0_NO_SHIFT_REG & rnode_1to2_bb1_c1_ene1_0_valid_out_0_NO_SHIFT_REG & SFC_1_VALID_1_2_0_valid_out_1_NO_SHIFT_REG & rnode_1to2_bb1_c1_ene1_0_valid_out_1_NO_SHIFT_REG & rnode_1to2_bb1_vectorpop13_extract1_0_valid_out_1_NO_SHIFT_REG & rnode_1to2_bb1_vectorpop13_extract0_0_valid_out_0_NO_SHIFT_REG & rnode_1to2_bb1_vectorpop13_extract0_0_valid_out_1_NO_SHIFT_REG & rnode_1to2_bb1_vectorpop13_extract1_0_valid_out_2_NO_SHIFT_REG);
assign local_bb1_c1_exi7[255:0] = local_bb1_c1_exi6[255:0];
assign local_bb1_c1_exi7[256] = local_bb1_masked;
assign local_bb1_c1_exi7[319:257] = local_bb1_c1_exi6[319:257];
assign local_bb1_vectorpush12_insert1_valid_out = 1'b1;
assign local_bb1_last_initeration_valid_out = 1'b1;
assign local_bb1_c1_exi7_valid_out = 1'b1;
assign local_bb1_first_cleanup_valid_out_1 = 1'b1;
assign local_bb1_vectorpush13_insert1_valid_out = 1'b1;
assign local_bb1_notexit_valid_out = 1'b1;
assign local_bb1_keep_going_c1_ene1_stall_in_1 = 1'b0;
assign rnode_1to2_bb1_vectorpop13_extract1_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_1to2_bb1_c1_ene1_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign SFC_1_VALID_1_2_0_stall_in_1 = 1'b0;
assign rnode_1to2_bb1_c1_ene1_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_1to2_bb1_vectorpop13_extract1_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_1to2_bb1_vectorpop13_extract0_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_1to2_bb1_vectorpop13_extract0_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_1to2_bb1_vectorpop13_extract1_0_stall_in_2_NO_SHIFT_REG = 1'b0;

// This section implements a registered operation.
// 
wire local_bb1_vectorpush12_vectorpush12_insert1_inputs_ready;
wire local_bb1_vectorpush12_vectorpush12_insert1_output_regs_ready;
wire [23:0] local_bb1_vectorpush12_vectorpush12_insert1_result;
wire local_bb1_vectorpush12_vectorpush12_insert1_fu_valid_out;
wire local_bb1_vectorpush12_vectorpush12_insert1_fu_stall_out;
 reg [23:0] local_bb1_vectorpush12_vectorpush12_insert1_NO_SHIFT_REG;
wire local_bb1_vectorpush12_vectorpush12_insert1_causedstall;

acl_push local_bb1_vectorpush12_vectorpush12_insert1_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_keep_going_c1_ene1_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpush12_insert1),
	.stall_out(local_bb1_vectorpush12_vectorpush12_insert1_fu_stall_out),
	.valid_in(SFC_1_VALID_1_2_0_NO_SHIFT_REG),
	.valid_out(local_bb1_vectorpush12_vectorpush12_insert1_fu_valid_out),
	.stall_in(~(local_bb1_c1_exit_c1_exi7_enable)),
	.data_out(local_bb1_vectorpush12_vectorpush12_insert1_result),
	.feedback_out(feedback_data_out_12),
	.feedback_valid_out(feedback_valid_out_12),
	.feedback_stall_in(feedback_stall_in_12)
);

defparam local_bb1_vectorpush12_vectorpush12_insert1_feedback.STALLFREE = 1;
defparam local_bb1_vectorpush12_vectorpush12_insert1_feedback.ENABLED = 1;
defparam local_bb1_vectorpush12_vectorpush12_insert1_feedback.DATA_WIDTH = 24;
defparam local_bb1_vectorpush12_vectorpush12_insert1_feedback.FIFO_DEPTH = 1;
defparam local_bb1_vectorpush12_vectorpush12_insert1_feedback.MIN_FIFO_LATENCY = 1;
defparam local_bb1_vectorpush12_vectorpush12_insert1_feedback.STYLE = "REGULAR";
defparam local_bb1_vectorpush12_vectorpush12_insert1_feedback.RAM_FIFO_DEPTH_INC = 1;

assign local_bb1_vectorpush12_vectorpush12_insert1_inputs_ready = 1'b1;
assign local_bb1_vectorpush12_vectorpush12_insert1_output_regs_ready = local_bb1_c1_exit_c1_exi7_enable;
assign local_bb1_vectorpush12_insert1_stall_in = 1'b0;
assign local_bb1_keep_going_c1_ene1_stall_in_3 = 1'b0;
assign SFC_1_VALID_1_2_0_stall_in_4 = 1'b0;
assign local_bb1_vectorpush12_vectorpush12_insert1_causedstall = (SFC_1_VALID_1_2_0_NO_SHIFT_REG && (1'b0 && !(~(local_bb1_c1_exit_c1_exi7_enable))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_vectorpush12_vectorpush12_insert1_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_vectorpush12_vectorpush12_insert1_output_regs_ready)
		begin
			local_bb1_vectorpush12_vectorpush12_insert1_NO_SHIFT_REG <= local_bb1_vectorpush12_vectorpush12_insert1_result;
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb1_lastiniteration_last_initeration_inputs_ready;
wire local_bb1_lastiniteration_last_initeration_output_regs_ready;
wire local_bb1_lastiniteration_last_initeration_result;
wire local_bb1_lastiniteration_last_initeration_fu_valid_out;
wire local_bb1_lastiniteration_last_initeration_fu_stall_out;
 reg local_bb1_lastiniteration_last_initeration_NO_SHIFT_REG;
wire local_bb1_lastiniteration_last_initeration_causedstall;

acl_push local_bb1_lastiniteration_last_initeration_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_keep_going_c1_ene1_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_last_initeration),
	.stall_out(local_bb1_lastiniteration_last_initeration_fu_stall_out),
	.valid_in(SFC_1_VALID_1_2_0_NO_SHIFT_REG),
	.valid_out(local_bb1_lastiniteration_last_initeration_fu_valid_out),
	.stall_in(~(local_bb1_c1_exit_c1_exi7_enable)),
	.data_out(local_bb1_lastiniteration_last_initeration_result),
	.feedback_out(feedback_data_out_0),
	.feedback_valid_out(feedback_valid_out_0),
	.feedback_stall_in(feedback_stall_in_0)
);

defparam local_bb1_lastiniteration_last_initeration_feedback.STALLFREE = 1;
defparam local_bb1_lastiniteration_last_initeration_feedback.ENABLED = 1;
defparam local_bb1_lastiniteration_last_initeration_feedback.DATA_WIDTH = 1;
defparam local_bb1_lastiniteration_last_initeration_feedback.FIFO_DEPTH = 1;
defparam local_bb1_lastiniteration_last_initeration_feedback.MIN_FIFO_LATENCY = 0;
defparam local_bb1_lastiniteration_last_initeration_feedback.STYLE = "REGULAR";
defparam local_bb1_lastiniteration_last_initeration_feedback.RAM_FIFO_DEPTH_INC = 0;

assign local_bb1_lastiniteration_last_initeration_inputs_ready = 1'b1;
assign local_bb1_lastiniteration_last_initeration_output_regs_ready = local_bb1_c1_exit_c1_exi7_enable;
assign local_bb1_last_initeration_stall_in = 1'b0;
assign local_bb1_keep_going_c1_ene1_stall_in_0 = 1'b0;
assign SFC_1_VALID_1_2_0_stall_in_2 = 1'b0;
assign local_bb1_lastiniteration_last_initeration_causedstall = (SFC_1_VALID_1_2_0_NO_SHIFT_REG && (1'b0 && !(~(local_bb1_c1_exit_c1_exi7_enable))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_lastiniteration_last_initeration_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_lastiniteration_last_initeration_output_regs_ready)
		begin
			local_bb1_lastiniteration_last_initeration_NO_SHIFT_REG <= local_bb1_lastiniteration_last_initeration_result;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c1_exit_c1_exi7_valid_out;
wire local_bb1_c1_exit_c1_exi7_stall_in;
wire local_bb1_c1_exit_c1_exi7_inputs_ready;
wire local_bb1_c1_exit_c1_exi7_stall_local;
wire [319:0] local_bb1_c1_exit_c1_exi7;
wire local_bb1_c1_exit_c1_exi7_valid;
wire local_bb1_c1_exit_c1_exi7_fu_stall_out;

acl_enable_sink local_bb1_c1_exit_c1_exi7_instance (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb1_c1_exi7),
	.data_out(local_bb1_c1_exit_c1_exi7),
	.input_accepted(local_bb1_c1_enter_c1_eni1_input_accepted),
	.valid_out(local_bb1_c1_exit_c1_exi7_valid),
	.stall_in(local_bb1_c1_exit_c1_exi7_stall_local),
	.enable(local_bb1_c1_exit_c1_exi7_enable),
	.valid_in(local_bb1_c1_exit_c1_exi7_valid_in),
	.stall_entry(local_bb1_c1_exit_c1_exi7_entry_stall),
	.inc_pipelined_thread(local_bb1_c1_enter_c1_eni1_inc_pipelined_thread),
	.dec_pipelined_thread(local_bb1_c1_enter_c1_eni1_dec_pipelined_thread)
);

defparam local_bb1_c1_exit_c1_exi7_instance.DATA_WIDTH = 320;
defparam local_bb1_c1_exit_c1_exi7_instance.PIPELINE_DEPTH = 1;
defparam local_bb1_c1_exit_c1_exi7_instance.SCHEDULEII = 1;
defparam local_bb1_c1_exit_c1_exi7_instance.IP_PIPELINE_LATENCY_PLUS1 = 1;

assign local_bb1_c1_exit_c1_exi7_inputs_ready = (local_bb1_c1_exi7_valid_out & SFC_1_VALID_1_2_0_valid_out_0_NO_SHIFT_REG);
assign local_bb1_c1_exit_c1_exi7_valid_in = SFC_1_VALID_1_2_0_NO_SHIFT_REG;
assign local_bb1_c1_exit_c1_exi7_fu_stall_out = ~(local_bb1_c1_exit_c1_exi7_enable);
assign local_bb1_c1_exit_c1_exi7_valid_out = local_bb1_c1_exit_c1_exi7_valid;
assign local_bb1_c1_exit_c1_exi7_stall_local = local_bb1_c1_exit_c1_exi7_stall_in;
assign local_bb1_c1_exi7_stall_in = 1'b0;
assign SFC_1_VALID_1_2_0_stall_in_0 = 1'b0;

// This section implements a registered operation.
// 
wire local_bb1_vectorpush13_vectorpush13_insert1_inputs_ready;
wire local_bb1_vectorpush13_vectorpush13_insert1_output_regs_ready;
wire [39:0] local_bb1_vectorpush13_vectorpush13_insert1_result;
wire local_bb1_vectorpush13_vectorpush13_insert1_fu_valid_out;
wire local_bb1_vectorpush13_vectorpush13_insert1_fu_stall_out;
 reg [39:0] local_bb1_vectorpush13_vectorpush13_insert1_NO_SHIFT_REG;
wire local_bb1_vectorpush13_vectorpush13_insert1_causedstall;

acl_push local_bb1_vectorpush13_vectorpush13_insert1_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_keep_going_c1_ene1_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpush13_insert1),
	.stall_out(local_bb1_vectorpush13_vectorpush13_insert1_fu_stall_out),
	.valid_in(SFC_1_VALID_1_2_0_NO_SHIFT_REG),
	.valid_out(local_bb1_vectorpush13_vectorpush13_insert1_fu_valid_out),
	.stall_in(~(local_bb1_c1_exit_c1_exi7_enable)),
	.data_out(local_bb1_vectorpush13_vectorpush13_insert1_result),
	.feedback_out(feedback_data_out_13),
	.feedback_valid_out(feedback_valid_out_13),
	.feedback_stall_in(feedback_stall_in_13)
);

defparam local_bb1_vectorpush13_vectorpush13_insert1_feedback.STALLFREE = 1;
defparam local_bb1_vectorpush13_vectorpush13_insert1_feedback.ENABLED = 1;
defparam local_bb1_vectorpush13_vectorpush13_insert1_feedback.DATA_WIDTH = 40;
defparam local_bb1_vectorpush13_vectorpush13_insert1_feedback.FIFO_DEPTH = 1;
defparam local_bb1_vectorpush13_vectorpush13_insert1_feedback.MIN_FIFO_LATENCY = 0;
defparam local_bb1_vectorpush13_vectorpush13_insert1_feedback.STYLE = "REGULAR";
defparam local_bb1_vectorpush13_vectorpush13_insert1_feedback.RAM_FIFO_DEPTH_INC = 0;

assign local_bb1_vectorpush13_vectorpush13_insert1_inputs_ready = 1'b1;
assign local_bb1_vectorpush13_vectorpush13_insert1_output_regs_ready = local_bb1_c1_exit_c1_exi7_enable;
assign local_bb1_vectorpush13_insert1_stall_in = 1'b0;
assign local_bb1_keep_going_c1_ene1_stall_in_2 = 1'b0;
assign SFC_1_VALID_1_2_0_stall_in_5 = 1'b0;
assign local_bb1_vectorpush13_vectorpush13_insert1_causedstall = (SFC_1_VALID_1_2_0_NO_SHIFT_REG && (1'b0 && !(~(local_bb1_c1_exit_c1_exi7_enable))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_vectorpush13_vectorpush13_insert1_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_vectorpush13_vectorpush13_insert1_output_regs_ready)
		begin
			local_bb1_vectorpush13_vectorpush13_insert1_NO_SHIFT_REG <= local_bb1_vectorpush13_vectorpush13_insert1_result;
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb1_notexitcond_notexit_inputs_ready;
wire local_bb1_notexitcond_notexit_output_regs_ready;
wire local_bb1_notexitcond_notexit_result;
wire local_bb1_notexitcond_notexit_fu_valid_out;
wire local_bb1_notexitcond_notexit_fu_stall_out;
 reg local_bb1_notexitcond_notexit_NO_SHIFT_REG;
wire local_bb1_notexitcond_notexit_causedstall;

acl_push local_bb1_notexitcond_notexit_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_first_cleanup),
	.predicate(1'b0),
	.data_in(local_bb1_notexit),
	.stall_out(local_bb1_notexitcond_notexit_fu_stall_out),
	.valid_in(SFC_1_VALID_1_2_0_NO_SHIFT_REG),
	.valid_out(local_bb1_notexitcond_notexit_fu_valid_out),
	.stall_in(~(local_bb1_c1_exit_c1_exi7_enable)),
	.data_out(local_bb1_notexitcond_notexit_result),
	.feedback_out(feedback_data_out_1),
	.feedback_valid_out(feedback_valid_out_1),
	.feedback_stall_in(feedback_stall_in_1)
);

defparam local_bb1_notexitcond_notexit_feedback.STALLFREE = 1;
defparam local_bb1_notexitcond_notexit_feedback.ENABLED = 1;
defparam local_bb1_notexitcond_notexit_feedback.DATA_WIDTH = 1;
defparam local_bb1_notexitcond_notexit_feedback.FIFO_DEPTH = 3;
defparam local_bb1_notexitcond_notexit_feedback.MIN_FIFO_LATENCY = 2;
defparam local_bb1_notexitcond_notexit_feedback.STYLE = "REGULAR";
defparam local_bb1_notexitcond_notexit_feedback.RAM_FIFO_DEPTH_INC = 0;

assign local_bb1_notexitcond_notexit_inputs_ready = 1'b1;
assign local_bb1_notexitcond_notexit_output_regs_ready = local_bb1_c1_exit_c1_exi7_enable;
assign local_bb1_notexit_stall_in = 1'b0;
assign local_bb1_first_cleanup_stall_in_1 = 1'b0;
assign SFC_1_VALID_1_2_0_stall_in_3 = 1'b0;
assign local_bb1_notexitcond_notexit_causedstall = (SFC_1_VALID_1_2_0_NO_SHIFT_REG && (1'b0 && !(~(local_bb1_c1_exit_c1_exi7_enable))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_notexitcond_notexit_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_notexitcond_notexit_output_regs_ready)
		begin
			local_bb1_notexitcond_notexit_NO_SHIFT_REG <= local_bb1_notexitcond_notexit_result;
		end
	end
end


// This section implements a staging register.
// 
wire rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_0;
wire rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_0;
wire rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_1;
wire rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_1;
wire rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_2;
wire rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_2;
wire rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_3;
wire rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_3;
wire rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_4;
wire rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_4;
wire rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_5;
wire rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_5;
wire rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_6;
wire rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_6;
wire rstag_2to2_bb1_c1_exit_c1_exi7_inputs_ready;
wire rstag_2to2_bb1_c1_exit_c1_exi7_stall_local;
 reg rstag_2to2_bb1_c1_exit_c1_exi7_staging_valid_NO_SHIFT_REG;
wire rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid;
 reg [319:0] rstag_2to2_bb1_c1_exit_c1_exi7_staging_reg_NO_SHIFT_REG;
wire [319:0] rstag_2to2_bb1_c1_exit_c1_exi7;
 reg rstag_2to2_bb1_c1_exit_c1_exi7_consumed_0_NO_SHIFT_REG;
 reg rstag_2to2_bb1_c1_exit_c1_exi7_consumed_1_NO_SHIFT_REG;
 reg rstag_2to2_bb1_c1_exit_c1_exi7_consumed_2_NO_SHIFT_REG;
 reg rstag_2to2_bb1_c1_exit_c1_exi7_consumed_4_NO_SHIFT_REG;
 reg rstag_2to2_bb1_c1_exit_c1_exi7_consumed_5_NO_SHIFT_REG;
 reg rstag_2to2_bb1_c1_exit_c1_exi7_consumed_6_NO_SHIFT_REG;

assign rstag_2to2_bb1_c1_exit_c1_exi7_inputs_ready = local_bb1_c1_exit_c1_exi7_valid_out;
assign rstag_2to2_bb1_c1_exit_c1_exi7 = (rstag_2to2_bb1_c1_exit_c1_exi7_staging_valid_NO_SHIFT_REG ? rstag_2to2_bb1_c1_exit_c1_exi7_staging_reg_NO_SHIFT_REG : local_bb1_c1_exit_c1_exi7);
assign rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid = (rstag_2to2_bb1_c1_exit_c1_exi7_staging_valid_NO_SHIFT_REG | rstag_2to2_bb1_c1_exit_c1_exi7_inputs_ready);
assign rstag_2to2_bb1_c1_exit_c1_exi7_stall_local = ((rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_0 & ~(rstag_2to2_bb1_c1_exit_c1_exi7_consumed_0_NO_SHIFT_REG)) | (rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_1 & ~(rstag_2to2_bb1_c1_exit_c1_exi7_consumed_1_NO_SHIFT_REG)) | (rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_2 & ~(rstag_2to2_bb1_c1_exit_c1_exi7_consumed_2_NO_SHIFT_REG)) | 1'b0 | (rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_4 & ~(rstag_2to2_bb1_c1_exit_c1_exi7_consumed_4_NO_SHIFT_REG)) | (rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_5 & ~(rstag_2to2_bb1_c1_exit_c1_exi7_consumed_5_NO_SHIFT_REG)) | (rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_6 & ~(rstag_2to2_bb1_c1_exit_c1_exi7_consumed_6_NO_SHIFT_REG)));
assign rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_0 = (rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid & ~(rstag_2to2_bb1_c1_exit_c1_exi7_consumed_0_NO_SHIFT_REG));
assign rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_1 = (rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid & ~(rstag_2to2_bb1_c1_exit_c1_exi7_consumed_1_NO_SHIFT_REG));
assign rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_2 = (rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid & ~(rstag_2to2_bb1_c1_exit_c1_exi7_consumed_2_NO_SHIFT_REG));
assign rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_3 = rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid;
assign rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_4 = (rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid & ~(rstag_2to2_bb1_c1_exit_c1_exi7_consumed_4_NO_SHIFT_REG));
assign rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_5 = (rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid & ~(rstag_2to2_bb1_c1_exit_c1_exi7_consumed_5_NO_SHIFT_REG));
assign rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_6 = (rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid & ~(rstag_2to2_bb1_c1_exit_c1_exi7_consumed_6_NO_SHIFT_REG));
assign local_bb1_c1_exit_c1_exi7_stall_in = (|rstag_2to2_bb1_c1_exit_c1_exi7_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_2to2_bb1_c1_exit_c1_exi7_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_2to2_bb1_c1_exit_c1_exi7_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_2to2_bb1_c1_exit_c1_exi7_stall_local)
		begin
			if (~(rstag_2to2_bb1_c1_exit_c1_exi7_staging_valid_NO_SHIFT_REG))
			begin
				rstag_2to2_bb1_c1_exit_c1_exi7_staging_valid_NO_SHIFT_REG <= rstag_2to2_bb1_c1_exit_c1_exi7_inputs_ready;
			end
		end
		else
		begin
			rstag_2to2_bb1_c1_exit_c1_exi7_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_2to2_bb1_c1_exit_c1_exi7_staging_valid_NO_SHIFT_REG))
		begin
			rstag_2to2_bb1_c1_exit_c1_exi7_staging_reg_NO_SHIFT_REG <= local_bb1_c1_exit_c1_exi7;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_2to2_bb1_c1_exit_c1_exi7_consumed_0_NO_SHIFT_REG <= 1'b0;
		rstag_2to2_bb1_c1_exit_c1_exi7_consumed_1_NO_SHIFT_REG <= 1'b0;
		rstag_2to2_bb1_c1_exit_c1_exi7_consumed_2_NO_SHIFT_REG <= 1'b0;
		rstag_2to2_bb1_c1_exit_c1_exi7_consumed_4_NO_SHIFT_REG <= 1'b0;
		rstag_2to2_bb1_c1_exit_c1_exi7_consumed_5_NO_SHIFT_REG <= 1'b0;
		rstag_2to2_bb1_c1_exit_c1_exi7_consumed_6_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		rstag_2to2_bb1_c1_exit_c1_exi7_consumed_0_NO_SHIFT_REG <= (rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid & (rstag_2to2_bb1_c1_exit_c1_exi7_consumed_0_NO_SHIFT_REG | ~(rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_0)) & rstag_2to2_bb1_c1_exit_c1_exi7_stall_local);
		rstag_2to2_bb1_c1_exit_c1_exi7_consumed_1_NO_SHIFT_REG <= (rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid & (rstag_2to2_bb1_c1_exit_c1_exi7_consumed_1_NO_SHIFT_REG | ~(rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_1)) & rstag_2to2_bb1_c1_exit_c1_exi7_stall_local);
		rstag_2to2_bb1_c1_exit_c1_exi7_consumed_2_NO_SHIFT_REG <= (rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid & (rstag_2to2_bb1_c1_exit_c1_exi7_consumed_2_NO_SHIFT_REG | ~(rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_2)) & rstag_2to2_bb1_c1_exit_c1_exi7_stall_local);
		rstag_2to2_bb1_c1_exit_c1_exi7_consumed_4_NO_SHIFT_REG <= (rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid & (rstag_2to2_bb1_c1_exit_c1_exi7_consumed_4_NO_SHIFT_REG | ~(rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_4)) & rstag_2to2_bb1_c1_exit_c1_exi7_stall_local);
		rstag_2to2_bb1_c1_exit_c1_exi7_consumed_5_NO_SHIFT_REG <= (rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid & (rstag_2to2_bb1_c1_exit_c1_exi7_consumed_5_NO_SHIFT_REG | ~(rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_5)) & rstag_2to2_bb1_c1_exit_c1_exi7_stall_local);
		rstag_2to2_bb1_c1_exit_c1_exi7_consumed_6_NO_SHIFT_REG <= (rstag_2to2_bb1_c1_exit_c1_exi7_combined_valid & (rstag_2to2_bb1_c1_exit_c1_exi7_consumed_6_NO_SHIFT_REG | ~(rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_6)) & rstag_2to2_bb1_c1_exit_c1_exi7_stall_local);
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c1_exe7_valid_out;
wire local_bb1_c1_exe7_stall_in;
wire local_bb1_c1_exe7_inputs_ready;
wire local_bb1_c1_exe7_stall_local;
wire local_bb1_c1_exe7;

assign local_bb1_c1_exe7_inputs_ready = rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_0;
assign local_bb1_c1_exe7 = rstag_2to2_bb1_c1_exit_c1_exi7[256];
assign local_bb1_c1_exe7_valid_out = local_bb1_c1_exe7_inputs_ready;
assign local_bb1_c1_exe7_stall_local = local_bb1_c1_exe7_stall_in;
assign rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_0 = (|local_bb1_c1_exe7_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exe6_valid_out;
wire local_bb1_c1_exe6_stall_in;
wire local_bb1_c1_exe6_inputs_ready;
wire local_bb1_c1_exe6_stall_local;
wire [63:0] local_bb1_c1_exe6;

assign local_bb1_c1_exe6_inputs_ready = rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_1;
assign local_bb1_c1_exe6[63:0] = rstag_2to2_bb1_c1_exit_c1_exi7[255:192];
assign local_bb1_c1_exe6_valid_out = local_bb1_c1_exe6_inputs_ready;
assign local_bb1_c1_exe6_stall_local = local_bb1_c1_exe6_stall_in;
assign rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_1 = (|local_bb1_c1_exe6_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exe5_stall_local;
wire local_bb1_c1_exe5;

assign local_bb1_c1_exe5 = rstag_2to2_bb1_c1_exit_c1_exi7[128];

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exe5_valid_out;
wire local_bb1_c1_exe5_stall_in;
wire local_bb1_c1_exe4_valid_out;
wire local_bb1_c1_exe4_stall_in;
wire local_bb1_c1_exe4_inputs_ready;
wire local_bb1_c1_exe4_stall_local;
wire [63:0] local_bb1_c1_exe4;
 reg local_bb1_c1_exe5_consumed_0_NO_SHIFT_REG;
 reg local_bb1_c1_exe4_consumed_0_NO_SHIFT_REG;

assign local_bb1_c1_exe4_inputs_ready = (rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_2 & rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_3);
assign local_bb1_c1_exe4[63:0] = rstag_2to2_bb1_c1_exit_c1_exi7[127:64];
assign local_bb1_c1_exe4_stall_local = ((local_bb1_c1_exe5_stall_in & ~(local_bb1_c1_exe5_consumed_0_NO_SHIFT_REG)) | (local_bb1_c1_exe4_stall_in & ~(local_bb1_c1_exe4_consumed_0_NO_SHIFT_REG)));
assign local_bb1_c1_exe5_valid_out = (local_bb1_c1_exe4_inputs_ready & ~(local_bb1_c1_exe5_consumed_0_NO_SHIFT_REG));
assign local_bb1_c1_exe4_valid_out = (local_bb1_c1_exe4_inputs_ready & ~(local_bb1_c1_exe4_consumed_0_NO_SHIFT_REG));
assign rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_2 = (local_bb1_c1_exe4_stall_local | ~(local_bb1_c1_exe4_inputs_ready));
assign rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_3 = (local_bb1_c1_exe4_stall_local | ~(local_bb1_c1_exe4_inputs_ready));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c1_exe5_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_c1_exe4_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_c1_exe5_consumed_0_NO_SHIFT_REG <= (local_bb1_c1_exe4_inputs_ready & (local_bb1_c1_exe5_consumed_0_NO_SHIFT_REG | ~(local_bb1_c1_exe5_stall_in)) & local_bb1_c1_exe4_stall_local);
		local_bb1_c1_exe4_consumed_0_NO_SHIFT_REG <= (local_bb1_c1_exe4_inputs_ready & (local_bb1_c1_exe4_consumed_0_NO_SHIFT_REG | ~(local_bb1_c1_exe4_stall_in)) & local_bb1_c1_exe4_stall_local);
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c1_exe3_valid_out;
wire local_bb1_c1_exe3_stall_in;
wire local_bb1_c1_exe3_inputs_ready;
wire local_bb1_c1_exe3_stall_local;
wire local_bb1_c1_exe3;

assign local_bb1_c1_exe3_inputs_ready = rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_4;
assign local_bb1_c1_exe3 = rstag_2to2_bb1_c1_exit_c1_exi7[40];
assign local_bb1_c1_exe3_valid_out = local_bb1_c1_exe3_inputs_ready;
assign local_bb1_c1_exe3_stall_local = local_bb1_c1_exe3_stall_in;
assign rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_4 = (|local_bb1_c1_exe3_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exe2_valid_out;
wire local_bb1_c1_exe2_stall_in;
wire local_bb1_c1_exe2_inputs_ready;
wire local_bb1_c1_exe2_stall_local;
wire local_bb1_c1_exe2;

assign local_bb1_c1_exe2_inputs_ready = rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_5;
assign local_bb1_c1_exe2 = rstag_2to2_bb1_c1_exit_c1_exi7[32];
assign local_bb1_c1_exe2_valid_out = local_bb1_c1_exe2_inputs_ready;
assign local_bb1_c1_exe2_stall_local = local_bb1_c1_exe2_stall_in;
assign rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_5 = (|local_bb1_c1_exe2_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exe1_valid_out;
wire local_bb1_c1_exe1_stall_in;
wire local_bb1_c1_exe1_inputs_ready;
wire local_bb1_c1_exe1_stall_local;
wire [11:0] local_bb1_c1_exe1;

assign local_bb1_c1_exe1_inputs_ready = rstag_2to2_bb1_c1_exit_c1_exi7_valid_out_6;
assign local_bb1_c1_exe1[11:0] = rstag_2to2_bb1_c1_exit_c1_exi7[27:16];
assign local_bb1_c1_exe1_valid_out = local_bb1_c1_exe1_inputs_ready;
assign local_bb1_c1_exe1_stall_local = local_bb1_c1_exe1_stall_in;
assign rstag_2to2_bb1_c1_exit_c1_exi7_stall_in_6 = (|local_bb1_c1_exe1_stall_local);

// Register node:
//  * latency = 18
//  * capacity = 18
 logic rnode_2to20_bb1_c1_exe7_0_valid_out_NO_SHIFT_REG;
 logic rnode_2to20_bb1_c1_exe7_0_stall_in_NO_SHIFT_REG;
 logic rnode_2to20_bb1_c1_exe7_0_NO_SHIFT_REG;
 logic rnode_2to20_bb1_c1_exe7_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic rnode_2to20_bb1_c1_exe7_0_reg_20_NO_SHIFT_REG;
 logic rnode_2to20_bb1_c1_exe7_0_valid_out_reg_20_NO_SHIFT_REG;
 logic rnode_2to20_bb1_c1_exe7_0_stall_in_reg_20_NO_SHIFT_REG;
 logic rnode_2to20_bb1_c1_exe7_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_2to20_bb1_c1_exe7_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_2to20_bb1_c1_exe7_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_2to20_bb1_c1_exe7_0_stall_in_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_2to20_bb1_c1_exe7_0_valid_out_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_2to20_bb1_c1_exe7_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(local_bb1_c1_exe7),
	.data_out(rnode_2to20_bb1_c1_exe7_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_2to20_bb1_c1_exe7_0_reg_20_fifo.DEPTH = 19;
defparam rnode_2to20_bb1_c1_exe7_0_reg_20_fifo.DATA_WIDTH = 1;
defparam rnode_2to20_bb1_c1_exe7_0_reg_20_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_2to20_bb1_c1_exe7_0_reg_20_fifo.IMPL = "ram";

assign rnode_2to20_bb1_c1_exe7_0_reg_20_inputs_ready_NO_SHIFT_REG = local_bb1_c1_exe7_valid_out;
assign local_bb1_c1_exe7_stall_in = rnode_2to20_bb1_c1_exe7_0_stall_out_reg_20_NO_SHIFT_REG;
assign rnode_2to20_bb1_c1_exe7_0_NO_SHIFT_REG = rnode_2to20_bb1_c1_exe7_0_reg_20_NO_SHIFT_REG;
assign rnode_2to20_bb1_c1_exe7_0_stall_in_reg_20_NO_SHIFT_REG = rnode_2to20_bb1_c1_exe7_0_stall_in_NO_SHIFT_REG;
assign rnode_2to20_bb1_c1_exe7_0_valid_out_NO_SHIFT_REG = rnode_2to20_bb1_c1_exe7_0_valid_out_reg_20_NO_SHIFT_REG;

// Register node:
//  * latency = 14
//  * capacity = 14
 logic rnode_2to16_bb1_c1_exe6_0_valid_out_NO_SHIFT_REG;
 logic rnode_2to16_bb1_c1_exe6_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_2to16_bb1_c1_exe6_0_NO_SHIFT_REG;
 logic rnode_2to16_bb1_c1_exe6_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_2to16_bb1_c1_exe6_0_reg_16_NO_SHIFT_REG;
 logic rnode_2to16_bb1_c1_exe6_0_valid_out_reg_16_NO_SHIFT_REG;
 logic rnode_2to16_bb1_c1_exe6_0_stall_in_reg_16_NO_SHIFT_REG;
 logic rnode_2to16_bb1_c1_exe6_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_2to16_bb1_c1_exe6_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_2to16_bb1_c1_exe6_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_2to16_bb1_c1_exe6_0_stall_in_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_2to16_bb1_c1_exe6_0_valid_out_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_2to16_bb1_c1_exe6_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in((local_bb1_c1_exe6 & 64'hFFFFFFFFFFFFFFFC)),
	.data_out(rnode_2to16_bb1_c1_exe6_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_2to16_bb1_c1_exe6_0_reg_16_fifo.DEPTH = 15;
defparam rnode_2to16_bb1_c1_exe6_0_reg_16_fifo.DATA_WIDTH = 64;
defparam rnode_2to16_bb1_c1_exe6_0_reg_16_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_2to16_bb1_c1_exe6_0_reg_16_fifo.IMPL = "ram";

assign rnode_2to16_bb1_c1_exe6_0_reg_16_inputs_ready_NO_SHIFT_REG = local_bb1_c1_exe6_valid_out;
assign local_bb1_c1_exe6_stall_in = rnode_2to16_bb1_c1_exe6_0_stall_out_reg_16_NO_SHIFT_REG;
assign rnode_2to16_bb1_c1_exe6_0_NO_SHIFT_REG = rnode_2to16_bb1_c1_exe6_0_reg_16_NO_SHIFT_REG;
assign rnode_2to16_bb1_c1_exe6_0_stall_in_reg_16_NO_SHIFT_REG = rnode_2to16_bb1_c1_exe6_0_stall_in_NO_SHIFT_REG;
assign rnode_2to16_bb1_c1_exe6_0_valid_out_NO_SHIFT_REG = rnode_2to16_bb1_c1_exe6_0_valid_out_reg_16_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_2to2_bb1_c1_exe5_valid_out_0;
wire rstag_2to2_bb1_c1_exe5_stall_in_0;
wire rstag_2to2_bb1_c1_exe5_valid_out_1;
wire rstag_2to2_bb1_c1_exe5_stall_in_1;
wire rstag_2to2_bb1_c1_exe5_inputs_ready;
wire rstag_2to2_bb1_c1_exe5_stall_local;
 reg rstag_2to2_bb1_c1_exe5_staging_valid_NO_SHIFT_REG;
wire rstag_2to2_bb1_c1_exe5_combined_valid;
 reg rstag_2to2_bb1_c1_exe5_staging_reg_NO_SHIFT_REG;
wire rstag_2to2_bb1_c1_exe5;
 reg rstag_2to2_bb1_c1_exe5_consumed_0_NO_SHIFT_REG;
 reg rstag_2to2_bb1_c1_exe5_consumed_1_NO_SHIFT_REG;

assign rstag_2to2_bb1_c1_exe5_inputs_ready = local_bb1_c1_exe5_valid_out;
assign rstag_2to2_bb1_c1_exe5 = (rstag_2to2_bb1_c1_exe5_staging_valid_NO_SHIFT_REG ? rstag_2to2_bb1_c1_exe5_staging_reg_NO_SHIFT_REG : local_bb1_c1_exe5);
assign rstag_2to2_bb1_c1_exe5_combined_valid = (rstag_2to2_bb1_c1_exe5_staging_valid_NO_SHIFT_REG | rstag_2to2_bb1_c1_exe5_inputs_ready);
assign rstag_2to2_bb1_c1_exe5_stall_local = ((rstag_2to2_bb1_c1_exe5_stall_in_0 & ~(rstag_2to2_bb1_c1_exe5_consumed_0_NO_SHIFT_REG)) | (rstag_2to2_bb1_c1_exe5_stall_in_1 & ~(rstag_2to2_bb1_c1_exe5_consumed_1_NO_SHIFT_REG)));
assign rstag_2to2_bb1_c1_exe5_valid_out_0 = (rstag_2to2_bb1_c1_exe5_combined_valid & ~(rstag_2to2_bb1_c1_exe5_consumed_0_NO_SHIFT_REG));
assign rstag_2to2_bb1_c1_exe5_valid_out_1 = (rstag_2to2_bb1_c1_exe5_combined_valid & ~(rstag_2to2_bb1_c1_exe5_consumed_1_NO_SHIFT_REG));
assign local_bb1_c1_exe5_stall_in = (|rstag_2to2_bb1_c1_exe5_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_2to2_bb1_c1_exe5_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_2to2_bb1_c1_exe5_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_2to2_bb1_c1_exe5_stall_local)
		begin
			if (~(rstag_2to2_bb1_c1_exe5_staging_valid_NO_SHIFT_REG))
			begin
				rstag_2to2_bb1_c1_exe5_staging_valid_NO_SHIFT_REG <= rstag_2to2_bb1_c1_exe5_inputs_ready;
			end
		end
		else
		begin
			rstag_2to2_bb1_c1_exe5_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_2to2_bb1_c1_exe5_staging_valid_NO_SHIFT_REG))
		begin
			rstag_2to2_bb1_c1_exe5_staging_reg_NO_SHIFT_REG <= local_bb1_c1_exe5;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_2to2_bb1_c1_exe5_consumed_0_NO_SHIFT_REG <= 1'b0;
		rstag_2to2_bb1_c1_exe5_consumed_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		rstag_2to2_bb1_c1_exe5_consumed_0_NO_SHIFT_REG <= (rstag_2to2_bb1_c1_exe5_combined_valid & (rstag_2to2_bb1_c1_exe5_consumed_0_NO_SHIFT_REG | ~(rstag_2to2_bb1_c1_exe5_stall_in_0)) & rstag_2to2_bb1_c1_exe5_stall_local);
		rstag_2to2_bb1_c1_exe5_consumed_1_NO_SHIFT_REG <= (rstag_2to2_bb1_c1_exe5_combined_valid & (rstag_2to2_bb1_c1_exe5_consumed_1_NO_SHIFT_REG | ~(rstag_2to2_bb1_c1_exe5_stall_in_1)) & rstag_2to2_bb1_c1_exe5_stall_local);
	end
end


// This section implements a staging register.
// 
wire rstag_2to2_bb1_c1_exe4_valid_out;
wire rstag_2to2_bb1_c1_exe4_stall_in;
wire rstag_2to2_bb1_c1_exe4_inputs_ready;
wire rstag_2to2_bb1_c1_exe4_stall_local;
 reg rstag_2to2_bb1_c1_exe4_staging_valid_NO_SHIFT_REG;
wire rstag_2to2_bb1_c1_exe4_combined_valid;
 reg [63:0] rstag_2to2_bb1_c1_exe4_staging_reg_NO_SHIFT_REG;
wire [63:0] rstag_2to2_bb1_c1_exe4;

assign rstag_2to2_bb1_c1_exe4_inputs_ready = local_bb1_c1_exe4_valid_out;
assign rstag_2to2_bb1_c1_exe4 = (rstag_2to2_bb1_c1_exe4_staging_valid_NO_SHIFT_REG ? rstag_2to2_bb1_c1_exe4_staging_reg_NO_SHIFT_REG : (local_bb1_c1_exe4 & 64'hFFFFFFFFFFFFFFFC));
assign rstag_2to2_bb1_c1_exe4_combined_valid = (rstag_2to2_bb1_c1_exe4_staging_valid_NO_SHIFT_REG | rstag_2to2_bb1_c1_exe4_inputs_ready);
assign rstag_2to2_bb1_c1_exe4_valid_out = rstag_2to2_bb1_c1_exe4_combined_valid;
assign rstag_2to2_bb1_c1_exe4_stall_local = rstag_2to2_bb1_c1_exe4_stall_in;
assign local_bb1_c1_exe4_stall_in = (|rstag_2to2_bb1_c1_exe4_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_2to2_bb1_c1_exe4_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_2to2_bb1_c1_exe4_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_2to2_bb1_c1_exe4_stall_local)
		begin
			if (~(rstag_2to2_bb1_c1_exe4_staging_valid_NO_SHIFT_REG))
			begin
				rstag_2to2_bb1_c1_exe4_staging_valid_NO_SHIFT_REG <= rstag_2to2_bb1_c1_exe4_inputs_ready;
			end
		end
		else
		begin
			rstag_2to2_bb1_c1_exe4_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_2to2_bb1_c1_exe4_staging_valid_NO_SHIFT_REG))
		begin
			rstag_2to2_bb1_c1_exe4_staging_reg_NO_SHIFT_REG <= (local_bb1_c1_exe4 & 64'hFFFFFFFFFFFFFFFC);
		end
	end
end


// Register node:
//  * latency = 3
//  * capacity = 3
 logic rnode_2to5_bb1_c1_exe3_0_valid_out_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe3_0_stall_in_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe3_0_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe3_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe3_0_reg_5_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe3_0_valid_out_reg_5_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe3_0_stall_in_reg_5_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe3_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_2to5_bb1_c1_exe3_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_2to5_bb1_c1_exe3_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_2to5_bb1_c1_exe3_0_stall_in_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_2to5_bb1_c1_exe3_0_valid_out_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_2to5_bb1_c1_exe3_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_bb1_c1_exe3),
	.data_out(rnode_2to5_bb1_c1_exe3_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_2to5_bb1_c1_exe3_0_reg_5_fifo.DEPTH = 4;
defparam rnode_2to5_bb1_c1_exe3_0_reg_5_fifo.DATA_WIDTH = 1;
defparam rnode_2to5_bb1_c1_exe3_0_reg_5_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_2to5_bb1_c1_exe3_0_reg_5_fifo.IMPL = "ll_reg";

assign rnode_2to5_bb1_c1_exe3_0_reg_5_inputs_ready_NO_SHIFT_REG = local_bb1_c1_exe3_valid_out;
assign local_bb1_c1_exe3_stall_in = rnode_2to5_bb1_c1_exe3_0_stall_out_reg_5_NO_SHIFT_REG;
assign rnode_2to5_bb1_c1_exe3_0_NO_SHIFT_REG = rnode_2to5_bb1_c1_exe3_0_reg_5_NO_SHIFT_REG;
assign rnode_2to5_bb1_c1_exe3_0_stall_in_reg_5_NO_SHIFT_REG = rnode_2to5_bb1_c1_exe3_0_stall_in_NO_SHIFT_REG;
assign rnode_2to5_bb1_c1_exe3_0_valid_out_NO_SHIFT_REG = rnode_2to5_bb1_c1_exe3_0_valid_out_reg_5_NO_SHIFT_REG;

// Register node:
//  * latency = 3
//  * capacity = 3
 logic rnode_2to5_bb1_c1_exe2_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe2_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe2_0_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe2_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe2_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe2_1_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe2_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe2_0_reg_5_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe2_0_valid_out_0_reg_5_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe2_0_stall_in_0_reg_5_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe2_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_2to5_bb1_c1_exe2_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_2to5_bb1_c1_exe2_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_2to5_bb1_c1_exe2_0_stall_in_0_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_2to5_bb1_c1_exe2_0_valid_out_0_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_2to5_bb1_c1_exe2_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_bb1_c1_exe2),
	.data_out(rnode_2to5_bb1_c1_exe2_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_2to5_bb1_c1_exe2_0_reg_5_fifo.DEPTH = 4;
defparam rnode_2to5_bb1_c1_exe2_0_reg_5_fifo.DATA_WIDTH = 1;
defparam rnode_2to5_bb1_c1_exe2_0_reg_5_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_2to5_bb1_c1_exe2_0_reg_5_fifo.IMPL = "ll_reg";

assign rnode_2to5_bb1_c1_exe2_0_reg_5_inputs_ready_NO_SHIFT_REG = local_bb1_c1_exe2_valid_out;
assign local_bb1_c1_exe2_stall_in = rnode_2to5_bb1_c1_exe2_0_stall_out_reg_5_NO_SHIFT_REG;
assign rnode_2to5_bb1_c1_exe2_0_stall_in_0_reg_5_NO_SHIFT_REG = (rnode_2to5_bb1_c1_exe2_0_stall_in_0_NO_SHIFT_REG | rnode_2to5_bb1_c1_exe2_0_stall_in_1_NO_SHIFT_REG);
assign rnode_2to5_bb1_c1_exe2_0_valid_out_0_NO_SHIFT_REG = rnode_2to5_bb1_c1_exe2_0_valid_out_0_reg_5_NO_SHIFT_REG;
assign rnode_2to5_bb1_c1_exe2_0_valid_out_1_NO_SHIFT_REG = rnode_2to5_bb1_c1_exe2_0_valid_out_0_reg_5_NO_SHIFT_REG;
assign rnode_2to5_bb1_c1_exe2_0_NO_SHIFT_REG = rnode_2to5_bb1_c1_exe2_0_reg_5_NO_SHIFT_REG;
assign rnode_2to5_bb1_c1_exe2_1_NO_SHIFT_REG = rnode_2to5_bb1_c1_exe2_0_reg_5_NO_SHIFT_REG;

// Register node:
//  * latency = 3
//  * capacity = 3
 logic rnode_2to5_bb1_c1_exe1_0_valid_out_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe1_0_stall_in_NO_SHIFT_REG;
 logic [11:0] rnode_2to5_bb1_c1_exe1_0_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe1_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic [11:0] rnode_2to5_bb1_c1_exe1_0_reg_5_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe1_0_valid_out_reg_5_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe1_0_stall_in_reg_5_NO_SHIFT_REG;
 logic rnode_2to5_bb1_c1_exe1_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_2to5_bb1_c1_exe1_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_2to5_bb1_c1_exe1_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_2to5_bb1_c1_exe1_0_stall_in_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_2to5_bb1_c1_exe1_0_valid_out_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_2to5_bb1_c1_exe1_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_bb1_c1_exe1),
	.data_out(rnode_2to5_bb1_c1_exe1_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_2to5_bb1_c1_exe1_0_reg_5_fifo.DEPTH = 4;
defparam rnode_2to5_bb1_c1_exe1_0_reg_5_fifo.DATA_WIDTH = 12;
defparam rnode_2to5_bb1_c1_exe1_0_reg_5_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_2to5_bb1_c1_exe1_0_reg_5_fifo.IMPL = "ll_reg";

assign rnode_2to5_bb1_c1_exe1_0_reg_5_inputs_ready_NO_SHIFT_REG = local_bb1_c1_exe1_valid_out;
assign local_bb1_c1_exe1_stall_in = rnode_2to5_bb1_c1_exe1_0_stall_out_reg_5_NO_SHIFT_REG;
assign rnode_2to5_bb1_c1_exe1_0_NO_SHIFT_REG = rnode_2to5_bb1_c1_exe1_0_reg_5_NO_SHIFT_REG;
assign rnode_2to5_bb1_c1_exe1_0_stall_in_reg_5_NO_SHIFT_REG = rnode_2to5_bb1_c1_exe1_0_stall_in_NO_SHIFT_REG;
assign rnode_2to5_bb1_c1_exe1_0_valid_out_NO_SHIFT_REG = rnode_2to5_bb1_c1_exe1_0_valid_out_reg_5_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_20to21_bb1_c1_exe7_0_valid_out_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c1_exe7_0_stall_in_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c1_exe7_0_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c1_exe7_0_reg_21_inputs_ready_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c1_exe7_0_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c1_exe7_0_valid_out_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c1_exe7_0_stall_in_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c1_exe7_0_stall_out_reg_21_NO_SHIFT_REG;

acl_data_fifo rnode_20to21_bb1_c1_exe7_0_reg_21_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_20to21_bb1_c1_exe7_0_reg_21_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_20to21_bb1_c1_exe7_0_stall_in_reg_21_NO_SHIFT_REG),
	.valid_out(rnode_20to21_bb1_c1_exe7_0_valid_out_reg_21_NO_SHIFT_REG),
	.stall_out(rnode_20to21_bb1_c1_exe7_0_stall_out_reg_21_NO_SHIFT_REG),
	.data_in(rnode_2to20_bb1_c1_exe7_0_NO_SHIFT_REG),
	.data_out(rnode_20to21_bb1_c1_exe7_0_reg_21_NO_SHIFT_REG)
);

defparam rnode_20to21_bb1_c1_exe7_0_reg_21_fifo.DEPTH = 1;
defparam rnode_20to21_bb1_c1_exe7_0_reg_21_fifo.DATA_WIDTH = 1;
defparam rnode_20to21_bb1_c1_exe7_0_reg_21_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_20to21_bb1_c1_exe7_0_reg_21_fifo.IMPL = "ll_reg";

assign rnode_20to21_bb1_c1_exe7_0_reg_21_inputs_ready_NO_SHIFT_REG = rnode_2to20_bb1_c1_exe7_0_valid_out_NO_SHIFT_REG;
assign rnode_2to20_bb1_c1_exe7_0_stall_in_NO_SHIFT_REG = rnode_20to21_bb1_c1_exe7_0_stall_out_reg_21_NO_SHIFT_REG;
assign rnode_20to21_bb1_c1_exe7_0_NO_SHIFT_REG = rnode_20to21_bb1_c1_exe7_0_reg_21_NO_SHIFT_REG;
assign rnode_20to21_bb1_c1_exe7_0_stall_in_reg_21_NO_SHIFT_REG = rnode_20to21_bb1_c1_exe7_0_stall_in_NO_SHIFT_REG;
assign rnode_20to21_bb1_c1_exe7_0_valid_out_NO_SHIFT_REG = rnode_20to21_bb1_c1_exe7_0_valid_out_reg_21_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_16to17_bb1_c1_exe6_0_valid_out_NO_SHIFT_REG;
 logic rnode_16to17_bb1_c1_exe6_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_16to17_bb1_c1_exe6_0_NO_SHIFT_REG;
 logic rnode_16to17_bb1_c1_exe6_0_reg_17_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_16to17_bb1_c1_exe6_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb1_c1_exe6_0_valid_out_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb1_c1_exe6_0_stall_in_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb1_c1_exe6_0_stall_out_reg_17_NO_SHIFT_REG;

acl_data_fifo rnode_16to17_bb1_c1_exe6_0_reg_17_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_16to17_bb1_c1_exe6_0_reg_17_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_16to17_bb1_c1_exe6_0_stall_in_reg_17_NO_SHIFT_REG),
	.valid_out(rnode_16to17_bb1_c1_exe6_0_valid_out_reg_17_NO_SHIFT_REG),
	.stall_out(rnode_16to17_bb1_c1_exe6_0_stall_out_reg_17_NO_SHIFT_REG),
	.data_in((rnode_2to16_bb1_c1_exe6_0_NO_SHIFT_REG & 64'hFFFFFFFFFFFFFFFC)),
	.data_out(rnode_16to17_bb1_c1_exe6_0_reg_17_NO_SHIFT_REG)
);

defparam rnode_16to17_bb1_c1_exe6_0_reg_17_fifo.DEPTH = 2;
defparam rnode_16to17_bb1_c1_exe6_0_reg_17_fifo.DATA_WIDTH = 64;
defparam rnode_16to17_bb1_c1_exe6_0_reg_17_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_16to17_bb1_c1_exe6_0_reg_17_fifo.IMPL = "ll_reg";

assign rnode_16to17_bb1_c1_exe6_0_reg_17_inputs_ready_NO_SHIFT_REG = rnode_2to16_bb1_c1_exe6_0_valid_out_NO_SHIFT_REG;
assign rnode_2to16_bb1_c1_exe6_0_stall_in_NO_SHIFT_REG = rnode_16to17_bb1_c1_exe6_0_stall_out_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb1_c1_exe6_0_NO_SHIFT_REG = rnode_16to17_bb1_c1_exe6_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb1_c1_exe6_0_stall_in_reg_17_NO_SHIFT_REG = rnode_16to17_bb1_c1_exe6_0_stall_in_NO_SHIFT_REG;
assign rnode_16to17_bb1_c1_exe6_0_valid_out_NO_SHIFT_REG = rnode_16to17_bb1_c1_exe6_0_valid_out_reg_17_NO_SHIFT_REG;

// Register node:
//  * latency = 14
//  * capacity = 14
 logic rnode_2to16_bb1_c1_exe5_0_valid_out_NO_SHIFT_REG;
 logic rnode_2to16_bb1_c1_exe5_0_stall_in_NO_SHIFT_REG;
 logic rnode_2to16_bb1_c1_exe5_0_NO_SHIFT_REG;
 logic rnode_2to16_bb1_c1_exe5_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic rnode_2to16_bb1_c1_exe5_0_reg_16_NO_SHIFT_REG;
 logic rnode_2to16_bb1_c1_exe5_0_valid_out_reg_16_NO_SHIFT_REG;
 logic rnode_2to16_bb1_c1_exe5_0_stall_in_reg_16_NO_SHIFT_REG;
 logic rnode_2to16_bb1_c1_exe5_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_2to16_bb1_c1_exe5_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_2to16_bb1_c1_exe5_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_2to16_bb1_c1_exe5_0_stall_in_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_2to16_bb1_c1_exe5_0_valid_out_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_2to16_bb1_c1_exe5_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(rstag_2to2_bb1_c1_exe5),
	.data_out(rnode_2to16_bb1_c1_exe5_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_2to16_bb1_c1_exe5_0_reg_16_fifo.DEPTH = 15;
defparam rnode_2to16_bb1_c1_exe5_0_reg_16_fifo.DATA_WIDTH = 1;
defparam rnode_2to16_bb1_c1_exe5_0_reg_16_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_2to16_bb1_c1_exe5_0_reg_16_fifo.IMPL = "ram";

assign rnode_2to16_bb1_c1_exe5_0_reg_16_inputs_ready_NO_SHIFT_REG = rstag_2to2_bb1_c1_exe5_valid_out_0;
assign rstag_2to2_bb1_c1_exe5_stall_in_0 = rnode_2to16_bb1_c1_exe5_0_stall_out_reg_16_NO_SHIFT_REG;
assign rnode_2to16_bb1_c1_exe5_0_NO_SHIFT_REG = rnode_2to16_bb1_c1_exe5_0_reg_16_NO_SHIFT_REG;
assign rnode_2to16_bb1_c1_exe5_0_stall_in_reg_16_NO_SHIFT_REG = rnode_2to16_bb1_c1_exe5_0_stall_in_NO_SHIFT_REG;
assign rnode_2to16_bb1_c1_exe5_0_valid_out_NO_SHIFT_REG = rnode_2to16_bb1_c1_exe5_0_valid_out_reg_16_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire local_bb1_ld__inputs_ready;
 reg local_bb1_ld__valid_out_NO_SHIFT_REG;
wire local_bb1_ld__stall_in;
wire local_bb1_ld__output_regs_ready;
wire local_bb1_ld__fu_stall_out;
wire local_bb1_ld__fu_valid_out;
wire [31:0] local_bb1_ld__lsu_dataout;
 reg [31:0] local_bb1_ld__NO_SHIFT_REG;
wire local_bb1_ld__causedstall;

lsu_top lsu_local_bb1_ld_ (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb1_ld__fu_stall_out),
	.i_valid(local_bb1_ld__inputs_ready),
	.i_address((rstag_2to2_bb1_c1_exe4 & 64'hFFFFFFFFFFFFFFFC)),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(rstag_2to2_bb1_c1_exe5),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_ld__output_regs_ready)),
	.o_valid(local_bb1_ld__fu_valid_out),
	.o_readdata(local_bb1_ld__lsu_dataout),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_ld__active),
	.avm_address(avm_local_bb1_ld__address),
	.avm_read(avm_local_bb1_ld__read),
	.avm_enable(avm_local_bb1_ld__enable),
	.avm_readdata(avm_local_bb1_ld__readdata),
	.avm_write(avm_local_bb1_ld__write),
	.avm_writeack(avm_local_bb1_ld__writeack),
	.avm_burstcount(avm_local_bb1_ld__burstcount),
	.avm_writedata(avm_local_bb1_ld__writedata),
	.avm_byteenable(avm_local_bb1_ld__byteenable),
	.avm_waitrequest(avm_local_bb1_ld__waitrequest),
	.avm_readdatavalid(avm_local_bb1_ld__readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb1_ld_.AWIDTH = 30;
defparam lsu_local_bb1_ld_.WIDTH_BYTES = 4;
defparam lsu_local_bb1_ld_.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld_.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld_.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb1_ld_.READ = 1;
defparam lsu_local_bb1_ld_.ATOMIC = 0;
defparam lsu_local_bb1_ld_.WIDTH = 32;
defparam lsu_local_bb1_ld_.MWIDTH = 256;
defparam lsu_local_bb1_ld_.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_ld_.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_ld_.KERNEL_SIDE_MEM_LATENCY = 3;
defparam lsu_local_bb1_ld_.MEMORY_SIDE_MEM_LATENCY = 73;
defparam lsu_local_bb1_ld_.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_ld_.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_ld_.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_ld_.NUMBER_BANKS = 1;
defparam lsu_local_bb1_ld_.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_ld_.INTENDED_DEVICE_FAMILY = "Cyclone V";
defparam lsu_local_bb1_ld_.USEINPUTFIFO = 0;
defparam lsu_local_bb1_ld_.USECACHING = 0;
defparam lsu_local_bb1_ld_.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_ld_.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_ld_.ADDRSPACE = 1;
defparam lsu_local_bb1_ld_.STYLE = "PREFETCHING";

assign local_bb1_ld__inputs_ready = (rstag_2to2_bb1_c1_exe5_valid_out_1 & rstag_2to2_bb1_c1_exe4_valid_out);
assign local_bb1_ld__output_regs_ready = (&(~(local_bb1_ld__valid_out_NO_SHIFT_REG) | ~(local_bb1_ld__stall_in)));
assign rstag_2to2_bb1_c1_exe5_stall_in_1 = (local_bb1_ld__fu_stall_out | ~(local_bb1_ld__inputs_ready));
assign rstag_2to2_bb1_c1_exe4_stall_in = (local_bb1_ld__fu_stall_out | ~(local_bb1_ld__inputs_ready));
assign local_bb1_ld__causedstall = (local_bb1_ld__inputs_ready && (local_bb1_ld__fu_stall_out && !(~(local_bb1_ld__output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_ld__NO_SHIFT_REG <= 'x;
		local_bb1_ld__valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_ld__output_regs_ready)
		begin
			local_bb1_ld__NO_SHIFT_REG <= local_bb1_ld__lsu_dataout;
			local_bb1_ld__valid_out_NO_SHIFT_REG <= local_bb1_ld__fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_ld__stall_in))
			begin
				local_bb1_ld__valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_eni2_stall_local;
wire [95:0] local_bb1_c0_eni2;

assign local_bb1_c0_eni2[15:0] = local_bb1_c0_eni1[15:0];
assign local_bb1_c0_eni2[27:16] = rnode_2to5_bb1_c1_exe1_0_NO_SHIFT_REG;
assign local_bb1_c0_eni2[95:28] = local_bb1_c0_eni1[95:28];

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_16to17_bb1_c1_exe5_0_valid_out_NO_SHIFT_REG;
 logic rnode_16to17_bb1_c1_exe5_0_stall_in_NO_SHIFT_REG;
 logic rnode_16to17_bb1_c1_exe5_0_NO_SHIFT_REG;
 logic rnode_16to17_bb1_c1_exe5_0_reg_17_inputs_ready_NO_SHIFT_REG;
 logic rnode_16to17_bb1_c1_exe5_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb1_c1_exe5_0_valid_out_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb1_c1_exe5_0_stall_in_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb1_c1_exe5_0_stall_out_reg_17_NO_SHIFT_REG;

acl_data_fifo rnode_16to17_bb1_c1_exe5_0_reg_17_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_16to17_bb1_c1_exe5_0_reg_17_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_16to17_bb1_c1_exe5_0_stall_in_reg_17_NO_SHIFT_REG),
	.valid_out(rnode_16to17_bb1_c1_exe5_0_valid_out_reg_17_NO_SHIFT_REG),
	.stall_out(rnode_16to17_bb1_c1_exe5_0_stall_out_reg_17_NO_SHIFT_REG),
	.data_in(rnode_2to16_bb1_c1_exe5_0_NO_SHIFT_REG),
	.data_out(rnode_16to17_bb1_c1_exe5_0_reg_17_NO_SHIFT_REG)
);

defparam rnode_16to17_bb1_c1_exe5_0_reg_17_fifo.DEPTH = 2;
defparam rnode_16to17_bb1_c1_exe5_0_reg_17_fifo.DATA_WIDTH = 1;
defparam rnode_16to17_bb1_c1_exe5_0_reg_17_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_16to17_bb1_c1_exe5_0_reg_17_fifo.IMPL = "ll_reg";

assign rnode_16to17_bb1_c1_exe5_0_reg_17_inputs_ready_NO_SHIFT_REG = rnode_2to16_bb1_c1_exe5_0_valid_out_NO_SHIFT_REG;
assign rnode_2to16_bb1_c1_exe5_0_stall_in_NO_SHIFT_REG = rnode_16to17_bb1_c1_exe5_0_stall_out_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb1_c1_exe5_0_NO_SHIFT_REG = rnode_16to17_bb1_c1_exe5_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb1_c1_exe5_0_stall_in_reg_17_NO_SHIFT_REG = rnode_16to17_bb1_c1_exe5_0_stall_in_NO_SHIFT_REG;
assign rnode_16to17_bb1_c1_exe5_0_valid_out_NO_SHIFT_REG = rnode_16to17_bb1_c1_exe5_0_valid_out_reg_17_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_5to5_bb1_ld__valid_out;
wire rstag_5to5_bb1_ld__stall_in;
wire rstag_5to5_bb1_ld__inputs_ready;
wire rstag_5to5_bb1_ld__stall_local;
 reg rstag_5to5_bb1_ld__staging_valid_NO_SHIFT_REG;
wire rstag_5to5_bb1_ld__combined_valid;
 reg [31:0] rstag_5to5_bb1_ld__staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_5to5_bb1_ld_;

assign rstag_5to5_bb1_ld__inputs_ready = local_bb1_ld__valid_out_NO_SHIFT_REG;
assign rstag_5to5_bb1_ld_ = (rstag_5to5_bb1_ld__staging_valid_NO_SHIFT_REG ? rstag_5to5_bb1_ld__staging_reg_NO_SHIFT_REG : local_bb1_ld__NO_SHIFT_REG);
assign rstag_5to5_bb1_ld__combined_valid = (rstag_5to5_bb1_ld__staging_valid_NO_SHIFT_REG | rstag_5to5_bb1_ld__inputs_ready);
assign rstag_5to5_bb1_ld__valid_out = rstag_5to5_bb1_ld__combined_valid;
assign rstag_5to5_bb1_ld__stall_local = rstag_5to5_bb1_ld__stall_in;
assign local_bb1_ld__stall_in = (|rstag_5to5_bb1_ld__staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_5to5_bb1_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_5to5_bb1_ld__staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_5to5_bb1_ld__stall_local)
		begin
			if (~(rstag_5to5_bb1_ld__staging_valid_NO_SHIFT_REG))
			begin
				rstag_5to5_bb1_ld__staging_valid_NO_SHIFT_REG <= rstag_5to5_bb1_ld__inputs_ready;
			end
		end
		else
		begin
			rstag_5to5_bb1_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_5to5_bb1_ld__staging_valid_NO_SHIFT_REG))
		begin
			rstag_5to5_bb1_ld__staging_reg_NO_SHIFT_REG <= local_bb1_ld__NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_eni3_stall_local;
wire [95:0] local_bb1_c0_eni3;

assign local_bb1_c0_eni3[31:0] = local_bb1_c0_eni2[31:0];
assign local_bb1_c0_eni3[32] = rnode_2to5_bb1_c1_exe2_0_NO_SHIFT_REG;
assign local_bb1_c0_eni3[95:33] = local_bb1_c0_eni2[95:33];

// This section implements an unregistered operation.
// 
wire local_bb1_c0_eni4_stall_local;
wire [95:0] local_bb1_c0_eni4;

assign local_bb1_c0_eni4[39:0] = local_bb1_c0_eni3[39:0];
assign local_bb1_c0_eni4[40] = rnode_2to5_bb1_c1_exe3_0_NO_SHIFT_REG;
assign local_bb1_c0_eni4[95:41] = local_bb1_c0_eni3[95:41];

// This section implements an unregistered operation.
// 
wire local_bb1_c0_eni5_valid_out;
wire local_bb1_c0_eni5_stall_in;
wire local_bb1_c0_eni5_inputs_ready;
wire local_bb1_c0_eni5_stall_local;
wire [95:0] local_bb1_c0_eni5;

assign local_bb1_c0_eni5_inputs_ready = (rnode_1to5_forked_0_valid_out_0_NO_SHIFT_REG & rnode_2to5_bb1_c1_exe1_0_valid_out_NO_SHIFT_REG & rnode_2to5_bb1_c1_exe2_0_valid_out_0_NO_SHIFT_REG & rnode_2to5_bb1_c1_exe3_0_valid_out_NO_SHIFT_REG & rstag_5to5_bb1_ld__valid_out);
assign local_bb1_c0_eni5[63:0] = local_bb1_c0_eni4[63:0];
assign local_bb1_c0_eni5[95:64] = rstag_5to5_bb1_ld_;
assign local_bb1_c0_eni5_valid_out = local_bb1_c0_eni5_inputs_ready;
assign local_bb1_c0_eni5_stall_local = local_bb1_c0_eni5_stall_in;
assign rnode_1to5_forked_0_stall_in_0_NO_SHIFT_REG = (local_bb1_c0_eni5_stall_local | ~(local_bb1_c0_eni5_inputs_ready));
assign rnode_2to5_bb1_c1_exe1_0_stall_in_NO_SHIFT_REG = (local_bb1_c0_eni5_stall_local | ~(local_bb1_c0_eni5_inputs_ready));
assign rnode_2to5_bb1_c1_exe2_0_stall_in_0_NO_SHIFT_REG = (local_bb1_c0_eni5_stall_local | ~(local_bb1_c0_eni5_inputs_ready));
assign rnode_2to5_bb1_c1_exe3_0_stall_in_NO_SHIFT_REG = (local_bb1_c0_eni5_stall_local | ~(local_bb1_c0_eni5_inputs_ready));
assign rstag_5to5_bb1_ld__stall_in = (local_bb1_c0_eni5_stall_local | ~(local_bb1_c0_eni5_inputs_ready));

// This section implements a registered operation.
// 
wire local_bb1_c0_enter_c0_eni5_inputs_ready;
 reg local_bb1_c0_enter_c0_eni5_valid_out_0_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni5_stall_in_0;
 reg local_bb1_c0_enter_c0_eni5_valid_out_1_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni5_stall_in_1;
 reg local_bb1_c0_enter_c0_eni5_valid_out_2_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni5_stall_in_2;
 reg local_bb1_c0_enter_c0_eni5_valid_out_3_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni5_stall_in_3;
 reg local_bb1_c0_enter_c0_eni5_valid_out_4_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni5_stall_in_4;
 reg local_bb1_c0_enter_c0_eni5_valid_out_5_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni5_stall_in_5;
wire local_bb1_c0_enter_c0_eni5_output_regs_ready;
 reg [95:0] local_bb1_c0_enter_c0_eni5_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni5_input_accepted;
 reg local_bb1_c0_enter_c0_eni5_valid_bit_NO_SHIFT_REG;
wire local_bb1_c0_exit_c0_exi1_entry_stall;
wire local_bb1_c0_exit_c0_exi1_output_regs_ready;
wire local_bb1_c0_exit_c0_exi1_valid_in;
wire local_bb1_c0_exit_c0_exi1_phases;
wire local_bb1_c0_enter_c0_eni5_inc_pipelined_thread;
wire local_bb1_c0_enter_c0_eni5_dec_pipelined_thread;
wire local_bb1_c0_enter_c0_eni5_causedstall;

assign local_bb1_c0_enter_c0_eni5_inputs_ready = (local_bb1_c0_eni5_valid_out & rnode_1to5_forked_0_valid_out_1_NO_SHIFT_REG & rnode_2to5_bb1_c1_exe2_0_valid_out_1_NO_SHIFT_REG);
assign local_bb1_c0_enter_c0_eni5_output_regs_ready = 1'b1;
assign local_bb1_c0_enter_c0_eni5_input_accepted = (local_bb1_c0_enter_c0_eni5_inputs_ready && !(local_bb1_c0_exit_c0_exi1_entry_stall));
assign local_bb1_c0_enter_c0_eni5_inc_pipelined_thread = rnode_1to5_forked_1_NO_SHIFT_REG;
assign local_bb1_c0_enter_c0_eni5_dec_pipelined_thread = ~(rnode_2to5_bb1_c1_exe2_1_NO_SHIFT_REG);
assign local_bb1_c0_eni5_stall_in = ((~(local_bb1_c0_enter_c0_eni5_inputs_ready) | local_bb1_c0_exit_c0_exi1_entry_stall) | ~(1'b1));
assign rnode_1to5_forked_0_stall_in_1_NO_SHIFT_REG = ((~(local_bb1_c0_enter_c0_eni5_inputs_ready) | local_bb1_c0_exit_c0_exi1_entry_stall) | ~(1'b1));
assign rnode_2to5_bb1_c1_exe2_0_stall_in_1_NO_SHIFT_REG = ((~(local_bb1_c0_enter_c0_eni5_inputs_ready) | local_bb1_c0_exit_c0_exi1_entry_stall) | ~(1'b1));
assign local_bb1_c0_enter_c0_eni5_causedstall = (1'b1 && ((~(local_bb1_c0_enter_c0_eni5_inputs_ready) | local_bb1_c0_exit_c0_exi1_entry_stall) && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c0_enter_c0_eni5_valid_bit_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_c0_enter_c0_eni5_valid_bit_NO_SHIFT_REG <= local_bb1_c0_enter_c0_eni5_input_accepted;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c0_enter_c0_eni5_NO_SHIFT_REG <= 'x;
		local_bb1_c0_enter_c0_eni5_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_enter_c0_eni5_valid_out_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_enter_c0_eni5_valid_out_2_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_enter_c0_eni5_valid_out_3_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_enter_c0_eni5_valid_out_4_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_enter_c0_eni5_valid_out_5_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c0_enter_c0_eni5_output_regs_ready)
		begin
			local_bb1_c0_enter_c0_eni5_NO_SHIFT_REG <= local_bb1_c0_eni5;
			local_bb1_c0_enter_c0_eni5_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb1_c0_enter_c0_eni5_valid_out_1_NO_SHIFT_REG <= 1'b1;
			local_bb1_c0_enter_c0_eni5_valid_out_2_NO_SHIFT_REG <= 1'b1;
			local_bb1_c0_enter_c0_eni5_valid_out_3_NO_SHIFT_REG <= 1'b1;
			local_bb1_c0_enter_c0_eni5_valid_out_4_NO_SHIFT_REG <= 1'b1;
			local_bb1_c0_enter_c0_eni5_valid_out_5_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb1_c0_enter_c0_eni5_stall_in_0))
			begin
				local_bb1_c0_enter_c0_eni5_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c0_enter_c0_eni5_stall_in_1))
			begin
				local_bb1_c0_enter_c0_eni5_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c0_enter_c0_eni5_stall_in_2))
			begin
				local_bb1_c0_enter_c0_eni5_valid_out_2_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c0_enter_c0_eni5_stall_in_3))
			begin
				local_bb1_c0_enter_c0_eni5_valid_out_3_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c0_enter_c0_eni5_stall_in_4))
			begin
				local_bb1_c0_enter_c0_eni5_valid_out_4_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c0_enter_c0_eni5_stall_in_5))
			begin
				local_bb1_c0_enter_c0_eni5_valid_out_5_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene1_stall_local;
wire local_bb1_c0_ene1;

assign local_bb1_c0_ene1 = local_bb1_c0_enter_c0_eni5_NO_SHIFT_REG[8];

// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene2_stall_local;
wire [11:0] local_bb1_c0_ene2;

assign local_bb1_c0_ene2[11:0] = local_bb1_c0_enter_c0_eni5_NO_SHIFT_REG[27:16];

// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene3_valid_out_0;
wire local_bb1_c0_ene3_stall_in_0;
wire local_bb1_c0_ene3_valid_out_1;
wire local_bb1_c0_ene3_stall_in_1;
wire local_bb1_c0_ene3_inputs_ready;
wire local_bb1_c0_ene3_stall_local;
wire local_bb1_c0_ene3;

assign local_bb1_c0_ene3_inputs_ready = local_bb1_c0_enter_c0_eni5_valid_out_2_NO_SHIFT_REG;
assign local_bb1_c0_ene3 = local_bb1_c0_enter_c0_eni5_NO_SHIFT_REG[32];
assign local_bb1_c0_ene3_valid_out_0 = 1'b1;
assign local_bb1_c0_ene3_valid_out_1 = 1'b1;
assign local_bb1_c0_enter_c0_eni5_stall_in_2 = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene4_stall_local;
wire local_bb1_c0_ene4;

assign local_bb1_c0_ene4 = local_bb1_c0_enter_c0_eni5_NO_SHIFT_REG[40];

// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene5_stall_local;
wire [31:0] local_bb1_c0_ene5;

assign local_bb1_c0_ene5[31:0] = local_bb1_c0_enter_c0_eni5_NO_SHIFT_REG[95:64];

// This section implements an unregistered operation.
// 
wire SFC_2_VALID_6_6_0_stall_local;
wire SFC_2_VALID_6_6_0;

assign SFC_2_VALID_6_6_0 = local_bb1_c0_enter_c0_eni5_valid_bit_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_insert0_stall_local;
wire [63:0] local_bb1_vectorpop3_insert0;

assign local_bb1_vectorpop3_insert0[31:0] = 'x;
assign local_bb1_vectorpop3_insert0[63:32] = 32'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop6_insert0_stall_local;
wire [127:0] local_bb1_vectorpop6_insert0;

assign local_bb1_vectorpop6_insert0[31:0] = 'x;
assign local_bb1_vectorpop6_insert0[127:32] = 96'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_not_select1680_stall_local;
wire local_bb1_not_select1680;

assign local_bb1_not_select1680 = ($signed(local_bb1_c0_ene2) > $signed(12'hFFF));

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_c0_ene3_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene3_0_stall_in_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene3_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene3_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene3_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene3_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene3_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene3_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_c0_ene3_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_c0_ene3_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_c0_ene3_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_c0_ene3_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_c0_ene3_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in(local_bb1_c0_ene3),
	.data_out(rnode_6to7_bb1_c0_ene3_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_c0_ene3_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_c0_ene3_0_reg_7_fifo.DATA_WIDTH = 1;
defparam rnode_6to7_bb1_c0_ene3_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_c0_ene3_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_c0_ene3_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_c0_ene3_stall_in_1 = 1'b0;
assign rnode_6to7_bb1_c0_ene3_0_NO_SHIFT_REG = rnode_6to7_bb1_c0_ene3_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_c0_ene3_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_c0_ene3_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1___stall_local;
wire [31:0] local_bb1__;

assign local_bb1__ = (local_bb1_c0_ene4 ? local_bb1_c0_ene5 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_insert1_stall_local;
wire [63:0] local_bb1_vectorpop3_insert1;

assign local_bb1_vectorpop3_insert1[31:0] = local_bb1_vectorpop3_insert0[31:0];
assign local_bb1_vectorpop3_insert1[63:32] = 'x;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop6_insert1_stall_local;
wire [127:0] local_bb1_vectorpop6_insert1;

assign local_bb1_vectorpop6_insert1[31:0] = local_bb1_vectorpop6_insert0[31:0];
assign local_bb1_vectorpop6_insert1[63:32] = 'x;
assign local_bb1_vectorpop6_insert1[127:64] = local_bb1_vectorpop6_insert0[127:64];

// This section implements an unregistered operation.
// 
wire local_bb1_shr_stall_local;
wire [31:0] local_bb1_shr;

assign local_bb1_shr = (local_bb1__ >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u2_stall_local;
wire [31:0] local_bb1_var__u2;

assign local_bb1_var__u2 = (local_bb1__ >> 32'hF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u3_stall_local;
wire [31:0] local_bb1_var__u3;

assign local_bb1_var__u3 = (local_bb1__ >> 32'hA);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u4_stall_local;
wire [31:0] local_bb1_var__u4;

assign local_bb1_var__u4 = (local_bb1__ >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_masked_stall_local;
wire [31:0] local_bb1_mul23_masked;

assign local_bb1_mul23_masked = (local_bb1__ & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_masked1245_stall_local;
wire [31:0] local_bb1_mul23_masked1245;

assign local_bb1_mul23_masked1245 = (local_bb1__ << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_masked1247_stall_local;
wire [31:0] local_bb1_mul23_masked1247;

assign local_bb1_mul23_masked1247 = (local_bb1__ << 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_vectorpop3_insert1_stall_local;
wire [63:0] local_bb1_vectorpop3_vectorpop3_insert1;
wire local_bb1_vectorpop3_vectorpop3_insert1_fu_valid_out;
wire local_bb1_vectorpop3_vectorpop3_insert1_fu_stall_out;

acl_pop local_bb1_vectorpop3_vectorpop3_insert1_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_not_select1680),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpop3_insert1),
	.stall_out(local_bb1_vectorpop3_vectorpop3_insert1_fu_stall_out),
	.valid_in(SFC_2_VALID_6_6_0),
	.valid_out(local_bb1_vectorpop3_vectorpop3_insert1_fu_valid_out),
	.stall_in(local_bb1_vectorpop3_vectorpop3_insert1_stall_local),
	.data_out(local_bb1_vectorpop3_vectorpop3_insert1),
	.feedback_in(feedback_data_in_3),
	.feedback_valid_in(feedback_valid_in_3),
	.feedback_stall_out(feedback_stall_out_3)
);

defparam local_bb1_vectorpop3_vectorpop3_insert1_feedback.COALESCE_DISTANCE = 1918;
defparam local_bb1_vectorpop3_vectorpop3_insert1_feedback.DATA_WIDTH = 64;
defparam local_bb1_vectorpop3_vectorpop3_insert1_feedback.STYLE = "COALESCE";

assign local_bb1_vectorpop3_vectorpop3_insert1_stall_local = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop6_insert2_stall_local;
wire [127:0] local_bb1_vectorpop6_insert2;

assign local_bb1_vectorpop6_insert2[63:0] = local_bb1_vectorpop6_insert1[63:0];
assign local_bb1_vectorpop6_insert2[95:64] = 'x;
assign local_bb1_vectorpop6_insert2[127:96] = local_bb1_vectorpop6_insert1[127:96];

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_masked_stall_local;
wire [31:0] local_bb1_mul21_masked;

assign local_bb1_mul21_masked = ((local_bb1_shr & 32'hFFFFFF) & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u5_stall_local;
wire [31:0] local_bb1_var__u5;

assign local_bb1_var__u5 = ((local_bb1_var__u2 & 32'h1FFFF) & 32'h1FE);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u6_stall_local;
wire [31:0] local_bb1_var__u6;

assign local_bb1_var__u6 = ((local_bb1_var__u3 & 32'h3FFFFF) & 32'h3FC0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u7_stall_local;
wire [31:0] local_bb1_var__u7;

assign local_bb1_var__u7 = ((local_bb1_var__u4 & 32'h7FFFFFFF) & 32'h7F80);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u8_stall_local;
wire [31:0] local_bb1_var__u8;

assign local_bb1_var__u8 = ((local_bb1_mul23_masked1245 & 32'hFFFFFFF8) & 32'h7F8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u9_stall_local;
wire [31:0] local_bb1_var__u9;

assign local_bb1_var__u9 = ((local_bb1_mul23_masked1247 & 32'hFFFFFFF0) & 32'hFF0);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_extract0_stall_local;
wire [31:0] local_bb1_vectorpop3_extract0;

assign local_bb1_vectorpop3_extract0[31:0] = local_bb1_vectorpop3_vectorpop3_insert1[31:0];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_extract1_stall_local;
wire [31:0] local_bb1_vectorpop3_extract1;

assign local_bb1_vectorpop3_extract1[31:0] = local_bb1_vectorpop3_vectorpop3_insert1[63:32];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop6_insert3_stall_local;
wire [127:0] local_bb1_vectorpop6_insert3;

assign local_bb1_vectorpop6_insert3[95:0] = local_bb1_vectorpop6_insert2[95:0];
assign local_bb1_vectorpop6_insert3[127:96] = 'x;

// This section implements an unregistered operation.
// 
wire local_bb1_mul20_add806_stall_local;
wire [31:0] local_bb1_mul20_add806;

assign local_bb1_mul20_add806 = ((local_bb1_var__u5 & 32'h1FE) + (local_bb1_var__u6 & 32'h3FC0));

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_add868_stall_local;
wire [31:0] local_bb1_mul21_add868;

assign local_bb1_mul21_add868 = ((local_bb1_mul21_masked & 32'hFF) + (local_bb1_var__u7 & 32'h7F80));

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_add1246_stall_local;
wire [31:0] local_bb1_mul23_add1246;

assign local_bb1_mul23_add1246 = ((local_bb1_mul23_masked & 32'hFF) + (local_bb1_var__u8 & 32'h7F8));

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop6_vectorpop6_insert3_stall_local;
wire [127:0] local_bb1_vectorpop6_vectorpop6_insert3;
wire local_bb1_vectorpop6_vectorpop6_insert3_fu_valid_out;
wire local_bb1_vectorpop6_vectorpop6_insert3_fu_stall_out;

acl_pop local_bb1_vectorpop6_vectorpop6_insert3_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_c0_ene1),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpop6_insert3),
	.stall_out(local_bb1_vectorpop6_vectorpop6_insert3_fu_stall_out),
	.valid_in(SFC_2_VALID_6_6_0),
	.valid_out(local_bb1_vectorpop6_vectorpop6_insert3_fu_valid_out),
	.stall_in(local_bb1_vectorpop6_vectorpop6_insert3_stall_local),
	.data_out(local_bb1_vectorpop6_vectorpop6_insert3),
	.feedback_in(feedback_data_in_6),
	.feedback_valid_in(feedback_valid_in_6),
	.feedback_stall_out(feedback_stall_out_6)
);

defparam local_bb1_vectorpop6_vectorpop6_insert3_feedback.COALESCE_DISTANCE = 1;
defparam local_bb1_vectorpop6_vectorpop6_insert3_feedback.DATA_WIDTH = 128;
defparam local_bb1_vectorpop6_vectorpop6_insert3_feedback.STYLE = "REGULAR";

assign local_bb1_vectorpop6_vectorpop6_insert3_stall_local = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_add1302_stall_local;
wire [31:0] local_bb1_mul23_add1302;

assign local_bb1_mul23_add1302 = ((local_bb1_mul23_add1246 & 32'hFFF) + (local_bb1_var__u9 & 32'hFF0));

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop6_extract0_stall_local;
wire [31:0] local_bb1_vectorpop6_extract0;

assign local_bb1_vectorpop6_extract0[31:0] = local_bb1_vectorpop6_vectorpop6_insert3[31:0];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop6_extract1_stall_local;
wire [31:0] local_bb1_vectorpop6_extract1;

assign local_bb1_vectorpop6_extract1[31:0] = local_bb1_vectorpop6_vectorpop6_insert3[63:32];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop6_extract2_stall_local;
wire [31:0] local_bb1_vectorpop6_extract2;

assign local_bb1_vectorpop6_extract2[31:0] = local_bb1_vectorpop6_vectorpop6_insert3[95:64];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop6_extract3_stall_local;
wire [31:0] local_bb1_vectorpop6_extract3;

assign local_bb1_vectorpop6_extract3[31:0] = local_bb1_vectorpop6_vectorpop6_insert3[127:96];

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_0_stall_local;
wire [31:0] local_bb1_reduction_0;

assign local_bb1_reduction_0 = ((local_bb1_mul23_add1302 & 32'h1FFF) + (local_bb1_mul21_add868 & 32'hFFFF));

// This section implements an unregistered operation.
// 
wire local_bb1_shr_2_stall_local;
wire [31:0] local_bb1_shr_2;

assign local_bb1_shr_2 = (local_bb1_vectorpop6_extract0 >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u10_stall_local;
wire [31:0] local_bb1_var__u10;

assign local_bb1_var__u10 = (local_bb1_vectorpop6_extract0 >> 32'hF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u11_stall_local;
wire [31:0] local_bb1_var__u11;

assign local_bb1_var__u11 = (local_bb1_vectorpop6_extract0 >> 32'hA);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u12_stall_local;
wire [31:0] local_bb1_var__u12;

assign local_bb1_var__u12 = (local_bb1_vectorpop6_extract0 >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_masked_stall_local;
wire [31:0] local_bb1_mul23_2_masked;

assign local_bb1_mul23_2_masked = (local_bb1_vectorpop6_extract0 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_masked1555_stall_local;
wire [31:0] local_bb1_mul23_2_masked1555;

assign local_bb1_mul23_2_masked1555 = (local_bb1_vectorpop6_extract0 << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_masked1557_stall_local;
wire [31:0] local_bb1_mul23_2_masked1557;

assign local_bb1_mul23_2_masked1557 = (local_bb1_vectorpop6_extract0 << 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush3_insert0_stall_local;
wire [63:0] local_bb1_vectorpush3_insert0;

assign local_bb1_vectorpush3_insert0[31:0] = local_bb1_vectorpop6_extract0;
assign local_bb1_vectorpush3_insert0[63:32] = 32'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_shr_2_1_stall_local;
wire [31:0] local_bb1_shr_2_1;

assign local_bb1_shr_2_1 = (local_bb1_vectorpop6_extract1 >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u13_stall_local;
wire [31:0] local_bb1_var__u13;

assign local_bb1_var__u13 = (local_bb1_vectorpop6_extract1 >> 32'hF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u14_stall_local;
wire [31:0] local_bb1_var__u14;

assign local_bb1_var__u14 = (local_bb1_vectorpop6_extract1 >> 32'hA);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u15_stall_local;
wire [31:0] local_bb1_var__u15;

assign local_bb1_var__u15 = (local_bb1_vectorpop6_extract1 >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_1_masked_stall_local;
wire [31:0] local_bb1_mul23_2_1_masked;

assign local_bb1_mul23_2_1_masked = (local_bb1_vectorpop6_extract1 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_1_masked1431_stall_local;
wire [31:0] local_bb1_mul23_2_1_masked1431;

assign local_bb1_mul23_2_1_masked1431 = (local_bb1_vectorpop6_extract1 << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_1_masked1433_stall_local;
wire [31:0] local_bb1_mul23_2_1_masked1433;

assign local_bb1_mul23_2_1_masked1433 = (local_bb1_vectorpop6_extract1 << 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_shr_1_stall_local;
wire [31:0] local_bb1_shr_1;

assign local_bb1_shr_1 = (local_bb1_vectorpop6_extract2 >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u16_stall_local;
wire [31:0] local_bb1_var__u16;

assign local_bb1_var__u16 = (local_bb1_vectorpop6_extract2 >> 32'hF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u17_stall_local;
wire [31:0] local_bb1_var__u17;

assign local_bb1_var__u17 = (local_bb1_vectorpop6_extract2 >> 32'hA);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u18_stall_local;
wire [31:0] local_bb1_var__u18;

assign local_bb1_var__u18 = (local_bb1_vectorpop6_extract2 >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_masked_stall_local;
wire [31:0] local_bb1_mul23_1_masked;

assign local_bb1_mul23_1_masked = (local_bb1_vectorpop6_extract2 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_masked1369_stall_local;
wire [31:0] local_bb1_mul23_1_masked1369;

assign local_bb1_mul23_1_masked1369 = (local_bb1_vectorpop6_extract2 << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_masked1371_stall_local;
wire [31:0] local_bb1_mul23_1_masked1371;

assign local_bb1_mul23_1_masked1371 = (local_bb1_vectorpop6_extract2 << 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush6_insert0_stall_local;
wire [127:0] local_bb1_vectorpush6_insert0;

assign local_bb1_vectorpush6_insert0[31:0] = local_bb1_vectorpop6_extract2;
assign local_bb1_vectorpush6_insert0[127:32] = 96'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_shr_1_1_stall_local;
wire [31:0] local_bb1_shr_1_1;

assign local_bb1_shr_1_1 = (local_bb1_vectorpop6_extract3 >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u19_stall_local;
wire [31:0] local_bb1_var__u19;

assign local_bb1_var__u19 = (local_bb1_vectorpop6_extract3 >> 32'hF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u20_stall_local;
wire [31:0] local_bb1_var__u20;

assign local_bb1_var__u20 = (local_bb1_vectorpop6_extract3 >> 32'hA);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u21_stall_local;
wire [31:0] local_bb1_var__u21;

assign local_bb1_var__u21 = (local_bb1_vectorpop6_extract3 >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_1_masked_stall_local;
wire [31:0] local_bb1_mul23_1_1_masked;

assign local_bb1_mul23_1_1_masked = (local_bb1_vectorpop6_extract3 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_1_masked1493_stall_local;
wire [31:0] local_bb1_mul23_1_1_masked1493;

assign local_bb1_mul23_1_1_masked1493 = (local_bb1_vectorpop6_extract3 << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_1_masked1495_stall_local;
wire [31:0] local_bb1_mul23_1_1_masked1495;

assign local_bb1_mul23_1_1_masked1495 = (local_bb1_vectorpop6_extract3 << 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_2_masked_stall_local;
wire [31:0] local_bb1_mul21_2_masked;

assign local_bb1_mul21_2_masked = ((local_bb1_shr_2 & 32'hFFFFFF) & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u22_stall_local;
wire [31:0] local_bb1_var__u22;

assign local_bb1_var__u22 = ((local_bb1_var__u10 & 32'h1FFFF) & 32'h1FE);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u23_stall_local;
wire [31:0] local_bb1_var__u23;

assign local_bb1_var__u23 = ((local_bb1_var__u11 & 32'h3FFFFF) & 32'h3FC0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u24_stall_local;
wire [31:0] local_bb1_var__u24;

assign local_bb1_var__u24 = ((local_bb1_var__u12 & 32'h7FFFFFFF) & 32'h7F80);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u25_stall_local;
wire [31:0] local_bb1_var__u25;

assign local_bb1_var__u25 = ((local_bb1_mul23_2_masked1555 & 32'hFFFFFFF8) & 32'h7F8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u26_stall_local;
wire [31:0] local_bb1_var__u26;

assign local_bb1_var__u26 = ((local_bb1_mul23_2_masked1557 & 32'hFFFFFFF0) & 32'hFF0);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush3_insert1_stall_local;
wire [63:0] local_bb1_vectorpush3_insert1;

assign local_bb1_vectorpush3_insert1[31:0] = local_bb1_vectorpush3_insert0[31:0];
assign local_bb1_vectorpush3_insert1[63:32] = local_bb1_vectorpop6_extract1;

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_2_1_masked_stall_local;
wire [31:0] local_bb1_mul21_2_1_masked;

assign local_bb1_mul21_2_1_masked = ((local_bb1_shr_2_1 & 32'hFFFFFF) & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u27_stall_local;
wire [31:0] local_bb1_var__u27;

assign local_bb1_var__u27 = ((local_bb1_var__u13 & 32'h1FFFF) & 32'h1FE);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u28_stall_local;
wire [31:0] local_bb1_var__u28;

assign local_bb1_var__u28 = ((local_bb1_var__u14 & 32'h3FFFFF) & 32'h3FC0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u29_stall_local;
wire [31:0] local_bb1_var__u29;

assign local_bb1_var__u29 = ((local_bb1_var__u15 & 32'h7FFFFFFF) & 32'h7F80);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u30_stall_local;
wire [31:0] local_bb1_var__u30;

assign local_bb1_var__u30 = ((local_bb1_mul23_2_1_masked1431 & 32'hFFFFFFF8) & 32'h7F8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u31_stall_local;
wire [31:0] local_bb1_var__u31;

assign local_bb1_var__u31 = ((local_bb1_mul23_2_1_masked1433 & 32'hFFFFFFF0) & 32'hFF0);

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_1_masked_stall_local;
wire [31:0] local_bb1_mul21_1_masked;

assign local_bb1_mul21_1_masked = ((local_bb1_shr_1 & 32'hFFFFFF) & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u32_stall_local;
wire [31:0] local_bb1_var__u32;

assign local_bb1_var__u32 = ((local_bb1_var__u16 & 32'h1FFFF) & 32'h1FE);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u33_stall_local;
wire [31:0] local_bb1_var__u33;

assign local_bb1_var__u33 = ((local_bb1_var__u17 & 32'h3FFFFF) & 32'h3FC0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u34_stall_local;
wire [31:0] local_bb1_var__u34;

assign local_bb1_var__u34 = ((local_bb1_var__u18 & 32'h7FFFFFFF) & 32'h7F80);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u35_stall_local;
wire [31:0] local_bb1_var__u35;

assign local_bb1_var__u35 = ((local_bb1_mul23_1_masked1369 & 32'hFFFFFFF8) & 32'h7F8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u36_stall_local;
wire [31:0] local_bb1_var__u36;

assign local_bb1_var__u36 = ((local_bb1_mul23_1_masked1371 & 32'hFFFFFFF0) & 32'hFF0);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush6_insert1_stall_local;
wire [127:0] local_bb1_vectorpush6_insert1;

assign local_bb1_vectorpush6_insert1[31:0] = local_bb1_vectorpush6_insert0[31:0];
assign local_bb1_vectorpush6_insert1[63:32] = local_bb1_vectorpop6_extract3;
assign local_bb1_vectorpush6_insert1[127:64] = local_bb1_vectorpush6_insert0[127:64];

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_1_1_masked_stall_local;
wire [31:0] local_bb1_mul21_1_1_masked;

assign local_bb1_mul21_1_1_masked = ((local_bb1_shr_1_1 & 32'hFFFFFF) & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u37_stall_local;
wire [31:0] local_bb1_var__u37;

assign local_bb1_var__u37 = ((local_bb1_var__u19 & 32'h1FFFF) & 32'h1FE);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u38_stall_local;
wire [31:0] local_bb1_var__u38;

assign local_bb1_var__u38 = ((local_bb1_var__u20 & 32'h3FFFFF) & 32'h3FC0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u39_stall_local;
wire [31:0] local_bb1_var__u39;

assign local_bb1_var__u39 = ((local_bb1_var__u21 & 32'h7FFFFFFF) & 32'h7F80);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u40_stall_local;
wire [31:0] local_bb1_var__u40;

assign local_bb1_var__u40 = ((local_bb1_mul23_1_1_masked1493 & 32'hFFFFFFF8) & 32'h7F8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u41_stall_local;
wire [31:0] local_bb1_var__u41;

assign local_bb1_var__u41 = ((local_bb1_mul23_1_1_masked1495 & 32'hFFFFFFF0) & 32'hFF0);

// This section implements an unregistered operation.
// 
wire local_bb1_mul20_2_add992_stall_local;
wire [31:0] local_bb1_mul20_2_add992;

assign local_bb1_mul20_2_add992 = ((local_bb1_var__u22 & 32'h1FE) + (local_bb1_var__u23 & 32'h3FC0));

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_2_add930_stall_local;
wire [31:0] local_bb1_mul21_2_add930;

assign local_bb1_mul21_2_add930 = ((local_bb1_mul21_2_masked & 32'hFF) + (local_bb1_var__u24 & 32'h7F80));

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_add1556_stall_local;
wire [31:0] local_bb1_mul23_2_add1556;

assign local_bb1_mul23_2_add1556 = ((local_bb1_mul23_2_masked & 32'hFF) + (local_bb1_var__u25 & 32'h7F8));

// This section implements an unregistered operation.
// 
wire local_bb1_mul20_2_1_add496_stall_local;
wire [31:0] local_bb1_mul20_2_1_add496;

assign local_bb1_mul20_2_1_add496 = ((local_bb1_var__u27 & 32'h1FE) + (local_bb1_var__u28 & 32'h3FC0));

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_2_1_add434_stall_local;
wire [31:0] local_bb1_mul21_2_1_add434;

assign local_bb1_mul21_2_1_add434 = ((local_bb1_mul21_2_1_masked & 32'hFF) + (local_bb1_var__u29 & 32'h7F80));

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_1_add1432_stall_local;
wire [31:0] local_bb1_mul23_2_1_add1432;

assign local_bb1_mul23_2_1_add1432 = ((local_bb1_mul23_2_1_masked & 32'hFF) + (local_bb1_var__u30 & 32'h7F8));

// This section implements an unregistered operation.
// 
wire local_bb1_mul20_1_add1116_stall_local;
wire [31:0] local_bb1_mul20_1_add1116;

assign local_bb1_mul20_1_add1116 = ((local_bb1_var__u32 & 32'h1FE) + (local_bb1_var__u33 & 32'h3FC0));

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_1_add1054_stall_local;
wire [31:0] local_bb1_mul21_1_add1054;

assign local_bb1_mul21_1_add1054 = ((local_bb1_mul21_1_masked & 32'hFF) + (local_bb1_var__u34 & 32'h7F80));

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_add1370_stall_local;
wire [31:0] local_bb1_mul23_1_add1370;

assign local_bb1_mul23_1_add1370 = ((local_bb1_mul23_1_masked & 32'hFF) + (local_bb1_var__u35 & 32'h7F8));

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush6_insert2_stall_local;
wire [127:0] local_bb1_vectorpush6_insert2;

assign local_bb1_vectorpush6_insert2[63:0] = local_bb1_vectorpush6_insert1[63:0];
assign local_bb1_vectorpush6_insert2[95:64] = local_bb1__;
assign local_bb1_vectorpush6_insert2[127:96] = local_bb1_vectorpush6_insert1[127:96];

// This section implements an unregistered operation.
// 
wire local_bb1_mul20_1_1_add620_stall_local;
wire [31:0] local_bb1_mul20_1_1_add620;

assign local_bb1_mul20_1_1_add620 = ((local_bb1_var__u37 & 32'h1FE) + (local_bb1_var__u38 & 32'h3FC0));

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_1_1_add558_stall_local;
wire [31:0] local_bb1_mul21_1_1_add558;

assign local_bb1_mul21_1_1_add558 = ((local_bb1_mul21_1_1_masked & 32'hFF) + (local_bb1_var__u39 & 32'h7F80));

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_1_add1494_stall_local;
wire [31:0] local_bb1_mul23_1_1_add1494;

assign local_bb1_mul23_1_1_add1494 = ((local_bb1_mul23_1_1_masked & 32'hFF) + (local_bb1_var__u40 & 32'h7F8));

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_add1612_stall_local;
wire [31:0] local_bb1_mul23_2_add1612;

assign local_bb1_mul23_2_add1612 = ((local_bb1_mul23_2_add1556 & 32'hFFF) + (local_bb1_var__u26 & 32'hFF0));

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_1_add1488_stall_local;
wire [31:0] local_bb1_mul23_2_1_add1488;

assign local_bb1_mul23_2_1_add1488 = ((local_bb1_mul23_2_1_add1432 & 32'hFFF) + (local_bb1_var__u31 & 32'hFF0));

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_add1426_stall_local;
wire [31:0] local_bb1_mul23_1_add1426;

assign local_bb1_mul23_1_add1426 = ((local_bb1_mul23_1_add1370 & 32'hFFF) + (local_bb1_var__u36 & 32'hFF0));

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush6_insert3_stall_local;
wire [127:0] local_bb1_vectorpush6_insert3;

assign local_bb1_vectorpush6_insert3[95:0] = local_bb1_vectorpush6_insert2[95:0];
assign local_bb1_vectorpush6_insert3[127:96] = local_bb1_vectorpop3_extract0;

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_1_add1550_stall_local;
wire [31:0] local_bb1_mul23_1_1_add1550;

assign local_bb1_mul23_1_1_add1550 = ((local_bb1_mul23_1_1_add1494 & 32'hFFF) + (local_bb1_var__u41 & 32'hFF0));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_6_stall_local;
wire [31:0] local_bb1_reduction_6;

assign local_bb1_reduction_6 = ((local_bb1_mul23_2_add1612 & 32'h1FFF) + (local_bb1_mul21_2_add930 & 32'hFFFF));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_15_stall_local;
wire [31:0] local_bb1_reduction_15;

assign local_bb1_reduction_15 = ((local_bb1_mul23_2_1_add1488 & 32'h1FFF) + (local_bb1_mul21_2_1_add434 & 32'hFFFF));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_3_stall_local;
wire [31:0] local_bb1_reduction_3;

assign local_bb1_reduction_3 = ((local_bb1_mul23_1_add1426 & 32'h1FFF) + (local_bb1_mul21_1_add1054 & 32'hFFFF));

// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene1_valid_out_3;
wire local_bb1_c0_ene1_stall_in_3;
wire SFC_2_VALID_6_6_0_valid_out_0;
wire SFC_2_VALID_6_6_0_stall_in_0;
wire SFC_2_VALID_6_6_0_valid_out_3;
wire SFC_2_VALID_6_6_0_stall_in_3;
wire SFC_2_VALID_6_6_0_valid_out_4;
wire SFC_2_VALID_6_6_0_stall_in_4;
wire local_bb1_vectorpop3_extract0_valid_out_1;
wire local_bb1_vectorpop3_extract0_stall_in_1;
wire local_bb1_vectorpop3_extract1_valid_out;
wire local_bb1_vectorpop3_extract1_stall_in;
wire local_bb1_vectorpush3_insert1_valid_out;
wire local_bb1_vectorpush3_insert1_stall_in;
wire local_bb1_vectorpush6_insert3_valid_out;
wire local_bb1_vectorpush6_insert3_stall_in;
wire local_bb1_mul20_add806_valid_out;
wire local_bb1_mul20_add806_stall_in;
wire local_bb1_mul20_2_add992_valid_out;
wire local_bb1_mul20_2_add992_stall_in;
wire local_bb1_mul20_2_1_add496_valid_out;
wire local_bb1_mul20_2_1_add496_stall_in;
wire local_bb1_mul20_1_add1116_valid_out;
wire local_bb1_mul20_1_add1116_stall_in;
wire local_bb1_mul20_1_1_add620_valid_out;
wire local_bb1_mul20_1_1_add620_stall_in;
wire local_bb1_reduction_0_valid_out;
wire local_bb1_reduction_0_stall_in;
wire local_bb1_reduction_6_valid_out;
wire local_bb1_reduction_6_stall_in;
wire local_bb1_reduction_15_valid_out;
wire local_bb1_reduction_15_stall_in;
wire local_bb1_reduction_3_valid_out;
wire local_bb1_reduction_3_stall_in;
wire local_bb1_reduction_12_valid_out;
wire local_bb1_reduction_12_stall_in;
wire local_bb1_reduction_12_inputs_ready;
wire local_bb1_reduction_12_stall_local;
wire [31:0] local_bb1_reduction_12;

assign local_bb1_reduction_12_inputs_ready = (local_bb1_c0_enter_c0_eni5_valid_out_0_NO_SHIFT_REG & local_bb1_c0_enter_c0_eni5_valid_out_5_NO_SHIFT_REG & local_bb1_c0_enter_c0_eni5_valid_out_1_NO_SHIFT_REG & local_bb1_c0_enter_c0_eni5_valid_out_3_NO_SHIFT_REG & local_bb1_c0_enter_c0_eni5_valid_out_4_NO_SHIFT_REG);
assign local_bb1_reduction_12 = ((local_bb1_mul23_1_1_add1550 & 32'h1FFF) + (local_bb1_mul21_1_1_add558 & 32'hFFFF));
assign local_bb1_c0_ene1_valid_out_3 = 1'b1;
assign SFC_2_VALID_6_6_0_valid_out_0 = 1'b1;
assign SFC_2_VALID_6_6_0_valid_out_3 = 1'b1;
assign SFC_2_VALID_6_6_0_valid_out_4 = 1'b1;
assign local_bb1_vectorpop3_extract0_valid_out_1 = 1'b1;
assign local_bb1_vectorpop3_extract1_valid_out = 1'b1;
assign local_bb1_vectorpush3_insert1_valid_out = 1'b1;
assign local_bb1_vectorpush6_insert3_valid_out = 1'b1;
assign local_bb1_mul20_add806_valid_out = 1'b1;
assign local_bb1_mul20_2_add992_valid_out = 1'b1;
assign local_bb1_mul20_2_1_add496_valid_out = 1'b1;
assign local_bb1_mul20_1_add1116_valid_out = 1'b1;
assign local_bb1_mul20_1_1_add620_valid_out = 1'b1;
assign local_bb1_reduction_0_valid_out = 1'b1;
assign local_bb1_reduction_6_valid_out = 1'b1;
assign local_bb1_reduction_15_valid_out = 1'b1;
assign local_bb1_reduction_3_valid_out = 1'b1;
assign local_bb1_reduction_12_valid_out = 1'b1;
assign local_bb1_c0_enter_c0_eni5_stall_in_0 = 1'b0;
assign local_bb1_c0_enter_c0_eni5_stall_in_5 = 1'b0;
assign local_bb1_c0_enter_c0_eni5_stall_in_1 = 1'b0;
assign local_bb1_c0_enter_c0_eni5_stall_in_3 = 1'b0;
assign local_bb1_c0_enter_c0_eni5_stall_in_4 = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_c0_ene1_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene1_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene1_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene1_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene1_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene1_1_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene1_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene1_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene1_0_valid_out_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene1_0_stall_in_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_c0_ene1_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_c0_ene1_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_c0_ene1_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_c0_ene1_0_stall_in_0_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_c0_ene1_0_valid_out_0_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_c0_ene1_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in(local_bb1_c0_ene1),
	.data_out(rnode_6to7_bb1_c0_ene1_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_c0_ene1_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_c0_ene1_0_reg_7_fifo.DATA_WIDTH = 1;
defparam rnode_6to7_bb1_c0_ene1_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_c0_ene1_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_c0_ene1_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_c0_ene1_stall_in_3 = 1'b0;
assign rnode_6to7_bb1_c0_ene1_0_stall_in_0_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_c0_ene1_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_c0_ene1_0_NO_SHIFT_REG = rnode_6to7_bb1_c0_ene1_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_c0_ene1_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_c0_ene1_1_NO_SHIFT_REG = rnode_6to7_bb1_c0_ene1_0_reg_7_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire SFC_2_VALID_6_7_0_inputs_ready;
 reg SFC_2_VALID_6_7_0_valid_out_0_NO_SHIFT_REG;
wire SFC_2_VALID_6_7_0_stall_in_0;
 reg SFC_2_VALID_6_7_0_valid_out_1_NO_SHIFT_REG;
wire SFC_2_VALID_6_7_0_stall_in_1;
 reg SFC_2_VALID_6_7_0_valid_out_2_NO_SHIFT_REG;
wire SFC_2_VALID_6_7_0_stall_in_2;
wire SFC_2_VALID_6_7_0_output_regs_ready;
 reg SFC_2_VALID_6_7_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_2_VALID_6_7_0_causedstall;

assign SFC_2_VALID_6_7_0_inputs_ready = 1'b1;
assign SFC_2_VALID_6_7_0_output_regs_ready = 1'b1;
assign SFC_2_VALID_6_6_0_stall_in_0 = 1'b0;
assign SFC_2_VALID_6_7_0_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		SFC_2_VALID_6_7_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (SFC_2_VALID_6_7_0_output_regs_ready)
		begin
			SFC_2_VALID_6_7_0_NO_SHIFT_REG <= SFC_2_VALID_6_6_0;
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract0_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract0_1_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract0_2_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract0_3_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_4_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_4_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract0_4_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_5_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_5_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract0_5_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_6_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_6_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract0_6_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract0_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_0_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_0_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_vectorpop3_extract0_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in(local_bb1_vectorpop3_extract0),
	.data_out(rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_vectorpop3_extract0_stall_in_1 = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_0_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract0_0_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract0_1_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract0_2_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract0_3_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_4_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract0_4_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_5_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract0_5_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_6_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract0_6_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract0_0_reg_7_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract1_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract1_1_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract1_2_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract1_3_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_4_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_4_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract1_4_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_5_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_5_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract1_5_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_6_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_6_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract1_6_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_7_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract1_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_vectorpop3_extract1_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_0_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_0_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_vectorpop3_extract1_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in(local_bb1_vectorpop3_extract1),
	.data_out(rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_vectorpop3_extract1_stall_in = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_0_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract1_0_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract1_1_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract1_2_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract1_3_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_4_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract1_4_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_5_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract1_5_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_6_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract1_6_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_7_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract1_7_NO_SHIFT_REG = rnode_6to7_bb1_vectorpop3_extract1_0_reg_7_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire local_bb1_vectorpush3_vectorpush3_insert1_inputs_ready;
wire local_bb1_vectorpush3_vectorpush3_insert1_output_regs_ready;
wire [63:0] local_bb1_vectorpush3_vectorpush3_insert1_result;
wire local_bb1_vectorpush3_vectorpush3_insert1_fu_valid_out;
wire local_bb1_vectorpush3_vectorpush3_insert1_fu_stall_out;
 reg [63:0] local_bb1_vectorpush3_vectorpush3_insert1_NO_SHIFT_REG;
wire local_bb1_vectorpush3_vectorpush3_insert1_causedstall;

acl_push local_bb1_vectorpush3_vectorpush3_insert1_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(1'b1),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpush3_insert1),
	.stall_out(local_bb1_vectorpush3_vectorpush3_insert1_fu_stall_out),
	.valid_in(SFC_2_VALID_6_6_0),
	.valid_out(local_bb1_vectorpush3_vectorpush3_insert1_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_vectorpush3_vectorpush3_insert1_result),
	.feedback_out(feedback_data_out_3),
	.feedback_valid_out(feedback_valid_out_3),
	.feedback_stall_in(feedback_stall_in_3)
);

defparam local_bb1_vectorpush3_vectorpush3_insert1_feedback.STALLFREE = 1;
defparam local_bb1_vectorpush3_vectorpush3_insert1_feedback.ENABLED = 0;
defparam local_bb1_vectorpush3_vectorpush3_insert1_feedback.DATA_WIDTH = 64;
defparam local_bb1_vectorpush3_vectorpush3_insert1_feedback.FIFO_DEPTH = 1918;
defparam local_bb1_vectorpush3_vectorpush3_insert1_feedback.MIN_FIFO_LATENCY = 1918;
defparam local_bb1_vectorpush3_vectorpush3_insert1_feedback.STYLE = "REGULAR";
defparam local_bb1_vectorpush3_vectorpush3_insert1_feedback.RAM_FIFO_DEPTH_INC = 1;

assign local_bb1_vectorpush3_vectorpush3_insert1_inputs_ready = 1'b1;
assign local_bb1_vectorpush3_vectorpush3_insert1_output_regs_ready = 1'b1;
assign local_bb1_vectorpush3_insert1_stall_in = 1'b0;
assign SFC_2_VALID_6_6_0_stall_in_3 = 1'b0;
assign local_bb1_vectorpush3_vectorpush3_insert1_causedstall = (SFC_2_VALID_6_6_0 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_vectorpush3_vectorpush3_insert1_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_vectorpush3_vectorpush3_insert1_output_regs_ready)
		begin
			local_bb1_vectorpush3_vectorpush3_insert1_NO_SHIFT_REG <= local_bb1_vectorpush3_vectorpush3_insert1_result;
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb1_vectorpush6_vectorpush6_insert3_inputs_ready;
wire local_bb1_vectorpush6_vectorpush6_insert3_output_regs_ready;
wire [127:0] local_bb1_vectorpush6_vectorpush6_insert3_result;
wire local_bb1_vectorpush6_vectorpush6_insert3_fu_valid_out;
wire local_bb1_vectorpush6_vectorpush6_insert3_fu_stall_out;
 reg [127:0] local_bb1_vectorpush6_vectorpush6_insert3_NO_SHIFT_REG;
wire local_bb1_vectorpush6_vectorpush6_insert3_causedstall;

acl_push local_bb1_vectorpush6_vectorpush6_insert3_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_c0_ene3),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpush6_insert3),
	.stall_out(local_bb1_vectorpush6_vectorpush6_insert3_fu_stall_out),
	.valid_in(SFC_2_VALID_6_6_0),
	.valid_out(local_bb1_vectorpush6_vectorpush6_insert3_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_vectorpush6_vectorpush6_insert3_result),
	.feedback_out(feedback_data_out_6),
	.feedback_valid_out(feedback_valid_out_6),
	.feedback_stall_in(feedback_stall_in_6)
);

defparam local_bb1_vectorpush6_vectorpush6_insert3_feedback.STALLFREE = 1;
defparam local_bb1_vectorpush6_vectorpush6_insert3_feedback.ENABLED = 0;
defparam local_bb1_vectorpush6_vectorpush6_insert3_feedback.DATA_WIDTH = 128;
defparam local_bb1_vectorpush6_vectorpush6_insert3_feedback.FIFO_DEPTH = 1;
defparam local_bb1_vectorpush6_vectorpush6_insert3_feedback.MIN_FIFO_LATENCY = 1;
defparam local_bb1_vectorpush6_vectorpush6_insert3_feedback.STYLE = "REGULAR";
defparam local_bb1_vectorpush6_vectorpush6_insert3_feedback.RAM_FIFO_DEPTH_INC = 1;

assign local_bb1_vectorpush6_vectorpush6_insert3_inputs_ready = 1'b1;
assign local_bb1_vectorpush6_vectorpush6_insert3_output_regs_ready = 1'b1;
assign local_bb1_vectorpush6_insert3_stall_in = 1'b0;
assign local_bb1_c0_ene3_stall_in_0 = 1'b0;
assign SFC_2_VALID_6_6_0_stall_in_4 = 1'b0;
assign local_bb1_vectorpush6_vectorpush6_insert3_causedstall = (SFC_2_VALID_6_6_0 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_vectorpush6_vectorpush6_insert3_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_vectorpush6_vectorpush6_insert3_output_regs_ready)
		begin
			local_bb1_vectorpush6_vectorpush6_insert3_NO_SHIFT_REG <= local_bb1_vectorpush6_vectorpush6_insert3_result;
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_mul20_add806_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_add806_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_mul20_add806_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_add806_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_mul20_add806_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_add806_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_add806_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_add806_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_mul20_add806_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_mul20_add806_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_mul20_add806_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_mul20_add806_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_mul20_add806_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in((local_bb1_mul20_add806 & 32'h7FFE)),
	.data_out(rnode_6to7_bb1_mul20_add806_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_mul20_add806_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_mul20_add806_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_mul20_add806_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_mul20_add806_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_mul20_add806_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_mul20_add806_stall_in = 1'b0;
assign rnode_6to7_bb1_mul20_add806_0_NO_SHIFT_REG = rnode_6to7_bb1_mul20_add806_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_mul20_add806_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_mul20_add806_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_mul20_2_add992_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_2_add992_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_mul20_2_add992_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_2_add992_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_mul20_2_add992_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_2_add992_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_2_add992_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_2_add992_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_mul20_2_add992_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_mul20_2_add992_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_mul20_2_add992_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_mul20_2_add992_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_mul20_2_add992_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in((local_bb1_mul20_2_add992 & 32'h7FFE)),
	.data_out(rnode_6to7_bb1_mul20_2_add992_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_mul20_2_add992_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_mul20_2_add992_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_mul20_2_add992_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_mul20_2_add992_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_mul20_2_add992_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_mul20_2_add992_stall_in = 1'b0;
assign rnode_6to7_bb1_mul20_2_add992_0_NO_SHIFT_REG = rnode_6to7_bb1_mul20_2_add992_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_mul20_2_add992_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_mul20_2_add992_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_mul20_2_1_add496_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_2_1_add496_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_mul20_2_1_add496_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_2_1_add496_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_mul20_2_1_add496_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_2_1_add496_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_2_1_add496_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_2_1_add496_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_mul20_2_1_add496_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_mul20_2_1_add496_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_mul20_2_1_add496_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_mul20_2_1_add496_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_mul20_2_1_add496_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in((local_bb1_mul20_2_1_add496 & 32'h7FFE)),
	.data_out(rnode_6to7_bb1_mul20_2_1_add496_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_mul20_2_1_add496_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_mul20_2_1_add496_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_mul20_2_1_add496_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_mul20_2_1_add496_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_mul20_2_1_add496_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_mul20_2_1_add496_stall_in = 1'b0;
assign rnode_6to7_bb1_mul20_2_1_add496_0_NO_SHIFT_REG = rnode_6to7_bb1_mul20_2_1_add496_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_mul20_2_1_add496_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_mul20_2_1_add496_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_mul20_1_add1116_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_1_add1116_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_mul20_1_add1116_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_1_add1116_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_mul20_1_add1116_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_1_add1116_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_1_add1116_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_1_add1116_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_mul20_1_add1116_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_mul20_1_add1116_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_mul20_1_add1116_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_mul20_1_add1116_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_mul20_1_add1116_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in((local_bb1_mul20_1_add1116 & 32'h7FFE)),
	.data_out(rnode_6to7_bb1_mul20_1_add1116_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_mul20_1_add1116_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_mul20_1_add1116_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_mul20_1_add1116_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_mul20_1_add1116_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_mul20_1_add1116_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_mul20_1_add1116_stall_in = 1'b0;
assign rnode_6to7_bb1_mul20_1_add1116_0_NO_SHIFT_REG = rnode_6to7_bb1_mul20_1_add1116_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_mul20_1_add1116_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_mul20_1_add1116_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_mul20_1_1_add620_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_1_1_add620_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_mul20_1_1_add620_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_1_1_add620_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_mul20_1_1_add620_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_1_1_add620_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_1_1_add620_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_mul20_1_1_add620_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_mul20_1_1_add620_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_mul20_1_1_add620_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_mul20_1_1_add620_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_mul20_1_1_add620_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_mul20_1_1_add620_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in((local_bb1_mul20_1_1_add620 & 32'h7FFE)),
	.data_out(rnode_6to7_bb1_mul20_1_1_add620_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_mul20_1_1_add620_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_mul20_1_1_add620_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_mul20_1_1_add620_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_mul20_1_1_add620_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_mul20_1_1_add620_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_mul20_1_1_add620_stall_in = 1'b0;
assign rnode_6to7_bb1_mul20_1_1_add620_0_NO_SHIFT_REG = rnode_6to7_bb1_mul20_1_1_add620_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_mul20_1_1_add620_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_mul20_1_1_add620_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_reduction_0_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_0_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_reduction_0_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_0_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_reduction_0_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_0_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_0_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_0_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_reduction_0_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_reduction_0_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_reduction_0_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_reduction_0_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_reduction_0_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in((local_bb1_reduction_0 & 32'h1FFFF)),
	.data_out(rnode_6to7_bb1_reduction_0_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_reduction_0_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_reduction_0_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_reduction_0_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_reduction_0_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_reduction_0_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_0_stall_in = 1'b0;
assign rnode_6to7_bb1_reduction_0_0_NO_SHIFT_REG = rnode_6to7_bb1_reduction_0_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_reduction_0_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_reduction_0_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_reduction_6_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_6_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_reduction_6_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_6_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_reduction_6_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_6_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_6_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_6_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_reduction_6_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_reduction_6_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_reduction_6_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_reduction_6_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_reduction_6_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in((local_bb1_reduction_6 & 32'h1FFFF)),
	.data_out(rnode_6to7_bb1_reduction_6_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_reduction_6_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_reduction_6_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_reduction_6_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_reduction_6_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_reduction_6_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_6_stall_in = 1'b0;
assign rnode_6to7_bb1_reduction_6_0_NO_SHIFT_REG = rnode_6to7_bb1_reduction_6_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_reduction_6_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_reduction_6_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_reduction_15_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_15_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_reduction_15_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_15_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_reduction_15_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_15_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_15_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_15_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_reduction_15_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_reduction_15_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_reduction_15_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_reduction_15_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_reduction_15_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in((local_bb1_reduction_15 & 32'h1FFFF)),
	.data_out(rnode_6to7_bb1_reduction_15_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_reduction_15_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_reduction_15_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_reduction_15_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_reduction_15_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_reduction_15_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_15_stall_in = 1'b0;
assign rnode_6to7_bb1_reduction_15_0_NO_SHIFT_REG = rnode_6to7_bb1_reduction_15_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_reduction_15_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_reduction_15_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_reduction_3_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_3_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_reduction_3_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_3_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_reduction_3_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_3_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_3_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_3_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_reduction_3_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_reduction_3_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_reduction_3_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_reduction_3_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_reduction_3_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in((local_bb1_reduction_3 & 32'h1FFFF)),
	.data_out(rnode_6to7_bb1_reduction_3_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_reduction_3_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_reduction_3_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_reduction_3_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_reduction_3_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_reduction_3_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_3_stall_in = 1'b0;
assign rnode_6to7_bb1_reduction_3_0_NO_SHIFT_REG = rnode_6to7_bb1_reduction_3_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_reduction_3_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_reduction_3_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_reduction_12_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_12_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_reduction_12_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_12_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_reduction_12_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_12_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_12_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_reduction_12_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_reduction_12_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_reduction_12_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_reduction_12_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_reduction_12_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_reduction_12_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in((local_bb1_reduction_12 & 32'h1FFFF)),
	.data_out(rnode_6to7_bb1_reduction_12_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_reduction_12_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_reduction_12_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_reduction_12_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_reduction_12_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_reduction_12_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_12_stall_in = 1'b0;
assign rnode_6to7_bb1_reduction_12_0_NO_SHIFT_REG = rnode_6to7_bb1_reduction_12_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_reduction_12_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_reduction_12_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert0_stall_local;
wire [63:0] local_bb1_vectorpop8_insert0;

assign local_bb1_vectorpop8_insert0[31:0] = 'x;
assign local_bb1_vectorpop8_insert0[63:32] = 32'bx;

// This section implements a registered operation.
// 
wire SFC_2_VALID_7_8_0_inputs_ready;
 reg SFC_2_VALID_7_8_0_valid_out_NO_SHIFT_REG;
wire SFC_2_VALID_7_8_0_stall_in;
wire SFC_2_VALID_7_8_0_output_regs_ready;
 reg SFC_2_VALID_7_8_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_2_VALID_7_8_0_causedstall;

assign SFC_2_VALID_7_8_0_inputs_ready = 1'b1;
assign SFC_2_VALID_7_8_0_output_regs_ready = 1'b1;
assign SFC_2_VALID_6_7_0_stall_in_0 = 1'b0;
assign SFC_2_VALID_7_8_0_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		SFC_2_VALID_7_8_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (SFC_2_VALID_7_8_0_output_regs_ready)
		begin
			SFC_2_VALID_7_8_0_NO_SHIFT_REG <= SFC_2_VALID_6_7_0_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_shr_112_stall_local;
wire [31:0] local_bb1_shr_112;

assign local_bb1_shr_112 = (rnode_6to7_bb1_vectorpop3_extract0_0_NO_SHIFT_REG >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u42_stall_local;
wire [31:0] local_bb1_var__u42;

assign local_bb1_var__u42 = (rnode_6to7_bb1_vectorpop3_extract0_1_NO_SHIFT_REG >> 32'hF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u43_stall_local;
wire [31:0] local_bb1_var__u43;

assign local_bb1_var__u43 = (rnode_6to7_bb1_vectorpop3_extract0_2_NO_SHIFT_REG >> 32'hA);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u44_stall_local;
wire [31:0] local_bb1_var__u44;

assign local_bb1_var__u44 = (rnode_6to7_bb1_vectorpop3_extract0_3_NO_SHIFT_REG >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_118_masked_stall_local;
wire [31:0] local_bb1_mul23_118_masked;

assign local_bb1_mul23_118_masked = (rnode_6to7_bb1_vectorpop3_extract0_4_NO_SHIFT_REG & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_118_masked1617_stall_local;
wire [31:0] local_bb1_mul23_118_masked1617;

assign local_bb1_mul23_118_masked1617 = (rnode_6to7_bb1_vectorpop3_extract0_5_NO_SHIFT_REG << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_118_masked1619_stall_local;
wire [31:0] local_bb1_mul23_118_masked1619;

assign local_bb1_mul23_118_masked1619 = (rnode_6to7_bb1_vectorpop3_extract0_6_NO_SHIFT_REG << 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_shr_230_stall_local;
wire [31:0] local_bb1_shr_230;

assign local_bb1_shr_230 = (rnode_6to7_bb1_vectorpop3_extract1_0_NO_SHIFT_REG >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u45_stall_local;
wire [31:0] local_bb1_var__u45;

assign local_bb1_var__u45 = (rnode_6to7_bb1_vectorpop3_extract1_1_NO_SHIFT_REG >> 32'hF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u46_stall_local;
wire [31:0] local_bb1_var__u46;

assign local_bb1_var__u46 = (rnode_6to7_bb1_vectorpop3_extract1_2_NO_SHIFT_REG >> 32'hA);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u47_stall_local;
wire [31:0] local_bb1_var__u47;

assign local_bb1_var__u47 = (rnode_6to7_bb1_vectorpop3_extract1_3_NO_SHIFT_REG >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_236_masked_stall_local;
wire [31:0] local_bb1_mul23_236_masked;

assign local_bb1_mul23_236_masked = (rnode_6to7_bb1_vectorpop3_extract1_4_NO_SHIFT_REG & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_236_masked1307_stall_local;
wire [31:0] local_bb1_mul23_236_masked1307;

assign local_bb1_mul23_236_masked1307 = (rnode_6to7_bb1_vectorpop3_extract1_5_NO_SHIFT_REG << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_236_masked1309_stall_local;
wire [31:0] local_bb1_mul23_236_masked1309;

assign local_bb1_mul23_236_masked1309 = (rnode_6to7_bb1_vectorpop3_extract1_6_NO_SHIFT_REG << 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert0_stall_local;
wire [63:0] local_bb1_vectorpush8_insert0;

assign local_bb1_vectorpush8_insert0[31:0] = rnode_6to7_bb1_vectorpop3_extract1_7_NO_SHIFT_REG;
assign local_bb1_vectorpush8_insert0[63:32] = 32'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_1_stall_local;
wire [31:0] local_bb1_reduction_1;

assign local_bb1_reduction_1 = ((rnode_6to7_bb1_mul20_add806_0_NO_SHIFT_REG & 32'h7FFE) + 32'h80);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_7_stall_local;
wire [31:0] local_bb1_reduction_7;

assign local_bb1_reduction_7 = ((rnode_6to7_bb1_mul20_2_add992_0_NO_SHIFT_REG & 32'h7FFE) + 32'h80);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_16_stall_local;
wire [31:0] local_bb1_reduction_16;

assign local_bb1_reduction_16 = ((rnode_6to7_bb1_mul20_2_1_add496_0_NO_SHIFT_REG & 32'h7FFE) + 32'h80);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_4_stall_local;
wire [31:0] local_bb1_reduction_4;

assign local_bb1_reduction_4 = ((rnode_6to7_bb1_mul20_1_add1116_0_NO_SHIFT_REG & 32'h7FFE) + 32'h80);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_13_stall_local;
wire [31:0] local_bb1_reduction_13;

assign local_bb1_reduction_13 = ((rnode_6to7_bb1_mul20_1_1_add620_0_NO_SHIFT_REG & 32'h7FFE) + 32'h80);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert1_stall_local;
wire [63:0] local_bb1_vectorpop8_insert1;

assign local_bb1_vectorpop8_insert1[31:0] = local_bb1_vectorpop8_insert0[31:0];
assign local_bb1_vectorpop8_insert1[63:32] = 'x;

// This section implements a registered operation.
// 
wire SFC_2_VALID_8_9_0_inputs_ready;
 reg SFC_2_VALID_8_9_0_valid_out_NO_SHIFT_REG;
wire SFC_2_VALID_8_9_0_stall_in;
wire SFC_2_VALID_8_9_0_output_regs_ready;
 reg SFC_2_VALID_8_9_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_2_VALID_8_9_0_causedstall;

assign SFC_2_VALID_8_9_0_inputs_ready = 1'b1;
assign SFC_2_VALID_8_9_0_output_regs_ready = 1'b1;
assign SFC_2_VALID_7_8_0_stall_in = 1'b0;
assign SFC_2_VALID_8_9_0_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		SFC_2_VALID_8_9_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (SFC_2_VALID_8_9_0_output_regs_ready)
		begin
			SFC_2_VALID_8_9_0_NO_SHIFT_REG <= SFC_2_VALID_7_8_0_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_mul21_117_masked_stall_local;
wire [31:0] local_bb1_mul21_117_masked;

assign local_bb1_mul21_117_masked = ((local_bb1_shr_112 & 32'hFFFFFF) & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u48_stall_local;
wire [31:0] local_bb1_var__u48;

assign local_bb1_var__u48 = ((local_bb1_var__u42 & 32'h1FFFF) & 32'h1FE);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u49_stall_local;
wire [31:0] local_bb1_var__u49;

assign local_bb1_var__u49 = ((local_bb1_var__u43 & 32'h3FFFFF) & 32'h3FC0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u50_stall_local;
wire [31:0] local_bb1_var__u50;

assign local_bb1_var__u50 = ((local_bb1_var__u44 & 32'h7FFFFFFF) & 32'h7F80);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u51_stall_local;
wire [31:0] local_bb1_var__u51;

assign local_bb1_var__u51 = ((local_bb1_mul23_118_masked1617 & 32'hFFFFFFF8) & 32'h7F8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u52_stall_local;
wire [31:0] local_bb1_var__u52;

assign local_bb1_var__u52 = ((local_bb1_mul23_118_masked1619 & 32'hFFFFFFF0) & 32'hFF0);

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_235_masked_stall_local;
wire [31:0] local_bb1_mul21_235_masked;

assign local_bb1_mul21_235_masked = ((local_bb1_shr_230 & 32'hFFFFFF) & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u53_stall_local;
wire [31:0] local_bb1_var__u53;

assign local_bb1_var__u53 = ((local_bb1_var__u45 & 32'h1FFFF) & 32'h1FE);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u54_stall_local;
wire [31:0] local_bb1_var__u54;

assign local_bb1_var__u54 = ((local_bb1_var__u46 & 32'h3FFFFF) & 32'h3FC0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u55_stall_local;
wire [31:0] local_bb1_var__u55;

assign local_bb1_var__u55 = ((local_bb1_var__u47 & 32'h7FFFFFFF) & 32'h7F80);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u56_stall_local;
wire [31:0] local_bb1_var__u56;

assign local_bb1_var__u56 = ((local_bb1_mul23_236_masked1307 & 32'hFFFFFFF8) & 32'h7F8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u57_stall_local;
wire [31:0] local_bb1_var__u57;

assign local_bb1_var__u57 = ((local_bb1_mul23_236_masked1309 & 32'hFFFFFFF0) & 32'hFF0);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_2_stall_local;
wire [31:0] local_bb1_reduction_2;

assign local_bb1_reduction_2 = ((rnode_6to7_bb1_reduction_0_0_NO_SHIFT_REG & 32'h1FFFF) + (local_bb1_reduction_1 & 32'hFFFE));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_8_stall_local;
wire [31:0] local_bb1_reduction_8;

assign local_bb1_reduction_8 = ((rnode_6to7_bb1_reduction_6_0_NO_SHIFT_REG & 32'h1FFFF) + (local_bb1_reduction_7 & 32'hFFFE));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_17_stall_local;
wire [31:0] local_bb1_reduction_17;

assign local_bb1_reduction_17 = ((rnode_6to7_bb1_reduction_15_0_NO_SHIFT_REG & 32'h1FFFF) + (local_bb1_reduction_16 & 32'hFFFE));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_5_stall_local;
wire [31:0] local_bb1_reduction_5;

assign local_bb1_reduction_5 = ((rnode_6to7_bb1_reduction_3_0_NO_SHIFT_REG & 32'h1FFFF) + (local_bb1_reduction_4 & 32'hFFFE));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_14_stall_local;
wire [31:0] local_bb1_reduction_14;

assign local_bb1_reduction_14 = ((rnode_6to7_bb1_reduction_12_0_NO_SHIFT_REG & 32'h1FFFF) + (local_bb1_reduction_13 & 32'hFFFE));

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_vectorpop8_insert1_stall_local;
wire [63:0] local_bb1_vectorpop8_vectorpop8_insert1;
wire local_bb1_vectorpop8_vectorpop8_insert1_fu_valid_out;
wire local_bb1_vectorpop8_vectorpop8_insert1_fu_stall_out;

acl_pop local_bb1_vectorpop8_vectorpop8_insert1_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(rnode_6to7_bb1_c0_ene1_1_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpop8_insert1),
	.stall_out(local_bb1_vectorpop8_vectorpop8_insert1_fu_stall_out),
	.valid_in(SFC_2_VALID_6_7_0_NO_SHIFT_REG),
	.valid_out(local_bb1_vectorpop8_vectorpop8_insert1_fu_valid_out),
	.stall_in(local_bb1_vectorpop8_vectorpop8_insert1_stall_local),
	.data_out(local_bb1_vectorpop8_vectorpop8_insert1),
	.feedback_in(feedback_data_in_8),
	.feedback_valid_in(feedback_valid_in_8),
	.feedback_stall_out(feedback_stall_out_8)
);

defparam local_bb1_vectorpop8_vectorpop8_insert1_feedback.COALESCE_DISTANCE = 1;
defparam local_bb1_vectorpop8_vectorpop8_insert1_feedback.DATA_WIDTH = 64;
defparam local_bb1_vectorpop8_vectorpop8_insert1_feedback.STYLE = "REGULAR";

assign local_bb1_vectorpop8_vectorpop8_insert1_stall_local = 1'b0;

// This section implements a registered operation.
// 
wire SFC_2_VALID_9_10_0_inputs_ready;
 reg SFC_2_VALID_9_10_0_valid_out_NO_SHIFT_REG;
wire SFC_2_VALID_9_10_0_stall_in;
wire SFC_2_VALID_9_10_0_output_regs_ready;
 reg SFC_2_VALID_9_10_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_2_VALID_9_10_0_causedstall;

assign SFC_2_VALID_9_10_0_inputs_ready = 1'b1;
assign SFC_2_VALID_9_10_0_output_regs_ready = 1'b1;
assign SFC_2_VALID_8_9_0_stall_in = 1'b0;
assign SFC_2_VALID_9_10_0_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		SFC_2_VALID_9_10_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (SFC_2_VALID_9_10_0_output_regs_ready)
		begin
			SFC_2_VALID_9_10_0_NO_SHIFT_REG <= SFC_2_VALID_8_9_0_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_mul20_116_add744_stall_local;
wire [31:0] local_bb1_mul20_116_add744;

assign local_bb1_mul20_116_add744 = ((local_bb1_var__u48 & 32'h1FE) + (local_bb1_var__u49 & 32'h3FC0));

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_117_add682_stall_local;
wire [31:0] local_bb1_mul21_117_add682;

assign local_bb1_mul21_117_add682 = ((local_bb1_mul21_117_masked & 32'hFF) + (local_bb1_var__u50 & 32'h7F80));

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_118_add1618_stall_local;
wire [31:0] local_bb1_mul23_118_add1618;

assign local_bb1_mul23_118_add1618 = ((local_bb1_mul23_118_masked & 32'hFF) + (local_bb1_var__u51 & 32'h7F8));

// This section implements an unregistered operation.
// 
wire local_bb1_mul20_234_add372_stall_local;
wire [31:0] local_bb1_mul20_234_add372;

assign local_bb1_mul20_234_add372 = ((local_bb1_var__u53 & 32'h1FE) + (local_bb1_var__u54 & 32'h3FC0));

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_235_add310_stall_local;
wire [31:0] local_bb1_mul21_235_add310;

assign local_bb1_mul21_235_add310 = ((local_bb1_mul21_235_masked & 32'hFF) + (local_bb1_var__u55 & 32'h7F80));

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_236_add1308_stall_local;
wire [31:0] local_bb1_mul23_236_add1308;

assign local_bb1_mul23_236_add1308 = ((local_bb1_mul23_236_masked & 32'hFF) + (local_bb1_var__u56 & 32'h7F8));

// This section implements an unregistered operation.
// 
wire local_bb1_shr26_valid_out;
wire local_bb1_shr26_stall_in;
wire local_bb1_shr26_inputs_ready;
wire local_bb1_shr26_stall_local;
wire [31:0] local_bb1_shr26;

assign local_bb1_shr26_inputs_ready = (rnode_6to7_bb1_mul20_add806_0_valid_out_NO_SHIFT_REG & rnode_6to7_bb1_reduction_0_0_valid_out_NO_SHIFT_REG);
assign local_bb1_shr26 = ((local_bb1_reduction_2 & 32'h3FFFF) >> 32'h8);
assign local_bb1_shr26_valid_out = 1'b1;
assign rnode_6to7_bb1_mul20_add806_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_reduction_0_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_shr26_2_valid_out;
wire local_bb1_shr26_2_stall_in;
wire local_bb1_shr26_2_inputs_ready;
wire local_bb1_shr26_2_stall_local;
wire [31:0] local_bb1_shr26_2;

assign local_bb1_shr26_2_inputs_ready = (rnode_6to7_bb1_mul20_2_add992_0_valid_out_NO_SHIFT_REG & rnode_6to7_bb1_reduction_6_0_valid_out_NO_SHIFT_REG);
assign local_bb1_shr26_2 = ((local_bb1_reduction_8 & 32'h3FFFF) >> 32'h8);
assign local_bb1_shr26_2_valid_out = 1'b1;
assign rnode_6to7_bb1_mul20_2_add992_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_reduction_6_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_shr26_2_1_valid_out;
wire local_bb1_shr26_2_1_stall_in;
wire local_bb1_shr26_2_1_inputs_ready;
wire local_bb1_shr26_2_1_stall_local;
wire [31:0] local_bb1_shr26_2_1;

assign local_bb1_shr26_2_1_inputs_ready = (rnode_6to7_bb1_mul20_2_1_add496_0_valid_out_NO_SHIFT_REG & rnode_6to7_bb1_reduction_15_0_valid_out_NO_SHIFT_REG);
assign local_bb1_shr26_2_1 = ((local_bb1_reduction_17 & 32'h3FFFF) >> 32'h8);
assign local_bb1_shr26_2_1_valid_out = 1'b1;
assign rnode_6to7_bb1_mul20_2_1_add496_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_reduction_15_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_shr26_1_valid_out;
wire local_bb1_shr26_1_stall_in;
wire local_bb1_shr26_1_inputs_ready;
wire local_bb1_shr26_1_stall_local;
wire [31:0] local_bb1_shr26_1;

assign local_bb1_shr26_1_inputs_ready = (rnode_6to7_bb1_mul20_1_add1116_0_valid_out_NO_SHIFT_REG & rnode_6to7_bb1_reduction_3_0_valid_out_NO_SHIFT_REG);
assign local_bb1_shr26_1 = ((local_bb1_reduction_5 & 32'h3FFFF) >> 32'h8);
assign local_bb1_shr26_1_valid_out = 1'b1;
assign rnode_6to7_bb1_mul20_1_add1116_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_reduction_3_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_var__u58_valid_out;
wire local_bb1_var__u58_stall_in;
wire local_bb1_var__u58_inputs_ready;
wire local_bb1_var__u58_stall_local;
wire [31:0] local_bb1_var__u58;

assign local_bb1_var__u58_inputs_ready = (rnode_6to7_bb1_mul20_1_1_add620_0_valid_out_NO_SHIFT_REG & rnode_6to7_bb1_reduction_12_0_valid_out_NO_SHIFT_REG);
assign local_bb1_var__u58 = ((local_bb1_reduction_14 & 32'h3FFFF) >> 32'h5);
assign local_bb1_var__u58_valid_out = 1'b1;
assign rnode_6to7_bb1_mul20_1_1_add620_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_reduction_12_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract0_stall_local;
wire [31:0] local_bb1_vectorpop8_extract0;

assign local_bb1_vectorpop8_extract0[31:0] = local_bb1_vectorpop8_vectorpop8_insert1[31:0];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract1_stall_local;
wire [31:0] local_bb1_vectorpop8_extract1;

assign local_bb1_vectorpop8_extract1[31:0] = local_bb1_vectorpop8_vectorpop8_insert1[63:32];

// This section implements a registered operation.
// 
wire SFC_2_VALID_10_11_0_inputs_ready;
 reg SFC_2_VALID_10_11_0_valid_out_NO_SHIFT_REG;
wire SFC_2_VALID_10_11_0_stall_in;
wire SFC_2_VALID_10_11_0_output_regs_ready;
 reg SFC_2_VALID_10_11_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_2_VALID_10_11_0_causedstall;

assign SFC_2_VALID_10_11_0_inputs_ready = 1'b1;
assign SFC_2_VALID_10_11_0_output_regs_ready = 1'b1;
assign SFC_2_VALID_9_10_0_stall_in = 1'b0;
assign SFC_2_VALID_10_11_0_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		SFC_2_VALID_10_11_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (SFC_2_VALID_10_11_0_output_regs_ready)
		begin
			SFC_2_VALID_10_11_0_NO_SHIFT_REG <= SFC_2_VALID_9_10_0_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_reduction_10_stall_local;
wire [31:0] local_bb1_reduction_10;

assign local_bb1_reduction_10 = ((local_bb1_mul20_116_add744 & 32'h7FFE) + 32'h80);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_118_add1674_stall_local;
wire [31:0] local_bb1_mul23_118_add1674;

assign local_bb1_mul23_118_add1674 = ((local_bb1_mul23_118_add1618 & 32'hFFF) + (local_bb1_var__u52 & 32'hFF0));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_19_stall_local;
wire [31:0] local_bb1_reduction_19;

assign local_bb1_reduction_19 = ((local_bb1_mul20_234_add372 & 32'h7FFE) + 32'h80);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_236_add1364_stall_local;
wire [31:0] local_bb1_mul23_236_add1364;

assign local_bb1_mul23_236_add1364 = ((local_bb1_mul23_236_add1308 & 32'hFFF) + (local_bb1_var__u57 & 32'hFF0));

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_shr26_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_shr26_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_shr26_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_shr26_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_shr26_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_shr26_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_shr26_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_shr26_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in((local_bb1_shr26 & 32'h3FF)),
	.data_out(rnode_7to8_bb1_shr26_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_shr26_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_shr26_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_shr26_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_shr26_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_shr26_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_shr26_stall_in = 1'b0;
assign rnode_7to8_bb1_shr26_0_NO_SHIFT_REG = rnode_7to8_bb1_shr26_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_shr26_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_shr26_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_shr26_2_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_2_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_shr26_2_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_2_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_shr26_2_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_2_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_2_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_2_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_shr26_2_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_shr26_2_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_shr26_2_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_shr26_2_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_shr26_2_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in((local_bb1_shr26_2 & 32'h3FF)),
	.data_out(rnode_7to8_bb1_shr26_2_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_shr26_2_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_shr26_2_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_shr26_2_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_shr26_2_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_shr26_2_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_shr26_2_stall_in = 1'b0;
assign rnode_7to8_bb1_shr26_2_0_NO_SHIFT_REG = rnode_7to8_bb1_shr26_2_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_shr26_2_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_shr26_2_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_shr26_2_1_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_2_1_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_shr26_2_1_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_2_1_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_shr26_2_1_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_2_1_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_2_1_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_2_1_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_shr26_2_1_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_shr26_2_1_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_shr26_2_1_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_shr26_2_1_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_shr26_2_1_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in((local_bb1_shr26_2_1 & 32'h3FF)),
	.data_out(rnode_7to8_bb1_shr26_2_1_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_shr26_2_1_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_shr26_2_1_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_shr26_2_1_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_shr26_2_1_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_shr26_2_1_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_shr26_2_1_stall_in = 1'b0;
assign rnode_7to8_bb1_shr26_2_1_0_NO_SHIFT_REG = rnode_7to8_bb1_shr26_2_1_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_shr26_2_1_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_shr26_2_1_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_shr26_1_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_1_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_shr26_1_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_1_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_shr26_1_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_1_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_1_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_1_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_shr26_1_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_shr26_1_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_shr26_1_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_shr26_1_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_shr26_1_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in((local_bb1_shr26_1 & 32'h3FF)),
	.data_out(rnode_7to8_bb1_shr26_1_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_shr26_1_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_shr26_1_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_shr26_1_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_shr26_1_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_shr26_1_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_shr26_1_stall_in = 1'b0;
assign rnode_7to8_bb1_shr26_1_0_NO_SHIFT_REG = rnode_7to8_bb1_shr26_1_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_shr26_1_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_shr26_1_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_7to9_bb1_var__u58_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to9_bb1_var__u58_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to9_bb1_var__u58_0_NO_SHIFT_REG;
 logic rnode_7to9_bb1_var__u58_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to9_bb1_var__u58_0_reg_9_NO_SHIFT_REG;
 logic rnode_7to9_bb1_var__u58_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_7to9_bb1_var__u58_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_7to9_bb1_var__u58_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_7to9_bb1_var__u58_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to9_bb1_var__u58_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to9_bb1_var__u58_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_7to9_bb1_var__u58_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_7to9_bb1_var__u58_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in((local_bb1_var__u58 & 32'h1FFF)),
	.data_out(rnode_7to9_bb1_var__u58_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_7to9_bb1_var__u58_0_reg_9_fifo.DEPTH = 2;
defparam rnode_7to9_bb1_var__u58_0_reg_9_fifo.DATA_WIDTH = 32;
defparam rnode_7to9_bb1_var__u58_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to9_bb1_var__u58_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_7to9_bb1_var__u58_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_var__u58_stall_in = 1'b0;
assign rnode_7to9_bb1_var__u58_0_NO_SHIFT_REG = rnode_7to9_bb1_var__u58_0_reg_9_NO_SHIFT_REG;
assign rnode_7to9_bb1_var__u58_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_7to9_bb1_var__u58_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_shr_1_2_stall_local;
wire [31:0] local_bb1_shr_1_2;

assign local_bb1_shr_1_2 = (local_bb1_vectorpop8_extract0 >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u59_stall_local;
wire [31:0] local_bb1_var__u59;

assign local_bb1_var__u59 = (local_bb1_vectorpop8_extract0 >> 32'hF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u60_stall_local;
wire [31:0] local_bb1_var__u60;

assign local_bb1_var__u60 = (local_bb1_vectorpop8_extract0 >> 32'hA);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u61_stall_local;
wire [31:0] local_bb1_var__u61;

assign local_bb1_var__u61 = (local_bb1_vectorpop8_extract0 >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_2_masked_stall_local;
wire [31:0] local_bb1_mul23_1_2_masked;

assign local_bb1_mul23_1_2_masked = (local_bb1_vectorpop8_extract0 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_2_masked1183_stall_local;
wire [31:0] local_bb1_mul23_1_2_masked1183;

assign local_bb1_mul23_1_2_masked1183 = (local_bb1_vectorpop8_extract0 << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_2_masked1185_stall_local;
wire [31:0] local_bb1_mul23_1_2_masked1185;

assign local_bb1_mul23_1_2_masked1185 = (local_bb1_vectorpop8_extract0 << 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert1_stall_local;
wire [63:0] local_bb1_vectorpush8_insert1;

assign local_bb1_vectorpush8_insert1[31:0] = local_bb1_vectorpush8_insert0[31:0];
assign local_bb1_vectorpush8_insert1[63:32] = local_bb1_vectorpop8_extract0;

// This section implements an unregistered operation.
// 
wire local_bb1_shr_2_2_stall_local;
wire [31:0] local_bb1_shr_2_2;

assign local_bb1_shr_2_2 = (local_bb1_vectorpop8_extract1 >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u62_stall_local;
wire [31:0] local_bb1_var__u62;

assign local_bb1_var__u62 = (local_bb1_vectorpop8_extract1 >> 32'hF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u63_stall_local;
wire [31:0] local_bb1_var__u63;

assign local_bb1_var__u63 = (local_bb1_vectorpop8_extract1 >> 32'hA);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u64_stall_local;
wire [31:0] local_bb1_var__u64;

assign local_bb1_var__u64 = (local_bb1_vectorpop8_extract1 >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_2_masked_stall_local;
wire [31:0] local_bb1_mul23_2_2_masked;

assign local_bb1_mul23_2_2_masked = (local_bb1_vectorpop8_extract1 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_2_masked1121_stall_local;
wire [31:0] local_bb1_mul23_2_2_masked1121;

assign local_bb1_mul23_2_2_masked1121 = (local_bb1_vectorpop8_extract1 << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_2_masked1123_stall_local;
wire [31:0] local_bb1_mul23_2_2_masked1123;

assign local_bb1_mul23_2_2_masked1123 = (local_bb1_vectorpop8_extract1 << 32'h4);

// This section implements a registered operation.
// 
wire SFC_2_VALID_11_12_0_inputs_ready;
 reg SFC_2_VALID_11_12_0_valid_out_NO_SHIFT_REG;
wire SFC_2_VALID_11_12_0_stall_in;
wire SFC_2_VALID_11_12_0_output_regs_ready;
 reg SFC_2_VALID_11_12_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_2_VALID_11_12_0_causedstall;

assign SFC_2_VALID_11_12_0_inputs_ready = 1'b1;
assign SFC_2_VALID_11_12_0_output_regs_ready = 1'b1;
assign SFC_2_VALID_10_11_0_stall_in = 1'b0;
assign SFC_2_VALID_11_12_0_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		SFC_2_VALID_11_12_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (SFC_2_VALID_11_12_0_output_regs_ready)
		begin
			SFC_2_VALID_11_12_0_NO_SHIFT_REG <= SFC_2_VALID_10_11_0_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_reduction_9_stall_local;
wire [31:0] local_bb1_reduction_9;

assign local_bb1_reduction_9 = ((local_bb1_mul23_118_add1674 & 32'h1FFF) + (local_bb1_mul21_117_add682 & 32'hFFFF));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_18_stall_local;
wire [31:0] local_bb1_reduction_18;

assign local_bb1_reduction_18 = ((local_bb1_mul23_236_add1364 & 32'h1FFF) + (local_bb1_mul21_235_add310 & 32'hFFFF));

// This section implements an unregistered operation.
// 
wire local_bb1_mul32_stall_local;
wire [31:0] local_bb1_mul32;

assign local_bb1_mul32 = (32'hFFFFFFF0 - (rnode_7to8_bb1_shr26_0_NO_SHIFT_REG & 32'h3FF));

// This section implements an unregistered operation.
// 
wire local_bb1_mul32_2_stall_local;
wire [31:0] local_bb1_mul32_2;

assign local_bb1_mul32_2 = (32'hFFFFFFF0 - (rnode_7to8_bb1_shr26_2_0_NO_SHIFT_REG & 32'h3FF));

// This section implements an unregistered operation.
// 
wire local_bb1_mul32_2_1_stall_local;
wire [31:0] local_bb1_mul32_2_1;

assign local_bb1_mul32_2_1 = (32'hFFFFFFF0 - (rnode_7to8_bb1_shr26_2_1_0_NO_SHIFT_REG & 32'h3FF));

// This section implements an unregistered operation.
// 
wire local_bb1_mul32_1_stall_local;
wire [31:0] local_bb1_mul32_1;

assign local_bb1_mul32_1 = (32'hFFFFFFF0 - (rnode_7to8_bb1_shr26_1_0_NO_SHIFT_REG & 32'h3FF));

// This section implements an unregistered operation.
// 
wire local_bb1_add27_1_1_stall_local;
wire [31:0] local_bb1_add27_1_1;

assign local_bb1_add27_1_1 = ((rnode_7to9_bb1_var__u58_0_NO_SHIFT_REG & 32'h1FFF) & 32'h7FFFFF8);

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_1_2_masked_stall_local;
wire [31:0] local_bb1_mul21_1_2_masked;

assign local_bb1_mul21_1_2_masked = ((local_bb1_shr_1_2 & 32'hFFFFFF) & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u65_stall_local;
wire [31:0] local_bb1_var__u65;

assign local_bb1_var__u65 = ((local_bb1_var__u59 & 32'h1FFFF) & 32'h1FE);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u66_stall_local;
wire [31:0] local_bb1_var__u66;

assign local_bb1_var__u66 = ((local_bb1_var__u60 & 32'h3FFFFF) & 32'h3FC0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u67_stall_local;
wire [31:0] local_bb1_var__u67;

assign local_bb1_var__u67 = ((local_bb1_var__u61 & 32'h7FFFFFFF) & 32'h7F80);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u68_stall_local;
wire [31:0] local_bb1_var__u68;

assign local_bb1_var__u68 = ((local_bb1_mul23_1_2_masked1183 & 32'hFFFFFFF8) & 32'h7F8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u69_stall_local;
wire [31:0] local_bb1_var__u69;

assign local_bb1_var__u69 = ((local_bb1_mul23_1_2_masked1185 & 32'hFFFFFFF0) & 32'hFF0);

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_2_2_masked_stall_local;
wire [31:0] local_bb1_mul21_2_2_masked;

assign local_bb1_mul21_2_2_masked = ((local_bb1_shr_2_2 & 32'hFFFFFF) & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u70_stall_local;
wire [31:0] local_bb1_var__u70;

assign local_bb1_var__u70 = ((local_bb1_var__u62 & 32'h1FFFF) & 32'h1FE);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u71_stall_local;
wire [31:0] local_bb1_var__u71;

assign local_bb1_var__u71 = ((local_bb1_var__u63 & 32'h3FFFFF) & 32'h3FC0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u72_stall_local;
wire [31:0] local_bb1_var__u72;

assign local_bb1_var__u72 = ((local_bb1_var__u64 & 32'h7FFFFFFF) & 32'h7F80);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u73_stall_local;
wire [31:0] local_bb1_var__u73;

assign local_bb1_var__u73 = ((local_bb1_mul23_2_2_masked1121 & 32'hFFFFFFF8) & 32'h7F8);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u74_stall_local;
wire [31:0] local_bb1_var__u74;

assign local_bb1_var__u74 = ((local_bb1_mul23_2_2_masked1123 & 32'hFFFFFFF0) & 32'hFF0);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_11_stall_local;
wire [31:0] local_bb1_reduction_11;

assign local_bb1_reduction_11 = ((local_bb1_reduction_9 & 32'h1FFFF) + (local_bb1_reduction_10 & 32'hFFFE));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_20_stall_local;
wire [31:0] local_bb1_reduction_20;

assign local_bb1_reduction_20 = ((local_bb1_reduction_18 & 32'h1FFFF) + (local_bb1_reduction_19 & 32'hFFFE));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_30_stall_local;
wire [31:0] local_bb1_reduction_30;

assign local_bb1_reduction_30 = (local_bb1_mul32_1 + local_bb1_mul32);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_34_stall_local;
wire [31:0] local_bb1_reduction_34;

assign local_bb1_reduction_34 = ((local_bb1_add27_1_1 & 32'h1FF8) + 32'h80);

// This section implements an unregistered operation.
// 
wire local_bb1_mul20_1_2_add248_stall_local;
wire [31:0] local_bb1_mul20_1_2_add248;

assign local_bb1_mul20_1_2_add248 = ((local_bb1_var__u65 & 32'h1FE) + (local_bb1_var__u66 & 32'h3FC0));

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_1_2_add186_stall_local;
wire [31:0] local_bb1_mul21_1_2_add186;

assign local_bb1_mul21_1_2_add186 = ((local_bb1_mul21_1_2_masked & 32'hFF) + (local_bb1_var__u67 & 32'h7F80));

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_2_add1184_stall_local;
wire [31:0] local_bb1_mul23_1_2_add1184;

assign local_bb1_mul23_1_2_add1184 = ((local_bb1_mul23_1_2_masked & 32'hFF) + (local_bb1_var__u68 & 32'h7F8));

// This section implements an unregistered operation.
// 
wire local_bb1_mul20_2_2_add124_stall_local;
wire [31:0] local_bb1_mul20_2_2_add124;

assign local_bb1_mul20_2_2_add124 = ((local_bb1_var__u70 & 32'h1FE) + (local_bb1_var__u71 & 32'h3FC0));

// This section implements an unregistered operation.
// 
wire local_bb1_mul21_2_2_add62_stall_local;
wire [31:0] local_bb1_mul21_2_2_add62;

assign local_bb1_mul21_2_2_add62 = ((local_bb1_mul21_2_2_masked & 32'hFF) + (local_bb1_var__u72 & 32'h7F80));

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_2_add1122_stall_local;
wire [31:0] local_bb1_mul23_2_2_add1122;

assign local_bb1_mul23_2_2_add1122 = ((local_bb1_mul23_2_2_masked & 32'hFF) + (local_bb1_var__u73 & 32'h7F8));

// This section implements an unregistered operation.
// 
wire local_bb1_shr26_122_valid_out;
wire local_bb1_shr26_122_stall_in;
wire local_bb1_shr26_122_inputs_ready;
wire local_bb1_shr26_122_stall_local;
wire [31:0] local_bb1_shr26_122;

assign local_bb1_shr26_122_inputs_ready = (rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_0_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_3_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_4_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_5_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_6_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_1_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract0_0_valid_out_2_NO_SHIFT_REG);
assign local_bb1_shr26_122 = ((local_bb1_reduction_11 & 32'h3FFFF) >> 32'h8);
assign local_bb1_shr26_122_valid_out = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_4_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_5_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_6_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract0_0_stall_in_2_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_shr26_240_valid_out;
wire local_bb1_shr26_240_stall_in;
wire local_bb1_shr26_240_inputs_ready;
wire local_bb1_shr26_240_stall_local;
wire [31:0] local_bb1_shr26_240;

assign local_bb1_shr26_240_inputs_ready = (rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_0_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_3_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_4_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_5_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_6_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_1_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_2_NO_SHIFT_REG);
assign local_bb1_shr26_240 = ((local_bb1_reduction_20 & 32'h3FFFF) >> 32'h8);
assign local_bb1_shr26_240_valid_out = 1'b1;
assign rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_4_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_5_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_6_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_2_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_22_stall_local;
wire [31:0] local_bb1_reduction_22;

assign local_bb1_reduction_22 = ((local_bb1_mul20_1_2_add248 & 32'h7FFE) + 32'h80);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_1_2_add1240_stall_local;
wire [31:0] local_bb1_mul23_1_2_add1240;

assign local_bb1_mul23_1_2_add1240 = ((local_bb1_mul23_1_2_add1184 & 32'hFFF) + (local_bb1_var__u69 & 32'hFF0));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_25_stall_local;
wire [31:0] local_bb1_reduction_25;

assign local_bb1_reduction_25 = ((local_bb1_mul20_2_2_add124 & 32'h7FFE) + 32'h80);

// This section implements an unregistered operation.
// 
wire local_bb1_mul23_2_2_add1178_stall_local;
wire [31:0] local_bb1_mul23_2_2_add1178;

assign local_bb1_mul23_2_2_add1178 = ((local_bb1_mul23_2_2_add1122 & 32'hFFF) + (local_bb1_var__u74 & 32'hFF0));

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_shr26_122_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_122_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_shr26_122_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_122_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_shr26_122_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_122_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_122_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_122_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_shr26_122_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_shr26_122_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_shr26_122_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_shr26_122_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_shr26_122_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in((local_bb1_shr26_122 & 32'h3FF)),
	.data_out(rnode_7to8_bb1_shr26_122_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_shr26_122_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_shr26_122_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_shr26_122_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_shr26_122_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_shr26_122_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_shr26_122_stall_in = 1'b0;
assign rnode_7to8_bb1_shr26_122_0_NO_SHIFT_REG = rnode_7to8_bb1_shr26_122_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_shr26_122_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_shr26_122_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_shr26_240_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_240_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_shr26_240_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_240_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_shr26_240_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_240_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_240_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_shr26_240_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_shr26_240_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_shr26_240_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_shr26_240_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_shr26_240_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_shr26_240_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in((local_bb1_shr26_240 & 32'h3FF)),
	.data_out(rnode_7to8_bb1_shr26_240_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_shr26_240_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_shr26_240_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_shr26_240_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_shr26_240_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_shr26_240_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_shr26_240_stall_in = 1'b0;
assign rnode_7to8_bb1_shr26_240_0_NO_SHIFT_REG = rnode_7to8_bb1_shr26_240_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_shr26_240_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_shr26_240_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_21_stall_local;
wire [31:0] local_bb1_reduction_21;

assign local_bb1_reduction_21 = ((local_bb1_mul23_1_2_add1240 & 32'h1FFF) + (local_bb1_mul21_1_2_add186 & 32'hFFFF));

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert1_valid_out;
wire local_bb1_vectorpush8_insert1_stall_in;
wire local_bb1_reduction_21_valid_out;
wire local_bb1_reduction_21_stall_in;
wire local_bb1_reduction_22_valid_out;
wire local_bb1_reduction_22_stall_in;
wire local_bb1_reduction_24_valid_out;
wire local_bb1_reduction_24_stall_in;
wire local_bb1_reduction_25_valid_out;
wire local_bb1_reduction_25_stall_in;
wire local_bb1_reduction_24_inputs_ready;
wire local_bb1_reduction_24_stall_local;
wire [31:0] local_bb1_reduction_24;

assign local_bb1_reduction_24_inputs_ready = (rnode_6to7_bb1_c0_ene1_0_valid_out_0_NO_SHIFT_REG & SFC_2_VALID_6_7_0_valid_out_1_NO_SHIFT_REG & rnode_6to7_bb1_c0_ene1_0_valid_out_1_NO_SHIFT_REG & rnode_6to7_bb1_vectorpop3_extract1_0_valid_out_7_NO_SHIFT_REG);
assign local_bb1_reduction_24 = ((local_bb1_mul23_2_2_add1178 & 32'h1FFF) + (local_bb1_mul21_2_2_add62 & 32'hFFFF));
assign local_bb1_vectorpush8_insert1_valid_out = 1'b1;
assign local_bb1_reduction_21_valid_out = 1'b1;
assign local_bb1_reduction_22_valid_out = 1'b1;
assign local_bb1_reduction_24_valid_out = 1'b1;
assign local_bb1_reduction_25_valid_out = 1'b1;
assign rnode_6to7_bb1_c0_ene1_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign SFC_2_VALID_6_7_0_stall_in_1 = 1'b0;
assign rnode_6to7_bb1_c0_ene1_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_vectorpop3_extract1_0_stall_in_7_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_mul32_125_stall_local;
wire [31:0] local_bb1_mul32_125;

assign local_bb1_mul32_125 = (32'hFFFFFFF0 - (rnode_7to8_bb1_shr26_122_0_NO_SHIFT_REG & 32'h3FF));

// This section implements an unregistered operation.
// 
wire local_bb1_mul32_243_stall_local;
wire [31:0] local_bb1_mul32_243;

assign local_bb1_mul32_243 = (32'hFFFFFFF0 - (rnode_7to8_bb1_shr26_240_0_NO_SHIFT_REG & 32'h3FF));

// This section implements a registered operation.
// 
wire local_bb1_vectorpush8_vectorpush8_insert1_inputs_ready;
wire local_bb1_vectorpush8_vectorpush8_insert1_output_regs_ready;
wire [63:0] local_bb1_vectorpush8_vectorpush8_insert1_result;
wire local_bb1_vectorpush8_vectorpush8_insert1_fu_valid_out;
wire local_bb1_vectorpush8_vectorpush8_insert1_fu_stall_out;
 reg [63:0] local_bb1_vectorpush8_vectorpush8_insert1_NO_SHIFT_REG;
wire local_bb1_vectorpush8_vectorpush8_insert1_causedstall;

acl_push local_bb1_vectorpush8_vectorpush8_insert1_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(rnode_6to7_bb1_c0_ene3_0_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpush8_insert1),
	.stall_out(local_bb1_vectorpush8_vectorpush8_insert1_fu_stall_out),
	.valid_in(SFC_2_VALID_6_7_0_NO_SHIFT_REG),
	.valid_out(local_bb1_vectorpush8_vectorpush8_insert1_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_vectorpush8_vectorpush8_insert1_result),
	.feedback_out(feedback_data_out_8),
	.feedback_valid_out(feedback_valid_out_8),
	.feedback_stall_in(feedback_stall_in_8)
);

defparam local_bb1_vectorpush8_vectorpush8_insert1_feedback.STALLFREE = 1;
defparam local_bb1_vectorpush8_vectorpush8_insert1_feedback.ENABLED = 0;
defparam local_bb1_vectorpush8_vectorpush8_insert1_feedback.DATA_WIDTH = 64;
defparam local_bb1_vectorpush8_vectorpush8_insert1_feedback.FIFO_DEPTH = 1;
defparam local_bb1_vectorpush8_vectorpush8_insert1_feedback.MIN_FIFO_LATENCY = 1;
defparam local_bb1_vectorpush8_vectorpush8_insert1_feedback.STYLE = "REGULAR";
defparam local_bb1_vectorpush8_vectorpush8_insert1_feedback.RAM_FIFO_DEPTH_INC = 1;

assign local_bb1_vectorpush8_vectorpush8_insert1_inputs_ready = 1'b1;
assign local_bb1_vectorpush8_vectorpush8_insert1_output_regs_ready = 1'b1;
assign local_bb1_vectorpush8_insert1_stall_in = 1'b0;
assign SFC_2_VALID_6_7_0_stall_in_2 = 1'b0;
assign rnode_6to7_bb1_c0_ene3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign local_bb1_vectorpush8_vectorpush8_insert1_causedstall = (SFC_2_VALID_6_7_0_NO_SHIFT_REG && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_vectorpush8_vectorpush8_insert1_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_vectorpush8_vectorpush8_insert1_output_regs_ready)
		begin
			local_bb1_vectorpush8_vectorpush8_insert1_NO_SHIFT_REG <= local_bb1_vectorpush8_vectorpush8_insert1_result;
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_reduction_21_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_21_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_reduction_21_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_21_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_reduction_21_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_21_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_21_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_21_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_reduction_21_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_reduction_21_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_reduction_21_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_reduction_21_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_reduction_21_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in((local_bb1_reduction_21 & 32'h1FFFF)),
	.data_out(rnode_7to8_bb1_reduction_21_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_reduction_21_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_reduction_21_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_reduction_21_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_reduction_21_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_reduction_21_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_21_stall_in = 1'b0;
assign rnode_7to8_bb1_reduction_21_0_NO_SHIFT_REG = rnode_7to8_bb1_reduction_21_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_reduction_21_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_reduction_21_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_reduction_22_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_22_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_reduction_22_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_22_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_reduction_22_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_22_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_22_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_22_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_reduction_22_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_reduction_22_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_reduction_22_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_reduction_22_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_reduction_22_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in((local_bb1_reduction_22 & 32'hFFFE)),
	.data_out(rnode_7to8_bb1_reduction_22_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_reduction_22_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_reduction_22_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_reduction_22_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_reduction_22_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_reduction_22_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_22_stall_in = 1'b0;
assign rnode_7to8_bb1_reduction_22_0_NO_SHIFT_REG = rnode_7to8_bb1_reduction_22_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_reduction_22_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_reduction_22_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_reduction_24_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_24_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_reduction_24_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_24_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_reduction_24_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_24_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_24_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_24_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_reduction_24_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_reduction_24_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_reduction_24_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_reduction_24_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_reduction_24_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in((local_bb1_reduction_24 & 32'h1FFFF)),
	.data_out(rnode_7to8_bb1_reduction_24_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_reduction_24_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_reduction_24_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_reduction_24_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_reduction_24_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_reduction_24_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_24_stall_in = 1'b0;
assign rnode_7to8_bb1_reduction_24_0_NO_SHIFT_REG = rnode_7to8_bb1_reduction_24_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_reduction_24_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_reduction_24_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_reduction_25_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_25_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_reduction_25_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_25_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_reduction_25_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_25_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_25_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_reduction_25_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_reduction_25_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_reduction_25_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_reduction_25_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_reduction_25_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_reduction_25_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in((local_bb1_reduction_25 & 32'hFFFE)),
	.data_out(rnode_7to8_bb1_reduction_25_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_reduction_25_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_reduction_25_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_reduction_25_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_reduction_25_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_reduction_25_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_25_stall_in = 1'b0;
assign rnode_7to8_bb1_reduction_25_0_NO_SHIFT_REG = rnode_7to8_bb1_reduction_25_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_reduction_25_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_reduction_25_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_29_stall_local;
wire [31:0] local_bb1_reduction_29;

assign local_bb1_reduction_29 = (local_bb1_mul32_125 + local_bb1_mul32_2);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_28_valid_out;
wire local_bb1_reduction_28_stall_in;
wire local_bb1_reduction_28_inputs_ready;
wire local_bb1_reduction_28_stall_local;
wire [31:0] local_bb1_reduction_28;

assign local_bb1_reduction_28_inputs_ready = (rnode_7to8_bb1_shr26_2_1_0_valid_out_NO_SHIFT_REG & rnode_7to8_bb1_shr26_240_0_valid_out_NO_SHIFT_REG);
assign local_bb1_reduction_28 = (local_bb1_mul32_243 + local_bb1_mul32_2_1);
assign local_bb1_reduction_28_valid_out = 1'b1;
assign rnode_7to8_bb1_shr26_2_1_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_shr26_240_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_23_stall_local;
wire [31:0] local_bb1_reduction_23;

assign local_bb1_reduction_23 = ((rnode_7to8_bb1_reduction_21_0_NO_SHIFT_REG & 32'h1FFFF) + (rnode_7to8_bb1_reduction_22_0_NO_SHIFT_REG & 32'hFFFE));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_26_stall_local;
wire [31:0] local_bb1_reduction_26;

assign local_bb1_reduction_26 = ((rnode_7to8_bb1_reduction_24_0_NO_SHIFT_REG & 32'h1FFFF) + (rnode_7to8_bb1_reduction_25_0_NO_SHIFT_REG & 32'hFFFE));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_32_valid_out;
wire local_bb1_reduction_32_stall_in;
wire local_bb1_reduction_32_inputs_ready;
wire local_bb1_reduction_32_stall_local;
wire [31:0] local_bb1_reduction_32;

assign local_bb1_reduction_32_inputs_ready = (rnode_7to8_bb1_shr26_0_valid_out_NO_SHIFT_REG & rnode_7to8_bb1_shr26_1_0_valid_out_NO_SHIFT_REG & rnode_7to8_bb1_shr26_2_0_valid_out_NO_SHIFT_REG & rnode_7to8_bb1_shr26_122_0_valid_out_NO_SHIFT_REG);
assign local_bb1_reduction_32 = (local_bb1_reduction_29 + local_bb1_reduction_30);
assign local_bb1_reduction_32_valid_out = 1'b1;
assign rnode_7to8_bb1_shr26_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_shr26_1_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_shr26_2_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_shr26_122_0_stall_in_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_reduction_28_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_28_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_reduction_28_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_28_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_reduction_28_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_28_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_28_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_28_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_reduction_28_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_reduction_28_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_reduction_28_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_reduction_28_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_reduction_28_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb1_reduction_28),
	.data_out(rnode_8to9_bb1_reduction_28_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_reduction_28_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_reduction_28_0_reg_9_fifo.DATA_WIDTH = 32;
defparam rnode_8to9_bb1_reduction_28_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_reduction_28_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_reduction_28_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_28_stall_in = 1'b0;
assign rnode_8to9_bb1_reduction_28_0_NO_SHIFT_REG = rnode_8to9_bb1_reduction_28_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_reduction_28_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_reduction_28_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_shr26_1_2_stall_local;
wire [31:0] local_bb1_shr26_1_2;

assign local_bb1_shr26_1_2 = ((local_bb1_reduction_23 & 32'h3FFFF) >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_shr26_2_2_stall_local;
wire [31:0] local_bb1_shr26_2_2;

assign local_bb1_shr26_2_2 = ((local_bb1_reduction_26 & 32'h3FFFF) >> 32'h8);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_reduction_32_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_32_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_reduction_32_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_32_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_reduction_32_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_32_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_32_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_32_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_reduction_32_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_reduction_32_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_reduction_32_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_reduction_32_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_reduction_32_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb1_reduction_32),
	.data_out(rnode_8to9_bb1_reduction_32_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_reduction_32_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_reduction_32_0_reg_9_fifo.DATA_WIDTH = 32;
defparam rnode_8to9_bb1_reduction_32_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_reduction_32_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_reduction_32_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_32_stall_in = 1'b0;
assign rnode_8to9_bb1_reduction_32_0_NO_SHIFT_REG = rnode_8to9_bb1_reduction_32_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_reduction_32_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_reduction_32_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_mul32_1_2_stall_local;
wire [31:0] local_bb1_mul32_1_2;

assign local_bb1_mul32_1_2 = (32'hFFFFFFF0 - (local_bb1_shr26_1_2 & 32'h3FF));

// This section implements an unregistered operation.
// 
wire local_bb1_mul32_2_2_stall_local;
wire [31:0] local_bb1_mul32_2_2;

assign local_bb1_mul32_2_2 = (32'hFFFFFFF0 - (local_bb1_shr26_2_2 & 32'h3FF));

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_27_valid_out;
wire local_bb1_reduction_27_stall_in;
wire local_bb1_reduction_27_inputs_ready;
wire local_bb1_reduction_27_stall_local;
wire [31:0] local_bb1_reduction_27;

assign local_bb1_reduction_27_inputs_ready = (rnode_7to8_bb1_reduction_21_0_valid_out_NO_SHIFT_REG & rnode_7to8_bb1_reduction_22_0_valid_out_NO_SHIFT_REG & rnode_7to8_bb1_reduction_24_0_valid_out_NO_SHIFT_REG & rnode_7to8_bb1_reduction_25_0_valid_out_NO_SHIFT_REG);
assign local_bb1_reduction_27 = (local_bb1_mul32_2_2 + local_bb1_mul32_1_2);
assign local_bb1_reduction_27_valid_out = 1'b1;
assign rnode_7to8_bb1_reduction_21_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_reduction_22_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_reduction_24_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_reduction_25_0_stall_in_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_reduction_27_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_27_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_reduction_27_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_27_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_reduction_27_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_27_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_27_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_reduction_27_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_reduction_27_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_reduction_27_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_reduction_27_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_reduction_27_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_reduction_27_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb1_reduction_27),
	.data_out(rnode_8to9_bb1_reduction_27_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_reduction_27_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_reduction_27_0_reg_9_fifo.DATA_WIDTH = 32;
defparam rnode_8to9_bb1_reduction_27_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_reduction_27_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_reduction_27_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_27_stall_in = 1'b0;
assign rnode_8to9_bb1_reduction_27_0_NO_SHIFT_REG = rnode_8to9_bb1_reduction_27_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_reduction_27_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_reduction_27_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_31_stall_local;
wire [31:0] local_bb1_reduction_31;

assign local_bb1_reduction_31 = (rnode_8to9_bb1_reduction_27_0_NO_SHIFT_REG + rnode_8to9_bb1_reduction_28_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_33_stall_local;
wire [31:0] local_bb1_reduction_33;

assign local_bb1_reduction_33 = (local_bb1_reduction_31 + rnode_8to9_bb1_reduction_32_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_35_valid_out;
wire local_bb1_reduction_35_stall_in;
wire local_bb1_reduction_35_inputs_ready;
wire local_bb1_reduction_35_stall_local;
wire [31:0] local_bb1_reduction_35;

assign local_bb1_reduction_35_inputs_ready = (rnode_7to9_bb1_var__u58_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb1_reduction_27_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb1_reduction_28_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb1_reduction_32_0_valid_out_NO_SHIFT_REG);
assign local_bb1_reduction_35 = (local_bb1_reduction_33 + (local_bb1_reduction_34 & 32'h3FF8));
assign local_bb1_reduction_35_valid_out = 1'b1;
assign rnode_7to9_bb1_var__u58_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_reduction_27_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_reduction_28_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_reduction_32_0_stall_in_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_9to10_bb1_reduction_35_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_35_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb1_reduction_35_0_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_35_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_35_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb1_reduction_35_1_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_35_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_35_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb1_reduction_35_2_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_35_0_reg_10_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb1_reduction_35_0_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_35_0_valid_out_0_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_35_0_stall_in_0_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_35_0_stall_out_reg_10_NO_SHIFT_REG;

acl_data_fifo rnode_9to10_bb1_reduction_35_0_reg_10_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_9to10_bb1_reduction_35_0_reg_10_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_9to10_bb1_reduction_35_0_stall_in_0_reg_10_NO_SHIFT_REG),
	.valid_out(rnode_9to10_bb1_reduction_35_0_valid_out_0_reg_10_NO_SHIFT_REG),
	.stall_out(rnode_9to10_bb1_reduction_35_0_stall_out_reg_10_NO_SHIFT_REG),
	.data_in(local_bb1_reduction_35),
	.data_out(rnode_9to10_bb1_reduction_35_0_reg_10_NO_SHIFT_REG)
);

defparam rnode_9to10_bb1_reduction_35_0_reg_10_fifo.DEPTH = 1;
defparam rnode_9to10_bb1_reduction_35_0_reg_10_fifo.DATA_WIDTH = 32;
defparam rnode_9to10_bb1_reduction_35_0_reg_10_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_9to10_bb1_reduction_35_0_reg_10_fifo.IMPL = "shift_reg";

assign rnode_9to10_bb1_reduction_35_0_reg_10_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_35_stall_in = 1'b0;
assign rnode_9to10_bb1_reduction_35_0_stall_in_0_reg_10_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb1_reduction_35_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_9to10_bb1_reduction_35_0_NO_SHIFT_REG = rnode_9to10_bb1_reduction_35_0_reg_10_NO_SHIFT_REG;
assign rnode_9to10_bb1_reduction_35_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_9to10_bb1_reduction_35_1_NO_SHIFT_REG = rnode_9to10_bb1_reduction_35_0_reg_10_NO_SHIFT_REG;
assign rnode_9to10_bb1_reduction_35_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_9to10_bb1_reduction_35_2_NO_SHIFT_REG = rnode_9to10_bb1_reduction_35_0_reg_10_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_sub_i_stall_local;
wire [31:0] local_bb1_sub_i;

assign local_bb1_sub_i = (32'h0 - rnode_9to10_bb1_reduction_35_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp_i_stall_local;
wire local_bb1_cmp_i;

assign local_bb1_cmp_i = ($signed(rnode_9to10_bb1_reduction_35_1_NO_SHIFT_REG) < $signed(32'h0));

// This section implements an unregistered operation.
// 
wire local_bb1_cond_i_valid_out;
wire local_bb1_cond_i_stall_in;
wire local_bb1_cond_i_inputs_ready;
wire local_bb1_cond_i_stall_local;
wire [31:0] local_bb1_cond_i;

assign local_bb1_cond_i_inputs_ready = (rnode_9to10_bb1_reduction_35_0_valid_out_0_NO_SHIFT_REG & rnode_9to10_bb1_reduction_35_0_valid_out_2_NO_SHIFT_REG & rnode_9to10_bb1_reduction_35_0_valid_out_1_NO_SHIFT_REG);
assign local_bb1_cond_i = (local_bb1_cmp_i ? local_bb1_sub_i : rnode_9to10_bb1_reduction_35_2_NO_SHIFT_REG);
assign local_bb1_cond_i_valid_out = 1'b1;
assign rnode_9to10_bb1_reduction_35_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb1_reduction_35_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb1_reduction_35_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_10to11_bb1_cond_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_10to11_bb1_cond_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_10to11_bb1_cond_i_0_NO_SHIFT_REG;
 logic rnode_10to11_bb1_cond_i_0_reg_11_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_10to11_bb1_cond_i_0_reg_11_NO_SHIFT_REG;
 logic rnode_10to11_bb1_cond_i_0_valid_out_reg_11_NO_SHIFT_REG;
 logic rnode_10to11_bb1_cond_i_0_stall_in_reg_11_NO_SHIFT_REG;
 logic rnode_10to11_bb1_cond_i_0_stall_out_reg_11_NO_SHIFT_REG;

acl_data_fifo rnode_10to11_bb1_cond_i_0_reg_11_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_10to11_bb1_cond_i_0_reg_11_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_10to11_bb1_cond_i_0_stall_in_reg_11_NO_SHIFT_REG),
	.valid_out(rnode_10to11_bb1_cond_i_0_valid_out_reg_11_NO_SHIFT_REG),
	.stall_out(rnode_10to11_bb1_cond_i_0_stall_out_reg_11_NO_SHIFT_REG),
	.data_in(local_bb1_cond_i),
	.data_out(rnode_10to11_bb1_cond_i_0_reg_11_NO_SHIFT_REG)
);

defparam rnode_10to11_bb1_cond_i_0_reg_11_fifo.DEPTH = 1;
defparam rnode_10to11_bb1_cond_i_0_reg_11_fifo.DATA_WIDTH = 32;
defparam rnode_10to11_bb1_cond_i_0_reg_11_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_10to11_bb1_cond_i_0_reg_11_fifo.IMPL = "shift_reg";

assign rnode_10to11_bb1_cond_i_0_reg_11_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cond_i_stall_in = 1'b0;
assign rnode_10to11_bb1_cond_i_0_NO_SHIFT_REG = rnode_10to11_bb1_cond_i_0_reg_11_NO_SHIFT_REG;
assign rnode_10to11_bb1_cond_i_0_stall_in_reg_11_NO_SHIFT_REG = 1'b0;
assign rnode_10to11_bb1_cond_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_cmp39_valid_out;
wire local_bb1_cmp39_stall_in;
wire local_bb1_cmp39_inputs_ready;
wire local_bb1_cmp39_stall_local;
wire local_bb1_cmp39;

assign local_bb1_cmp39_inputs_ready = rnode_10to11_bb1_cond_i_0_valid_out_NO_SHIFT_REG;
assign local_bb1_cmp39 = (rnode_10to11_bb1_cond_i_0_NO_SHIFT_REG > input_threshold);
assign local_bb1_cmp39_valid_out = 1'b1;
assign rnode_10to11_bb1_cond_i_0_stall_in_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_11to12_bb1_cmp39_0_valid_out_NO_SHIFT_REG;
 logic rnode_11to12_bb1_cmp39_0_stall_in_NO_SHIFT_REG;
 logic rnode_11to12_bb1_cmp39_0_NO_SHIFT_REG;
 logic rnode_11to12_bb1_cmp39_0_reg_12_inputs_ready_NO_SHIFT_REG;
 logic rnode_11to12_bb1_cmp39_0_reg_12_NO_SHIFT_REG;
 logic rnode_11to12_bb1_cmp39_0_valid_out_reg_12_NO_SHIFT_REG;
 logic rnode_11to12_bb1_cmp39_0_stall_in_reg_12_NO_SHIFT_REG;
 logic rnode_11to12_bb1_cmp39_0_stall_out_reg_12_NO_SHIFT_REG;

acl_data_fifo rnode_11to12_bb1_cmp39_0_reg_12_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_11to12_bb1_cmp39_0_reg_12_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_11to12_bb1_cmp39_0_stall_in_reg_12_NO_SHIFT_REG),
	.valid_out(rnode_11to12_bb1_cmp39_0_valid_out_reg_12_NO_SHIFT_REG),
	.stall_out(rnode_11to12_bb1_cmp39_0_stall_out_reg_12_NO_SHIFT_REG),
	.data_in(local_bb1_cmp39),
	.data_out(rnode_11to12_bb1_cmp39_0_reg_12_NO_SHIFT_REG)
);

defparam rnode_11to12_bb1_cmp39_0_reg_12_fifo.DEPTH = 1;
defparam rnode_11to12_bb1_cmp39_0_reg_12_fifo.DATA_WIDTH = 1;
defparam rnode_11to12_bb1_cmp39_0_reg_12_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_11to12_bb1_cmp39_0_reg_12_fifo.IMPL = "shift_reg";

assign rnode_11to12_bb1_cmp39_0_reg_12_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp39_stall_in = 1'b0;
assign rnode_11to12_bb1_cmp39_0_NO_SHIFT_REG = rnode_11to12_bb1_cmp39_0_reg_12_NO_SHIFT_REG;
assign rnode_11to12_bb1_cmp39_0_stall_in_reg_12_NO_SHIFT_REG = 1'b0;
assign rnode_11to12_bb1_cmp39_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1___u75_stall_local;
wire [31:0] local_bb1___u75;

assign local_bb1___u75 = (rnode_11to12_bb1_cmp39_0_NO_SHIFT_REG ? 32'hFFFFFF : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_c0_exi1_valid_out;
wire local_bb1_c0_exi1_stall_in;
wire local_bb1_c0_exi1_inputs_ready;
wire local_bb1_c0_exi1_stall_local;
wire [63:0] local_bb1_c0_exi1;

assign local_bb1_c0_exi1_inputs_ready = rnode_11to12_bb1_cmp39_0_valid_out_NO_SHIFT_REG;
assign local_bb1_c0_exi1[31:0] = 32'bx;
assign local_bb1_c0_exi1[63:32] = (local_bb1___u75 & 32'hFFFFFF);
assign local_bb1_c0_exi1_valid_out = 1'b1;
assign rnode_11to12_bb1_cmp39_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements a registered operation.
// 
wire local_bb1_c0_exit_c0_exi1_inputs_ready;
 reg local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG;
wire local_bb1_c0_exit_c0_exi1_stall_in;
 reg [63:0] local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG;
wire [63:0] local_bb1_c0_exit_c0_exi1_in;
wire local_bb1_c0_exit_c0_exi1_valid;
wire local_bb1_c0_exit_c0_exi1_causedstall;

acl_stall_free_sink local_bb1_c0_exit_c0_exi1_instance (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb1_c0_exi1),
	.data_out(local_bb1_c0_exit_c0_exi1_in),
	.input_accepted(local_bb1_c0_enter_c0_eni5_input_accepted),
	.valid_out(local_bb1_c0_exit_c0_exi1_valid),
	.stall_in(~(local_bb1_c0_exit_c0_exi1_output_regs_ready)),
	.stall_entry(local_bb1_c0_exit_c0_exi1_entry_stall),
	.valid_in(local_bb1_c0_exit_c0_exi1_valid_in),
	.IIphases(local_bb1_c0_exit_c0_exi1_phases),
	.inc_pipelined_thread(local_bb1_c0_enter_c0_eni5_inc_pipelined_thread),
	.dec_pipelined_thread(local_bb1_c0_enter_c0_eni5_dec_pipelined_thread)
);

defparam local_bb1_c0_exit_c0_exi1_instance.DATA_WIDTH = 64;
defparam local_bb1_c0_exit_c0_exi1_instance.PIPELINE_DEPTH = 12;
defparam local_bb1_c0_exit_c0_exi1_instance.SHARINGII = 1;
defparam local_bb1_c0_exit_c0_exi1_instance.SCHEDULEII = 1;
defparam local_bb1_c0_exit_c0_exi1_instance.ALWAYS_THROTTLE = 0;

assign local_bb1_c0_exit_c0_exi1_inputs_ready = 1'b1;
assign local_bb1_c0_exit_c0_exi1_output_regs_ready = (&(~(local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG) | ~(local_bb1_c0_exit_c0_exi1_stall_in)));
assign local_bb1_c0_exit_c0_exi1_valid_in = SFC_2_VALID_11_12_0_NO_SHIFT_REG;
assign local_bb1_c0_exi1_stall_in = 1'b0;
assign SFC_2_VALID_11_12_0_stall_in = 1'b0;
assign local_bb1_c0_exit_c0_exi1_causedstall = (1'b1 && (1'b0 && !(~(local_bb1_c0_exit_c0_exi1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG <= 'x;
		local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c0_exit_c0_exi1_output_regs_ready)
		begin
			local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi1_in;
			local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi1_valid;
		end
		else
		begin
			if (~(local_bb1_c0_exit_c0_exi1_stall_in))
			begin
				local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_exe1_valid_out;
wire local_bb1_c0_exe1_stall_in;
wire local_bb1_c0_exe1_inputs_ready;
wire local_bb1_c0_exe1_stall_local;
wire [31:0] local_bb1_c0_exe1;

assign local_bb1_c0_exe1_inputs_ready = local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG;
assign local_bb1_c0_exe1[31:0] = local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG[63:32];
assign local_bb1_c0_exe1_valid_out = local_bb1_c0_exe1_inputs_ready;
assign local_bb1_c0_exe1_stall_local = local_bb1_c0_exe1_stall_in;
assign local_bb1_c0_exit_c0_exi1_stall_in = (|local_bb1_c0_exe1_stall_local);

// This section implements a registered operation.
// 
wire local_bb1_st_c0_exe1_inputs_ready;
 reg local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG;
wire local_bb1_st_c0_exe1_stall_in;
wire local_bb1_st_c0_exe1_output_regs_ready;
wire local_bb1_st_c0_exe1_fu_stall_out;
wire local_bb1_st_c0_exe1_fu_valid_out;
wire local_bb1_st_c0_exe1_causedstall;

lsu_top lsu_local_bb1_st_c0_exe1 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb1_st_c0_exe1_fu_stall_out),
	.i_valid(local_bb1_st_c0_exe1_inputs_ready),
	.i_address((rnode_16to17_bb1_c1_exe6_0_NO_SHIFT_REG & 64'hFFFFFFFFFFFFFFFC)),
	.i_writedata((local_bb1_c0_exe1 & 32'hFFFFFF)),
	.i_cmpdata(),
	.i_predicate(rnode_16to17_bb1_c1_exe5_0_NO_SHIFT_REG),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_st_c0_exe1_output_regs_ready)),
	.o_valid(local_bb1_st_c0_exe1_fu_valid_out),
	.o_readdata(),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_st_c0_exe1_active),
	.avm_address(avm_local_bb1_st_c0_exe1_address),
	.avm_read(avm_local_bb1_st_c0_exe1_read),
	.avm_enable(avm_local_bb1_st_c0_exe1_enable),
	.avm_readdata(avm_local_bb1_st_c0_exe1_readdata),
	.avm_write(avm_local_bb1_st_c0_exe1_write),
	.avm_writeack(avm_local_bb1_st_c0_exe1_writeack),
	.avm_burstcount(avm_local_bb1_st_c0_exe1_burstcount),
	.avm_writedata(avm_local_bb1_st_c0_exe1_writedata),
	.avm_byteenable(avm_local_bb1_st_c0_exe1_byteenable),
	.avm_waitrequest(avm_local_bb1_st_c0_exe1_waitrequest),
	.avm_readdatavalid(avm_local_bb1_st_c0_exe1_readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb1_st_c0_exe1.AWIDTH = 30;
defparam lsu_local_bb1_st_c0_exe1.WIDTH_BYTES = 4;
defparam lsu_local_bb1_st_c0_exe1.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_st_c0_exe1.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_st_c0_exe1.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb1_st_c0_exe1.READ = 0;
defparam lsu_local_bb1_st_c0_exe1.ATOMIC = 0;
defparam lsu_local_bb1_st_c0_exe1.WIDTH = 32;
defparam lsu_local_bb1_st_c0_exe1.MWIDTH = 256;
defparam lsu_local_bb1_st_c0_exe1.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_st_c0_exe1.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_st_c0_exe1.KERNEL_SIDE_MEM_LATENCY = 4;
defparam lsu_local_bb1_st_c0_exe1.MEMORY_SIDE_MEM_LATENCY = 8;
defparam lsu_local_bb1_st_c0_exe1.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_st_c0_exe1.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_st_c0_exe1.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_st_c0_exe1.NUMBER_BANKS = 1;
defparam lsu_local_bb1_st_c0_exe1.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_st_c0_exe1.INTENDED_DEVICE_FAMILY = "Cyclone V";
defparam lsu_local_bb1_st_c0_exe1.USEINPUTFIFO = 0;
defparam lsu_local_bb1_st_c0_exe1.USECACHING = 0;
defparam lsu_local_bb1_st_c0_exe1.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_st_c0_exe1.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_st_c0_exe1.ADDRSPACE = 1;
defparam lsu_local_bb1_st_c0_exe1.STYLE = "BURST-COALESCED";
defparam lsu_local_bb1_st_c0_exe1.USE_BYTE_EN = 0;

assign local_bb1_st_c0_exe1_inputs_ready = (local_bb1_c0_exe1_valid_out & rnode_16to17_bb1_c1_exe5_0_valid_out_NO_SHIFT_REG & rnode_16to17_bb1_c1_exe6_0_valid_out_NO_SHIFT_REG);
assign local_bb1_st_c0_exe1_output_regs_ready = (&(~(local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG) | ~(local_bb1_st_c0_exe1_stall_in)));
assign local_bb1_c0_exe1_stall_in = (local_bb1_st_c0_exe1_fu_stall_out | ~(local_bb1_st_c0_exe1_inputs_ready));
assign rnode_16to17_bb1_c1_exe5_0_stall_in_NO_SHIFT_REG = (local_bb1_st_c0_exe1_fu_stall_out | ~(local_bb1_st_c0_exe1_inputs_ready));
assign rnode_16to17_bb1_c1_exe6_0_stall_in_NO_SHIFT_REG = (local_bb1_st_c0_exe1_fu_stall_out | ~(local_bb1_st_c0_exe1_inputs_ready));
assign local_bb1_st_c0_exe1_causedstall = (local_bb1_st_c0_exe1_inputs_ready && (local_bb1_st_c0_exe1_fu_stall_out && !(~(local_bb1_st_c0_exe1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_st_c0_exe1_output_regs_ready)
		begin
			local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG <= local_bb1_st_c0_exe1_fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_st_c0_exe1_stall_in))
			begin
				local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements a staging register.
// 
wire rstag_21to21_bb1_st_c0_exe1_valid_out;
wire rstag_21to21_bb1_st_c0_exe1_stall_in;
wire rstag_21to21_bb1_st_c0_exe1_inputs_ready;
wire rstag_21to21_bb1_st_c0_exe1_stall_local;
 reg rstag_21to21_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG;
wire rstag_21to21_bb1_st_c0_exe1_combined_valid;

assign rstag_21to21_bb1_st_c0_exe1_inputs_ready = local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG;
assign rstag_21to21_bb1_st_c0_exe1_combined_valid = (rstag_21to21_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG | rstag_21to21_bb1_st_c0_exe1_inputs_ready);
assign rstag_21to21_bb1_st_c0_exe1_valid_out = rstag_21to21_bb1_st_c0_exe1_combined_valid;
assign rstag_21to21_bb1_st_c0_exe1_stall_local = rstag_21to21_bb1_st_c0_exe1_stall_in;
assign local_bb1_st_c0_exe1_stall_in = (|rstag_21to21_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_21to21_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (rstag_21to21_bb1_st_c0_exe1_stall_local)
		begin
			if (~(rstag_21to21_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG))
			begin
				rstag_21to21_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG <= rstag_21to21_bb1_st_c0_exe1_inputs_ready;
			end
		end
		else
		begin
			rstag_21to21_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
 reg branch_node_valid_out_0_NO_SHIFT_REG;
 reg branch_compare_result_NO_SHIFT_REG;
wire branch_var__output_regs_ready;
wire combined_branch_stall_in_signal;

assign branch_var__inputs_ready = (rnode_20to21_bb1_c1_exe7_0_valid_out_NO_SHIFT_REG & rstag_21to21_bb1_st_c0_exe1_valid_out);
assign branch_var__output_regs_ready = (~(branch_node_valid_out_0_NO_SHIFT_REG) | (((branch_compare_result_NO_SHIFT_REG != 1'b1) & ~(stall_in_1)) | (~((branch_compare_result_NO_SHIFT_REG != 1'b1)) & ~(stall_in_0))));
assign rnode_20to21_bb1_c1_exe7_0_stall_in_NO_SHIFT_REG = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rstag_21to21_bb1_st_c0_exe1_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign valid_out_0 = (~((branch_compare_result_NO_SHIFT_REG != 1'b1)) & branch_node_valid_out_0_NO_SHIFT_REG);
assign valid_out_1 = ((branch_compare_result_NO_SHIFT_REG != 1'b1) & branch_node_valid_out_0_NO_SHIFT_REG);
assign combined_branch_stall_in_signal = ((((branch_compare_result_NO_SHIFT_REG != 1'b1) & branch_node_valid_out_0_NO_SHIFT_REG) & stall_in_1) | ((~((branch_compare_result_NO_SHIFT_REG != 1'b1)) & branch_node_valid_out_0_NO_SHIFT_REG) & stall_in_0));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		branch_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
		branch_compare_result_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (branch_var__output_regs_ready)
		begin
			branch_node_valid_out_0_NO_SHIFT_REG <= branch_var__inputs_ready;
			branch_compare_result_NO_SHIFT_REG <= rnode_20to21_bb1_c1_exe7_0_NO_SHIFT_REG;
		end
		else
		begin
			if (~(combined_branch_stall_in_signal))
			begin
				branch_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

// altera message_off 10036
// altera message_off 10230
// altera message_off 10858
module laplacian_basic_block_2
	(
		input 		clock,
		input 		resetn,
		input 		valid_in,
		output 		stall_out,
		output 		valid_out,
		input 		stall_in,
		input [31:0] 		workgroup_size,
		input 		start
	);


// Values used for debugging.  These are swept away by synthesis.
wire _entry;
wire _exit;
 reg [31:0] _num_entry_NO_SHIFT_REG;
 reg [31:0] _num_exit_NO_SHIFT_REG;
wire [31:0] _num_live;

assign _entry = ((&valid_in) & ~((|stall_out)));
assign _exit = ((&valid_out) & ~((|stall_in)));
assign _num_live = (_num_entry_NO_SHIFT_REG - _num_exit_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		_num_entry_NO_SHIFT_REG <= 32'h0;
		_num_exit_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		if (_entry)
		begin
			_num_entry_NO_SHIFT_REG <= (_num_entry_NO_SHIFT_REG + 2'h1);
		end
		if (_exit)
		begin
			_num_exit_NO_SHIFT_REG <= (_num_exit_NO_SHIFT_REG + 2'h1);
		end
	end
end



// This section defines the behaviour of the MERGE node
wire merge_node_stall_in;
 reg merge_node_valid_out_NO_SHIFT_REG;
wire merge_stalled_by_successors;
 reg merge_block_selector_NO_SHIFT_REG;
 reg merge_node_valid_in_staging_reg_NO_SHIFT_REG;
 reg is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
 reg invariant_valid_NO_SHIFT_REG;

assign merge_stalled_by_successors = (|(merge_node_stall_in & merge_node_valid_out_NO_SHIFT_REG));
assign stall_out = merge_node_valid_in_staging_reg_NO_SHIFT_REG;

always @(*)
begin
	if ((merge_node_valid_in_staging_reg_NO_SHIFT_REG | valid_in))
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b1;
	end
	else
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b0;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_staging_reg_NO_SHIFT_REG))
			begin
				merge_node_valid_in_staging_reg_NO_SHIFT_REG <= valid_in;
			end
		end
		else
		begin
			merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (~(merge_stalled_by_successors))
		begin
			merge_node_valid_out_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
		end
		else
		begin
			if (~(merge_node_stall_in))
			begin
				merge_node_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		invariant_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		invariant_valid_NO_SHIFT_REG <= (~(start) & (invariant_valid_NO_SHIFT_REG | is_merge_data_to_local_regs_valid_NO_SHIFT_REG));
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
wire branch_var__output_regs_ready;

assign branch_var__inputs_ready = merge_node_valid_out_NO_SHIFT_REG;
assign branch_var__output_regs_ready = ~(stall_in);
assign merge_node_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign valid_out = branch_var__inputs_ready;

endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

// altera message_off 10036
// altera message_off 10230
// altera message_off 10858
module laplacian_function
	(
		input 		clock,
		input 		resetn,
		output 		stall_out,
		input 		valid_in,
		output 		valid_out,
		input 		stall_in,
		output 		avm_local_bb1_ld__enable,
		input [255:0] 		avm_local_bb1_ld__readdata,
		input 		avm_local_bb1_ld__readdatavalid,
		input 		avm_local_bb1_ld__waitrequest,
		output [29:0] 		avm_local_bb1_ld__address,
		output 		avm_local_bb1_ld__read,
		output 		avm_local_bb1_ld__write,
		input 		avm_local_bb1_ld__writeack,
		output [255:0] 		avm_local_bb1_ld__writedata,
		output [31:0] 		avm_local_bb1_ld__byteenable,
		output [4:0] 		avm_local_bb1_ld__burstcount,
		output 		avm_local_bb1_st_c0_exe1_enable,
		input [255:0] 		avm_local_bb1_st_c0_exe1_readdata,
		input 		avm_local_bb1_st_c0_exe1_readdatavalid,
		input 		avm_local_bb1_st_c0_exe1_waitrequest,
		output [29:0] 		avm_local_bb1_st_c0_exe1_address,
		output 		avm_local_bb1_st_c0_exe1_read,
		output 		avm_local_bb1_st_c0_exe1_write,
		input 		avm_local_bb1_st_c0_exe1_writeack,
		output [255:0] 		avm_local_bb1_st_c0_exe1_writedata,
		output [31:0] 		avm_local_bb1_st_c0_exe1_byteenable,
		output [4:0] 		avm_local_bb1_st_c0_exe1_burstcount,
		input 		start,
		input [31:0] 		input_iterations,
		input 		clock2x,
		input [63:0] 		input_frame_in,
		input [63:0] 		input_frame_out,
		input [31:0] 		input_threshold,
		output reg 		has_a_write_pending,
		output reg 		has_a_lsu_active
	);


wire [31:0] workgroup_size;
wire [31:0] cur_cycle;
wire bb_0_stall_out;
wire bb_0_valid_out;
wire bb_0_lvb_bb0_cmp6;
wire bb_1_stall_out_0;
wire bb_1_stall_out_1;
wire bb_1_valid_out_0;
wire bb_1_valid_out_1;
wire bb_1_feedback_stall_out_13;
wire bb_1_feedback_stall_out_0;
wire bb_1_feedback_stall_out_1;
wire bb_1_acl_pipelined_valid;
wire bb_1_acl_pipelined_exiting_valid;
wire bb_1_acl_pipelined_exiting_stall;
wire bb_1_feedback_stall_out_12;
wire bb_1_feedback_valid_out_12;
wire [23:0] bb_1_feedback_data_out_12;
wire bb_1_feedback_valid_out_0;
wire bb_1_feedback_data_out_0;
wire bb_1_feedback_valid_out_13;
wire [39:0] bb_1_feedback_data_out_13;
wire bb_1_feedback_valid_out_1;
wire bb_1_feedback_data_out_1;
wire bb_1_local_bb1_ld__active;
wire bb_1_feedback_stall_out_3;
wire bb_1_feedback_stall_out_6;
wire bb_1_feedback_valid_out_3;
wire [63:0] bb_1_feedback_data_out_3;
wire bb_1_feedback_valid_out_6;
wire [127:0] bb_1_feedback_data_out_6;
wire bb_1_feedback_stall_out_8;
wire bb_1_feedback_valid_out_8;
wire [63:0] bb_1_feedback_data_out_8;
wire bb_1_local_bb1_st_c0_exe1_active;
wire bb_2_stall_out;
wire bb_2_valid_out;
wire feedback_stall_12;
wire feedback_valid_12;
wire [23:0] feedback_data_12;
wire feedback_stall_0;
wire feedback_valid_0;
wire feedback_data_0;
wire feedback_stall_1;
wire feedback_valid_1;
wire feedback_data_1;
wire feedback_stall_13;
wire feedback_valid_13;
wire [39:0] feedback_data_13;
wire feedback_stall_3;
wire feedback_valid_3;
wire [63:0] feedback_data_3;
wire feedback_stall_6;
wire feedback_valid_6;
wire [127:0] feedback_data_6;
wire feedback_stall_8;
wire feedback_valid_8;
wire [63:0] feedback_data_8;
wire loop_limiter_0_stall_out;
wire loop_limiter_0_valid_out;
wire writes_pending;
wire [1:0] lsus_active;

laplacian_basic_block_0 laplacian_basic_block_0 (
	.clock(clock),
	.resetn(resetn),
	.start(start),
	.input_iterations(input_iterations),
	.valid_in(valid_in),
	.stall_out(bb_0_stall_out),
	.valid_out(bb_0_valid_out),
	.stall_in(loop_limiter_0_stall_out),
	.lvb_bb0_cmp6(bb_0_lvb_bb0_cmp6),
	.workgroup_size(workgroup_size)
);


laplacian_basic_block_1 laplacian_basic_block_1 (
	.clock(clock),
	.resetn(resetn),
	.input_frame_in(input_frame_in),
	.input_frame_out(input_frame_out),
	.input_iterations(input_iterations),
	.input_threshold(input_threshold),
	.input_wii_cmp6(bb_0_lvb_bb0_cmp6),
	.valid_in_0(bb_1_acl_pipelined_valid),
	.stall_out_0(bb_1_stall_out_0),
	.input_forked_0(1'b0),
	.valid_in_1(loop_limiter_0_valid_out),
	.stall_out_1(bb_1_stall_out_1),
	.input_forked_1(1'b1),
	.valid_out_0(bb_1_valid_out_0),
	.stall_in_0(bb_2_stall_out),
	.valid_out_1(bb_1_valid_out_1),
	.stall_in_1(1'b0),
	.workgroup_size(workgroup_size),
	.start(start),
	.feedback_valid_in_13(feedback_valid_13),
	.feedback_stall_out_13(feedback_stall_13),
	.feedback_data_in_13(feedback_data_13),
	.feedback_valid_in_0(feedback_valid_0),
	.feedback_stall_out_0(feedback_stall_0),
	.feedback_data_in_0(feedback_data_0),
	.feedback_valid_in_1(feedback_valid_1),
	.feedback_stall_out_1(feedback_stall_1),
	.feedback_data_in_1(feedback_data_1),
	.acl_pipelined_valid(bb_1_acl_pipelined_valid),
	.acl_pipelined_stall(bb_1_stall_out_0),
	.acl_pipelined_exiting_valid(bb_1_acl_pipelined_exiting_valid),
	.acl_pipelined_exiting_stall(bb_1_acl_pipelined_exiting_stall),
	.feedback_valid_in_12(feedback_valid_12),
	.feedback_stall_out_12(feedback_stall_12),
	.feedback_data_in_12(feedback_data_12),
	.feedback_valid_out_12(feedback_valid_12),
	.feedback_stall_in_12(feedback_stall_12),
	.feedback_data_out_12(feedback_data_12),
	.feedback_valid_out_0(feedback_valid_0),
	.feedback_stall_in_0(feedback_stall_0),
	.feedback_data_out_0(feedback_data_0),
	.feedback_valid_out_13(feedback_valid_13),
	.feedback_stall_in_13(feedback_stall_13),
	.feedback_data_out_13(feedback_data_13),
	.feedback_valid_out_1(feedback_valid_1),
	.feedback_stall_in_1(feedback_stall_1),
	.feedback_data_out_1(feedback_data_1),
	.avm_local_bb1_ld__enable(avm_local_bb1_ld__enable),
	.avm_local_bb1_ld__readdata(avm_local_bb1_ld__readdata),
	.avm_local_bb1_ld__readdatavalid(avm_local_bb1_ld__readdatavalid),
	.avm_local_bb1_ld__waitrequest(avm_local_bb1_ld__waitrequest),
	.avm_local_bb1_ld__address(avm_local_bb1_ld__address),
	.avm_local_bb1_ld__read(avm_local_bb1_ld__read),
	.avm_local_bb1_ld__write(avm_local_bb1_ld__write),
	.avm_local_bb1_ld__writeack(avm_local_bb1_ld__writeack),
	.avm_local_bb1_ld__writedata(avm_local_bb1_ld__writedata),
	.avm_local_bb1_ld__byteenable(avm_local_bb1_ld__byteenable),
	.avm_local_bb1_ld__burstcount(avm_local_bb1_ld__burstcount),
	.local_bb1_ld__active(bb_1_local_bb1_ld__active),
	.clock2x(clock2x),
	.feedback_valid_in_3(feedback_valid_3),
	.feedback_stall_out_3(feedback_stall_3),
	.feedback_data_in_3(feedback_data_3),
	.feedback_valid_in_6(feedback_valid_6),
	.feedback_stall_out_6(feedback_stall_6),
	.feedback_data_in_6(feedback_data_6),
	.feedback_valid_out_3(feedback_valid_3),
	.feedback_stall_in_3(feedback_stall_3),
	.feedback_data_out_3(feedback_data_3),
	.feedback_valid_out_6(feedback_valid_6),
	.feedback_stall_in_6(feedback_stall_6),
	.feedback_data_out_6(feedback_data_6),
	.feedback_valid_in_8(feedback_valid_8),
	.feedback_stall_out_8(feedback_stall_8),
	.feedback_data_in_8(feedback_data_8),
	.feedback_valid_out_8(feedback_valid_8),
	.feedback_stall_in_8(feedback_stall_8),
	.feedback_data_out_8(feedback_data_8),
	.avm_local_bb1_st_c0_exe1_enable(avm_local_bb1_st_c0_exe1_enable),
	.avm_local_bb1_st_c0_exe1_readdata(avm_local_bb1_st_c0_exe1_readdata),
	.avm_local_bb1_st_c0_exe1_readdatavalid(avm_local_bb1_st_c0_exe1_readdatavalid),
	.avm_local_bb1_st_c0_exe1_waitrequest(avm_local_bb1_st_c0_exe1_waitrequest),
	.avm_local_bb1_st_c0_exe1_address(avm_local_bb1_st_c0_exe1_address),
	.avm_local_bb1_st_c0_exe1_read(avm_local_bb1_st_c0_exe1_read),
	.avm_local_bb1_st_c0_exe1_write(avm_local_bb1_st_c0_exe1_write),
	.avm_local_bb1_st_c0_exe1_writeack(avm_local_bb1_st_c0_exe1_writeack),
	.avm_local_bb1_st_c0_exe1_writedata(avm_local_bb1_st_c0_exe1_writedata),
	.avm_local_bb1_st_c0_exe1_byteenable(avm_local_bb1_st_c0_exe1_byteenable),
	.avm_local_bb1_st_c0_exe1_burstcount(avm_local_bb1_st_c0_exe1_burstcount),
	.local_bb1_st_c0_exe1_active(bb_1_local_bb1_st_c0_exe1_active)
);


laplacian_basic_block_2 laplacian_basic_block_2 (
	.clock(clock),
	.resetn(resetn),
	.valid_in(bb_1_valid_out_0),
	.stall_out(bb_2_stall_out),
	.valid_out(bb_2_valid_out),
	.stall_in(stall_in),
	.workgroup_size(workgroup_size),
	.start(start)
);


acl_loop_limiter loop_limiter_0 (
	.clock(clock),
	.resetn(resetn),
	.i_valid(bb_0_valid_out),
	.i_stall(bb_1_stall_out_1),
	.i_valid_exit(bb_1_acl_pipelined_exiting_valid),
	.i_stall_exit(bb_1_acl_pipelined_exiting_stall),
	.o_valid(loop_limiter_0_valid_out),
	.o_stall(loop_limiter_0_stall_out)
);

defparam loop_limiter_0.ENTRY_WIDTH = 1;
defparam loop_limiter_0.EXIT_WIDTH = 1;
defparam loop_limiter_0.THRESHOLD = 1;

laplacian_sys_cycle_time system_cycle_time_module (
	.clock(clock),
	.resetn(resetn),
	.cur_cycle(cur_cycle)
);


assign workgroup_size = 32'h1;
assign valid_out = bb_2_valid_out;
assign stall_out = bb_0_stall_out;
assign writes_pending = bb_1_local_bb1_st_c0_exe1_active;
assign lsus_active[0] = bb_1_local_bb1_ld__active;
assign lsus_active[1] = bb_1_local_bb1_st_c0_exe1_active;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		has_a_write_pending <= 1'b0;
		has_a_lsu_active <= 1'b0;
	end
	else
	begin
		has_a_write_pending <= (|writes_pending);
		has_a_lsu_active <= (|lsus_active);
	end
end

endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

// altera message_off 10036
// altera message_off 10230
// altera message_off 10858
module laplacian_function_wrapper
	(
		input 		clock,
		input 		resetn,
		input 		clock2x,
		input 		local_router_hang,
		input 		avs_cra_enable,
		input 		avs_cra_read,
		input 		avs_cra_write,
		input [3:0] 		avs_cra_address,
		input [63:0] 		avs_cra_writedata,
		input [7:0] 		avs_cra_byteenable,
		output reg [63:0] 		avs_cra_readdata,
		output reg 		avs_cra_readdatavalid,
		output 		cra_irq,
		output 		avm_local_bb1_ld__inst0_enable,
		input [255:0] 		avm_local_bb1_ld__inst0_readdata,
		input 		avm_local_bb1_ld__inst0_readdatavalid,
		input 		avm_local_bb1_ld__inst0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__inst0_address,
		output 		avm_local_bb1_ld__inst0_read,
		output 		avm_local_bb1_ld__inst0_write,
		input 		avm_local_bb1_ld__inst0_writeack,
		output [255:0] 		avm_local_bb1_ld__inst0_writedata,
		output [31:0] 		avm_local_bb1_ld__inst0_byteenable,
		output [4:0] 		avm_local_bb1_ld__inst0_burstcount,
		output 		avm_local_bb1_st_c0_exe1_inst0_enable,
		input [255:0] 		avm_local_bb1_st_c0_exe1_inst0_readdata,
		input 		avm_local_bb1_st_c0_exe1_inst0_readdatavalid,
		input 		avm_local_bb1_st_c0_exe1_inst0_waitrequest,
		output [29:0] 		avm_local_bb1_st_c0_exe1_inst0_address,
		output 		avm_local_bb1_st_c0_exe1_inst0_read,
		output 		avm_local_bb1_st_c0_exe1_inst0_write,
		input 		avm_local_bb1_st_c0_exe1_inst0_writeack,
		output [255:0] 		avm_local_bb1_st_c0_exe1_inst0_writedata,
		output [31:0] 		avm_local_bb1_st_c0_exe1_inst0_byteenable,
		output [4:0] 		avm_local_bb1_st_c0_exe1_inst0_burstcount
	);

// Responsible for interfacing a kernel with the outside world. It comprises a
// slave interface to specify the kernel arguments and retain kernel status. 

// This section of the wrapper implements the slave interface.
// twoXclock_consumer uses clock2x, even if nobody inside the kernel does. Keeps interface to acl_iface consistent for all kernels.
 reg start_NO_SHIFT_REG;
 reg started_NO_SHIFT_REG;
wire finish;
 reg [31:0] status_NO_SHIFT_REG;
wire has_a_write_pending;
wire has_a_lsu_active;
 reg [191:0] kernel_arguments_NO_SHIFT_REG;
 reg twoXclock_consumer_NO_SHIFT_REG /* synthesis  preserve  noprune  */;
 reg [31:0] global_size_NO_SHIFT_REG[2:0];
 reg [31:0] num_groups_NO_SHIFT_REG[2:0];
 reg [31:0] local_size_NO_SHIFT_REG[2:0];
 reg [31:0] global_offset_NO_SHIFT_REG[2:0];
 reg [31:0] work_dim_NO_SHIFT_REG;
 reg [31:0] workgroup_size_NO_SHIFT_REG;
 reg [63:0] profile_data_NO_SHIFT_REG;
 reg [31:0] profile_ctrl_NO_SHIFT_REG;
 reg [63:0] profile_start_cycle_NO_SHIFT_REG;
 reg [63:0] profile_stop_cycle_NO_SHIFT_REG;
wire dispatched_all_groups;
wire [31:0] group_id_tmp[2:0];
wire [31:0] global_id_base_out[2:0];
wire start_out;
wire [31:0] local_id[0:0][2:0];
wire [31:0] global_id[0:0][2:0];
wire [31:0] group_id[0:0][2:0];
wire iter_valid_in;
wire iter_stall_out;
wire stall_in;
wire stall_out;
wire valid_in;
wire valid_out;
wire start_chain;
wire start_kernel;
wire start_finish_detector;
wire start_finish_chain_element;
wire finish_chain;
wire kernel_copy_finished;
 reg start_isolation_reg_NO_SHIFT_REG;

assign start_chain = start_isolation_reg_NO_SHIFT_REG;

always @(posedge clock2x or negedge resetn)
begin
	if (~(resetn))
	begin
		twoXclock_consumer_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		twoXclock_consumer_NO_SHIFT_REG <= 1'b1;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		start_isolation_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		start_isolation_reg_NO_SHIFT_REG <= start_NO_SHIFT_REG;
	end
end



// Work group dispatcher is responsible for issuing work-groups to id iterator(s)
acl_work_group_dispatcher group_dispatcher (
	.clock(clock),
	.resetn(resetn),
	.start(start_NO_SHIFT_REG),
	.num_groups(num_groups_NO_SHIFT_REG),
	.local_size(local_size_NO_SHIFT_REG),
	.stall_in(iter_stall_out),
	.valid_out(iter_valid_in),
	.group_id_out(group_id_tmp),
	.global_id_base_out(global_id_base_out),
	.start_out(start_out),
	.dispatched_all_groups(dispatched_all_groups)
);

defparam group_dispatcher.NUM_COPIES = 1;
defparam group_dispatcher.RUN_FOREVER = 0;


// This section of the wrapper implements an Avalon Slave Interface used to configure a kernel invocation.
// The few words words contain the status and the workgroup size registers.
// The remaining addressable space is reserved for kernel arguments.
 reg [63:0] cra_readdata_st1_NO_SHIFT_REG;
 reg [3:0] cra_addr_st1_NO_SHIFT_REG;
 reg cra_read_st1_NO_SHIFT_REG;
wire [63:0] bitenable;

assign bitenable[7:0] = (avs_cra_byteenable[0] ? 8'hFF : 8'h0);
assign bitenable[15:8] = (avs_cra_byteenable[1] ? 8'hFF : 8'h0);
assign bitenable[23:16] = (avs_cra_byteenable[2] ? 8'hFF : 8'h0);
assign bitenable[31:24] = (avs_cra_byteenable[3] ? 8'hFF : 8'h0);
assign bitenable[39:32] = (avs_cra_byteenable[4] ? 8'hFF : 8'h0);
assign bitenable[47:40] = (avs_cra_byteenable[5] ? 8'hFF : 8'h0);
assign bitenable[55:48] = (avs_cra_byteenable[6] ? 8'hFF : 8'h0);
assign bitenable[63:56] = (avs_cra_byteenable[7] ? 8'hFF : 8'h0);
assign cra_irq = (status_NO_SHIFT_REG[1] | status_NO_SHIFT_REG[3]);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		start_NO_SHIFT_REG <= 1'b0;
		started_NO_SHIFT_REG <= 1'b0;
		kernel_arguments_NO_SHIFT_REG <= 192'h0;
		status_NO_SHIFT_REG <= 32'h30000;
		profile_ctrl_NO_SHIFT_REG <= 32'h4;
		profile_start_cycle_NO_SHIFT_REG <= 64'h0;
		profile_stop_cycle_NO_SHIFT_REG <= 64'hFFFFFFFFFFFFFFFF;
		work_dim_NO_SHIFT_REG <= 32'h0;
		workgroup_size_NO_SHIFT_REG <= 32'h0;
		global_size_NO_SHIFT_REG[0] <= 32'h0;
		global_size_NO_SHIFT_REG[1] <= 32'h0;
		global_size_NO_SHIFT_REG[2] <= 32'h0;
		num_groups_NO_SHIFT_REG[0] <= 32'h0;
		num_groups_NO_SHIFT_REG[1] <= 32'h0;
		num_groups_NO_SHIFT_REG[2] <= 32'h0;
		local_size_NO_SHIFT_REG[0] <= 32'h0;
		local_size_NO_SHIFT_REG[1] <= 32'h0;
		local_size_NO_SHIFT_REG[2] <= 32'h0;
		global_offset_NO_SHIFT_REG[0] <= 32'h0;
		global_offset_NO_SHIFT_REG[1] <= 32'h0;
		global_offset_NO_SHIFT_REG[2] <= 32'h0;
	end
	else
	begin
		if (avs_cra_write)
		begin
			case (avs_cra_address)
				4'h0:
				begin
					status_NO_SHIFT_REG[31:16] <= 16'h3;
					status_NO_SHIFT_REG[15:0] <= ((status_NO_SHIFT_REG[15:0] & ~(bitenable[15:0])) | (avs_cra_writedata[15:0] & bitenable[15:0]));
				end

				4'h1:
				begin
					profile_ctrl_NO_SHIFT_REG <= ((profile_ctrl_NO_SHIFT_REG & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h3:
				begin
					profile_start_cycle_NO_SHIFT_REG[31:0] <= ((profile_start_cycle_NO_SHIFT_REG[31:0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					profile_start_cycle_NO_SHIFT_REG[63:32] <= ((profile_start_cycle_NO_SHIFT_REG[63:32] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h4:
				begin
					profile_stop_cycle_NO_SHIFT_REG[31:0] <= ((profile_stop_cycle_NO_SHIFT_REG[31:0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					profile_stop_cycle_NO_SHIFT_REG[63:32] <= ((profile_stop_cycle_NO_SHIFT_REG[63:32] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h5:
				begin
					work_dim_NO_SHIFT_REG <= ((work_dim_NO_SHIFT_REG & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					workgroup_size_NO_SHIFT_REG <= ((workgroup_size_NO_SHIFT_REG & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h6:
				begin
					global_size_NO_SHIFT_REG[0] <= ((global_size_NO_SHIFT_REG[0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_size_NO_SHIFT_REG[1] <= ((global_size_NO_SHIFT_REG[1] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h7:
				begin
					global_size_NO_SHIFT_REG[2] <= ((global_size_NO_SHIFT_REG[2] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					num_groups_NO_SHIFT_REG[0] <= ((num_groups_NO_SHIFT_REG[0] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h8:
				begin
					num_groups_NO_SHIFT_REG[1] <= ((num_groups_NO_SHIFT_REG[1] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					num_groups_NO_SHIFT_REG[2] <= ((num_groups_NO_SHIFT_REG[2] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h9:
				begin
					local_size_NO_SHIFT_REG[0] <= ((local_size_NO_SHIFT_REG[0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					local_size_NO_SHIFT_REG[1] <= ((local_size_NO_SHIFT_REG[1] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'hA:
				begin
					local_size_NO_SHIFT_REG[2] <= ((local_size_NO_SHIFT_REG[2] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_offset_NO_SHIFT_REG[0] <= ((global_offset_NO_SHIFT_REG[0] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'hB:
				begin
					global_offset_NO_SHIFT_REG[1] <= ((global_offset_NO_SHIFT_REG[1] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_offset_NO_SHIFT_REG[2] <= ((global_offset_NO_SHIFT_REG[2] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'hC:
				begin
					kernel_arguments_NO_SHIFT_REG[31:0] <= ((kernel_arguments_NO_SHIFT_REG[31:0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[63:32] <= ((kernel_arguments_NO_SHIFT_REG[63:32] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'hD:
				begin
					kernel_arguments_NO_SHIFT_REG[95:64] <= ((kernel_arguments_NO_SHIFT_REG[95:64] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[127:96] <= ((kernel_arguments_NO_SHIFT_REG[127:96] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'hE:
				begin
					kernel_arguments_NO_SHIFT_REG[159:128] <= ((kernel_arguments_NO_SHIFT_REG[159:128] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[191:160] <= ((kernel_arguments_NO_SHIFT_REG[191:160] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				default:
				begin
				end

			endcase
		end
		else
		begin
			if (status_NO_SHIFT_REG[0])
			begin
				start_NO_SHIFT_REG <= 1'b1;
			end
			if (start_NO_SHIFT_REG)
			begin
				status_NO_SHIFT_REG[0] <= 1'b0;
				started_NO_SHIFT_REG <= 1'b1;
			end
			if (started_NO_SHIFT_REG)
			begin
				start_NO_SHIFT_REG <= 1'b0;
			end
			if (finish)
			begin
				status_NO_SHIFT_REG[1] <= 1'b1;
				started_NO_SHIFT_REG <= 1'b0;
			end
		end
		status_NO_SHIFT_REG[11] <= 1'b0;
		status_NO_SHIFT_REG[12] <= (|has_a_lsu_active);
		status_NO_SHIFT_REG[13] <= (|has_a_write_pending);
		status_NO_SHIFT_REG[14] <= (|valid_in);
		status_NO_SHIFT_REG[15] <= started_NO_SHIFT_REG;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		cra_read_st1_NO_SHIFT_REG <= 1'b0;
		cra_addr_st1_NO_SHIFT_REG <= 4'h0;
		cra_readdata_st1_NO_SHIFT_REG <= 64'h0;
	end
	else
	begin
		cra_read_st1_NO_SHIFT_REG <= avs_cra_read;
		cra_addr_st1_NO_SHIFT_REG <= avs_cra_address;
		case (avs_cra_address)
			4'h0:
			begin
				cra_readdata_st1_NO_SHIFT_REG[31:0] <= status_NO_SHIFT_REG;
				cra_readdata_st1_NO_SHIFT_REG[63:32] <= 32'h0;
			end

			4'h1:
			begin
				cra_readdata_st1_NO_SHIFT_REG[31:0] <= 'x;
				cra_readdata_st1_NO_SHIFT_REG[63:32] <= 32'h0;
			end

			4'h2:
			begin
				cra_readdata_st1_NO_SHIFT_REG[63:0] <= 64'h0;
			end

			4'h3:
			begin
				cra_readdata_st1_NO_SHIFT_REG[63:0] <= 64'h0;
			end

			4'h4:
			begin
				cra_readdata_st1_NO_SHIFT_REG[63:0] <= 64'h0;
			end

			default:
			begin
				cra_readdata_st1_NO_SHIFT_REG <= status_NO_SHIFT_REG;
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		avs_cra_readdatavalid <= 1'b0;
		avs_cra_readdata <= 64'h0;
	end
	else
	begin
		avs_cra_readdatavalid <= cra_read_st1_NO_SHIFT_REG;
		case (cra_addr_st1_NO_SHIFT_REG)
			4'h2:
			begin
				avs_cra_readdata[63:0] <= profile_data_NO_SHIFT_REG;
			end

			default:
			begin
				avs_cra_readdata <= cra_readdata_st1_NO_SHIFT_REG;
			end

		endcase
	end
end


// Handshaking signals used to control data through the pipeline

// Determine when the kernel is finished.
acl_kernel_finish_detector kernel_finish_detector (
	.clock(clock),
	.resetn(resetn),
	.start(start_NO_SHIFT_REG),
	.wg_size(workgroup_size_NO_SHIFT_REG),
	.wg_dispatch_valid_out(iter_valid_in),
	.wg_dispatch_stall_in(iter_stall_out),
	.dispatched_all_groups(dispatched_all_groups),
	.kernel_copy_valid_out(valid_out),
	.kernel_copy_stall_in(stall_in),
	.pending_writes(has_a_write_pending),
	.finish(finish)
);

defparam kernel_finish_detector.TESSELLATION_SIZE = 0;
defparam kernel_finish_detector.NUM_COPIES = 1;
defparam kernel_finish_detector.WG_SIZE_W = 32;

assign stall_in = 1'b0;

// Creating ID iterator and kernel instance for every requested kernel copy

// ID iterator is responsible for iterating over all local ids for given work-groups
acl_id_iterator id_iter_inst0 (
	.clock(clock),
	.resetn(resetn),
	.start(start_out),
	.valid_in(iter_valid_in),
	.stall_out(iter_stall_out),
	.stall_in(stall_out),
	.valid_out(valid_in),
	.group_id_in(group_id_tmp),
	.global_id_base_in(global_id_base_out),
	.local_size(local_size_NO_SHIFT_REG),
	.global_size(global_size_NO_SHIFT_REG),
	.local_id(local_id[0]),
	.global_id(global_id[0]),
	.group_id(group_id[0])
);

defparam id_iter_inst0.LOCAL_WIDTH_X = 32;
defparam id_iter_inst0.LOCAL_WIDTH_Y = 32;
defparam id_iter_inst0.LOCAL_WIDTH_Z = 32;


// Start chain element is responsible for delivering start signal to each kernel copy.
acl_start_signal_chain_element acl_start_signal_chain_element_inst0 (
	.clock(clock),
	.resetn(resetn),
	.start_in(start_chain),
	.start_kernel(start_kernel),
	.start_finish_detector(start_finish_detector),
	.start_finish_chain_element(start_finish_chain_element),
	.start_chain()
);



// This section instantiates a kernel function block
laplacian_function laplacian_function_inst0 (
	.clock(clock),
	.resetn(resetn),
	.stall_out(stall_out),
	.valid_in(valid_in),
	.valid_out(valid_out),
	.stall_in(stall_in),
	.avm_local_bb1_ld__enable(avm_local_bb1_ld__inst0_enable),
	.avm_local_bb1_ld__readdata(avm_local_bb1_ld__inst0_readdata),
	.avm_local_bb1_ld__readdatavalid(avm_local_bb1_ld__inst0_readdatavalid),
	.avm_local_bb1_ld__waitrequest(avm_local_bb1_ld__inst0_waitrequest),
	.avm_local_bb1_ld__address(avm_local_bb1_ld__inst0_address),
	.avm_local_bb1_ld__read(avm_local_bb1_ld__inst0_read),
	.avm_local_bb1_ld__write(avm_local_bb1_ld__inst0_write),
	.avm_local_bb1_ld__writeack(avm_local_bb1_ld__inst0_writeack),
	.avm_local_bb1_ld__writedata(avm_local_bb1_ld__inst0_writedata),
	.avm_local_bb1_ld__byteenable(avm_local_bb1_ld__inst0_byteenable),
	.avm_local_bb1_ld__burstcount(avm_local_bb1_ld__inst0_burstcount),
	.avm_local_bb1_st_c0_exe1_enable(avm_local_bb1_st_c0_exe1_inst0_enable),
	.avm_local_bb1_st_c0_exe1_readdata(avm_local_bb1_st_c0_exe1_inst0_readdata),
	.avm_local_bb1_st_c0_exe1_readdatavalid(avm_local_bb1_st_c0_exe1_inst0_readdatavalid),
	.avm_local_bb1_st_c0_exe1_waitrequest(avm_local_bb1_st_c0_exe1_inst0_waitrequest),
	.avm_local_bb1_st_c0_exe1_address(avm_local_bb1_st_c0_exe1_inst0_address),
	.avm_local_bb1_st_c0_exe1_read(avm_local_bb1_st_c0_exe1_inst0_read),
	.avm_local_bb1_st_c0_exe1_write(avm_local_bb1_st_c0_exe1_inst0_write),
	.avm_local_bb1_st_c0_exe1_writeack(avm_local_bb1_st_c0_exe1_inst0_writeack),
	.avm_local_bb1_st_c0_exe1_writedata(avm_local_bb1_st_c0_exe1_inst0_writedata),
	.avm_local_bb1_st_c0_exe1_byteenable(avm_local_bb1_st_c0_exe1_inst0_byteenable),
	.avm_local_bb1_st_c0_exe1_burstcount(avm_local_bb1_st_c0_exe1_inst0_burstcount),
	.start(start_kernel),
	.input_iterations(kernel_arguments_NO_SHIFT_REG[159:128]),
	.clock2x(clock2x),
	.input_frame_in(kernel_arguments_NO_SHIFT_REG[63:0]),
	.input_frame_out(kernel_arguments_NO_SHIFT_REG[127:64]),
	.input_threshold(kernel_arguments_NO_SHIFT_REG[191:160]),
	.has_a_write_pending(has_a_write_pending),
	.has_a_lsu_active(has_a_lsu_active)
);



endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

// altera message_off 10036
// altera message_off 10230
// altera message_off 10858
module laplacian_sys_cycle_time
	(
		input 		clock,
		input 		resetn,
		output [31:0] 		cur_cycle
	);


 reg [31:0] cur_count_NO_SHIFT_REG;

assign cur_cycle = cur_count_NO_SHIFT_REG;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		cur_count_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		cur_count_NO_SHIFT_REG <= (cur_count_NO_SHIFT_REG + 32'h1);
	end
end

endmodule

