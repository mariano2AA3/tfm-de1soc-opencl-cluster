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
module errorDiffusion_basic_block_0
	(
		input 		clock,
		input 		resetn,
		input 		start,
		input [31:0] 		input_width,
		input [31:0] 		input_height,
		input 		valid_in,
		output 		stall_out,
		output 		valid_out,
		input 		stall_in,
		output [31:0] 		lvb_bb0_mul,
		output 		lvb_bb0_cmp22,
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
wire local_bb0_mul_inputs_ready;
 reg local_bb0_mul_wii_reg_NO_SHIFT_REG;
 reg local_bb0_mul_valid_out_0_NO_SHIFT_REG;
wire local_bb0_mul_stall_in_0;
 reg local_bb0_mul_valid_out_1_NO_SHIFT_REG;
wire local_bb0_mul_stall_in_1;
wire local_bb0_mul_output_regs_ready;
wire [31:0] local_bb0_mul;
 reg local_bb0_mul_valid_pipe_0_NO_SHIFT_REG;
 reg local_bb0_mul_valid_pipe_1_NO_SHIFT_REG;
wire local_bb0_mul_causedstall;

acl_int_mult int_module_local_bb0_mul (
	.clock(clock),
	.dataa(input_width),
	.datab(input_height),
	.enable(local_bb0_mul_output_regs_ready),
	.result(local_bb0_mul)
);

defparam int_module_local_bb0_mul.INPUT1_WIDTH = 32;
defparam int_module_local_bb0_mul.INPUT2_WIDTH = 32;
defparam int_module_local_bb0_mul.OUTPUT_WIDTH = 32;
defparam int_module_local_bb0_mul.LATENCY = 3;
defparam int_module_local_bb0_mul.SIGNED = 0;

assign local_bb0_mul_inputs_ready = merge_node_valid_out_0_NO_SHIFT_REG;
assign local_bb0_mul_output_regs_ready = (~(local_bb0_mul_wii_reg_NO_SHIFT_REG) & ((~(local_bb0_mul_valid_out_0_NO_SHIFT_REG) | ~(local_bb0_mul_stall_in_0)) & (~(local_bb0_mul_valid_out_1_NO_SHIFT_REG) | ~(local_bb0_mul_stall_in_1))));
assign merge_node_stall_in_0 = (~(local_bb0_mul_wii_reg_NO_SHIFT_REG) & (~(local_bb0_mul_output_regs_ready) | ~(local_bb0_mul_inputs_ready)));
assign local_bb0_mul_causedstall = (local_bb0_mul_inputs_ready && (~(local_bb0_mul_output_regs_ready) && !(~(local_bb0_mul_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_mul_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
		local_bb0_mul_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_mul_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
			local_bb0_mul_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_mul_output_regs_ready)
			begin
				local_bb0_mul_valid_pipe_0_NO_SHIFT_REG <= local_bb0_mul_inputs_ready;
				local_bb0_mul_valid_pipe_1_NO_SHIFT_REG <= local_bb0_mul_valid_pipe_0_NO_SHIFT_REG;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_mul_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb0_mul_valid_out_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_mul_valid_out_0_NO_SHIFT_REG <= 1'b0;
			local_bb0_mul_valid_out_1_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_mul_output_regs_ready)
			begin
				local_bb0_mul_valid_out_0_NO_SHIFT_REG <= local_bb0_mul_valid_pipe_1_NO_SHIFT_REG;
				local_bb0_mul_valid_out_1_NO_SHIFT_REG <= local_bb0_mul_valid_pipe_1_NO_SHIFT_REG;
			end
			else
			begin
				if (~(local_bb0_mul_stall_in_0))
				begin
					local_bb0_mul_valid_out_0_NO_SHIFT_REG <= local_bb0_mul_wii_reg_NO_SHIFT_REG;
				end
				if (~(local_bb0_mul_stall_in_1))
				begin
					local_bb0_mul_valid_out_1_NO_SHIFT_REG <= local_bb0_mul_wii_reg_NO_SHIFT_REG;
				end
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_mul_wii_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_mul_wii_reg_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_mul_valid_pipe_1_NO_SHIFT_REG)
			begin
				local_bb0_mul_wii_reg_NO_SHIFT_REG <= 1'b1;
			end
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb0_cmp22_inputs_ready;
 reg local_bb0_cmp22_wii_reg_NO_SHIFT_REG;
 reg local_bb0_cmp22_valid_out_NO_SHIFT_REG;
wire local_bb0_cmp22_stall_in;
wire local_bb0_cmp22_output_regs_ready;
 reg local_bb0_cmp22_NO_SHIFT_REG;
wire local_bb0_cmp22_causedstall;

assign local_bb0_cmp22_inputs_ready = local_bb0_mul_valid_out_0_NO_SHIFT_REG;
assign local_bb0_cmp22_output_regs_ready = (~(local_bb0_cmp22_wii_reg_NO_SHIFT_REG) & (&(~(local_bb0_cmp22_valid_out_NO_SHIFT_REG) | ~(local_bb0_cmp22_stall_in))));
assign local_bb0_mul_stall_in_0 = (~(local_bb0_cmp22_wii_reg_NO_SHIFT_REG) & (~(local_bb0_cmp22_output_regs_ready) | ~(local_bb0_cmp22_inputs_ready)));
assign local_bb0_cmp22_causedstall = (local_bb0_cmp22_inputs_ready && (~(local_bb0_cmp22_output_regs_ready) && !(~(local_bb0_cmp22_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_cmp22_NO_SHIFT_REG <= 'x;
		local_bb0_cmp22_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_cmp22_NO_SHIFT_REG <= 'x;
			local_bb0_cmp22_valid_out_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_cmp22_output_regs_ready)
			begin
				local_bb0_cmp22_NO_SHIFT_REG <= (local_bb0_mul == 32'h0);
				local_bb0_cmp22_valid_out_NO_SHIFT_REG <= local_bb0_cmp22_inputs_ready;
			end
			else
			begin
				if (~(local_bb0_cmp22_stall_in))
				begin
					local_bb0_cmp22_valid_out_NO_SHIFT_REG <= local_bb0_cmp22_wii_reg_NO_SHIFT_REG;
				end
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_cmp22_wii_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_cmp22_wii_reg_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_cmp22_inputs_ready)
			begin
				local_bb0_cmp22_wii_reg_NO_SHIFT_REG <= 1'b1;
			end
		end
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
 reg branch_node_valid_out_NO_SHIFT_REG;
wire branch_var__output_regs_ready;
wire combined_branch_stall_in_signal;
 reg [31:0] lvb_bb0_mul_reg_NO_SHIFT_REG;
 reg lvb_bb0_cmp22_reg_NO_SHIFT_REG;

assign branch_var__inputs_ready = (local_bb0_cmp22_valid_out_NO_SHIFT_REG & merge_node_valid_out_1_NO_SHIFT_REG & local_bb0_mul_valid_out_1_NO_SHIFT_REG);
assign branch_var__output_regs_ready = (~(stall_in) | ~(branch_node_valid_out_NO_SHIFT_REG));
assign local_bb0_cmp22_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign merge_node_stall_in_1 = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign local_bb0_mul_stall_in_1 = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign lvb_bb0_mul = lvb_bb0_mul_reg_NO_SHIFT_REG;
assign lvb_bb0_cmp22 = lvb_bb0_cmp22_reg_NO_SHIFT_REG;
assign combined_branch_stall_in_signal = stall_in;
assign valid_out = branch_node_valid_out_NO_SHIFT_REG;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		branch_node_valid_out_NO_SHIFT_REG <= 1'b0;
		lvb_bb0_mul_reg_NO_SHIFT_REG <= 'x;
		lvb_bb0_cmp22_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (branch_var__output_regs_ready)
		begin
			branch_node_valid_out_NO_SHIFT_REG <= branch_var__inputs_ready;
			lvb_bb0_mul_reg_NO_SHIFT_REG <= local_bb0_mul;
			lvb_bb0_cmp22_reg_NO_SHIFT_REG <= local_bb0_cmp22_NO_SHIFT_REG;
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
module errorDiffusion_basic_block_1
	(
		input 		clock,
		input 		resetn,
		input [63:0] 		input_pixels,
		input [31:0] 		input_wii_mul,
		input 		input_wii_cmp22,
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
		input 		feedback_valid_in_25,
		output 		feedback_stall_out_25,
		input [3:0] 		feedback_data_in_25,
		input 		feedback_valid_in_27,
		output 		feedback_stall_out_27,
		input [3:0] 		feedback_data_in_27,
		input 		feedback_valid_in_24,
		output 		feedback_stall_out_24,
		input [31:0] 		feedback_data_in_24,
		output 		feedback_valid_out_24,
		input 		feedback_stall_in_24,
		output [31:0] 		feedback_data_out_24,
		output 		feedback_valid_out_25,
		input 		feedback_stall_in_25,
		output [3:0] 		feedback_data_out_25,
		output 		feedback_valid_out_0,
		input 		feedback_stall_in_0,
		output 		feedback_data_out_0,
		output 		feedback_valid_out_1,
		input 		feedback_stall_in_1,
		output 		feedback_data_out_1,
		output 		feedback_valid_out_27,
		input 		feedback_stall_in_27,
		output [3:0] 		feedback_data_out_27,
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
		input 		feedback_valid_in_26,
		output 		feedback_stall_out_26,
		input [47:0] 		feedback_data_in_26,
		input 		feedback_valid_in_2,
		output 		feedback_stall_out_2,
		input [31:0] 		feedback_data_in_2,
		input 		feedback_valid_in_3,
		output 		feedback_stall_out_3,
		input [71:0] 		feedback_data_in_3,
		input 		feedback_valid_in_8,
		output 		feedback_stall_out_8,
		input [87:0] 		feedback_data_in_8,
		output 		feedback_valid_out_26,
		input 		feedback_stall_in_26,
		output [47:0] 		feedback_data_out_26,
		output 		avm_local_bb1_st_c1_exe1_enable,
		input [255:0] 		avm_local_bb1_st_c1_exe1_readdata,
		input 		avm_local_bb1_st_c1_exe1_readdatavalid,
		input 		avm_local_bb1_st_c1_exe1_waitrequest,
		output [29:0] 		avm_local_bb1_st_c1_exe1_address,
		output 		avm_local_bb1_st_c1_exe1_read,
		output 		avm_local_bb1_st_c1_exe1_write,
		input 		avm_local_bb1_st_c1_exe1_writeack,
		output [255:0] 		avm_local_bb1_st_c1_exe1_writedata,
		output [31:0] 		avm_local_bb1_st_c1_exe1_byteenable,
		output [4:0] 		avm_local_bb1_st_c1_exe1_burstcount,
		output 		local_bb1_st_c1_exe1_active,
		output 		feedback_valid_out_3,
		input 		feedback_stall_in_3,
		output [71:0] 		feedback_data_out_3,
		output 		feedback_valid_out_8,
		input 		feedback_stall_in_8,
		output [87:0] 		feedback_data_out_8,
		output 		feedback_valid_out_2,
		input 		feedback_stall_in_2,
		output [31:0] 		feedback_data_out_2
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
wire local_bb1_c0_eni1_valid_out;
wire local_bb1_c0_eni1_stall_in;
wire local_bb1_c0_eni1_inputs_ready;
wire local_bb1_c0_eni1_stall_local;
wire [15:0] local_bb1_c0_eni1;

assign local_bb1_c0_eni1_inputs_ready = merge_node_valid_out_0_NO_SHIFT_REG;
assign local_bb1_c0_eni1[7:0] = 8'bx;
assign local_bb1_c0_eni1[8] = local_lvm_forked_NO_SHIFT_REG;
assign local_bb1_c0_eni1[15:9] = 7'bx;
assign local_bb1_c0_eni1_valid_out = local_bb1_c0_eni1_inputs_ready;
assign local_bb1_c0_eni1_stall_local = local_bb1_c0_eni1_stall_in;
assign merge_node_stall_in_0 = (|local_bb1_c0_eni1_stall_local);

// Register node:
//  * latency = 11
//  * capacity = 11
 logic rnode_1to12_forked_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to12_forked_0_stall_in_NO_SHIFT_REG;
 logic rnode_1to12_forked_0_NO_SHIFT_REG;
 logic rnode_1to12_forked_0_reg_12_inputs_ready_NO_SHIFT_REG;
 logic rnode_1to12_forked_0_reg_12_NO_SHIFT_REG;
 logic rnode_1to12_forked_0_valid_out_reg_12_NO_SHIFT_REG;
 logic rnode_1to12_forked_0_stall_in_reg_12_NO_SHIFT_REG;
 logic rnode_1to12_forked_0_stall_out_reg_12_NO_SHIFT_REG;

acl_data_fifo rnode_1to12_forked_0_reg_12_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to12_forked_0_reg_12_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to12_forked_0_stall_in_reg_12_NO_SHIFT_REG),
	.valid_out(rnode_1to12_forked_0_valid_out_reg_12_NO_SHIFT_REG),
	.stall_out(rnode_1to12_forked_0_stall_out_reg_12_NO_SHIFT_REG),
	.data_in(local_lvm_forked_NO_SHIFT_REG),
	.data_out(rnode_1to12_forked_0_reg_12_NO_SHIFT_REG)
);

defparam rnode_1to12_forked_0_reg_12_fifo.DEPTH = 12;
defparam rnode_1to12_forked_0_reg_12_fifo.DATA_WIDTH = 1;
defparam rnode_1to12_forked_0_reg_12_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to12_forked_0_reg_12_fifo.IMPL = "ram";

assign rnode_1to12_forked_0_reg_12_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_1_NO_SHIFT_REG;
assign merge_node_stall_in_1 = rnode_1to12_forked_0_stall_out_reg_12_NO_SHIFT_REG;
assign rnode_1to12_forked_0_NO_SHIFT_REG = rnode_1to12_forked_0_reg_12_NO_SHIFT_REG;
assign rnode_1to12_forked_0_stall_in_reg_12_NO_SHIFT_REG = rnode_1to12_forked_0_stall_in_NO_SHIFT_REG;
assign rnode_1to12_forked_0_valid_out_NO_SHIFT_REG = rnode_1to12_forked_0_valid_out_reg_12_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_c0_enter_c0_eni1_valid_out_0;
wire local_bb1_c0_enter_c0_eni1_stall_in_0;
wire local_bb1_c0_enter_c0_eni1_valid_out_1;
wire local_bb1_c0_enter_c0_eni1_stall_in_1;
wire local_bb1_c0_enter_c0_eni1_inputs_ready;
wire local_bb1_c0_enter_c0_eni1_stall_local;
wire local_bb1_c0_enter_c0_eni1_input_accepted;
wire [15:0] local_bb1_c0_enter_c0_eni1;
wire local_bb1_c0_exit_c0_exi4_entry_stall;
wire local_bb1_c0_enter_c0_eni1_valid_bit;
wire local_bb1_c0_exit_c0_exi4_output_regs_ready;
wire local_bb1_c0_exit_c0_exi4_valid_in;
wire local_bb1_c0_exit_c0_exi4_phases;
wire local_bb1_c0_enter_c0_eni1_inc_pipelined_thread;
wire local_bb1_c0_enter_c0_eni1_dec_pipelined_thread;
wire local_bb1_c0_enter_c0_eni1_fu_stall_out;

assign local_bb1_c0_enter_c0_eni1_inputs_ready = local_bb1_c0_eni1_valid_out;
assign local_bb1_c0_enter_c0_eni1 = local_bb1_c0_eni1;
assign local_bb1_c0_enter_c0_eni1_input_accepted = (local_bb1_c0_enter_c0_eni1_inputs_ready && !(local_bb1_c0_exit_c0_exi4_entry_stall));
assign local_bb1_c0_enter_c0_eni1_valid_bit = local_bb1_c0_enter_c0_eni1_input_accepted;
assign local_bb1_c0_enter_c0_eni1_inc_pipelined_thread = 1'b1;
assign local_bb1_c0_enter_c0_eni1_dec_pipelined_thread = ~(1'b0);
assign local_bb1_c0_enter_c0_eni1_fu_stall_out = (~(local_bb1_c0_enter_c0_eni1_inputs_ready) | local_bb1_c0_exit_c0_exi4_entry_stall);
assign local_bb1_c0_enter_c0_eni1_stall_local = (local_bb1_c0_enter_c0_eni1_stall_in_0 | local_bb1_c0_enter_c0_eni1_stall_in_1);
assign local_bb1_c0_enter_c0_eni1_valid_out_0 = local_bb1_c0_enter_c0_eni1_inputs_ready;
assign local_bb1_c0_enter_c0_eni1_valid_out_1 = local_bb1_c0_enter_c0_eni1_inputs_ready;
assign local_bb1_c0_eni1_stall_in = (|local_bb1_c0_enter_c0_eni1_fu_stall_out);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_12to13_forked_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_12to13_forked_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_12to13_forked_0_NO_SHIFT_REG;
 logic rnode_12to13_forked_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_12to13_forked_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_12to13_forked_1_NO_SHIFT_REG;
 logic rnode_12to13_forked_0_reg_13_inputs_ready_NO_SHIFT_REG;
 logic rnode_12to13_forked_0_reg_13_NO_SHIFT_REG;
 logic rnode_12to13_forked_0_valid_out_0_reg_13_NO_SHIFT_REG;
 logic rnode_12to13_forked_0_stall_in_0_reg_13_NO_SHIFT_REG;
 logic rnode_12to13_forked_0_stall_out_reg_13_NO_SHIFT_REG;

acl_data_fifo rnode_12to13_forked_0_reg_13_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_12to13_forked_0_reg_13_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_12to13_forked_0_stall_in_0_reg_13_NO_SHIFT_REG),
	.valid_out(rnode_12to13_forked_0_valid_out_0_reg_13_NO_SHIFT_REG),
	.stall_out(rnode_12to13_forked_0_stall_out_reg_13_NO_SHIFT_REG),
	.data_in(rnode_1to12_forked_0_NO_SHIFT_REG),
	.data_out(rnode_12to13_forked_0_reg_13_NO_SHIFT_REG)
);

defparam rnode_12to13_forked_0_reg_13_fifo.DEPTH = 1;
defparam rnode_12to13_forked_0_reg_13_fifo.DATA_WIDTH = 1;
defparam rnode_12to13_forked_0_reg_13_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_12to13_forked_0_reg_13_fifo.IMPL = "ll_reg";

assign rnode_12to13_forked_0_reg_13_inputs_ready_NO_SHIFT_REG = rnode_1to12_forked_0_valid_out_NO_SHIFT_REG;
assign rnode_1to12_forked_0_stall_in_NO_SHIFT_REG = rnode_12to13_forked_0_stall_out_reg_13_NO_SHIFT_REG;
assign rnode_12to13_forked_0_stall_in_0_reg_13_NO_SHIFT_REG = (rnode_12to13_forked_0_stall_in_0_NO_SHIFT_REG | rnode_12to13_forked_0_stall_in_1_NO_SHIFT_REG);
assign rnode_12to13_forked_0_valid_out_0_NO_SHIFT_REG = rnode_12to13_forked_0_valid_out_0_reg_13_NO_SHIFT_REG;
assign rnode_12to13_forked_0_valid_out_1_NO_SHIFT_REG = rnode_12to13_forked_0_valid_out_0_reg_13_NO_SHIFT_REG;
assign rnode_12to13_forked_0_NO_SHIFT_REG = rnode_12to13_forked_0_reg_13_NO_SHIFT_REG;
assign rnode_12to13_forked_1_NO_SHIFT_REG = rnode_12to13_forked_0_reg_13_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene1_valid_out_0;
wire local_bb1_c0_ene1_stall_in_0;
wire local_bb1_c0_ene1_valid_out_1;
wire local_bb1_c0_ene1_stall_in_1;
wire local_bb1_c0_ene1_inputs_ready;
wire local_bb1_c0_ene1_stall_local;
wire local_bb1_c0_ene1;

assign local_bb1_c0_ene1_inputs_ready = local_bb1_c0_enter_c0_eni1_valid_out_0;
assign local_bb1_c0_ene1 = local_bb1_c0_enter_c0_eni1[8];
assign local_bb1_c0_ene1_valid_out_0 = 1'b1;
assign local_bb1_c0_ene1_valid_out_1 = 1'b1;
assign local_bb1_c0_enter_c0_eni1_stall_in_0 = 1'b0;

// This section implements an unregistered operation.
// 
wire SFC_1_VALID_1_1_0_valid_out_0;
wire SFC_1_VALID_1_1_0_stall_in_0;
wire SFC_1_VALID_1_1_0_valid_out_1;
wire SFC_1_VALID_1_1_0_stall_in_1;
wire SFC_1_VALID_1_1_0_inputs_ready;
wire SFC_1_VALID_1_1_0_stall_local;
wire SFC_1_VALID_1_1_0;

assign SFC_1_VALID_1_1_0_inputs_ready = local_bb1_c0_enter_c0_eni1_valid_out_1;
assign SFC_1_VALID_1_1_0 = local_bb1_c0_enter_c0_eni1_valid_bit;
assign SFC_1_VALID_1_1_0_valid_out_0 = 1'b1;
assign SFC_1_VALID_1_1_0_valid_out_1 = 1'b1;
assign local_bb1_c0_enter_c0_eni1_stall_in_1 = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_c1_eni1_stall_local;
wire [63:0] local_bb1_c1_eni1;

assign local_bb1_c1_eni1[7:0] = 8'bx;
assign local_bb1_c1_eni1[8] = rnode_12to13_forked_0_NO_SHIFT_REG;
assign local_bb1_c1_eni1[63:9] = 55'bx;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_1to2_bb1_c0_ene1_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c0_ene1_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c0_ene1_0_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c0_ene1_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c0_ene1_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c0_ene1_1_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c0_ene1_0_reg_2_inputs_ready_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c0_ene1_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c0_ene1_0_valid_out_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c0_ene1_0_stall_in_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb1_c0_ene1_0_stall_out_reg_2_NO_SHIFT_REG;

acl_data_fifo rnode_1to2_bb1_c0_ene1_0_reg_2_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to2_bb1_c0_ene1_0_reg_2_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to2_bb1_c0_ene1_0_stall_in_0_reg_2_NO_SHIFT_REG),
	.valid_out(rnode_1to2_bb1_c0_ene1_0_valid_out_0_reg_2_NO_SHIFT_REG),
	.stall_out(rnode_1to2_bb1_c0_ene1_0_stall_out_reg_2_NO_SHIFT_REG),
	.data_in(local_bb1_c0_ene1),
	.data_out(rnode_1to2_bb1_c0_ene1_0_reg_2_NO_SHIFT_REG)
);

defparam rnode_1to2_bb1_c0_ene1_0_reg_2_fifo.DEPTH = 1;
defparam rnode_1to2_bb1_c0_ene1_0_reg_2_fifo.DATA_WIDTH = 1;
defparam rnode_1to2_bb1_c0_ene1_0_reg_2_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_1to2_bb1_c0_ene1_0_reg_2_fifo.IMPL = "shift_reg";

assign rnode_1to2_bb1_c0_ene1_0_reg_2_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_c0_ene1_stall_in_1 = 1'b0;
assign rnode_1to2_bb1_c0_ene1_0_stall_in_0_reg_2_NO_SHIFT_REG = 1'b0;
assign rnode_1to2_bb1_c0_ene1_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_1to2_bb1_c0_ene1_0_NO_SHIFT_REG = rnode_1to2_bb1_c0_ene1_0_reg_2_NO_SHIFT_REG;
assign rnode_1to2_bb1_c0_ene1_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_1to2_bb1_c0_ene1_1_NO_SHIFT_REG = rnode_1to2_bb1_c0_ene1_0_reg_2_NO_SHIFT_REG;

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
wire SFC_1_VALID_1_2_0_output_regs_ready;
 reg SFC_1_VALID_1_2_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_1_VALID_1_2_0_causedstall;

assign SFC_1_VALID_1_2_0_inputs_ready = 1'b1;
assign SFC_1_VALID_1_2_0_output_regs_ready = 1'b1;
assign SFC_1_VALID_1_1_0_stall_in_0 = 1'b0;
assign SFC_1_VALID_1_2_0_causedstall = (1'b1 && (1'b0 && !(1'b0)));

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
wire local_bb1_keep_going_c0_ene1_inputs_ready;
 reg local_bb1_keep_going_c0_ene1_valid_out_0_NO_SHIFT_REG;
wire local_bb1_keep_going_c0_ene1_stall_in_0;
 reg local_bb1_keep_going_c0_ene1_valid_out_1_NO_SHIFT_REG;
wire local_bb1_keep_going_c0_ene1_stall_in_1;
 reg local_bb1_keep_going_c0_ene1_valid_out_2_NO_SHIFT_REG;
wire local_bb1_keep_going_c0_ene1_stall_in_2;
wire local_bb1_keep_going_c0_ene1_output_regs_ready;
wire local_bb1_keep_going_c0_ene1_keep_going;
wire local_bb1_keep_going_c0_ene1_fu_valid_out;
wire local_bb1_keep_going_c0_ene1_fu_stall_out;
 reg local_bb1_keep_going_c0_ene1_NO_SHIFT_REG;
wire local_bb1_keep_going_c0_ene1_feedback_pipelined;
wire local_bb1_keep_going_c0_ene1_causedstall;

acl_pipeline local_bb1_keep_going_c0_ene1_pipelined (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb1_c0_ene1),
	.stall_out(local_bb1_keep_going_c0_ene1_fu_stall_out),
	.valid_in(SFC_1_VALID_1_1_0),
	.valid_out(local_bb1_keep_going_c0_ene1_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_keep_going_c0_ene1_keep_going),
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

defparam local_bb1_keep_going_c0_ene1_pipelined.FIFO_DEPTH = 1;
defparam local_bb1_keep_going_c0_ene1_pipelined.STYLE = "SPECULATIVE";

assign local_bb1_keep_going_c0_ene1_inputs_ready = 1'b1;
assign local_bb1_keep_going_c0_ene1_output_regs_ready = 1'b1;
assign acl_pipelined_exiting_stall = acl_pipelined_stall;
assign local_bb1_c0_ene1_stall_in_0 = 1'b0;
assign SFC_1_VALID_1_1_0_stall_in_1 = 1'b0;
assign local_bb1_keep_going_c0_ene1_causedstall = (SFC_1_VALID_1_1_0 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_keep_going_c0_ene1_NO_SHIFT_REG <= 'x;
		local_bb1_keep_going_c0_ene1_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_keep_going_c0_ene1_valid_out_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_keep_going_c0_ene1_valid_out_2_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_keep_going_c0_ene1_output_regs_ready)
		begin
			local_bb1_keep_going_c0_ene1_NO_SHIFT_REG <= local_bb1_keep_going_c0_ene1_keep_going;
			local_bb1_keep_going_c0_ene1_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb1_keep_going_c0_ene1_valid_out_1_NO_SHIFT_REG <= 1'b1;
			local_bb1_keep_going_c0_ene1_valid_out_2_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb1_keep_going_c0_ene1_stall_in_0))
			begin
				local_bb1_keep_going_c0_ene1_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_keep_going_c0_ene1_stall_in_1))
			begin
				local_bb1_keep_going_c0_ene1_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_keep_going_c0_ene1_stall_in_2))
			begin
				local_bb1_keep_going_c0_ene1_valid_out_2_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_2to3_bb1_c0_ene1_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_2to3_bb1_c0_ene1_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_2to3_bb1_c0_ene1_0_NO_SHIFT_REG;
 logic rnode_2to3_bb1_c0_ene1_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_2to3_bb1_c0_ene1_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_2to3_bb1_c0_ene1_1_NO_SHIFT_REG;
 logic rnode_2to3_bb1_c0_ene1_0_reg_3_inputs_ready_NO_SHIFT_REG;
 logic rnode_2to3_bb1_c0_ene1_0_reg_3_NO_SHIFT_REG;
 logic rnode_2to3_bb1_c0_ene1_0_valid_out_0_reg_3_NO_SHIFT_REG;
 logic rnode_2to3_bb1_c0_ene1_0_stall_in_0_reg_3_NO_SHIFT_REG;
 logic rnode_2to3_bb1_c0_ene1_0_stall_out_reg_3_NO_SHIFT_REG;

acl_data_fifo rnode_2to3_bb1_c0_ene1_0_reg_3_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_2to3_bb1_c0_ene1_0_reg_3_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_2to3_bb1_c0_ene1_0_stall_in_0_reg_3_NO_SHIFT_REG),
	.valid_out(rnode_2to3_bb1_c0_ene1_0_valid_out_0_reg_3_NO_SHIFT_REG),
	.stall_out(rnode_2to3_bb1_c0_ene1_0_stall_out_reg_3_NO_SHIFT_REG),
	.data_in(rnode_1to2_bb1_c0_ene1_1_NO_SHIFT_REG),
	.data_out(rnode_2to3_bb1_c0_ene1_0_reg_3_NO_SHIFT_REG)
);

defparam rnode_2to3_bb1_c0_ene1_0_reg_3_fifo.DEPTH = 1;
defparam rnode_2to3_bb1_c0_ene1_0_reg_3_fifo.DATA_WIDTH = 1;
defparam rnode_2to3_bb1_c0_ene1_0_reg_3_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_2to3_bb1_c0_ene1_0_reg_3_fifo.IMPL = "shift_reg";

assign rnode_2to3_bb1_c0_ene1_0_reg_3_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_1to2_bb1_c0_ene1_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_2to3_bb1_c0_ene1_0_stall_in_0_reg_3_NO_SHIFT_REG = 1'b0;
assign rnode_2to3_bb1_c0_ene1_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_2to3_bb1_c0_ene1_0_NO_SHIFT_REG = rnode_2to3_bb1_c0_ene1_0_reg_3_NO_SHIFT_REG;
assign rnode_2to3_bb1_c0_ene1_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_2to3_bb1_c0_ene1_1_NO_SHIFT_REG = rnode_2to3_bb1_c0_ene1_0_reg_3_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire SFC_1_VALID_2_3_0_inputs_ready;
 reg SFC_1_VALID_2_3_0_valid_out_0_NO_SHIFT_REG;
wire SFC_1_VALID_2_3_0_stall_in_0;
 reg SFC_1_VALID_2_3_0_valid_out_1_NO_SHIFT_REG;
wire SFC_1_VALID_2_3_0_stall_in_1;
 reg SFC_1_VALID_2_3_0_valid_out_2_NO_SHIFT_REG;
wire SFC_1_VALID_2_3_0_stall_in_2;
 reg SFC_1_VALID_2_3_0_valid_out_3_NO_SHIFT_REG;
wire SFC_1_VALID_2_3_0_stall_in_3;
wire SFC_1_VALID_2_3_0_output_regs_ready;
 reg SFC_1_VALID_2_3_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_1_VALID_2_3_0_causedstall;

assign SFC_1_VALID_2_3_0_inputs_ready = 1'b1;
assign SFC_1_VALID_2_3_0_output_regs_ready = 1'b1;
assign SFC_1_VALID_1_2_0_stall_in_0 = 1'b0;
assign SFC_1_VALID_2_3_0_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		SFC_1_VALID_2_3_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (SFC_1_VALID_2_3_0_output_regs_ready)
		begin
			SFC_1_VALID_2_3_0_NO_SHIFT_REG <= SFC_1_VALID_1_2_0_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_initerations_pop25_acl_pop_i4_7_stall_local;
wire [3:0] local_bb1_initerations_pop25_acl_pop_i4_7;
wire local_bb1_initerations_pop25_acl_pop_i4_7_fu_valid_out;
wire local_bb1_initerations_pop25_acl_pop_i4_7_fu_stall_out;

acl_pop local_bb1_initerations_pop25_acl_pop_i4_7_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(rnode_1to2_bb1_c0_ene1_0_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(4'h7),
	.stall_out(local_bb1_initerations_pop25_acl_pop_i4_7_fu_stall_out),
	.valid_in(SFC_1_VALID_1_2_0_NO_SHIFT_REG),
	.valid_out(local_bb1_initerations_pop25_acl_pop_i4_7_fu_valid_out),
	.stall_in(local_bb1_initerations_pop25_acl_pop_i4_7_stall_local),
	.data_out(local_bb1_initerations_pop25_acl_pop_i4_7),
	.feedback_in(feedback_data_in_25),
	.feedback_valid_in(feedback_valid_in_25),
	.feedback_stall_out(feedback_stall_out_25)
);

defparam local_bb1_initerations_pop25_acl_pop_i4_7_feedback.COALESCE_DISTANCE = 1;
defparam local_bb1_initerations_pop25_acl_pop_i4_7_feedback.DATA_WIDTH = 4;
defparam local_bb1_initerations_pop25_acl_pop_i4_7_feedback.STYLE = "REGULAR";

assign local_bb1_initerations_pop25_acl_pop_i4_7_stall_local = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_2to3_bb1_keep_going_c0_ene1_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_2to3_bb1_keep_going_c0_ene1_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_2to3_bb1_keep_going_c0_ene1_0_NO_SHIFT_REG;
 logic rnode_2to3_bb1_keep_going_c0_ene1_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_2to3_bb1_keep_going_c0_ene1_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_2to3_bb1_keep_going_c0_ene1_1_NO_SHIFT_REG;
 logic rnode_2to3_bb1_keep_going_c0_ene1_0_reg_3_inputs_ready_NO_SHIFT_REG;
 logic rnode_2to3_bb1_keep_going_c0_ene1_0_reg_3_NO_SHIFT_REG;
 logic rnode_2to3_bb1_keep_going_c0_ene1_0_valid_out_0_reg_3_NO_SHIFT_REG;
 logic rnode_2to3_bb1_keep_going_c0_ene1_0_stall_in_0_reg_3_NO_SHIFT_REG;
 logic rnode_2to3_bb1_keep_going_c0_ene1_0_stall_out_reg_3_NO_SHIFT_REG;

acl_data_fifo rnode_2to3_bb1_keep_going_c0_ene1_0_reg_3_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_2to3_bb1_keep_going_c0_ene1_0_reg_3_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_2to3_bb1_keep_going_c0_ene1_0_stall_in_0_reg_3_NO_SHIFT_REG),
	.valid_out(rnode_2to3_bb1_keep_going_c0_ene1_0_valid_out_0_reg_3_NO_SHIFT_REG),
	.stall_out(rnode_2to3_bb1_keep_going_c0_ene1_0_stall_out_reg_3_NO_SHIFT_REG),
	.data_in(local_bb1_keep_going_c0_ene1_NO_SHIFT_REG),
	.data_out(rnode_2to3_bb1_keep_going_c0_ene1_0_reg_3_NO_SHIFT_REG)
);

defparam rnode_2to3_bb1_keep_going_c0_ene1_0_reg_3_fifo.DEPTH = 1;
defparam rnode_2to3_bb1_keep_going_c0_ene1_0_reg_3_fifo.DATA_WIDTH = 1;
defparam rnode_2to3_bb1_keep_going_c0_ene1_0_reg_3_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_2to3_bb1_keep_going_c0_ene1_0_reg_3_fifo.IMPL = "shift_reg";

assign rnode_2to3_bb1_keep_going_c0_ene1_0_reg_3_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_keep_going_c0_ene1_stall_in_2 = 1'b0;
assign rnode_2to3_bb1_keep_going_c0_ene1_0_stall_in_0_reg_3_NO_SHIFT_REG = 1'b0;
assign rnode_2to3_bb1_keep_going_c0_ene1_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_2to3_bb1_keep_going_c0_ene1_0_NO_SHIFT_REG = rnode_2to3_bb1_keep_going_c0_ene1_0_reg_3_NO_SHIFT_REG;
assign rnode_2to3_bb1_keep_going_c0_ene1_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_2to3_bb1_keep_going_c0_ene1_1_NO_SHIFT_REG = rnode_2to3_bb1_keep_going_c0_ene1_0_reg_3_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire SFC_1_VALID_3_4_0_inputs_ready;
 reg SFC_1_VALID_3_4_0_valid_out_0_NO_SHIFT_REG;
wire SFC_1_VALID_3_4_0_stall_in_0;
 reg SFC_1_VALID_3_4_0_valid_out_1_NO_SHIFT_REG;
wire SFC_1_VALID_3_4_0_stall_in_1;
 reg SFC_1_VALID_3_4_0_valid_out_2_NO_SHIFT_REG;
wire SFC_1_VALID_3_4_0_stall_in_2;
wire SFC_1_VALID_3_4_0_output_regs_ready;
 reg SFC_1_VALID_3_4_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_1_VALID_3_4_0_causedstall;

assign SFC_1_VALID_3_4_0_inputs_ready = 1'b1;
assign SFC_1_VALID_3_4_0_output_regs_ready = 1'b1;
assign SFC_1_VALID_2_3_0_stall_in_0 = 1'b0;
assign SFC_1_VALID_3_4_0_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		SFC_1_VALID_3_4_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (SFC_1_VALID_3_4_0_output_regs_ready)
		begin
			SFC_1_VALID_3_4_0_NO_SHIFT_REG <= SFC_1_VALID_2_3_0_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_cleanups_pop27_acl_pop_i4_7_valid_out;
wire local_bb1_cleanups_pop27_acl_pop_i4_7_stall_in;
wire local_bb1_cleanups_pop27_acl_pop_i4_7_inputs_ready;
wire local_bb1_cleanups_pop27_acl_pop_i4_7_stall_local;
wire [3:0] local_bb1_cleanups_pop27_acl_pop_i4_7;
wire local_bb1_cleanups_pop27_acl_pop_i4_7_fu_valid_out;
wire local_bb1_cleanups_pop27_acl_pop_i4_7_fu_stall_out;

acl_pop local_bb1_cleanups_pop27_acl_pop_i4_7_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(rnode_2to3_bb1_c0_ene1_0_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(4'h7),
	.stall_out(local_bb1_cleanups_pop27_acl_pop_i4_7_fu_stall_out),
	.valid_in(SFC_1_VALID_2_3_0_NO_SHIFT_REG),
	.valid_out(local_bb1_cleanups_pop27_acl_pop_i4_7_fu_valid_out),
	.stall_in(local_bb1_cleanups_pop27_acl_pop_i4_7_stall_local),
	.data_out(local_bb1_cleanups_pop27_acl_pop_i4_7),
	.feedback_in(feedback_data_in_27),
	.feedback_valid_in(feedback_valid_in_27),
	.feedback_stall_out(feedback_stall_out_27)
);

defparam local_bb1_cleanups_pop27_acl_pop_i4_7_feedback.COALESCE_DISTANCE = 1;
defparam local_bb1_cleanups_pop27_acl_pop_i4_7_feedback.DATA_WIDTH = 4;
defparam local_bb1_cleanups_pop27_acl_pop_i4_7_feedback.STYLE = "REGULAR";

assign local_bb1_cleanups_pop27_acl_pop_i4_7_inputs_ready = (SFC_1_VALID_2_3_0_valid_out_1_NO_SHIFT_REG & rnode_2to3_bb1_c0_ene1_0_valid_out_0_NO_SHIFT_REG);
assign local_bb1_cleanups_pop27_acl_pop_i4_7_stall_local = 1'b0;
assign local_bb1_cleanups_pop27_acl_pop_i4_7_valid_out = 1'b1;
assign SFC_1_VALID_2_3_0_stall_in_1 = 1'b0;
assign rnode_2to3_bb1_c0_ene1_0_stall_in_0_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_i_04_pop24_acl_pop_i32_0_stall_local;
wire [31:0] local_bb1_i_04_pop24_acl_pop_i32_0;
wire local_bb1_i_04_pop24_acl_pop_i32_0_fu_valid_out;
wire local_bb1_i_04_pop24_acl_pop_i32_0_fu_stall_out;

acl_pop local_bb1_i_04_pop24_acl_pop_i32_0_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(rnode_2to3_bb1_c0_ene1_1_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(32'h0),
	.stall_out(local_bb1_i_04_pop24_acl_pop_i32_0_fu_stall_out),
	.valid_in(SFC_1_VALID_2_3_0_NO_SHIFT_REG),
	.valid_out(local_bb1_i_04_pop24_acl_pop_i32_0_fu_valid_out),
	.stall_in(local_bb1_i_04_pop24_acl_pop_i32_0_stall_local),
	.data_out(local_bb1_i_04_pop24_acl_pop_i32_0),
	.feedback_in(feedback_data_in_24),
	.feedback_valid_in(feedback_valid_in_24),
	.feedback_stall_out(feedback_stall_out_24)
);

defparam local_bb1_i_04_pop24_acl_pop_i32_0_feedback.COALESCE_DISTANCE = 1;
defparam local_bb1_i_04_pop24_acl_pop_i32_0_feedback.DATA_WIDTH = 32;
defparam local_bb1_i_04_pop24_acl_pop_i32_0_feedback.STYLE = "REGULAR";

assign local_bb1_i_04_pop24_acl_pop_i32_0_stall_local = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_next_initerations_stall_local;
wire [3:0] local_bb1_next_initerations;

assign local_bb1_next_initerations = (local_bb1_initerations_pop25_acl_pop_i4_7 >> 4'h1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_3to4_bb1_keep_going_c0_ene1_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_3to4_bb1_keep_going_c0_ene1_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_3to4_bb1_keep_going_c0_ene1_0_NO_SHIFT_REG;
 logic rnode_3to4_bb1_keep_going_c0_ene1_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_3to4_bb1_keep_going_c0_ene1_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_3to4_bb1_keep_going_c0_ene1_1_NO_SHIFT_REG;
 logic rnode_3to4_bb1_keep_going_c0_ene1_0_reg_4_inputs_ready_NO_SHIFT_REG;
 logic rnode_3to4_bb1_keep_going_c0_ene1_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb1_keep_going_c0_ene1_0_valid_out_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb1_keep_going_c0_ene1_0_stall_in_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb1_keep_going_c0_ene1_0_stall_out_reg_4_NO_SHIFT_REG;

acl_data_fifo rnode_3to4_bb1_keep_going_c0_ene1_0_reg_4_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_3to4_bb1_keep_going_c0_ene1_0_reg_4_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_3to4_bb1_keep_going_c0_ene1_0_stall_in_0_reg_4_NO_SHIFT_REG),
	.valid_out(rnode_3to4_bb1_keep_going_c0_ene1_0_valid_out_0_reg_4_NO_SHIFT_REG),
	.stall_out(rnode_3to4_bb1_keep_going_c0_ene1_0_stall_out_reg_4_NO_SHIFT_REG),
	.data_in(rnode_2to3_bb1_keep_going_c0_ene1_1_NO_SHIFT_REG),
	.data_out(rnode_3to4_bb1_keep_going_c0_ene1_0_reg_4_NO_SHIFT_REG)
);

defparam rnode_3to4_bb1_keep_going_c0_ene1_0_reg_4_fifo.DEPTH = 1;
defparam rnode_3to4_bb1_keep_going_c0_ene1_0_reg_4_fifo.DATA_WIDTH = 1;
defparam rnode_3to4_bb1_keep_going_c0_ene1_0_reg_4_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_3to4_bb1_keep_going_c0_ene1_0_reg_4_fifo.IMPL = "shift_reg";

assign rnode_3to4_bb1_keep_going_c0_ene1_0_reg_4_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_2to3_bb1_keep_going_c0_ene1_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb1_keep_going_c0_ene1_0_stall_in_0_reg_4_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb1_keep_going_c0_ene1_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_3to4_bb1_keep_going_c0_ene1_0_NO_SHIFT_REG = rnode_3to4_bb1_keep_going_c0_ene1_0_reg_4_NO_SHIFT_REG;
assign rnode_3to4_bb1_keep_going_c0_ene1_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_3to4_bb1_keep_going_c0_ene1_1_NO_SHIFT_REG = rnode_3to4_bb1_keep_going_c0_ene1_0_reg_4_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire SFC_1_VALID_4_5_0_inputs_ready;
 reg SFC_1_VALID_4_5_0_valid_out_NO_SHIFT_REG;
wire SFC_1_VALID_4_5_0_stall_in;
wire SFC_1_VALID_4_5_0_output_regs_ready;
 reg SFC_1_VALID_4_5_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_1_VALID_4_5_0_causedstall;

assign SFC_1_VALID_4_5_0_inputs_ready = 1'b1;
assign SFC_1_VALID_4_5_0_output_regs_ready = 1'b1;
assign SFC_1_VALID_3_4_0_stall_in_0 = 1'b0;
assign SFC_1_VALID_4_5_0_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		SFC_1_VALID_4_5_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (SFC_1_VALID_4_5_0_output_regs_ready)
		begin
			SFC_1_VALID_4_5_0_NO_SHIFT_REG <= SFC_1_VALID_3_4_0_NO_SHIFT_REG;
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_stall_in_0_NO_SHIFT_REG;
 logic [3:0] rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_NO_SHIFT_REG;
 logic rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_stall_in_1_NO_SHIFT_REG;
 logic [3:0] rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_1_NO_SHIFT_REG;
 logic rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_reg_4_inputs_ready_NO_SHIFT_REG;
 logic [3:0] rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_valid_out_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_stall_in_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_stall_out_reg_4_NO_SHIFT_REG;

acl_data_fifo rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_reg_4_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_reg_4_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_stall_in_0_reg_4_NO_SHIFT_REG),
	.valid_out(rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_valid_out_0_reg_4_NO_SHIFT_REG),
	.stall_out(rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_stall_out_reg_4_NO_SHIFT_REG),
	.data_in(local_bb1_cleanups_pop27_acl_pop_i4_7),
	.data_out(rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_reg_4_NO_SHIFT_REG)
);

defparam rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_reg_4_fifo.DEPTH = 1;
defparam rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_reg_4_fifo.DATA_WIDTH = 4;
defparam rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_reg_4_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_reg_4_fifo.IMPL = "shift_reg";

assign rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_reg_4_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cleanups_pop27_acl_pop_i4_7_stall_in = 1'b0;
assign rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_stall_in_0_reg_4_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_NO_SHIFT_REG = rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_reg_4_NO_SHIFT_REG;
assign rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_1_NO_SHIFT_REG = rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_reg_4_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_inc74_stall_local;
wire [31:0] local_bb1_inc74;

assign local_bb1_inc74 = (local_bb1_i_04_pop24_acl_pop_i32_0 + 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_var__stall_local;
wire [3:0] local_bb1_var_;

assign local_bb1_var_ = ((local_bb1_next_initerations & 4'h7) & 4'h1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_4to5_bb1_keep_going_c0_ene1_0_valid_out_NO_SHIFT_REG;
 logic rnode_4to5_bb1_keep_going_c0_ene1_0_stall_in_NO_SHIFT_REG;
 logic rnode_4to5_bb1_keep_going_c0_ene1_0_NO_SHIFT_REG;
 logic rnode_4to5_bb1_keep_going_c0_ene1_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic rnode_4to5_bb1_keep_going_c0_ene1_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1_keep_going_c0_ene1_0_valid_out_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1_keep_going_c0_ene1_0_stall_in_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1_keep_going_c0_ene1_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_4to5_bb1_keep_going_c0_ene1_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_4to5_bb1_keep_going_c0_ene1_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_4to5_bb1_keep_going_c0_ene1_0_stall_in_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_4to5_bb1_keep_going_c0_ene1_0_valid_out_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_4to5_bb1_keep_going_c0_ene1_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(rnode_3to4_bb1_keep_going_c0_ene1_1_NO_SHIFT_REG),
	.data_out(rnode_4to5_bb1_keep_going_c0_ene1_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_4to5_bb1_keep_going_c0_ene1_0_reg_5_fifo.DEPTH = 1;
defparam rnode_4to5_bb1_keep_going_c0_ene1_0_reg_5_fifo.DATA_WIDTH = 1;
defparam rnode_4to5_bb1_keep_going_c0_ene1_0_reg_5_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_4to5_bb1_keep_going_c0_ene1_0_reg_5_fifo.IMPL = "shift_reg";

assign rnode_4to5_bb1_keep_going_c0_ene1_0_reg_5_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_3to4_bb1_keep_going_c0_ene1_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb1_keep_going_c0_ene1_0_NO_SHIFT_REG = rnode_4to5_bb1_keep_going_c0_ene1_0_reg_5_NO_SHIFT_REG;
assign rnode_4to5_bb1_keep_going_c0_ene1_0_stall_in_reg_5_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb1_keep_going_c0_ene1_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_var__u0_stall_local;
wire [3:0] local_bb1_var__u0;

assign local_bb1_var__u0 = (rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_NO_SHIFT_REG & 4'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_i_04_pop24_acl_pop_i32_0_valid_out_1;
wire local_bb1_i_04_pop24_acl_pop_i32_0_stall_in_1;
wire local_bb1_inc74_valid_out_0;
wire local_bb1_inc74_stall_in_0;
wire local_bb1_exitcond7_valid_out;
wire local_bb1_exitcond7_stall_in;
wire local_bb1_exitcond7_inputs_ready;
wire local_bb1_exitcond7_stall_local;
wire local_bb1_exitcond7;

assign local_bb1_exitcond7_inputs_ready = (SFC_1_VALID_2_3_0_valid_out_2_NO_SHIFT_REG & rnode_2to3_bb1_c0_ene1_0_valid_out_1_NO_SHIFT_REG);
assign local_bb1_exitcond7 = (local_bb1_inc74 == input_wii_mul);
assign local_bb1_i_04_pop24_acl_pop_i32_0_valid_out_1 = 1'b1;
assign local_bb1_inc74_valid_out_0 = 1'b1;
assign local_bb1_exitcond7_valid_out = 1'b1;
assign SFC_1_VALID_2_3_0_stall_in_2 = 1'b0;
assign rnode_2to3_bb1_c0_ene1_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_next_initerations_valid_out_0;
wire local_bb1_next_initerations_stall_in_0;
wire local_bb1_last_initeration_valid_out;
wire local_bb1_last_initeration_stall_in;
wire local_bb1_last_initeration_inputs_ready;
wire local_bb1_last_initeration_stall_local;
wire local_bb1_last_initeration;

assign local_bb1_last_initeration_inputs_ready = (SFC_1_VALID_1_2_0_valid_out_1_NO_SHIFT_REG & rnode_1to2_bb1_c0_ene1_0_valid_out_0_NO_SHIFT_REG);
assign local_bb1_last_initeration = ((local_bb1_var_ & 4'h1) != 4'h0);
assign local_bb1_next_initerations_valid_out_0 = 1'b1;
assign local_bb1_last_initeration_valid_out = 1'b1;
assign SFC_1_VALID_1_2_0_stall_in_1 = 1'b0;
assign rnode_1to2_bb1_c0_ene1_0_stall_in_0_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_c0_exi1_stall_local;
wire [191:0] local_bb1_c0_exi1;

assign local_bb1_c0_exi1[7:0] = 8'bx;
assign local_bb1_c0_exi1[8] = rnode_4to5_bb1_keep_going_c0_ene1_0_NO_SHIFT_REG;
assign local_bb1_c0_exi1[191:9] = 183'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_first_cleanup_stall_local;
wire local_bb1_first_cleanup;

assign local_bb1_first_cleanup = ((local_bb1_var__u0 & 4'h1) != 4'h0);

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_valid_out_NO_SHIFT_REG;
 logic rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_NO_SHIFT_REG;
 logic rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_reg_5_NO_SHIFT_REG;
 logic rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_valid_out_reg_5_NO_SHIFT_REG;
 logic rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_stall_in_reg_5_NO_SHIFT_REG;
 logic rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_stall_in_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_valid_out_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_bb1_i_04_pop24_acl_pop_i32_0),
	.data_out(rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_reg_5_fifo.DEPTH = 2;
defparam rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_reg_5_fifo.DATA_WIDTH = 32;
defparam rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_reg_5_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_reg_5_fifo.IMPL = "shift_reg";

assign rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_reg_5_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_i_04_pop24_acl_pop_i32_0_stall_in_1 = 1'b0;
assign rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_NO_SHIFT_REG = rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_reg_5_NO_SHIFT_REG;
assign rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_stall_in_reg_5_NO_SHIFT_REG = 1'b0;
assign rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements a registered operation.
// 
wire local_bb1_i_04_push24_inc74_inputs_ready;
wire local_bb1_i_04_push24_inc74_output_regs_ready;
wire [31:0] local_bb1_i_04_push24_inc74_result;
wire local_bb1_i_04_push24_inc74_fu_valid_out;
wire local_bb1_i_04_push24_inc74_fu_stall_out;
 reg [31:0] local_bb1_i_04_push24_inc74_NO_SHIFT_REG;
wire local_bb1_i_04_push24_inc74_causedstall;

acl_push local_bb1_i_04_push24_inc74_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(rnode_2to3_bb1_keep_going_c0_ene1_0_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_inc74),
	.stall_out(local_bb1_i_04_push24_inc74_fu_stall_out),
	.valid_in(SFC_1_VALID_2_3_0_NO_SHIFT_REG),
	.valid_out(local_bb1_i_04_push24_inc74_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_i_04_push24_inc74_result),
	.feedback_out(feedback_data_out_24),
	.feedback_valid_out(feedback_valid_out_24),
	.feedback_stall_in(feedback_stall_in_24)
);

defparam local_bb1_i_04_push24_inc74_feedback.STALLFREE = 1;
defparam local_bb1_i_04_push24_inc74_feedback.ENABLED = 0;
defparam local_bb1_i_04_push24_inc74_feedback.DATA_WIDTH = 32;
defparam local_bb1_i_04_push24_inc74_feedback.FIFO_DEPTH = 1;
defparam local_bb1_i_04_push24_inc74_feedback.MIN_FIFO_LATENCY = 1;
defparam local_bb1_i_04_push24_inc74_feedback.STYLE = "REGULAR";
defparam local_bb1_i_04_push24_inc74_feedback.RAM_FIFO_DEPTH_INC = 1;

assign local_bb1_i_04_push24_inc74_inputs_ready = 1'b1;
assign local_bb1_i_04_push24_inc74_output_regs_ready = 1'b1;
assign local_bb1_inc74_stall_in_0 = 1'b0;
assign SFC_1_VALID_2_3_0_stall_in_3 = 1'b0;
assign rnode_2to3_bb1_keep_going_c0_ene1_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign local_bb1_i_04_push24_inc74_causedstall = (SFC_1_VALID_2_3_0_NO_SHIFT_REG && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_i_04_push24_inc74_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_i_04_push24_inc74_output_regs_ready)
		begin
			local_bb1_i_04_push24_inc74_NO_SHIFT_REG <= local_bb1_i_04_push24_inc74_result;
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_3to4_bb1_exitcond7_0_valid_out_NO_SHIFT_REG;
 logic rnode_3to4_bb1_exitcond7_0_stall_in_NO_SHIFT_REG;
 logic rnode_3to4_bb1_exitcond7_0_NO_SHIFT_REG;
 logic rnode_3to4_bb1_exitcond7_0_reg_4_inputs_ready_NO_SHIFT_REG;
 logic rnode_3to4_bb1_exitcond7_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb1_exitcond7_0_valid_out_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb1_exitcond7_0_stall_in_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb1_exitcond7_0_stall_out_reg_4_NO_SHIFT_REG;

acl_data_fifo rnode_3to4_bb1_exitcond7_0_reg_4_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_3to4_bb1_exitcond7_0_reg_4_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_3to4_bb1_exitcond7_0_stall_in_reg_4_NO_SHIFT_REG),
	.valid_out(rnode_3to4_bb1_exitcond7_0_valid_out_reg_4_NO_SHIFT_REG),
	.stall_out(rnode_3to4_bb1_exitcond7_0_stall_out_reg_4_NO_SHIFT_REG),
	.data_in(local_bb1_exitcond7),
	.data_out(rnode_3to4_bb1_exitcond7_0_reg_4_NO_SHIFT_REG)
);

defparam rnode_3to4_bb1_exitcond7_0_reg_4_fifo.DEPTH = 1;
defparam rnode_3to4_bb1_exitcond7_0_reg_4_fifo.DATA_WIDTH = 1;
defparam rnode_3to4_bb1_exitcond7_0_reg_4_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_3to4_bb1_exitcond7_0_reg_4_fifo.IMPL = "shift_reg";

assign rnode_3to4_bb1_exitcond7_0_reg_4_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_exitcond7_stall_in = 1'b0;
assign rnode_3to4_bb1_exitcond7_0_NO_SHIFT_REG = rnode_3to4_bb1_exitcond7_0_reg_4_NO_SHIFT_REG;
assign rnode_3to4_bb1_exitcond7_0_stall_in_reg_4_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb1_exitcond7_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements a registered operation.
// 
wire local_bb1_initerations_push25_next_initerations_inputs_ready;
wire local_bb1_initerations_push25_next_initerations_output_regs_ready;
wire [3:0] local_bb1_initerations_push25_next_initerations_result;
wire local_bb1_initerations_push25_next_initerations_fu_valid_out;
wire local_bb1_initerations_push25_next_initerations_fu_stall_out;
 reg [3:0] local_bb1_initerations_push25_next_initerations_NO_SHIFT_REG;
wire local_bb1_initerations_push25_next_initerations_causedstall;

acl_push local_bb1_initerations_push25_next_initerations_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_keep_going_c0_ene1_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in((local_bb1_next_initerations & 4'h7)),
	.stall_out(local_bb1_initerations_push25_next_initerations_fu_stall_out),
	.valid_in(SFC_1_VALID_1_2_0_NO_SHIFT_REG),
	.valid_out(local_bb1_initerations_push25_next_initerations_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_initerations_push25_next_initerations_result),
	.feedback_out(feedback_data_out_25),
	.feedback_valid_out(feedback_valid_out_25),
	.feedback_stall_in(feedback_stall_in_25)
);

defparam local_bb1_initerations_push25_next_initerations_feedback.STALLFREE = 1;
defparam local_bb1_initerations_push25_next_initerations_feedback.ENABLED = 0;
defparam local_bb1_initerations_push25_next_initerations_feedback.DATA_WIDTH = 4;
defparam local_bb1_initerations_push25_next_initerations_feedback.FIFO_DEPTH = 1;
defparam local_bb1_initerations_push25_next_initerations_feedback.MIN_FIFO_LATENCY = 1;
defparam local_bb1_initerations_push25_next_initerations_feedback.STYLE = "REGULAR";
defparam local_bb1_initerations_push25_next_initerations_feedback.RAM_FIFO_DEPTH_INC = 1;

assign local_bb1_initerations_push25_next_initerations_inputs_ready = 1'b1;
assign local_bb1_initerations_push25_next_initerations_output_regs_ready = 1'b1;
assign local_bb1_next_initerations_stall_in_0 = 1'b0;
assign local_bb1_keep_going_c0_ene1_stall_in_0 = 1'b0;
assign SFC_1_VALID_1_2_0_stall_in_2 = 1'b0;
assign local_bb1_initerations_push25_next_initerations_causedstall = (SFC_1_VALID_1_2_0_NO_SHIFT_REG && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_initerations_push25_next_initerations_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_initerations_push25_next_initerations_output_regs_ready)
		begin
			local_bb1_initerations_push25_next_initerations_NO_SHIFT_REG <= local_bb1_initerations_push25_next_initerations_result;
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
	.dir(local_bb1_keep_going_c0_ene1_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_last_initeration),
	.stall_out(local_bb1_lastiniteration_last_initeration_fu_stall_out),
	.valid_in(SFC_1_VALID_1_2_0_NO_SHIFT_REG),
	.valid_out(local_bb1_lastiniteration_last_initeration_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_lastiniteration_last_initeration_result),
	.feedback_out(feedback_data_out_0),
	.feedback_valid_out(feedback_valid_out_0),
	.feedback_stall_in(feedback_stall_in_0)
);

defparam local_bb1_lastiniteration_last_initeration_feedback.STALLFREE = 1;
defparam local_bb1_lastiniteration_last_initeration_feedback.ENABLED = 0;
defparam local_bb1_lastiniteration_last_initeration_feedback.DATA_WIDTH = 1;
defparam local_bb1_lastiniteration_last_initeration_feedback.FIFO_DEPTH = 1;
defparam local_bb1_lastiniteration_last_initeration_feedback.MIN_FIFO_LATENCY = 0;
defparam local_bb1_lastiniteration_last_initeration_feedback.STYLE = "REGULAR";
defparam local_bb1_lastiniteration_last_initeration_feedback.RAM_FIFO_DEPTH_INC = 0;

assign local_bb1_lastiniteration_last_initeration_inputs_ready = 1'b1;
assign local_bb1_lastiniteration_last_initeration_output_regs_ready = 1'b1;
assign local_bb1_last_initeration_stall_in = 1'b0;
assign local_bb1_keep_going_c0_ene1_stall_in_1 = 1'b0;
assign SFC_1_VALID_1_2_0_stall_in_3 = 1'b0;
assign local_bb1_lastiniteration_last_initeration_causedstall = (SFC_1_VALID_1_2_0_NO_SHIFT_REG && (1'b0 && !(1'b0)));

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
wire local_bb1_xor_stall_local;
wire local_bb1_xor;

assign local_bb1_xor = (local_bb1_first_cleanup ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1_idxprom7_stall_local;
wire [63:0] local_bb1_idxprom7;

assign local_bb1_idxprom7[63:32] = 32'h0;
assign local_bb1_idxprom7[31:0] = rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_var__u1_stall_local;
wire local_bb1_var__u1;

assign local_bb1_var__u1 = (input_wii_cmp22 | rnode_3to4_bb1_exitcond7_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_arrayidx8_stall_local;
wire [63:0] local_bb1_arrayidx8;

assign local_bb1_arrayidx8 = ((input_pixels & 64'hFFFFFFFFFFFFFC00) + ((local_bb1_idxprom7 & 64'hFFFFFFFF) << 6'h2));

// This section implements an unregistered operation.
// 
wire local_bb1_notexit_stall_local;
wire local_bb1_notexit;

assign local_bb1_notexit = (local_bb1_var__u1 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1_or_stall_local;
wire local_bb1_or;

assign local_bb1_or = (local_bb1_var__u1 | local_bb1_xor);

// This section implements an unregistered operation.
// 
wire local_bb1_masked_stall_local;
wire local_bb1_masked;

assign local_bb1_masked = (local_bb1_var__u1 & local_bb1_first_cleanup);

// This section implements an unregistered operation.
// 
wire local_bb1_c0_exi2_stall_local;
wire [191:0] local_bb1_c0_exi2;

assign local_bb1_c0_exi2[63:0] = local_bb1_c0_exi1[63:0];
assign local_bb1_c0_exi2[127:64] = (local_bb1_arrayidx8 & 64'hFFFFFFFFFFFFFFFC);
assign local_bb1_c0_exi2[191:128] = local_bb1_c0_exi1[191:128];

// This section implements an unregistered operation.
// 
wire local_bb1_cleanups_shl_stall_local;
wire [3:0] local_bb1_cleanups_shl;

assign local_bb1_cleanups_shl[3:1] = 3'h0;
assign local_bb1_cleanups_shl[0] = local_bb1_or;

// This section implements an unregistered operation.
// 
wire local_bb1_first_cleanup_valid_out_1;
wire local_bb1_first_cleanup_stall_in_1;
wire local_bb1_xor_valid_out_1;
wire local_bb1_xor_stall_in_1;
wire local_bb1_masked_valid_out;
wire local_bb1_masked_stall_in;
wire local_bb1_notexit_valid_out;
wire local_bb1_notexit_stall_in;
wire local_bb1_next_cleanups_valid_out;
wire local_bb1_next_cleanups_stall_in;
wire local_bb1_next_cleanups_inputs_ready;
wire local_bb1_next_cleanups_stall_local;
wire [3:0] local_bb1_next_cleanups;

assign local_bb1_next_cleanups_inputs_ready = (rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_valid_out_0_NO_SHIFT_REG & rnode_3to4_bb1_exitcond7_0_valid_out_NO_SHIFT_REG & rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_valid_out_1_NO_SHIFT_REG);
assign local_bb1_next_cleanups = (rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_1_NO_SHIFT_REG << (local_bb1_cleanups_shl & 4'h1));
assign local_bb1_first_cleanup_valid_out_1 = 1'b1;
assign local_bb1_xor_valid_out_1 = 1'b1;
assign local_bb1_masked_valid_out = 1'b1;
assign local_bb1_notexit_valid_out = 1'b1;
assign local_bb1_next_cleanups_valid_out = 1'b1;
assign rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb1_exitcond7_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb1_cleanups_pop27_acl_pop_i4_7_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_4to5_bb1_xor_0_valid_out_NO_SHIFT_REG;
 logic rnode_4to5_bb1_xor_0_stall_in_NO_SHIFT_REG;
 logic rnode_4to5_bb1_xor_0_NO_SHIFT_REG;
 logic rnode_4to5_bb1_xor_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic rnode_4to5_bb1_xor_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1_xor_0_valid_out_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1_xor_0_stall_in_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1_xor_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_4to5_bb1_xor_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_4to5_bb1_xor_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_4to5_bb1_xor_0_stall_in_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_4to5_bb1_xor_0_valid_out_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_4to5_bb1_xor_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_bb1_xor),
	.data_out(rnode_4to5_bb1_xor_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_4to5_bb1_xor_0_reg_5_fifo.DEPTH = 1;
defparam rnode_4to5_bb1_xor_0_reg_5_fifo.DATA_WIDTH = 1;
defparam rnode_4to5_bb1_xor_0_reg_5_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_4to5_bb1_xor_0_reg_5_fifo.IMPL = "shift_reg";

assign rnode_4to5_bb1_xor_0_reg_5_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_xor_stall_in_1 = 1'b0;
assign rnode_4to5_bb1_xor_0_NO_SHIFT_REG = rnode_4to5_bb1_xor_0_reg_5_NO_SHIFT_REG;
assign rnode_4to5_bb1_xor_0_stall_in_reg_5_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb1_xor_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_4to5_bb1_masked_0_valid_out_NO_SHIFT_REG;
 logic rnode_4to5_bb1_masked_0_stall_in_NO_SHIFT_REG;
 logic rnode_4to5_bb1_masked_0_NO_SHIFT_REG;
 logic rnode_4to5_bb1_masked_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic rnode_4to5_bb1_masked_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1_masked_0_valid_out_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1_masked_0_stall_in_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1_masked_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_4to5_bb1_masked_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_4to5_bb1_masked_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_4to5_bb1_masked_0_stall_in_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_4to5_bb1_masked_0_valid_out_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_4to5_bb1_masked_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_bb1_masked),
	.data_out(rnode_4to5_bb1_masked_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_4to5_bb1_masked_0_reg_5_fifo.DEPTH = 1;
defparam rnode_4to5_bb1_masked_0_reg_5_fifo.DATA_WIDTH = 1;
defparam rnode_4to5_bb1_masked_0_reg_5_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_4to5_bb1_masked_0_reg_5_fifo.IMPL = "shift_reg";

assign rnode_4to5_bb1_masked_0_reg_5_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_masked_stall_in = 1'b0;
assign rnode_4to5_bb1_masked_0_NO_SHIFT_REG = rnode_4to5_bb1_masked_0_reg_5_NO_SHIFT_REG;
assign rnode_4to5_bb1_masked_0_stall_in_reg_5_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb1_masked_0_valid_out_NO_SHIFT_REG = 1'b1;

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
	.valid_in(SFC_1_VALID_3_4_0_NO_SHIFT_REG),
	.valid_out(local_bb1_notexitcond_notexit_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_notexitcond_notexit_result),
	.feedback_out(feedback_data_out_1),
	.feedback_valid_out(feedback_valid_out_1),
	.feedback_stall_in(feedback_stall_in_1)
);

defparam local_bb1_notexitcond_notexit_feedback.STALLFREE = 1;
defparam local_bb1_notexitcond_notexit_feedback.ENABLED = 0;
defparam local_bb1_notexitcond_notexit_feedback.DATA_WIDTH = 1;
defparam local_bb1_notexitcond_notexit_feedback.FIFO_DEPTH = 3;
defparam local_bb1_notexitcond_notexit_feedback.MIN_FIFO_LATENCY = 0;
defparam local_bb1_notexitcond_notexit_feedback.STYLE = "REGULAR";
defparam local_bb1_notexitcond_notexit_feedback.RAM_FIFO_DEPTH_INC = 0;

assign local_bb1_notexitcond_notexit_inputs_ready = 1'b1;
assign local_bb1_notexitcond_notexit_output_regs_ready = 1'b1;
assign local_bb1_notexit_stall_in = 1'b0;
assign local_bb1_first_cleanup_stall_in_1 = 1'b0;
assign SFC_1_VALID_3_4_0_stall_in_1 = 1'b0;
assign local_bb1_notexitcond_notexit_causedstall = (SFC_1_VALID_3_4_0_NO_SHIFT_REG && (1'b0 && !(1'b0)));

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


// This section implements a registered operation.
// 
wire local_bb1_cleanups_push27_next_cleanups_inputs_ready;
wire local_bb1_cleanups_push27_next_cleanups_output_regs_ready;
wire [3:0] local_bb1_cleanups_push27_next_cleanups_result;
wire local_bb1_cleanups_push27_next_cleanups_fu_valid_out;
wire local_bb1_cleanups_push27_next_cleanups_fu_stall_out;
 reg [3:0] local_bb1_cleanups_push27_next_cleanups_NO_SHIFT_REG;
wire local_bb1_cleanups_push27_next_cleanups_causedstall;

acl_push local_bb1_cleanups_push27_next_cleanups_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(rnode_3to4_bb1_keep_going_c0_ene1_0_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_next_cleanups),
	.stall_out(local_bb1_cleanups_push27_next_cleanups_fu_stall_out),
	.valid_in(SFC_1_VALID_3_4_0_NO_SHIFT_REG),
	.valid_out(local_bb1_cleanups_push27_next_cleanups_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_cleanups_push27_next_cleanups_result),
	.feedback_out(feedback_data_out_27),
	.feedback_valid_out(feedback_valid_out_27),
	.feedback_stall_in(feedback_stall_in_27)
);

defparam local_bb1_cleanups_push27_next_cleanups_feedback.STALLFREE = 1;
defparam local_bb1_cleanups_push27_next_cleanups_feedback.ENABLED = 0;
defparam local_bb1_cleanups_push27_next_cleanups_feedback.DATA_WIDTH = 4;
defparam local_bb1_cleanups_push27_next_cleanups_feedback.FIFO_DEPTH = 1;
defparam local_bb1_cleanups_push27_next_cleanups_feedback.MIN_FIFO_LATENCY = 0;
defparam local_bb1_cleanups_push27_next_cleanups_feedback.STYLE = "REGULAR";
defparam local_bb1_cleanups_push27_next_cleanups_feedback.RAM_FIFO_DEPTH_INC = 0;

assign local_bb1_cleanups_push27_next_cleanups_inputs_ready = 1'b1;
assign local_bb1_cleanups_push27_next_cleanups_output_regs_ready = 1'b1;
assign local_bb1_next_cleanups_stall_in = 1'b0;
assign SFC_1_VALID_3_4_0_stall_in_2 = 1'b0;
assign rnode_3to4_bb1_keep_going_c0_ene1_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign local_bb1_cleanups_push27_next_cleanups_causedstall = (SFC_1_VALID_3_4_0_NO_SHIFT_REG && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_cleanups_push27_next_cleanups_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_cleanups_push27_next_cleanups_output_regs_ready)
		begin
			local_bb1_cleanups_push27_next_cleanups_NO_SHIFT_REG <= local_bb1_cleanups_push27_next_cleanups_result;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_first_cleanup_xor_or_stall_local;
wire local_bb1_first_cleanup_xor_or;

assign local_bb1_first_cleanup_xor_or = (input_wii_cmp22 | rnode_4to5_bb1_xor_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_c0_exi3_stall_local;
wire [191:0] local_bb1_c0_exi3;

assign local_bb1_c0_exi3[127:0] = local_bb1_c0_exi2[127:0];
assign local_bb1_c0_exi3[128] = local_bb1_first_cleanup_xor_or;
assign local_bb1_c0_exi3[191:129] = local_bb1_c0_exi2[191:129];

// This section implements an unregistered operation.
// 
wire local_bb1_c0_exi4_valid_out;
wire local_bb1_c0_exi4_stall_in;
wire local_bb1_c0_exi4_inputs_ready;
wire local_bb1_c0_exi4_stall_local;
wire [191:0] local_bb1_c0_exi4;

assign local_bb1_c0_exi4_inputs_ready = (rnode_4to5_bb1_keep_going_c0_ene1_0_valid_out_NO_SHIFT_REG & rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_valid_out_NO_SHIFT_REG & rnode_4to5_bb1_masked_0_valid_out_NO_SHIFT_REG & rnode_4to5_bb1_xor_0_valid_out_NO_SHIFT_REG);
assign local_bb1_c0_exi4[135:0] = local_bb1_c0_exi3[135:0];
assign local_bb1_c0_exi4[136] = rnode_4to5_bb1_masked_0_NO_SHIFT_REG;
assign local_bb1_c0_exi4[191:137] = local_bb1_c0_exi3[191:137];
assign local_bb1_c0_exi4_valid_out = 1'b1;
assign rnode_4to5_bb1_keep_going_c0_ene1_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_3to5_bb1_i_04_pop24_acl_pop_i32_0_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb1_masked_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb1_xor_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements a registered operation.
// 
wire local_bb1_c0_exit_c0_exi4_inputs_ready;
 reg local_bb1_c0_exit_c0_exi4_valid_out_0_NO_SHIFT_REG;
wire local_bb1_c0_exit_c0_exi4_stall_in_0;
 reg local_bb1_c0_exit_c0_exi4_valid_out_1_NO_SHIFT_REG;
wire local_bb1_c0_exit_c0_exi4_stall_in_1;
 reg local_bb1_c0_exit_c0_exi4_valid_out_2_NO_SHIFT_REG;
wire local_bb1_c0_exit_c0_exi4_stall_in_2;
 reg local_bb1_c0_exit_c0_exi4_valid_out_3_NO_SHIFT_REG;
wire local_bb1_c0_exit_c0_exi4_stall_in_3;
 reg [191:0] local_bb1_c0_exit_c0_exi4_NO_SHIFT_REG;
wire [191:0] local_bb1_c0_exit_c0_exi4_in;
wire local_bb1_c0_exit_c0_exi4_valid;
wire local_bb1_c0_exit_c0_exi4_causedstall;

acl_stall_free_sink local_bb1_c0_exit_c0_exi4_instance (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb1_c0_exi4),
	.data_out(local_bb1_c0_exit_c0_exi4_in),
	.input_accepted(local_bb1_c0_enter_c0_eni1_input_accepted),
	.valid_out(local_bb1_c0_exit_c0_exi4_valid),
	.stall_in(~(local_bb1_c0_exit_c0_exi4_output_regs_ready)),
	.stall_entry(local_bb1_c0_exit_c0_exi4_entry_stall),
	.valid_in(local_bb1_c0_exit_c0_exi4_valid_in),
	.IIphases(local_bb1_c0_exit_c0_exi4_phases),
	.inc_pipelined_thread(local_bb1_c0_enter_c0_eni1_inc_pipelined_thread),
	.dec_pipelined_thread(local_bb1_c0_enter_c0_eni1_dec_pipelined_thread)
);

defparam local_bb1_c0_exit_c0_exi4_instance.DATA_WIDTH = 192;
defparam local_bb1_c0_exit_c0_exi4_instance.PIPELINE_DEPTH = 9;
defparam local_bb1_c0_exit_c0_exi4_instance.SHARINGII = 1;
defparam local_bb1_c0_exit_c0_exi4_instance.SCHEDULEII = 1;
defparam local_bb1_c0_exit_c0_exi4_instance.ALWAYS_THROTTLE = 0;

assign local_bb1_c0_exit_c0_exi4_inputs_ready = 1'b1;
assign local_bb1_c0_exit_c0_exi4_output_regs_ready = ((~(local_bb1_c0_exit_c0_exi4_valid_out_0_NO_SHIFT_REG) | ~(local_bb1_c0_exit_c0_exi4_stall_in_0)) & (~(local_bb1_c0_exit_c0_exi4_valid_out_1_NO_SHIFT_REG) | ~(local_bb1_c0_exit_c0_exi4_stall_in_1)) & (~(local_bb1_c0_exit_c0_exi4_valid_out_2_NO_SHIFT_REG) | ~(local_bb1_c0_exit_c0_exi4_stall_in_2)) & (~(local_bb1_c0_exit_c0_exi4_valid_out_3_NO_SHIFT_REG) | ~(local_bb1_c0_exit_c0_exi4_stall_in_3)));
assign local_bb1_c0_exit_c0_exi4_valid_in = SFC_1_VALID_4_5_0_NO_SHIFT_REG;
assign local_bb1_c0_exi4_stall_in = 1'b0;
assign SFC_1_VALID_4_5_0_stall_in = 1'b0;
assign local_bb1_c0_exit_c0_exi4_causedstall = (1'b1 && (1'b0 && !(~(local_bb1_c0_exit_c0_exi4_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c0_exit_c0_exi4_NO_SHIFT_REG <= 'x;
		local_bb1_c0_exit_c0_exi4_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_exit_c0_exi4_valid_out_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_exit_c0_exi4_valid_out_2_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_exit_c0_exi4_valid_out_3_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c0_exit_c0_exi4_output_regs_ready)
		begin
			local_bb1_c0_exit_c0_exi4_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi4_in;
			local_bb1_c0_exit_c0_exi4_valid_out_0_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi4_valid;
			local_bb1_c0_exit_c0_exi4_valid_out_1_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi4_valid;
			local_bb1_c0_exit_c0_exi4_valid_out_2_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi4_valid;
			local_bb1_c0_exit_c0_exi4_valid_out_3_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi4_valid;
		end
		else
		begin
			if (~(local_bb1_c0_exit_c0_exi4_stall_in_0))
			begin
				local_bb1_c0_exit_c0_exi4_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c0_exit_c0_exi4_stall_in_1))
			begin
				local_bb1_c0_exit_c0_exi4_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c0_exit_c0_exi4_stall_in_2))
			begin
				local_bb1_c0_exit_c0_exi4_valid_out_2_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c0_exit_c0_exi4_stall_in_3))
			begin
				local_bb1_c0_exit_c0_exi4_valid_out_3_NO_SHIFT_REG <= 1'b0;
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
wire local_bb1_c0_exe1;

assign local_bb1_c0_exe1_inputs_ready = local_bb1_c0_exit_c0_exi4_valid_out_0_NO_SHIFT_REG;
assign local_bb1_c0_exe1 = local_bb1_c0_exit_c0_exi4_NO_SHIFT_REG[8];
assign local_bb1_c0_exe1_valid_out = local_bb1_c0_exe1_inputs_ready;
assign local_bb1_c0_exe1_stall_local = local_bb1_c0_exe1_stall_in;
assign local_bb1_c0_exit_c0_exi4_stall_in_0 = (|local_bb1_c0_exe1_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb1_c0_exe2_stall_local;
wire [63:0] local_bb1_c0_exe2;

assign local_bb1_c0_exe2[63:0] = local_bb1_c0_exit_c0_exi4_NO_SHIFT_REG[127:64];

// This section implements an unregistered operation.
// 
wire local_bb1_c0_exe2_valid_out;
wire local_bb1_c0_exe2_stall_in;
wire local_bb1_c0_exe3_valid_out;
wire local_bb1_c0_exe3_stall_in;
wire local_bb1_c0_exe3_inputs_ready;
wire local_bb1_c0_exe3_stall_local;
wire local_bb1_c0_exe3;
 reg local_bb1_c0_exe2_consumed_0_NO_SHIFT_REG;
 reg local_bb1_c0_exe3_consumed_0_NO_SHIFT_REG;

assign local_bb1_c0_exe3_inputs_ready = (local_bb1_c0_exit_c0_exi4_valid_out_1_NO_SHIFT_REG & local_bb1_c0_exit_c0_exi4_valid_out_2_NO_SHIFT_REG);
assign local_bb1_c0_exe3 = local_bb1_c0_exit_c0_exi4_NO_SHIFT_REG[128];
assign local_bb1_c0_exe3_stall_local = ((local_bb1_c0_exe2_stall_in & ~(local_bb1_c0_exe2_consumed_0_NO_SHIFT_REG)) | (local_bb1_c0_exe3_stall_in & ~(local_bb1_c0_exe3_consumed_0_NO_SHIFT_REG)));
assign local_bb1_c0_exe2_valid_out = (local_bb1_c0_exe3_inputs_ready & ~(local_bb1_c0_exe2_consumed_0_NO_SHIFT_REG));
assign local_bb1_c0_exe3_valid_out = (local_bb1_c0_exe3_inputs_ready & ~(local_bb1_c0_exe3_consumed_0_NO_SHIFT_REG));
assign local_bb1_c0_exit_c0_exi4_stall_in_1 = (local_bb1_c0_exe3_stall_local | ~(local_bb1_c0_exe3_inputs_ready));
assign local_bb1_c0_exit_c0_exi4_stall_in_2 = (local_bb1_c0_exe3_stall_local | ~(local_bb1_c0_exe3_inputs_ready));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c0_exe2_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_exe3_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_c0_exe2_consumed_0_NO_SHIFT_REG <= (local_bb1_c0_exe3_inputs_ready & (local_bb1_c0_exe2_consumed_0_NO_SHIFT_REG | ~(local_bb1_c0_exe2_stall_in)) & local_bb1_c0_exe3_stall_local);
		local_bb1_c0_exe3_consumed_0_NO_SHIFT_REG <= (local_bb1_c0_exe3_inputs_ready & (local_bb1_c0_exe3_consumed_0_NO_SHIFT_REG | ~(local_bb1_c0_exe3_stall_in)) & local_bb1_c0_exe3_stall_local);
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_exe4_valid_out;
wire local_bb1_c0_exe4_stall_in;
wire local_bb1_c0_exe4_inputs_ready;
wire local_bb1_c0_exe4_stall_local;
wire local_bb1_c0_exe4;

assign local_bb1_c0_exe4_inputs_ready = local_bb1_c0_exit_c0_exi4_valid_out_3_NO_SHIFT_REG;
assign local_bb1_c0_exe4 = local_bb1_c0_exit_c0_exi4_NO_SHIFT_REG[136];
assign local_bb1_c0_exe4_valid_out = local_bb1_c0_exe4_inputs_ready;
assign local_bb1_c0_exe4_stall_local = local_bb1_c0_exe4_stall_in;
assign local_bb1_c0_exit_c0_exi4_stall_in_3 = (|local_bb1_c0_exe4_stall_local);

// Register node:
//  * latency = 3
//  * capacity = 3
 logic rnode_10to13_bb1_c0_exe1_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_10to13_bb1_c0_exe1_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_10to13_bb1_c0_exe1_0_NO_SHIFT_REG;
 logic rnode_10to13_bb1_c0_exe1_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_10to13_bb1_c0_exe1_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_10to13_bb1_c0_exe1_1_NO_SHIFT_REG;
 logic rnode_10to13_bb1_c0_exe1_0_reg_13_inputs_ready_NO_SHIFT_REG;
 logic rnode_10to13_bb1_c0_exe1_0_reg_13_NO_SHIFT_REG;
 logic rnode_10to13_bb1_c0_exe1_0_valid_out_0_reg_13_NO_SHIFT_REG;
 logic rnode_10to13_bb1_c0_exe1_0_stall_in_0_reg_13_NO_SHIFT_REG;
 logic rnode_10to13_bb1_c0_exe1_0_stall_out_reg_13_NO_SHIFT_REG;

acl_data_fifo rnode_10to13_bb1_c0_exe1_0_reg_13_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_10to13_bb1_c0_exe1_0_reg_13_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_10to13_bb1_c0_exe1_0_stall_in_0_reg_13_NO_SHIFT_REG),
	.valid_out(rnode_10to13_bb1_c0_exe1_0_valid_out_0_reg_13_NO_SHIFT_REG),
	.stall_out(rnode_10to13_bb1_c0_exe1_0_stall_out_reg_13_NO_SHIFT_REG),
	.data_in(local_bb1_c0_exe1),
	.data_out(rnode_10to13_bb1_c0_exe1_0_reg_13_NO_SHIFT_REG)
);

defparam rnode_10to13_bb1_c0_exe1_0_reg_13_fifo.DEPTH = 4;
defparam rnode_10to13_bb1_c0_exe1_0_reg_13_fifo.DATA_WIDTH = 1;
defparam rnode_10to13_bb1_c0_exe1_0_reg_13_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_10to13_bb1_c0_exe1_0_reg_13_fifo.IMPL = "ll_reg";

assign rnode_10to13_bb1_c0_exe1_0_reg_13_inputs_ready_NO_SHIFT_REG = local_bb1_c0_exe1_valid_out;
assign local_bb1_c0_exe1_stall_in = rnode_10to13_bb1_c0_exe1_0_stall_out_reg_13_NO_SHIFT_REG;
assign rnode_10to13_bb1_c0_exe1_0_stall_in_0_reg_13_NO_SHIFT_REG = (rnode_10to13_bb1_c0_exe1_0_stall_in_0_NO_SHIFT_REG | rnode_10to13_bb1_c0_exe1_0_stall_in_1_NO_SHIFT_REG);
assign rnode_10to13_bb1_c0_exe1_0_valid_out_0_NO_SHIFT_REG = rnode_10to13_bb1_c0_exe1_0_valid_out_0_reg_13_NO_SHIFT_REG;
assign rnode_10to13_bb1_c0_exe1_0_valid_out_1_NO_SHIFT_REG = rnode_10to13_bb1_c0_exe1_0_valid_out_0_reg_13_NO_SHIFT_REG;
assign rnode_10to13_bb1_c0_exe1_0_NO_SHIFT_REG = rnode_10to13_bb1_c0_exe1_0_reg_13_NO_SHIFT_REG;
assign rnode_10to13_bb1_c0_exe1_1_NO_SHIFT_REG = rnode_10to13_bb1_c0_exe1_0_reg_13_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_10to10_bb1_c0_exe2_valid_out_0;
wire rstag_10to10_bb1_c0_exe2_stall_in_0;
wire rstag_10to10_bb1_c0_exe2_valid_out_1;
wire rstag_10to10_bb1_c0_exe2_stall_in_1;
wire rstag_10to10_bb1_c0_exe2_inputs_ready;
wire rstag_10to10_bb1_c0_exe2_stall_local;
 reg rstag_10to10_bb1_c0_exe2_staging_valid_NO_SHIFT_REG;
wire rstag_10to10_bb1_c0_exe2_combined_valid;
 reg [63:0] rstag_10to10_bb1_c0_exe2_staging_reg_NO_SHIFT_REG;
wire [63:0] rstag_10to10_bb1_c0_exe2;
 reg rstag_10to10_bb1_c0_exe2_consumed_0_NO_SHIFT_REG;
 reg rstag_10to10_bb1_c0_exe2_consumed_1_NO_SHIFT_REG;

assign rstag_10to10_bb1_c0_exe2_inputs_ready = local_bb1_c0_exe2_valid_out;
assign rstag_10to10_bb1_c0_exe2 = (rstag_10to10_bb1_c0_exe2_staging_valid_NO_SHIFT_REG ? rstag_10to10_bb1_c0_exe2_staging_reg_NO_SHIFT_REG : (local_bb1_c0_exe2 & 64'hFFFFFFFFFFFFFFFC));
assign rstag_10to10_bb1_c0_exe2_combined_valid = (rstag_10to10_bb1_c0_exe2_staging_valid_NO_SHIFT_REG | rstag_10to10_bb1_c0_exe2_inputs_ready);
assign rstag_10to10_bb1_c0_exe2_stall_local = ((rstag_10to10_bb1_c0_exe2_stall_in_0 & ~(rstag_10to10_bb1_c0_exe2_consumed_0_NO_SHIFT_REG)) | (rstag_10to10_bb1_c0_exe2_stall_in_1 & ~(rstag_10to10_bb1_c0_exe2_consumed_1_NO_SHIFT_REG)));
assign rstag_10to10_bb1_c0_exe2_valid_out_0 = (rstag_10to10_bb1_c0_exe2_combined_valid & ~(rstag_10to10_bb1_c0_exe2_consumed_0_NO_SHIFT_REG));
assign rstag_10to10_bb1_c0_exe2_valid_out_1 = (rstag_10to10_bb1_c0_exe2_combined_valid & ~(rstag_10to10_bb1_c0_exe2_consumed_1_NO_SHIFT_REG));
assign local_bb1_c0_exe2_stall_in = (|rstag_10to10_bb1_c0_exe2_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_10to10_bb1_c0_exe2_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_10to10_bb1_c0_exe2_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_10to10_bb1_c0_exe2_stall_local)
		begin
			if (~(rstag_10to10_bb1_c0_exe2_staging_valid_NO_SHIFT_REG))
			begin
				rstag_10to10_bb1_c0_exe2_staging_valid_NO_SHIFT_REG <= rstag_10to10_bb1_c0_exe2_inputs_ready;
			end
		end
		else
		begin
			rstag_10to10_bb1_c0_exe2_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_10to10_bb1_c0_exe2_staging_valid_NO_SHIFT_REG))
		begin
			rstag_10to10_bb1_c0_exe2_staging_reg_NO_SHIFT_REG <= (local_bb1_c0_exe2 & 64'hFFFFFFFFFFFFFFFC);
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_10to10_bb1_c0_exe2_consumed_0_NO_SHIFT_REG <= 1'b0;
		rstag_10to10_bb1_c0_exe2_consumed_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		rstag_10to10_bb1_c0_exe2_consumed_0_NO_SHIFT_REG <= (rstag_10to10_bb1_c0_exe2_combined_valid & (rstag_10to10_bb1_c0_exe2_consumed_0_NO_SHIFT_REG | ~(rstag_10to10_bb1_c0_exe2_stall_in_0)) & rstag_10to10_bb1_c0_exe2_stall_local);
		rstag_10to10_bb1_c0_exe2_consumed_1_NO_SHIFT_REG <= (rstag_10to10_bb1_c0_exe2_combined_valid & (rstag_10to10_bb1_c0_exe2_consumed_1_NO_SHIFT_REG | ~(rstag_10to10_bb1_c0_exe2_stall_in_1)) & rstag_10to10_bb1_c0_exe2_stall_local);
	end
end


// This section implements a staging register.
// 
wire rstag_10to10_bb1_c0_exe3_valid_out_0;
wire rstag_10to10_bb1_c0_exe3_stall_in_0;
wire rstag_10to10_bb1_c0_exe3_valid_out_1;
wire rstag_10to10_bb1_c0_exe3_stall_in_1;
wire rstag_10to10_bb1_c0_exe3_inputs_ready;
wire rstag_10to10_bb1_c0_exe3_stall_local;
 reg rstag_10to10_bb1_c0_exe3_staging_valid_NO_SHIFT_REG;
wire rstag_10to10_bb1_c0_exe3_combined_valid;
 reg rstag_10to10_bb1_c0_exe3_staging_reg_NO_SHIFT_REG;
wire rstag_10to10_bb1_c0_exe3;
 reg rstag_10to10_bb1_c0_exe3_consumed_0_NO_SHIFT_REG;
 reg rstag_10to10_bb1_c0_exe3_consumed_1_NO_SHIFT_REG;

assign rstag_10to10_bb1_c0_exe3_inputs_ready = local_bb1_c0_exe3_valid_out;
assign rstag_10to10_bb1_c0_exe3 = (rstag_10to10_bb1_c0_exe3_staging_valid_NO_SHIFT_REG ? rstag_10to10_bb1_c0_exe3_staging_reg_NO_SHIFT_REG : local_bb1_c0_exe3);
assign rstag_10to10_bb1_c0_exe3_combined_valid = (rstag_10to10_bb1_c0_exe3_staging_valid_NO_SHIFT_REG | rstag_10to10_bb1_c0_exe3_inputs_ready);
assign rstag_10to10_bb1_c0_exe3_stall_local = ((rstag_10to10_bb1_c0_exe3_stall_in_0 & ~(rstag_10to10_bb1_c0_exe3_consumed_0_NO_SHIFT_REG)) | (rstag_10to10_bb1_c0_exe3_stall_in_1 & ~(rstag_10to10_bb1_c0_exe3_consumed_1_NO_SHIFT_REG)));
assign rstag_10to10_bb1_c0_exe3_valid_out_0 = (rstag_10to10_bb1_c0_exe3_combined_valid & ~(rstag_10to10_bb1_c0_exe3_consumed_0_NO_SHIFT_REG));
assign rstag_10to10_bb1_c0_exe3_valid_out_1 = (rstag_10to10_bb1_c0_exe3_combined_valid & ~(rstag_10to10_bb1_c0_exe3_consumed_1_NO_SHIFT_REG));
assign local_bb1_c0_exe3_stall_in = (|rstag_10to10_bb1_c0_exe3_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_10to10_bb1_c0_exe3_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_10to10_bb1_c0_exe3_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_10to10_bb1_c0_exe3_stall_local)
		begin
			if (~(rstag_10to10_bb1_c0_exe3_staging_valid_NO_SHIFT_REG))
			begin
				rstag_10to10_bb1_c0_exe3_staging_valid_NO_SHIFT_REG <= rstag_10to10_bb1_c0_exe3_inputs_ready;
			end
		end
		else
		begin
			rstag_10to10_bb1_c0_exe3_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_10to10_bb1_c0_exe3_staging_valid_NO_SHIFT_REG))
		begin
			rstag_10to10_bb1_c0_exe3_staging_reg_NO_SHIFT_REG <= local_bb1_c0_exe3;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_10to10_bb1_c0_exe3_consumed_0_NO_SHIFT_REG <= 1'b0;
		rstag_10to10_bb1_c0_exe3_consumed_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		rstag_10to10_bb1_c0_exe3_consumed_0_NO_SHIFT_REG <= (rstag_10to10_bb1_c0_exe3_combined_valid & (rstag_10to10_bb1_c0_exe3_consumed_0_NO_SHIFT_REG | ~(rstag_10to10_bb1_c0_exe3_stall_in_0)) & rstag_10to10_bb1_c0_exe3_stall_local);
		rstag_10to10_bb1_c0_exe3_consumed_1_NO_SHIFT_REG <= (rstag_10to10_bb1_c0_exe3_combined_valid & (rstag_10to10_bb1_c0_exe3_consumed_1_NO_SHIFT_REG | ~(rstag_10to10_bb1_c0_exe3_stall_in_1)) & rstag_10to10_bb1_c0_exe3_stall_local);
	end
end


// Register node:
//  * latency = 14
//  * capacity = 14
 logic rnode_10to24_bb1_c0_exe4_0_valid_out_NO_SHIFT_REG;
 logic rnode_10to24_bb1_c0_exe4_0_stall_in_NO_SHIFT_REG;
 logic rnode_10to24_bb1_c0_exe4_0_NO_SHIFT_REG;
 logic rnode_10to24_bb1_c0_exe4_0_reg_24_inputs_ready_NO_SHIFT_REG;
 logic rnode_10to24_bb1_c0_exe4_0_reg_24_NO_SHIFT_REG;
 logic rnode_10to24_bb1_c0_exe4_0_valid_out_reg_24_NO_SHIFT_REG;
 logic rnode_10to24_bb1_c0_exe4_0_stall_in_reg_24_NO_SHIFT_REG;
 logic rnode_10to24_bb1_c0_exe4_0_stall_out_reg_24_NO_SHIFT_REG;

acl_data_fifo rnode_10to24_bb1_c0_exe4_0_reg_24_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_10to24_bb1_c0_exe4_0_reg_24_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_10to24_bb1_c0_exe4_0_stall_in_reg_24_NO_SHIFT_REG),
	.valid_out(rnode_10to24_bb1_c0_exe4_0_valid_out_reg_24_NO_SHIFT_REG),
	.stall_out(rnode_10to24_bb1_c0_exe4_0_stall_out_reg_24_NO_SHIFT_REG),
	.data_in(local_bb1_c0_exe4),
	.data_out(rnode_10to24_bb1_c0_exe4_0_reg_24_NO_SHIFT_REG)
);

defparam rnode_10to24_bb1_c0_exe4_0_reg_24_fifo.DEPTH = 15;
defparam rnode_10to24_bb1_c0_exe4_0_reg_24_fifo.DATA_WIDTH = 1;
defparam rnode_10to24_bb1_c0_exe4_0_reg_24_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_10to24_bb1_c0_exe4_0_reg_24_fifo.IMPL = "ram";

assign rnode_10to24_bb1_c0_exe4_0_reg_24_inputs_ready_NO_SHIFT_REG = local_bb1_c0_exe4_valid_out;
assign local_bb1_c0_exe4_stall_in = rnode_10to24_bb1_c0_exe4_0_stall_out_reg_24_NO_SHIFT_REG;
assign rnode_10to24_bb1_c0_exe4_0_NO_SHIFT_REG = rnode_10to24_bb1_c0_exe4_0_reg_24_NO_SHIFT_REG;
assign rnode_10to24_bb1_c0_exe4_0_stall_in_reg_24_NO_SHIFT_REG = rnode_10to24_bb1_c0_exe4_0_stall_in_NO_SHIFT_REG;
assign rnode_10to24_bb1_c0_exe4_0_valid_out_NO_SHIFT_REG = rnode_10to24_bb1_c0_exe4_0_valid_out_reg_24_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_c1_eni2_stall_local;
wire [63:0] local_bb1_c1_eni2;

assign local_bb1_c1_eni2[15:0] = local_bb1_c1_eni1[15:0];
assign local_bb1_c1_eni2[16] = rnode_10to13_bb1_c0_exe1_0_NO_SHIFT_REG;
assign local_bb1_c1_eni2[63:17] = local_bb1_c1_eni1[63:17];

// Register node:
//  * latency = 10
//  * capacity = 10
 logic rnode_10to20_bb1_c0_exe2_0_valid_out_NO_SHIFT_REG;
 logic rnode_10to20_bb1_c0_exe2_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_10to20_bb1_c0_exe2_0_NO_SHIFT_REG;
 logic rnode_10to20_bb1_c0_exe2_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_10to20_bb1_c0_exe2_0_reg_20_NO_SHIFT_REG;
 logic rnode_10to20_bb1_c0_exe2_0_valid_out_reg_20_NO_SHIFT_REG;
 logic rnode_10to20_bb1_c0_exe2_0_stall_in_reg_20_NO_SHIFT_REG;
 logic rnode_10to20_bb1_c0_exe2_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_10to20_bb1_c0_exe2_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_10to20_bb1_c0_exe2_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_10to20_bb1_c0_exe2_0_stall_in_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_10to20_bb1_c0_exe2_0_valid_out_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_10to20_bb1_c0_exe2_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in((rstag_10to10_bb1_c0_exe2 & 64'hFFFFFFFFFFFFFFFC)),
	.data_out(rnode_10to20_bb1_c0_exe2_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_10to20_bb1_c0_exe2_0_reg_20_fifo.DEPTH = 11;
defparam rnode_10to20_bb1_c0_exe2_0_reg_20_fifo.DATA_WIDTH = 64;
defparam rnode_10to20_bb1_c0_exe2_0_reg_20_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_10to20_bb1_c0_exe2_0_reg_20_fifo.IMPL = "ram";

assign rnode_10to20_bb1_c0_exe2_0_reg_20_inputs_ready_NO_SHIFT_REG = rstag_10to10_bb1_c0_exe2_valid_out_0;
assign rstag_10to10_bb1_c0_exe2_stall_in_0 = rnode_10to20_bb1_c0_exe2_0_stall_out_reg_20_NO_SHIFT_REG;
assign rnode_10to20_bb1_c0_exe2_0_NO_SHIFT_REG = rnode_10to20_bb1_c0_exe2_0_reg_20_NO_SHIFT_REG;
assign rnode_10to20_bb1_c0_exe2_0_stall_in_reg_20_NO_SHIFT_REG = rnode_10to20_bb1_c0_exe2_0_stall_in_NO_SHIFT_REG;
assign rnode_10to20_bb1_c0_exe2_0_valid_out_NO_SHIFT_REG = rnode_10to20_bb1_c0_exe2_0_valid_out_reg_20_NO_SHIFT_REG;

// Register node:
//  * latency = 10
//  * capacity = 10
 logic rnode_10to20_bb1_c0_exe3_0_valid_out_NO_SHIFT_REG;
 logic rnode_10to20_bb1_c0_exe3_0_stall_in_NO_SHIFT_REG;
 logic rnode_10to20_bb1_c0_exe3_0_NO_SHIFT_REG;
 logic rnode_10to20_bb1_c0_exe3_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic rnode_10to20_bb1_c0_exe3_0_reg_20_NO_SHIFT_REG;
 logic rnode_10to20_bb1_c0_exe3_0_valid_out_reg_20_NO_SHIFT_REG;
 logic rnode_10to20_bb1_c0_exe3_0_stall_in_reg_20_NO_SHIFT_REG;
 logic rnode_10to20_bb1_c0_exe3_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_10to20_bb1_c0_exe3_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_10to20_bb1_c0_exe3_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_10to20_bb1_c0_exe3_0_stall_in_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_10to20_bb1_c0_exe3_0_valid_out_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_10to20_bb1_c0_exe3_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(rstag_10to10_bb1_c0_exe3),
	.data_out(rnode_10to20_bb1_c0_exe3_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_10to20_bb1_c0_exe3_0_reg_20_fifo.DEPTH = 11;
defparam rnode_10to20_bb1_c0_exe3_0_reg_20_fifo.DATA_WIDTH = 1;
defparam rnode_10to20_bb1_c0_exe3_0_reg_20_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_10to20_bb1_c0_exe3_0_reg_20_fifo.IMPL = "ram";

assign rnode_10to20_bb1_c0_exe3_0_reg_20_inputs_ready_NO_SHIFT_REG = rstag_10to10_bb1_c0_exe3_valid_out_0;
assign rstag_10to10_bb1_c0_exe3_stall_in_0 = rnode_10to20_bb1_c0_exe3_0_stall_out_reg_20_NO_SHIFT_REG;
assign rnode_10to20_bb1_c0_exe3_0_NO_SHIFT_REG = rnode_10to20_bb1_c0_exe3_0_reg_20_NO_SHIFT_REG;
assign rnode_10to20_bb1_c0_exe3_0_stall_in_reg_20_NO_SHIFT_REG = rnode_10to20_bb1_c0_exe3_0_stall_in_NO_SHIFT_REG;
assign rnode_10to20_bb1_c0_exe3_0_valid_out_NO_SHIFT_REG = rnode_10to20_bb1_c0_exe3_0_valid_out_reg_20_NO_SHIFT_REG;

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
	.i_address((rstag_10to10_bb1_c0_exe2 & 64'hFFFFFFFFFFFFFFFC)),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(rstag_10to10_bb1_c0_exe3),
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

assign local_bb1_ld__inputs_ready = (rstag_10to10_bb1_c0_exe3_valid_out_1 & rstag_10to10_bb1_c0_exe2_valid_out_1);
assign local_bb1_ld__output_regs_ready = (&(~(local_bb1_ld__valid_out_NO_SHIFT_REG) | ~(local_bb1_ld__stall_in)));
assign rstag_10to10_bb1_c0_exe3_stall_in_1 = (local_bb1_ld__fu_stall_out | ~(local_bb1_ld__inputs_ready));
assign rstag_10to10_bb1_c0_exe2_stall_in_1 = (local_bb1_ld__fu_stall_out | ~(local_bb1_ld__inputs_ready));
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


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_24to25_bb1_c0_exe4_0_valid_out_NO_SHIFT_REG;
 logic rnode_24to25_bb1_c0_exe4_0_stall_in_NO_SHIFT_REG;
 logic rnode_24to25_bb1_c0_exe4_0_NO_SHIFT_REG;
 logic rnode_24to25_bb1_c0_exe4_0_reg_25_inputs_ready_NO_SHIFT_REG;
 logic rnode_24to25_bb1_c0_exe4_0_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb1_c0_exe4_0_valid_out_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb1_c0_exe4_0_stall_in_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb1_c0_exe4_0_stall_out_reg_25_NO_SHIFT_REG;

acl_data_fifo rnode_24to25_bb1_c0_exe4_0_reg_25_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_24to25_bb1_c0_exe4_0_reg_25_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_24to25_bb1_c0_exe4_0_stall_in_reg_25_NO_SHIFT_REG),
	.valid_out(rnode_24to25_bb1_c0_exe4_0_valid_out_reg_25_NO_SHIFT_REG),
	.stall_out(rnode_24to25_bb1_c0_exe4_0_stall_out_reg_25_NO_SHIFT_REG),
	.data_in(rnode_10to24_bb1_c0_exe4_0_NO_SHIFT_REG),
	.data_out(rnode_24to25_bb1_c0_exe4_0_reg_25_NO_SHIFT_REG)
);

defparam rnode_24to25_bb1_c0_exe4_0_reg_25_fifo.DEPTH = 1;
defparam rnode_24to25_bb1_c0_exe4_0_reg_25_fifo.DATA_WIDTH = 1;
defparam rnode_24to25_bb1_c0_exe4_0_reg_25_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_24to25_bb1_c0_exe4_0_reg_25_fifo.IMPL = "ll_reg";

assign rnode_24to25_bb1_c0_exe4_0_reg_25_inputs_ready_NO_SHIFT_REG = rnode_10to24_bb1_c0_exe4_0_valid_out_NO_SHIFT_REG;
assign rnode_10to24_bb1_c0_exe4_0_stall_in_NO_SHIFT_REG = rnode_24to25_bb1_c0_exe4_0_stall_out_reg_25_NO_SHIFT_REG;
assign rnode_24to25_bb1_c0_exe4_0_NO_SHIFT_REG = rnode_24to25_bb1_c0_exe4_0_reg_25_NO_SHIFT_REG;
assign rnode_24to25_bb1_c0_exe4_0_stall_in_reg_25_NO_SHIFT_REG = rnode_24to25_bb1_c0_exe4_0_stall_in_NO_SHIFT_REG;
assign rnode_24to25_bb1_c0_exe4_0_valid_out_NO_SHIFT_REG = rnode_24to25_bb1_c0_exe4_0_valid_out_reg_25_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_20to21_bb1_c0_exe2_0_valid_out_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c0_exe2_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_20to21_bb1_c0_exe2_0_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c0_exe2_0_reg_21_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_20to21_bb1_c0_exe2_0_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c0_exe2_0_valid_out_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c0_exe2_0_stall_in_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c0_exe2_0_stall_out_reg_21_NO_SHIFT_REG;

acl_data_fifo rnode_20to21_bb1_c0_exe2_0_reg_21_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_20to21_bb1_c0_exe2_0_reg_21_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_20to21_bb1_c0_exe2_0_stall_in_reg_21_NO_SHIFT_REG),
	.valid_out(rnode_20to21_bb1_c0_exe2_0_valid_out_reg_21_NO_SHIFT_REG),
	.stall_out(rnode_20to21_bb1_c0_exe2_0_stall_out_reg_21_NO_SHIFT_REG),
	.data_in((rnode_10to20_bb1_c0_exe2_0_NO_SHIFT_REG & 64'hFFFFFFFFFFFFFFFC)),
	.data_out(rnode_20to21_bb1_c0_exe2_0_reg_21_NO_SHIFT_REG)
);

defparam rnode_20to21_bb1_c0_exe2_0_reg_21_fifo.DEPTH = 2;
defparam rnode_20to21_bb1_c0_exe2_0_reg_21_fifo.DATA_WIDTH = 64;
defparam rnode_20to21_bb1_c0_exe2_0_reg_21_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_20to21_bb1_c0_exe2_0_reg_21_fifo.IMPL = "ll_reg";

assign rnode_20to21_bb1_c0_exe2_0_reg_21_inputs_ready_NO_SHIFT_REG = rnode_10to20_bb1_c0_exe2_0_valid_out_NO_SHIFT_REG;
assign rnode_10to20_bb1_c0_exe2_0_stall_in_NO_SHIFT_REG = rnode_20to21_bb1_c0_exe2_0_stall_out_reg_21_NO_SHIFT_REG;
assign rnode_20to21_bb1_c0_exe2_0_NO_SHIFT_REG = rnode_20to21_bb1_c0_exe2_0_reg_21_NO_SHIFT_REG;
assign rnode_20to21_bb1_c0_exe2_0_stall_in_reg_21_NO_SHIFT_REG = rnode_20to21_bb1_c0_exe2_0_stall_in_NO_SHIFT_REG;
assign rnode_20to21_bb1_c0_exe2_0_valid_out_NO_SHIFT_REG = rnode_20to21_bb1_c0_exe2_0_valid_out_reg_21_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_20to21_bb1_c0_exe3_0_valid_out_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c0_exe3_0_stall_in_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c0_exe3_0_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c0_exe3_0_reg_21_inputs_ready_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c0_exe3_0_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c0_exe3_0_valid_out_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c0_exe3_0_stall_in_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb1_c0_exe3_0_stall_out_reg_21_NO_SHIFT_REG;

acl_data_fifo rnode_20to21_bb1_c0_exe3_0_reg_21_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_20to21_bb1_c0_exe3_0_reg_21_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_20to21_bb1_c0_exe3_0_stall_in_reg_21_NO_SHIFT_REG),
	.valid_out(rnode_20to21_bb1_c0_exe3_0_valid_out_reg_21_NO_SHIFT_REG),
	.stall_out(rnode_20to21_bb1_c0_exe3_0_stall_out_reg_21_NO_SHIFT_REG),
	.data_in(rnode_10to20_bb1_c0_exe3_0_NO_SHIFT_REG),
	.data_out(rnode_20to21_bb1_c0_exe3_0_reg_21_NO_SHIFT_REG)
);

defparam rnode_20to21_bb1_c0_exe3_0_reg_21_fifo.DEPTH = 2;
defparam rnode_20to21_bb1_c0_exe3_0_reg_21_fifo.DATA_WIDTH = 1;
defparam rnode_20to21_bb1_c0_exe3_0_reg_21_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_20to21_bb1_c0_exe3_0_reg_21_fifo.IMPL = "ll_reg";

assign rnode_20to21_bb1_c0_exe3_0_reg_21_inputs_ready_NO_SHIFT_REG = rnode_10to20_bb1_c0_exe3_0_valid_out_NO_SHIFT_REG;
assign rnode_10to20_bb1_c0_exe3_0_stall_in_NO_SHIFT_REG = rnode_20to21_bb1_c0_exe3_0_stall_out_reg_21_NO_SHIFT_REG;
assign rnode_20to21_bb1_c0_exe3_0_NO_SHIFT_REG = rnode_20to21_bb1_c0_exe3_0_reg_21_NO_SHIFT_REG;
assign rnode_20to21_bb1_c0_exe3_0_stall_in_reg_21_NO_SHIFT_REG = rnode_20to21_bb1_c0_exe3_0_stall_in_NO_SHIFT_REG;
assign rnode_20to21_bb1_c0_exe3_0_valid_out_NO_SHIFT_REG = rnode_20to21_bb1_c0_exe3_0_valid_out_reg_21_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_13to13_bb1_ld__valid_out;
wire rstag_13to13_bb1_ld__stall_in;
wire rstag_13to13_bb1_ld__inputs_ready;
wire rstag_13to13_bb1_ld__stall_local;
 reg rstag_13to13_bb1_ld__staging_valid_NO_SHIFT_REG;
wire rstag_13to13_bb1_ld__combined_valid;
 reg [31:0] rstag_13to13_bb1_ld__staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_13to13_bb1_ld_;

assign rstag_13to13_bb1_ld__inputs_ready = local_bb1_ld__valid_out_NO_SHIFT_REG;
assign rstag_13to13_bb1_ld_ = (rstag_13to13_bb1_ld__staging_valid_NO_SHIFT_REG ? rstag_13to13_bb1_ld__staging_reg_NO_SHIFT_REG : local_bb1_ld__NO_SHIFT_REG);
assign rstag_13to13_bb1_ld__combined_valid = (rstag_13to13_bb1_ld__staging_valid_NO_SHIFT_REG | rstag_13to13_bb1_ld__inputs_ready);
assign rstag_13to13_bb1_ld__valid_out = rstag_13to13_bb1_ld__combined_valid;
assign rstag_13to13_bb1_ld__stall_local = rstag_13to13_bb1_ld__stall_in;
assign local_bb1_ld__stall_in = (|rstag_13to13_bb1_ld__staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_13to13_bb1_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_13to13_bb1_ld__staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_13to13_bb1_ld__stall_local)
		begin
			if (~(rstag_13to13_bb1_ld__staging_valid_NO_SHIFT_REG))
			begin
				rstag_13to13_bb1_ld__staging_valid_NO_SHIFT_REG <= rstag_13to13_bb1_ld__inputs_ready;
			end
		end
		else
		begin
			rstag_13to13_bb1_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_13to13_bb1_ld__staging_valid_NO_SHIFT_REG))
		begin
			rstag_13to13_bb1_ld__staging_reg_NO_SHIFT_REG <= local_bb1_ld__NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c1_eni3_valid_out;
wire local_bb1_c1_eni3_stall_in;
wire local_bb1_c1_eni3_inputs_ready;
wire local_bb1_c1_eni3_stall_local;
wire [63:0] local_bb1_c1_eni3;

assign local_bb1_c1_eni3_inputs_ready = (rnode_12to13_forked_0_valid_out_0_NO_SHIFT_REG & rnode_10to13_bb1_c0_exe1_0_valid_out_0_NO_SHIFT_REG & rstag_13to13_bb1_ld__valid_out);
assign local_bb1_c1_eni3[31:0] = local_bb1_c1_eni2[31:0];
assign local_bb1_c1_eni3[63:32] = rstag_13to13_bb1_ld_;
assign local_bb1_c1_eni3_valid_out = local_bb1_c1_eni3_inputs_ready;
assign local_bb1_c1_eni3_stall_local = local_bb1_c1_eni3_stall_in;
assign rnode_12to13_forked_0_stall_in_0_NO_SHIFT_REG = (local_bb1_c1_eni3_stall_local | ~(local_bb1_c1_eni3_inputs_ready));
assign rnode_10to13_bb1_c0_exe1_0_stall_in_0_NO_SHIFT_REG = (local_bb1_c1_eni3_stall_local | ~(local_bb1_c1_eni3_inputs_ready));
assign rstag_13to13_bb1_ld__stall_in = (local_bb1_c1_eni3_stall_local | ~(local_bb1_c1_eni3_inputs_ready));

// This section implements a registered operation.
// 
wire local_bb1_c1_enter_c1_eni3_inputs_ready;
 reg local_bb1_c1_enter_c1_eni3_valid_out_0_NO_SHIFT_REG;
wire local_bb1_c1_enter_c1_eni3_stall_in_0;
 reg local_bb1_c1_enter_c1_eni3_valid_out_1_NO_SHIFT_REG;
wire local_bb1_c1_enter_c1_eni3_stall_in_1;
 reg local_bb1_c1_enter_c1_eni3_valid_out_2_NO_SHIFT_REG;
wire local_bb1_c1_enter_c1_eni3_stall_in_2;
 reg local_bb1_c1_enter_c1_eni3_valid_out_3_NO_SHIFT_REG;
wire local_bb1_c1_enter_c1_eni3_stall_in_3;
wire local_bb1_c1_enter_c1_eni3_output_regs_ready;
 reg [63:0] local_bb1_c1_enter_c1_eni3_NO_SHIFT_REG;
wire local_bb1_c1_enter_c1_eni3_input_accepted;
 reg local_bb1_c1_enter_c1_eni3_valid_bit_NO_SHIFT_REG;
wire local_bb1_c1_exit_c1_exi1_entry_stall;
wire local_bb1_c1_exit_c1_exi1_output_regs_ready;
wire local_bb1_c1_exit_c1_exi1_valid_in;
wire local_bb1_c1_exit_c1_exi1_phases;
wire local_bb1_c1_enter_c1_eni3_inc_pipelined_thread;
wire local_bb1_c1_enter_c1_eni3_dec_pipelined_thread;
wire local_bb1_c1_enter_c1_eni3_causedstall;

assign local_bb1_c1_enter_c1_eni3_inputs_ready = (local_bb1_c1_eni3_valid_out & rnode_10to13_bb1_c0_exe1_0_valid_out_1_NO_SHIFT_REG & rnode_12to13_forked_0_valid_out_1_NO_SHIFT_REG);
assign local_bb1_c1_enter_c1_eni3_output_regs_ready = 1'b1;
assign local_bb1_c1_enter_c1_eni3_input_accepted = (local_bb1_c1_enter_c1_eni3_inputs_ready && !(local_bb1_c1_exit_c1_exi1_entry_stall));
assign local_bb1_c1_enter_c1_eni3_inc_pipelined_thread = rnode_12to13_forked_1_NO_SHIFT_REG;
assign local_bb1_c1_enter_c1_eni3_dec_pipelined_thread = ~(rnode_10to13_bb1_c0_exe1_1_NO_SHIFT_REG);
assign local_bb1_c1_eni3_stall_in = ((~(local_bb1_c1_enter_c1_eni3_inputs_ready) | local_bb1_c1_exit_c1_exi1_entry_stall) | ~(1'b1));
assign rnode_10to13_bb1_c0_exe1_0_stall_in_1_NO_SHIFT_REG = ((~(local_bb1_c1_enter_c1_eni3_inputs_ready) | local_bb1_c1_exit_c1_exi1_entry_stall) | ~(1'b1));
assign rnode_12to13_forked_0_stall_in_1_NO_SHIFT_REG = ((~(local_bb1_c1_enter_c1_eni3_inputs_ready) | local_bb1_c1_exit_c1_exi1_entry_stall) | ~(1'b1));
assign local_bb1_c1_enter_c1_eni3_causedstall = (1'b1 && ((~(local_bb1_c1_enter_c1_eni3_inputs_ready) | local_bb1_c1_exit_c1_exi1_entry_stall) && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c1_enter_c1_eni3_valid_bit_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_c1_enter_c1_eni3_valid_bit_NO_SHIFT_REG <= local_bb1_c1_enter_c1_eni3_input_accepted;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c1_enter_c1_eni3_NO_SHIFT_REG <= 'x;
		local_bb1_c1_enter_c1_eni3_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_c1_enter_c1_eni3_valid_out_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_c1_enter_c1_eni3_valid_out_2_NO_SHIFT_REG <= 1'b0;
		local_bb1_c1_enter_c1_eni3_valid_out_3_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c1_enter_c1_eni3_output_regs_ready)
		begin
			local_bb1_c1_enter_c1_eni3_NO_SHIFT_REG <= local_bb1_c1_eni3;
			local_bb1_c1_enter_c1_eni3_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb1_c1_enter_c1_eni3_valid_out_1_NO_SHIFT_REG <= 1'b1;
			local_bb1_c1_enter_c1_eni3_valid_out_2_NO_SHIFT_REG <= 1'b1;
			local_bb1_c1_enter_c1_eni3_valid_out_3_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb1_c1_enter_c1_eni3_stall_in_0))
			begin
				local_bb1_c1_enter_c1_eni3_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c1_enter_c1_eni3_stall_in_1))
			begin
				local_bb1_c1_enter_c1_eni3_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c1_enter_c1_eni3_stall_in_2))
			begin
				local_bb1_c1_enter_c1_eni3_valid_out_2_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c1_enter_c1_eni3_stall_in_3))
			begin
				local_bb1_c1_enter_c1_eni3_valid_out_3_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb1_c1_ene1_inputs_ready;
 reg local_bb1_c1_ene1_valid_out_0_NO_SHIFT_REG;
wire local_bb1_c1_ene1_stall_in_0;
 reg local_bb1_c1_ene1_valid_out_1_NO_SHIFT_REG;
wire local_bb1_c1_ene1_stall_in_1;
 reg local_bb1_c1_ene1_valid_out_2_NO_SHIFT_REG;
wire local_bb1_c1_ene1_stall_in_2;
 reg local_bb1_c1_ene1_valid_out_3_NO_SHIFT_REG;
wire local_bb1_c1_ene1_stall_in_3;
 reg local_bb1_c1_ene1_valid_out_4_NO_SHIFT_REG;
wire local_bb1_c1_ene1_stall_in_4;
wire local_bb1_c1_ene1_output_regs_ready;
 reg local_bb1_c1_ene1_NO_SHIFT_REG;
wire local_bb1_c1_ene1_op_wire;
wire local_bb1_c1_ene1_causedstall;

assign local_bb1_c1_ene1_inputs_ready = 1'b1;
assign local_bb1_c1_ene1_output_regs_ready = 1'b1;
assign local_bb1_c1_ene1_op_wire = local_bb1_c1_enter_c1_eni3_NO_SHIFT_REG[8];
assign local_bb1_c1_enter_c1_eni3_stall_in_0 = 1'b0;
assign local_bb1_c1_ene1_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c1_ene1_NO_SHIFT_REG <= 'x;
		local_bb1_c1_ene1_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_c1_ene1_valid_out_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_c1_ene1_valid_out_2_NO_SHIFT_REG <= 1'b0;
		local_bb1_c1_ene1_valid_out_3_NO_SHIFT_REG <= 1'b0;
		local_bb1_c1_ene1_valid_out_4_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c1_ene1_output_regs_ready)
		begin
			local_bb1_c1_ene1_NO_SHIFT_REG <= local_bb1_c1_ene1_op_wire;
			local_bb1_c1_ene1_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb1_c1_ene1_valid_out_1_NO_SHIFT_REG <= 1'b1;
			local_bb1_c1_ene1_valid_out_2_NO_SHIFT_REG <= 1'b1;
			local_bb1_c1_ene1_valid_out_3_NO_SHIFT_REG <= 1'b1;
			local_bb1_c1_ene1_valid_out_4_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb1_c1_ene1_stall_in_0))
			begin
				local_bb1_c1_ene1_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c1_ene1_stall_in_1))
			begin
				local_bb1_c1_ene1_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c1_ene1_stall_in_2))
			begin
				local_bb1_c1_ene1_valid_out_2_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c1_ene1_stall_in_3))
			begin
				local_bb1_c1_ene1_valid_out_3_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c1_ene1_stall_in_4))
			begin
				local_bb1_c1_ene1_valid_out_4_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb1_c1_ene2_inputs_ready;
 reg local_bb1_c1_ene2_valid_out_0_NO_SHIFT_REG;
wire local_bb1_c1_ene2_stall_in_0;
 reg local_bb1_c1_ene2_valid_out_1_NO_SHIFT_REG;
wire local_bb1_c1_ene2_stall_in_1;
wire local_bb1_c1_ene2_output_regs_ready;
 reg local_bb1_c1_ene2_NO_SHIFT_REG;
wire local_bb1_c1_ene2_op_wire;
wire local_bb1_c1_ene2_causedstall;

assign local_bb1_c1_ene2_inputs_ready = 1'b1;
assign local_bb1_c1_ene2_output_regs_ready = 1'b1;
assign local_bb1_c1_ene2_op_wire = local_bb1_c1_enter_c1_eni3_NO_SHIFT_REG[16];
assign local_bb1_c1_enter_c1_eni3_stall_in_1 = 1'b0;
assign local_bb1_c1_ene2_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c1_ene2_NO_SHIFT_REG <= 'x;
		local_bb1_c1_ene2_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_c1_ene2_valid_out_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c1_ene2_output_regs_ready)
		begin
			local_bb1_c1_ene2_NO_SHIFT_REG <= local_bb1_c1_ene2_op_wire;
			local_bb1_c1_ene2_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb1_c1_ene2_valid_out_1_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb1_c1_ene2_stall_in_0))
			begin
				local_bb1_c1_ene2_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c1_ene2_stall_in_1))
			begin
				local_bb1_c1_ene2_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c1_ene3_stall_local;
wire [31:0] local_bb1_c1_ene3;

assign local_bb1_c1_ene3[31:0] = local_bb1_c1_enter_c1_eni3_NO_SHIFT_REG[63:32];

// This section implements an unregistered operation.
// 
wire SFC_2_VALID_14_14_0_valid_out;
wire SFC_2_VALID_14_14_0_stall_in;
wire SFC_2_VALID_14_14_0_inputs_ready;
wire SFC_2_VALID_14_14_0_stall_local;
wire SFC_2_VALID_14_14_0;

assign SFC_2_VALID_14_14_0_inputs_ready = local_bb1_c1_enter_c1_eni3_valid_out_3_NO_SHIFT_REG;
assign SFC_2_VALID_14_14_0 = local_bb1_c1_enter_c1_eni3_valid_bit_NO_SHIFT_REG;
assign SFC_2_VALID_14_14_0_valid_out = 1'b1;
assign local_bb1_c1_enter_c1_eni3_stall_in_3 = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop26_insert0_stall_local;
wire [47:0] local_bb1_vectorpop26_insert0;

assign local_bb1_vectorpop26_insert0[13:0] = 14'h13E6;
assign local_bb1_vectorpop26_insert0[47:14] = 34'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_insert0_stall_local;
wire [71:0] local_bb1_vectorpop3_insert0;

assign local_bb1_vectorpop3_insert0[7:0] = 8'h0;
assign local_bb1_vectorpop3_insert0[71:8] = 64'bx;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_c1_ene1_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene1_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene1_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene1_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene1_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene1_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene1_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene1_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene1_0_valid_out_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene1_0_stall_in_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene1_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_c1_ene1_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_c1_ene1_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_c1_ene1_0_stall_in_0_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_c1_ene1_0_valid_out_0_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_c1_ene1_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_c1_ene1_NO_SHIFT_REG),
	.data_out(rnode_15to16_bb1_c1_ene1_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_c1_ene1_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_c1_ene1_0_reg_16_fifo.DATA_WIDTH = 1;
defparam rnode_15to16_bb1_c1_ene1_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_c1_ene1_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_c1_ene1_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_c1_ene1_stall_in_4 = 1'b0;
assign rnode_15to16_bb1_c1_ene1_0_stall_in_0_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_c1_ene1_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_c1_ene1_0_NO_SHIFT_REG = rnode_15to16_bb1_c1_ene1_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_c1_ene1_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_c1_ene1_1_NO_SHIFT_REG = rnode_15to16_bb1_c1_ene1_0_reg_16_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_c1_ene2_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene2_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene2_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene2_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene2_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene2_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene2_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene2_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene2_0_valid_out_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene2_0_stall_in_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_c1_ene2_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_c1_ene2_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_c1_ene2_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_c1_ene2_0_stall_in_0_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_c1_ene2_0_valid_out_0_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_c1_ene2_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_c1_ene2_NO_SHIFT_REG),
	.data_out(rnode_15to16_bb1_c1_ene2_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_c1_ene2_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_c1_ene2_0_reg_16_fifo.DATA_WIDTH = 1;
defparam rnode_15to16_bb1_c1_ene2_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_c1_ene2_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_c1_ene2_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_c1_ene2_stall_in_1 = 1'b0;
assign rnode_15to16_bb1_c1_ene2_0_stall_in_0_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_c1_ene2_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_c1_ene2_0_NO_SHIFT_REG = rnode_15to16_bb1_c1_ene2_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_c1_ene2_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_c1_ene2_1_NO_SHIFT_REG = rnode_15to16_bb1_c1_ene2_0_reg_16_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1__0_stall_local;
wire [7:0] local_bb1__0;

assign local_bb1__0 = local_bb1_c1_ene3[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1__1_stall_local;
wire [7:0] local_bb1__1;

assign local_bb1__1 = local_bb1_c1_ene3[15:8];

// This section implements an unregistered operation.
// 
wire local_bb1__2_stall_local;
wire [7:0] local_bb1__2;

assign local_bb1__2 = local_bb1_c1_ene3[23:16];

// This section implements an unregistered operation.
// 
wire local_bb1__0_valid_out;
wire local_bb1__0_stall_in;
wire local_bb1__1_valid_out;
wire local_bb1__1_stall_in;
wire local_bb1__2_valid_out;
wire local_bb1__2_stall_in;
wire local_bb1__3_valid_out;
wire local_bb1__3_stall_in;
wire local_bb1__3_inputs_ready;
wire local_bb1__3_stall_local;
wire [7:0] local_bb1__3;

assign local_bb1__3_inputs_ready = local_bb1_c1_enter_c1_eni3_valid_out_2_NO_SHIFT_REG;
assign local_bb1__3 = local_bb1_c1_ene3[31:24];
assign local_bb1__0_valid_out = 1'b1;
assign local_bb1__1_valid_out = 1'b1;
assign local_bb1__2_valid_out = 1'b1;
assign local_bb1__3_valid_out = 1'b1;
assign local_bb1_c1_enter_c1_eni3_stall_in_2 = 1'b0;

// This section implements a registered operation.
// 
wire SFC_2_VALID_14_15_0_inputs_ready;
 reg SFC_2_VALID_14_15_0_valid_out_0_NO_SHIFT_REG;
wire SFC_2_VALID_14_15_0_stall_in_0;
 reg SFC_2_VALID_14_15_0_valid_out_1_NO_SHIFT_REG;
wire SFC_2_VALID_14_15_0_stall_in_1;
 reg SFC_2_VALID_14_15_0_valid_out_2_NO_SHIFT_REG;
wire SFC_2_VALID_14_15_0_stall_in_2;
 reg SFC_2_VALID_14_15_0_valid_out_3_NO_SHIFT_REG;
wire SFC_2_VALID_14_15_0_stall_in_3;
 reg SFC_2_VALID_14_15_0_valid_out_4_NO_SHIFT_REG;
wire SFC_2_VALID_14_15_0_stall_in_4;
wire SFC_2_VALID_14_15_0_output_regs_ready;
 reg SFC_2_VALID_14_15_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_2_VALID_14_15_0_causedstall;

assign SFC_2_VALID_14_15_0_inputs_ready = 1'b1;
assign SFC_2_VALID_14_15_0_output_regs_ready = 1'b1;
assign SFC_2_VALID_14_14_0_stall_in = 1'b0;
assign SFC_2_VALID_14_15_0_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		SFC_2_VALID_14_15_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (SFC_2_VALID_14_15_0_output_regs_ready)
		begin
			SFC_2_VALID_14_15_0_NO_SHIFT_REG <= SFC_2_VALID_14_14_0;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop26_insert1_stall_local;
wire [47:0] local_bb1_vectorpop26_insert1;

assign local_bb1_vectorpop26_insert1[15:0] = local_bb1_vectorpop26_insert0[15:0];
assign local_bb1_vectorpop26_insert1[47:16] = 32'h0;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_insert1_stall_local;
wire [71:0] local_bb1_vectorpop3_insert1;

assign local_bb1_vectorpop3_insert1[7:0] = local_bb1_vectorpop3_insert0[7:0];
assign local_bb1_vectorpop3_insert1[15:8] = 8'h0;
assign local_bb1_vectorpop3_insert1[71:16] = local_bb1_vectorpop3_insert0[71:16];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert0_stall_local;
wire [87:0] local_bb1_vectorpop8_insert0;

assign local_bb1_vectorpop8_insert0[7:0] = 8'h0;
assign local_bb1_vectorpop8_insert0[87:8] = 80'bx;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_14to15_bb1__0_0_valid_out_NO_SHIFT_REG;
 logic rnode_14to15_bb1__0_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_14to15_bb1__0_0_NO_SHIFT_REG;
 logic rnode_14to15_bb1__0_0_reg_15_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_14to15_bb1__0_0_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1__0_0_valid_out_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1__0_0_stall_in_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1__0_0_stall_out_reg_15_NO_SHIFT_REG;

acl_data_fifo rnode_14to15_bb1__0_0_reg_15_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_14to15_bb1__0_0_reg_15_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_14to15_bb1__0_0_stall_in_reg_15_NO_SHIFT_REG),
	.valid_out(rnode_14to15_bb1__0_0_valid_out_reg_15_NO_SHIFT_REG),
	.stall_out(rnode_14to15_bb1__0_0_stall_out_reg_15_NO_SHIFT_REG),
	.data_in(local_bb1__0),
	.data_out(rnode_14to15_bb1__0_0_reg_15_NO_SHIFT_REG)
);

defparam rnode_14to15_bb1__0_0_reg_15_fifo.DEPTH = 1;
defparam rnode_14to15_bb1__0_0_reg_15_fifo.DATA_WIDTH = 8;
defparam rnode_14to15_bb1__0_0_reg_15_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_14to15_bb1__0_0_reg_15_fifo.IMPL = "shift_reg";

assign rnode_14to15_bb1__0_0_reg_15_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__0_stall_in = 1'b0;
assign rnode_14to15_bb1__0_0_NO_SHIFT_REG = rnode_14to15_bb1__0_0_reg_15_NO_SHIFT_REG;
assign rnode_14to15_bb1__0_0_stall_in_reg_15_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb1__0_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_14to15_bb1__1_0_valid_out_NO_SHIFT_REG;
 logic rnode_14to15_bb1__1_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_14to15_bb1__1_0_NO_SHIFT_REG;
 logic rnode_14to15_bb1__1_0_reg_15_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_14to15_bb1__1_0_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1__1_0_valid_out_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1__1_0_stall_in_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1__1_0_stall_out_reg_15_NO_SHIFT_REG;

acl_data_fifo rnode_14to15_bb1__1_0_reg_15_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_14to15_bb1__1_0_reg_15_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_14to15_bb1__1_0_stall_in_reg_15_NO_SHIFT_REG),
	.valid_out(rnode_14to15_bb1__1_0_valid_out_reg_15_NO_SHIFT_REG),
	.stall_out(rnode_14to15_bb1__1_0_stall_out_reg_15_NO_SHIFT_REG),
	.data_in(local_bb1__1),
	.data_out(rnode_14to15_bb1__1_0_reg_15_NO_SHIFT_REG)
);

defparam rnode_14to15_bb1__1_0_reg_15_fifo.DEPTH = 1;
defparam rnode_14to15_bb1__1_0_reg_15_fifo.DATA_WIDTH = 8;
defparam rnode_14to15_bb1__1_0_reg_15_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_14to15_bb1__1_0_reg_15_fifo.IMPL = "shift_reg";

assign rnode_14to15_bb1__1_0_reg_15_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__1_stall_in = 1'b0;
assign rnode_14to15_bb1__1_0_NO_SHIFT_REG = rnode_14to15_bb1__1_0_reg_15_NO_SHIFT_REG;
assign rnode_14to15_bb1__1_0_stall_in_reg_15_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb1__1_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_14to15_bb1__2_0_valid_out_NO_SHIFT_REG;
 logic rnode_14to15_bb1__2_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_14to15_bb1__2_0_NO_SHIFT_REG;
 logic rnode_14to15_bb1__2_0_reg_15_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_14to15_bb1__2_0_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1__2_0_valid_out_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1__2_0_stall_in_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1__2_0_stall_out_reg_15_NO_SHIFT_REG;

acl_data_fifo rnode_14to15_bb1__2_0_reg_15_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_14to15_bb1__2_0_reg_15_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_14to15_bb1__2_0_stall_in_reg_15_NO_SHIFT_REG),
	.valid_out(rnode_14to15_bb1__2_0_valid_out_reg_15_NO_SHIFT_REG),
	.stall_out(rnode_14to15_bb1__2_0_stall_out_reg_15_NO_SHIFT_REG),
	.data_in(local_bb1__2),
	.data_out(rnode_14to15_bb1__2_0_reg_15_NO_SHIFT_REG)
);

defparam rnode_14to15_bb1__2_0_reg_15_fifo.DEPTH = 1;
defparam rnode_14to15_bb1__2_0_reg_15_fifo.DATA_WIDTH = 8;
defparam rnode_14to15_bb1__2_0_reg_15_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_14to15_bb1__2_0_reg_15_fifo.IMPL = "shift_reg";

assign rnode_14to15_bb1__2_0_reg_15_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__2_stall_in = 1'b0;
assign rnode_14to15_bb1__2_0_NO_SHIFT_REG = rnode_14to15_bb1__2_0_reg_15_NO_SHIFT_REG;
assign rnode_14to15_bb1__2_0_stall_in_reg_15_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb1__2_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_14to15_bb1__3_0_valid_out_NO_SHIFT_REG;
 logic rnode_14to15_bb1__3_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_14to15_bb1__3_0_NO_SHIFT_REG;
 logic rnode_14to15_bb1__3_0_reg_15_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_14to15_bb1__3_0_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1__3_0_valid_out_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1__3_0_stall_in_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1__3_0_stall_out_reg_15_NO_SHIFT_REG;

acl_data_fifo rnode_14to15_bb1__3_0_reg_15_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_14to15_bb1__3_0_reg_15_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_14to15_bb1__3_0_stall_in_reg_15_NO_SHIFT_REG),
	.valid_out(rnode_14to15_bb1__3_0_valid_out_reg_15_NO_SHIFT_REG),
	.stall_out(rnode_14to15_bb1__3_0_stall_out_reg_15_NO_SHIFT_REG),
	.data_in(local_bb1__3),
	.data_out(rnode_14to15_bb1__3_0_reg_15_NO_SHIFT_REG)
);

defparam rnode_14to15_bb1__3_0_reg_15_fifo.DEPTH = 1;
defparam rnode_14to15_bb1__3_0_reg_15_fifo.DATA_WIDTH = 8;
defparam rnode_14to15_bb1__3_0_reg_15_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_14to15_bb1__3_0_reg_15_fifo.IMPL = "shift_reg";

assign rnode_14to15_bb1__3_0_reg_15_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__3_stall_in = 1'b0;
assign rnode_14to15_bb1__3_0_NO_SHIFT_REG = rnode_14to15_bb1__3_0_reg_15_NO_SHIFT_REG;
assign rnode_14to15_bb1__3_0_stall_in_reg_15_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb1__3_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements a registered operation.
// 
wire SFC_2_VALID_15_16_0_inputs_ready;
 reg SFC_2_VALID_15_16_0_valid_out_0_NO_SHIFT_REG;
wire SFC_2_VALID_15_16_0_stall_in_0;
 reg SFC_2_VALID_15_16_0_valid_out_1_NO_SHIFT_REG;
wire SFC_2_VALID_15_16_0_stall_in_1;
 reg SFC_2_VALID_15_16_0_valid_out_2_NO_SHIFT_REG;
wire SFC_2_VALID_15_16_0_stall_in_2;
 reg SFC_2_VALID_15_16_0_valid_out_3_NO_SHIFT_REG;
wire SFC_2_VALID_15_16_0_stall_in_3;
 reg SFC_2_VALID_15_16_0_valid_out_4_NO_SHIFT_REG;
wire SFC_2_VALID_15_16_0_stall_in_4;
wire SFC_2_VALID_15_16_0_output_regs_ready;
 reg SFC_2_VALID_15_16_0_NO_SHIFT_REG /* synthesis  preserve  */;
wire SFC_2_VALID_15_16_0_causedstall;

assign SFC_2_VALID_15_16_0_inputs_ready = 1'b1;
assign SFC_2_VALID_15_16_0_output_regs_ready = 1'b1;
assign SFC_2_VALID_14_15_0_stall_in_0 = 1'b0;
assign SFC_2_VALID_15_16_0_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		SFC_2_VALID_15_16_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (SFC_2_VALID_15_16_0_output_regs_ready)
		begin
			SFC_2_VALID_15_16_0_NO_SHIFT_REG <= SFC_2_VALID_14_15_0_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop26_vectorpop26_insert1_stall_local;
wire [47:0] local_bb1_vectorpop26_vectorpop26_insert1;
wire local_bb1_vectorpop26_vectorpop26_insert1_fu_valid_out;
wire local_bb1_vectorpop26_vectorpop26_insert1_fu_stall_out;

acl_pop local_bb1_vectorpop26_vectorpop26_insert1_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_c1_ene1_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpop26_insert1),
	.stall_out(local_bb1_vectorpop26_vectorpop26_insert1_fu_stall_out),
	.valid_in(SFC_2_VALID_14_15_0_NO_SHIFT_REG),
	.valid_out(local_bb1_vectorpop26_vectorpop26_insert1_fu_valid_out),
	.stall_in(local_bb1_vectorpop26_vectorpop26_insert1_stall_local),
	.data_out(local_bb1_vectorpop26_vectorpop26_insert1),
	.feedback_in(feedback_data_in_26),
	.feedback_valid_in(feedback_valid_in_26),
	.feedback_stall_out(feedback_stall_out_26)
);

defparam local_bb1_vectorpop26_vectorpop26_insert1_feedback.COALESCE_DISTANCE = 1;
defparam local_bb1_vectorpop26_vectorpop26_insert1_feedback.DATA_WIDTH = 48;
defparam local_bb1_vectorpop26_vectorpop26_insert1_feedback.STYLE = "REGULAR";

assign local_bb1_vectorpop26_vectorpop26_insert1_stall_local = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_insert2_stall_local;
wire [71:0] local_bb1_vectorpop3_insert2;

assign local_bb1_vectorpop3_insert2[15:0] = local_bb1_vectorpop3_insert1[15:0];
assign local_bb1_vectorpop3_insert2[23:16] = 8'h0;
assign local_bb1_vectorpop3_insert2[71:24] = local_bb1_vectorpop3_insert1[71:24];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert1_stall_local;
wire [87:0] local_bb1_vectorpop8_insert1;

assign local_bb1_vectorpop8_insert1[7:0] = local_bb1_vectorpop8_insert0[7:0];
assign local_bb1_vectorpop8_insert1[15:8] = 8'h0;
assign local_bb1_vectorpop8_insert1[87:16] = local_bb1_vectorpop8_insert0[87:16];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0zext_stall_local;
wire [31:0] local_bb1_scalarizer_0zext;

assign local_bb1_scalarizer_0zext[31:8] = 24'h0;
assign local_bb1_scalarizer_0zext[7:0] = rnode_14to15_bb1__0_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1zext_stall_local;
wire [31:0] local_bb1_scalarizer_1zext;

assign local_bb1_scalarizer_1zext[31:8] = 24'h0;
assign local_bb1_scalarizer_1zext[7:0] = rnode_14to15_bb1__1_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2zext_stall_local;
wire [31:0] local_bb1_scalarizer_2zext;

assign local_bb1_scalarizer_2zext[31:8] = 24'h0;
assign local_bb1_scalarizer_2zext[7:0] = rnode_14to15_bb1__2_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3zext_stall_local;
wire [31:0] local_bb1_scalarizer_3zext;

assign local_bb1_scalarizer_3zext[31:8] = 24'h0;
assign local_bb1_scalarizer_3zext[7:0] = rnode_14to15_bb1__3_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop26_extract0_stall_local;
wire [13:0] local_bb1_vectorpop26_extract0;

assign local_bb1_vectorpop26_extract0[13:0] = local_bb1_vectorpop26_vectorpop26_insert1[13:0];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop26_extract1_stall_local;
wire [31:0] local_bb1_vectorpop26_extract1;

assign local_bb1_vectorpop26_extract1[31:0] = local_bb1_vectorpop26_vectorpop26_insert1[47:16];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_insert3_stall_local;
wire [71:0] local_bb1_vectorpop3_insert3;

assign local_bb1_vectorpop3_insert3[23:0] = local_bb1_vectorpop3_insert2[23:0];
assign local_bb1_vectorpop3_insert3[31:24] = 8'h0;
assign local_bb1_vectorpop3_insert3[71:32] = local_bb1_vectorpop3_insert2[71:32];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert2_stall_local;
wire [87:0] local_bb1_vectorpop8_insert2;

assign local_bb1_vectorpop8_insert2[15:0] = local_bb1_vectorpop8_insert1[15:0];
assign local_bb1_vectorpop8_insert2[23:16] = 8'h0;
assign local_bb1_vectorpop8_insert2[87:24] = local_bb1_vectorpop8_insert1[87:24];

// This section implements an unregistered operation.
// 
wire local_bb1_not_select_stall_local;
wire local_bb1_not_select;

assign local_bb1_not_select = ($signed(local_bb1_vectorpop26_extract0) > $signed(14'h3FFF));

// This section implements an unregistered operation.
// 
wire local_bb1_coalesce_counter_lobit_stall_local;
wire [13:0] local_bb1_coalesce_counter_lobit;

assign local_bb1_coalesce_counter_lobit = (local_bb1_vectorpop26_extract0 >> 14'hD);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp4_stall_local;
wire local_bb1_cmp4;

assign local_bb1_cmp4 = (local_bb1_vectorpop26_extract1 == 32'h13EC);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_insert4_stall_local;
wire [71:0] local_bb1_vectorpop3_insert4;

assign local_bb1_vectorpop3_insert4[31:0] = local_bb1_vectorpop3_insert3[31:0];
assign local_bb1_vectorpop3_insert4[39:32] = 8'h0;
assign local_bb1_vectorpop3_insert4[71:40] = local_bb1_vectorpop3_insert3[71:40];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert3_stall_local;
wire [87:0] local_bb1_vectorpop8_insert3;

assign local_bb1_vectorpop8_insert3[23:0] = local_bb1_vectorpop8_insert2[23:0];
assign local_bb1_vectorpop8_insert3[31:24] = 8'h0;
assign local_bb1_vectorpop8_insert3[87:32] = local_bb1_vectorpop8_insert2[87:32];

// This section implements an unregistered operation.
// 
wire local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0_stall_local;
wire [31:0] local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0;
wire local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0_fu_valid_out;
wire local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0_fu_stall_out;

acl_pop local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_not_select),
	.predicate(1'b0),
	.data_in(32'h0),
	.stall_out(local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0_fu_stall_out),
	.valid_in(SFC_2_VALID_14_15_0_NO_SHIFT_REG),
	.valid_out(local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0_fu_valid_out),
	.stall_in(local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0_stall_local),
	.data_out(local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0),
	.feedback_in(feedback_data_in_2),
	.feedback_valid_in(feedback_valid_in_2),
	.feedback_stall_out(feedback_stall_out_2)
);

defparam local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0_feedback.COALESCE_DISTANCE = 5095;
defparam local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0_feedback.DATA_WIDTH = 32;
defparam local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0_feedback.STYLE = "COALESCE";

assign local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0_stall_local = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_next_coalesce_select_stall_local;
wire [13:0] local_bb1_next_coalesce_select;

assign local_bb1_next_coalesce_select = ((local_bb1_coalesce_counter_lobit & 14'h1) ^ 14'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_col_1_stall_local;
wire [31:0] local_bb1_col_1;

assign local_bb1_col_1 = (local_bb1_cmp4 ? 32'h0 : local_bb1_vectorpop26_extract1);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_insert5_stall_local;
wire [71:0] local_bb1_vectorpop3_insert5;

assign local_bb1_vectorpop3_insert5[39:0] = local_bb1_vectorpop3_insert4[39:0];
assign local_bb1_vectorpop3_insert5[47:40] = 8'h0;
assign local_bb1_vectorpop3_insert5[71:48] = local_bb1_vectorpop3_insert4[71:48];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert4_stall_local;
wire [87:0] local_bb1_vectorpop8_insert4;

assign local_bb1_vectorpop8_insert4[31:0] = local_bb1_vectorpop8_insert3[31:0];
assign local_bb1_vectorpop8_insert4[39:32] = 8'h0;
assign local_bb1_vectorpop8_insert4[87:40] = local_bb1_vectorpop8_insert3[87:40];

// This section implements an unregistered operation.
// 
wire local_bb1_errorBuffer_5_0_coalesced_head_bitcast_stall_local;
wire [31:0] local_bb1_errorBuffer_5_0_coalesced_head_bitcast;

assign local_bb1_errorBuffer_5_0_coalesced_head_bitcast = local_bb1_errorBuffer_5_0_coalesced_pop2_acl_pop_i32_0;

// This section implements an unregistered operation.
// 
wire local_bb1_next_coalesce_stall_local;
wire [13:0] local_bb1_next_coalesce;

assign local_bb1_next_coalesce = (local_bb1_vectorpop26_extract0 - (local_bb1_next_coalesce_select & 14'h1));

// This section implements an unregistered operation.
// 
wire local_bb1_cmp32_stall_local;
wire local_bb1_cmp32;

assign local_bb1_cmp32 = (local_bb1_col_1 < 32'h13EB);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp38_stall_local;
wire local_bb1_cmp38;

assign local_bb1_cmp38 = (local_bb1_col_1 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp43_stall_local;
wire local_bb1_cmp43;

assign local_bb1_cmp43 = (local_bb1_col_1 > 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp48_stall_local;
wire local_bb1_cmp48;

assign local_bb1_cmp48 = (local_bb1_col_1 > 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp53_stall_local;
wire local_bb1_cmp53;

assign local_bb1_cmp53 = (local_bb1_col_1 > 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_inc72_stall_local;
wire [31:0] local_bb1_inc72;

assign local_bb1_inc72 = (local_bb1_col_1 + 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_insert6_stall_local;
wire [71:0] local_bb1_vectorpop3_insert6;

assign local_bb1_vectorpop3_insert6[47:0] = local_bb1_vectorpop3_insert5[47:0];
assign local_bb1_vectorpop3_insert6[55:48] = 8'h0;
assign local_bb1_vectorpop3_insert6[71:56] = local_bb1_vectorpop3_insert5[71:56];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert5_stall_local;
wire [87:0] local_bb1_vectorpop8_insert5;

assign local_bb1_vectorpop8_insert5[39:0] = local_bb1_vectorpop8_insert4[39:0];
assign local_bb1_vectorpop8_insert5[47:40] = 8'h0;
assign local_bb1_vectorpop8_insert5[87:48] = local_bb1_vectorpop8_insert4[87:48];

// This section implements an unregistered operation.
// 
wire local_bb1_errorBuffer_5_0_coalesced_head_bitcast_0_stall_local;
wire [7:0] local_bb1_errorBuffer_5_0_coalesced_head_bitcast_0;

assign local_bb1_errorBuffer_5_0_coalesced_head_bitcast_0 = local_bb1_errorBuffer_5_0_coalesced_head_bitcast[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_errorBuffer_5_0_coalesced_head_bitcast_1_stall_local;
wire [7:0] local_bb1_errorBuffer_5_0_coalesced_head_bitcast_1;

assign local_bb1_errorBuffer_5_0_coalesced_head_bitcast_1 = local_bb1_errorBuffer_5_0_coalesced_head_bitcast[15:8];

// This section implements an unregistered operation.
// 
wire local_bb1_errorBuffer_5_0_coalesced_head_bitcast_2_stall_local;
wire [7:0] local_bb1_errorBuffer_5_0_coalesced_head_bitcast_2;

assign local_bb1_errorBuffer_5_0_coalesced_head_bitcast_2 = local_bb1_errorBuffer_5_0_coalesced_head_bitcast[23:16];

// This section implements an unregistered operation.
// 
wire local_bb1_errorBuffer_5_0_coalesced_head_bitcast_3_stall_local;
wire [7:0] local_bb1_errorBuffer_5_0_coalesced_head_bitcast_3;

assign local_bb1_errorBuffer_5_0_coalesced_head_bitcast_3 = local_bb1_errorBuffer_5_0_coalesced_head_bitcast[31:24];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush26_insert0_stall_local;
wire [47:0] local_bb1_vectorpush26_insert0;

assign local_bb1_vectorpush26_insert0[13:0] = local_bb1_next_coalesce;
assign local_bb1_vectorpush26_insert0[47:14] = 34'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_insert7_stall_local;
wire [71:0] local_bb1_vectorpop3_insert7;

assign local_bb1_vectorpop3_insert7[55:0] = local_bb1_vectorpop3_insert6[55:0];
assign local_bb1_vectorpop3_insert7[63:56] = 8'h0;
assign local_bb1_vectorpop3_insert7[71:64] = local_bb1_vectorpop3_insert6[71:64];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert6_stall_local;
wire [87:0] local_bb1_vectorpop8_insert6;

assign local_bb1_vectorpop8_insert6[47:0] = local_bb1_vectorpop8_insert5[47:0];
assign local_bb1_vectorpop8_insert6[55:48] = 8'h0;
assign local_bb1_vectorpop8_insert6[87:56] = local_bb1_vectorpop8_insert5[87:56];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush26_insert1_stall_local;
wire [47:0] local_bb1_vectorpush26_insert1;

assign local_bb1_vectorpush26_insert1[15:0] = local_bb1_vectorpush26_insert0[15:0];
assign local_bb1_vectorpush26_insert1[47:16] = local_bb1_inc72;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_insert8_stall_local;
wire [71:0] local_bb1_vectorpop3_insert8;

assign local_bb1_vectorpop3_insert8[63:0] = local_bb1_vectorpop3_insert7[63:0];
assign local_bb1_vectorpop3_insert8[71:64] = 8'h0;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert7_stall_local;
wire [87:0] local_bb1_vectorpop8_insert7;

assign local_bb1_vectorpop8_insert7[55:0] = local_bb1_vectorpop8_insert6[55:0];
assign local_bb1_vectorpop8_insert7[63:56] = 8'h0;
assign local_bb1_vectorpop8_insert7[87:64] = local_bb1_vectorpop8_insert6[87:64];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_vectorpop3_insert8_stall_local;
wire [71:0] local_bb1_vectorpop3_vectorpop3_insert8;
wire local_bb1_vectorpop3_vectorpop3_insert8_fu_valid_out;
wire local_bb1_vectorpop3_vectorpop3_insert8_fu_stall_out;

acl_pop local_bb1_vectorpop3_vectorpop3_insert8_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_c1_ene1_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpop3_insert8),
	.stall_out(local_bb1_vectorpop3_vectorpop3_insert8_fu_stall_out),
	.valid_in(SFC_2_VALID_14_15_0_NO_SHIFT_REG),
	.valid_out(local_bb1_vectorpop3_vectorpop3_insert8_fu_valid_out),
	.stall_in(local_bb1_vectorpop3_vectorpop3_insert8_stall_local),
	.data_out(local_bb1_vectorpop3_vectorpop3_insert8),
	.feedback_in(feedback_data_in_3),
	.feedback_valid_in(feedback_valid_in_3),
	.feedback_stall_out(feedback_stall_out_3)
);

defparam local_bb1_vectorpop3_vectorpop3_insert8_feedback.COALESCE_DISTANCE = 1;
defparam local_bb1_vectorpop3_vectorpop3_insert8_feedback.DATA_WIDTH = 72;
defparam local_bb1_vectorpop3_vectorpop3_insert8_feedback.STYLE = "REGULAR";

assign local_bb1_vectorpop3_vectorpop3_insert8_stall_local = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert8_stall_local;
wire [87:0] local_bb1_vectorpop8_insert8;

assign local_bb1_vectorpop8_insert8[63:0] = local_bb1_vectorpop8_insert7[63:0];
assign local_bb1_vectorpop8_insert8[71:64] = 8'h0;
assign local_bb1_vectorpop8_insert8[87:72] = local_bb1_vectorpop8_insert7[87:72];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_extract0_stall_local;
wire [7:0] local_bb1_vectorpop3_extract0;

assign local_bb1_vectorpop3_extract0[7:0] = local_bb1_vectorpop3_vectorpop3_insert8[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_extract1_stall_local;
wire [7:0] local_bb1_vectorpop3_extract1;

assign local_bb1_vectorpop3_extract1[7:0] = local_bb1_vectorpop3_vectorpop3_insert8[15:8];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_extract2_stall_local;
wire [7:0] local_bb1_vectorpop3_extract2;

assign local_bb1_vectorpop3_extract2[7:0] = local_bb1_vectorpop3_vectorpop3_insert8[23:16];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_extract3_stall_local;
wire [7:0] local_bb1_vectorpop3_extract3;

assign local_bb1_vectorpop3_extract3[7:0] = local_bb1_vectorpop3_vectorpop3_insert8[31:24];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_extract4_stall_local;
wire [7:0] local_bb1_vectorpop3_extract4;

assign local_bb1_vectorpop3_extract4[7:0] = local_bb1_vectorpop3_vectorpop3_insert8[39:32];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_extract5_stall_local;
wire [7:0] local_bb1_vectorpop3_extract5;

assign local_bb1_vectorpop3_extract5[7:0] = local_bb1_vectorpop3_vectorpop3_insert8[47:40];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_extract6_stall_local;
wire [7:0] local_bb1_vectorpop3_extract6;

assign local_bb1_vectorpop3_extract6[7:0] = local_bb1_vectorpop3_vectorpop3_insert8[55:48];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_extract7_stall_local;
wire [7:0] local_bb1_vectorpop3_extract7;

assign local_bb1_vectorpop3_extract7[7:0] = local_bb1_vectorpop3_vectorpop3_insert8[63:56];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop3_extract8_stall_local;
wire [7:0] local_bb1_vectorpop3_extract8;

assign local_bb1_vectorpop3_extract8[7:0] = local_bb1_vectorpop3_vectorpop3_insert8[71:64];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert9_stall_local;
wire [87:0] local_bb1_vectorpop8_insert9;

assign local_bb1_vectorpop8_insert9[71:0] = local_bb1_vectorpop8_insert8[71:0];
assign local_bb1_vectorpop8_insert9[79:72] = 8'h0;
assign local_bb1_vectorpop8_insert9[87:80] = local_bb1_vectorpop8_insert8[87:80];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0sext_stall_local;
wire [31:0] local_bb1_scalarizer_0sext;

assign local_bb1_scalarizer_0sext[8] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[9] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[10] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[11] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[12] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[13] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[14] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[15] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[16] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[17] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[18] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[19] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[20] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[21] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[22] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[23] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[24] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[25] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[26] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[27] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[28] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[29] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[30] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[31] = local_bb1_vectorpop3_extract0[7];
assign local_bb1_scalarizer_0sext[7:0] = local_bb1_vectorpop3_extract0;

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1sext_stall_local;
wire [31:0] local_bb1_scalarizer_1sext;

assign local_bb1_scalarizer_1sext[8] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[9] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[10] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[11] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[12] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[13] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[14] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[15] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[16] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[17] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[18] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[19] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[20] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[21] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[22] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[23] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[24] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[25] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[26] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[27] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[28] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[29] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[30] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[31] = local_bb1_vectorpop3_extract1[7];
assign local_bb1_scalarizer_1sext[7:0] = local_bb1_vectorpop3_extract1;

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2sext_stall_local;
wire [31:0] local_bb1_scalarizer_2sext;

assign local_bb1_scalarizer_2sext[8] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[9] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[10] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[11] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[12] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[13] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[14] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[15] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[16] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[17] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[18] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[19] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[20] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[21] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[22] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[23] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[24] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[25] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[26] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[27] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[28] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[29] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[30] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[31] = local_bb1_vectorpop3_extract2[7];
assign local_bb1_scalarizer_2sext[7:0] = local_bb1_vectorpop3_extract2;

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3sext_stall_local;
wire [31:0] local_bb1_scalarizer_3sext;

assign local_bb1_scalarizer_3sext[8] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[9] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[10] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[11] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[12] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[13] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[14] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[15] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[16] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[17] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[18] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[19] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[20] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[21] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[22] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[23] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[24] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[25] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[26] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[27] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[28] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[29] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[30] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[31] = local_bb1_vectorpop3_extract3[7];
assign local_bb1_scalarizer_3sext[7:0] = local_bb1_vectorpop3_extract3;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_insert10_stall_local;
wire [87:0] local_bb1_vectorpop8_insert10;

assign local_bb1_vectorpop8_insert10[79:0] = local_bb1_vectorpop8_insert9[79:0];
assign local_bb1_vectorpop8_insert10[87:80] = 8'h0;

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0add_stall_local;
wire [31:0] local_bb1_scalarizer_0add;

assign local_bb1_scalarizer_0add = ((local_bb1_scalarizer_0zext & 32'hFF) + local_bb1_scalarizer_0sext);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1add_stall_local;
wire [31:0] local_bb1_scalarizer_1add;

assign local_bb1_scalarizer_1add = ((local_bb1_scalarizer_1zext & 32'hFF) + local_bb1_scalarizer_1sext);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2add_stall_local;
wire [31:0] local_bb1_scalarizer_2add;

assign local_bb1_scalarizer_2add = ((local_bb1_scalarizer_2zext & 32'hFF) + local_bb1_scalarizer_2sext);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3add_stall_local;
wire [31:0] local_bb1_scalarizer_3add;

assign local_bb1_scalarizer_3add = ((local_bb1_scalarizer_3zext & 32'hFF) + local_bb1_scalarizer_3sext);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_vectorpop8_insert10_stall_local;
wire [87:0] local_bb1_vectorpop8_vectorpop8_insert10;
wire local_bb1_vectorpop8_vectorpop8_insert10_fu_valid_out;
wire local_bb1_vectorpop8_vectorpop8_insert10_fu_stall_out;

acl_pop local_bb1_vectorpop8_vectorpop8_insert10_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(rnode_15to16_bb1_c1_ene1_1_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpop8_insert10),
	.stall_out(local_bb1_vectorpop8_vectorpop8_insert10_fu_stall_out),
	.valid_in(SFC_2_VALID_15_16_0_NO_SHIFT_REG),
	.valid_out(local_bb1_vectorpop8_vectorpop8_insert10_fu_valid_out),
	.stall_in(local_bb1_vectorpop8_vectorpop8_insert10_stall_local),
	.data_out(local_bb1_vectorpop8_vectorpop8_insert10),
	.feedback_in(feedback_data_in_8),
	.feedback_valid_in(feedback_valid_in_8),
	.feedback_stall_out(feedback_stall_out_8)
);

defparam local_bb1_vectorpop8_vectorpop8_insert10_feedback.COALESCE_DISTANCE = 1;
defparam local_bb1_vectorpop8_vectorpop8_insert10_feedback.DATA_WIDTH = 88;
defparam local_bb1_vectorpop8_vectorpop8_insert10_feedback.STYLE = "REGULAR";

assign local_bb1_vectorpop8_vectorpop8_insert10_stall_local = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_cmp9_stall_local;
wire local_bb1_cmp9;

assign local_bb1_cmp9 = ($signed(local_bb1_scalarizer_0add) > $signed(32'h7F));

// This section implements an unregistered operation.
// 
wire local_bb1_cmp10_stall_local;
wire local_bb1_cmp10;

assign local_bb1_cmp10 = ($signed(local_bb1_scalarizer_1add) > $signed(32'h7F));

// This section implements an unregistered operation.
// 
wire local_bb1_cmp15_stall_local;
wire local_bb1_cmp15;

assign local_bb1_cmp15 = ($signed(local_bb1_scalarizer_2add) > $signed(32'h7F));

// This section implements an unregistered operation.
// 
wire local_bb1_cmp20_stall_local;
wire local_bb1_cmp20;

assign local_bb1_cmp20 = ($signed(local_bb1_scalarizer_3add) > $signed(32'h7F));

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract0_stall_local;
wire [7:0] local_bb1_vectorpop8_extract0;

assign local_bb1_vectorpop8_extract0[7:0] = local_bb1_vectorpop8_vectorpop8_insert10[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract1_stall_local;
wire [7:0] local_bb1_vectorpop8_extract1;

assign local_bb1_vectorpop8_extract1[7:0] = local_bb1_vectorpop8_vectorpop8_insert10[15:8];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract2_stall_local;
wire [7:0] local_bb1_vectorpop8_extract2;

assign local_bb1_vectorpop8_extract2[7:0] = local_bb1_vectorpop8_vectorpop8_insert10[23:16];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract3_stall_local;
wire [7:0] local_bb1_vectorpop8_extract3;

assign local_bb1_vectorpop8_extract3[7:0] = local_bb1_vectorpop8_vectorpop8_insert10[31:24];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract4_stall_local;
wire [7:0] local_bb1_vectorpop8_extract4;

assign local_bb1_vectorpop8_extract4[7:0] = local_bb1_vectorpop8_vectorpop8_insert10[39:32];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract5_stall_local;
wire [7:0] local_bb1_vectorpop8_extract5;

assign local_bb1_vectorpop8_extract5[7:0] = local_bb1_vectorpop8_vectorpop8_insert10[47:40];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract6_stall_local;
wire [7:0] local_bb1_vectorpop8_extract6;

assign local_bb1_vectorpop8_extract6[7:0] = local_bb1_vectorpop8_vectorpop8_insert10[55:48];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract7_stall_local;
wire [7:0] local_bb1_vectorpop8_extract7;

assign local_bb1_vectorpop8_extract7[7:0] = local_bb1_vectorpop8_vectorpop8_insert10[63:56];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract8_stall_local;
wire [7:0] local_bb1_vectorpop8_extract8;

assign local_bb1_vectorpop8_extract8[7:0] = local_bb1_vectorpop8_vectorpop8_insert10[71:64];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract9_stall_local;
wire [7:0] local_bb1_vectorpop8_extract9;

assign local_bb1_vectorpop8_extract9[7:0] = local_bb1_vectorpop8_vectorpop8_insert10[79:72];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpop8_extract10_stall_local;
wire [7:0] local_bb1_vectorpop8_extract10;

assign local_bb1_vectorpop8_extract10[7:0] = local_bb1_vectorpop8_vectorpop8_insert10[87:80];

// This section implements an unregistered operation.
// 
wire local_bb1___stall_local;
wire [31:0] local_bb1__;

assign local_bb1__ = (local_bb1_cmp9 ? 32'hFF : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1__5209_stall_local;
wire [31:0] local_bb1__5209;

assign local_bb1__5209 = (local_bb1_cmp10 ? 32'hFF : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1__5210_stall_local;
wire [31:0] local_bb1__5210;

assign local_bb1__5210 = (local_bb1_cmp15 ? 32'hFF : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1__5211_stall_local;
wire [31:0] local_bb1__5211;

assign local_bb1__5211 = (local_bb1_cmp20 ? 32'hFF : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0trunc_stall_local;
wire [7:0] local_bb1_scalarizer_0trunc;
wire [31:0] local_bb1_scalarizer_0trunc$ps;

assign local_bb1_scalarizer_0trunc$ps = (local_bb1__ & 32'hFF);
assign local_bb1_scalarizer_0trunc = local_bb1_scalarizer_0trunc$ps[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0sub_stall_local;
wire [31:0] local_bb1_scalarizer_0sub;

assign local_bb1_scalarizer_0sub = (local_bb1_scalarizer_0add - (local_bb1__ & 32'hFF));

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1trunc_stall_local;
wire [7:0] local_bb1_scalarizer_1trunc;
wire [31:0] local_bb1_scalarizer_1trunc$ps;

assign local_bb1_scalarizer_1trunc$ps = (local_bb1__5209 & 32'hFF);
assign local_bb1_scalarizer_1trunc = local_bb1_scalarizer_1trunc$ps[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1sub_stall_local;
wire [31:0] local_bb1_scalarizer_1sub;

assign local_bb1_scalarizer_1sub = (local_bb1_scalarizer_1add - (local_bb1__5209 & 32'hFF));

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2trunc_stall_local;
wire [7:0] local_bb1_scalarizer_2trunc;
wire [31:0] local_bb1_scalarizer_2trunc$ps;

assign local_bb1_scalarizer_2trunc$ps = (local_bb1__5210 & 32'hFF);
assign local_bb1_scalarizer_2trunc = local_bb1_scalarizer_2trunc$ps[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2sub_stall_local;
wire [31:0] local_bb1_scalarizer_2sub;

assign local_bb1_scalarizer_2sub = (local_bb1_scalarizer_2add - (local_bb1__5210 & 32'hFF));

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3trunc_stall_local;
wire [7:0] local_bb1_scalarizer_3trunc;
wire [31:0] local_bb1_scalarizer_3trunc$ps;

assign local_bb1_scalarizer_3trunc$ps = (local_bb1__5211 & 32'hFF);
assign local_bb1_scalarizer_3trunc = local_bb1_scalarizer_3trunc$ps[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3sub_stall_local;
wire [31:0] local_bb1_scalarizer_3sub;

assign local_bb1_scalarizer_3sub = (local_bb1_scalarizer_3add - (local_bb1__5211 & 32'hFF));

// This section implements an unregistered operation.
// 
wire local_bb1_conv9_reassembled_stall_local;
wire [31:0] local_bb1_conv9_reassembled;

assign local_bb1_conv9_reassembled[7:0] = local_bb1_scalarizer_0trunc;
assign local_bb1_conv9_reassembled[15:8] = 8'bx;
assign local_bb1_conv9_reassembled[23:16] = 8'bx;
assign local_bb1_conv9_reassembled[31:24] = 8'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0trunc5149_stall_local;
wire [7:0] local_bb1_scalarizer_0trunc5149;

assign local_bb1_scalarizer_0trunc5149 = local_bb1_scalarizer_0sub[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1trunc5150_stall_local;
wire [7:0] local_bb1_scalarizer_1trunc5150;

assign local_bb1_scalarizer_1trunc5150 = local_bb1_scalarizer_1sub[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2trunc5151_stall_local;
wire [7:0] local_bb1_scalarizer_2trunc5151;

assign local_bb1_scalarizer_2trunc5151 = local_bb1_scalarizer_2sub[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3trunc5152_stall_local;
wire [7:0] local_bb1_scalarizer_3trunc5152;

assign local_bb1_scalarizer_3trunc5152 = local_bb1_scalarizer_3sub[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_conv9_reassembled5146_stall_local;
wire [31:0] local_bb1_conv9_reassembled5146;

assign local_bb1_conv9_reassembled5146[7:0] = local_bb1_conv9_reassembled[7:0];
assign local_bb1_conv9_reassembled5146[15:8] = local_bb1_scalarizer_1trunc;
assign local_bb1_conv9_reassembled5146[23:16] = local_bb1_conv9_reassembled[23:16];
assign local_bb1_conv9_reassembled5146[31:24] = local_bb1_conv9_reassembled[31:24];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0ashr5165_stall_local;
wire [7:0] local_bb1_scalarizer_0ashr5165;

assign local_bb1_scalarizer_0ashr5165 = ($signed(local_bb1_scalarizer_0trunc5149) >>> 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1ashr5166_stall_local;
wire [7:0] local_bb1_scalarizer_1ashr5166;

assign local_bb1_scalarizer_1ashr5166 = ($signed(local_bb1_scalarizer_1trunc5150) >>> 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2ashr5167_stall_local;
wire [7:0] local_bb1_scalarizer_2ashr5167;

assign local_bb1_scalarizer_2ashr5167 = ($signed(local_bb1_scalarizer_2trunc5151) >>> 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3ashr5168_stall_local;
wire [7:0] local_bb1_scalarizer_3ashr5168;

assign local_bb1_scalarizer_3ashr5168 = ($signed(local_bb1_scalarizer_3trunc5152) >>> 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_conv9_reassembled5147_stall_local;
wire [31:0] local_bb1_conv9_reassembled5147;

assign local_bb1_conv9_reassembled5147[7:0] = local_bb1_conv9_reassembled5146[7:0];
assign local_bb1_conv9_reassembled5147[15:8] = local_bb1_conv9_reassembled5146[15:8];
assign local_bb1_conv9_reassembled5147[23:16] = local_bb1_scalarizer_2trunc;
assign local_bb1_conv9_reassembled5147[31:24] = local_bb1_conv9_reassembled5146[31:24];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0add5169_stall_local;
wire [7:0] local_bb1_scalarizer_0add5169;

assign local_bb1_scalarizer_0add5169 = (local_bb1_cmp32 ? local_bb1_scalarizer_0ashr5165 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1add5170_stall_local;
wire [7:0] local_bb1_scalarizer_1add5170;

assign local_bb1_scalarizer_1add5170 = (local_bb1_cmp32 ? local_bb1_scalarizer_1ashr5166 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2add5171_stall_local;
wire [7:0] local_bb1_scalarizer_2add5171;

assign local_bb1_scalarizer_2add5171 = (local_bb1_cmp32 ? local_bb1_scalarizer_2ashr5167 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3add5172_stall_local;
wire [7:0] local_bb1_scalarizer_3add5172;

assign local_bb1_scalarizer_3add5172 = (local_bb1_cmp32 ? local_bb1_scalarizer_3ashr5168 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_conv9_reassembled5148_stall_local;
wire [31:0] local_bb1_conv9_reassembled5148;

assign local_bb1_conv9_reassembled5148[7:0] = local_bb1_conv9_reassembled5147[7:0];
assign local_bb1_conv9_reassembled5148[15:8] = local_bb1_conv9_reassembled5147[15:8];
assign local_bb1_conv9_reassembled5148[23:16] = local_bb1_conv9_reassembled5147[23:16];
assign local_bb1_conv9_reassembled5148[31:24] = local_bb1_scalarizer_3trunc;

// This section implements an unregistered operation.
// 
wire local_bb1__5212_stall_local;
wire [7:0] local_bb1__5212;

assign local_bb1__5212 = (local_bb1_errorBuffer_5_0_coalesced_head_bitcast_0 + local_bb1_scalarizer_0add5169);

// This section implements an unregistered operation.
// 
wire local_bb1__5213_stall_local;
wire [7:0] local_bb1__5213;

assign local_bb1__5213 = (local_bb1_errorBuffer_5_0_coalesced_head_bitcast_1 + local_bb1_scalarizer_1add5170);

// This section implements an unregistered operation.
// 
wire local_bb1__5214_stall_local;
wire [7:0] local_bb1__5214;

assign local_bb1__5214 = (local_bb1_errorBuffer_5_0_coalesced_head_bitcast_2 + local_bb1_scalarizer_2add5171);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp38_valid_out;
wire local_bb1_cmp38_stall_in;
wire local_bb1_cmp43_valid_out;
wire local_bb1_cmp43_stall_in;
wire local_bb1_cmp48_valid_out;
wire local_bb1_cmp48_stall_in;
wire local_bb1_cmp53_valid_out;
wire local_bb1_cmp53_stall_in;
wire local_bb1_vectorpush26_insert1_valid_out;
wire local_bb1_vectorpush26_insert1_stall_in;
wire local_bb1__5212_valid_out;
wire local_bb1__5212_stall_in;
wire local_bb1__5213_valid_out;
wire local_bb1__5213_stall_in;
wire local_bb1__5214_valid_out;
wire local_bb1__5214_stall_in;
wire local_bb1__5215_valid_out;
wire local_bb1__5215_stall_in;
wire local_bb1_vectorpop3_extract4_valid_out;
wire local_bb1_vectorpop3_extract4_stall_in;
wire local_bb1_vectorpop3_extract5_valid_out;
wire local_bb1_vectorpop3_extract5_stall_in;
wire local_bb1_vectorpop3_extract6_valid_out;
wire local_bb1_vectorpop3_extract6_stall_in;
wire local_bb1_vectorpop3_extract7_valid_out;
wire local_bb1_vectorpop3_extract7_stall_in;
wire local_bb1_vectorpop3_extract8_valid_out;
wire local_bb1_vectorpop3_extract8_stall_in;
wire local_bb1_scalarizer_0trunc5149_valid_out_1;
wire local_bb1_scalarizer_0trunc5149_stall_in_1;
wire local_bb1_scalarizer_1trunc5150_valid_out_1;
wire local_bb1_scalarizer_1trunc5150_stall_in_1;
wire local_bb1_scalarizer_2trunc5151_valid_out_1;
wire local_bb1_scalarizer_2trunc5151_stall_in_1;
wire local_bb1_scalarizer_3trunc5152_valid_out_1;
wire local_bb1_scalarizer_3trunc5152_stall_in_1;
wire local_bb1_conv9_reassembled5148_valid_out;
wire local_bb1_conv9_reassembled5148_stall_in;
wire local_bb1__5215_inputs_ready;
wire local_bb1__5215_stall_local;
wire [7:0] local_bb1__5215;

assign local_bb1__5215_inputs_ready = (local_bb1_c1_ene1_valid_out_0_NO_SHIFT_REG & local_bb1_c1_ene1_valid_out_1_NO_SHIFT_REG & SFC_2_VALID_14_15_0_valid_out_1_NO_SHIFT_REG & SFC_2_VALID_14_15_0_valid_out_2_NO_SHIFT_REG & local_bb1_c1_ene1_valid_out_3_NO_SHIFT_REG & SFC_2_VALID_14_15_0_valid_out_4_NO_SHIFT_REG & rnode_14to15_bb1__0_0_valid_out_NO_SHIFT_REG & rnode_14to15_bb1__1_0_valid_out_NO_SHIFT_REG & rnode_14to15_bb1__2_0_valid_out_NO_SHIFT_REG & rnode_14to15_bb1__3_0_valid_out_NO_SHIFT_REG & local_bb1_c1_ene1_valid_out_2_NO_SHIFT_REG);
assign local_bb1__5215 = (local_bb1_errorBuffer_5_0_coalesced_head_bitcast_3 + local_bb1_scalarizer_3add5172);
assign local_bb1_cmp38_valid_out = 1'b1;
assign local_bb1_cmp43_valid_out = 1'b1;
assign local_bb1_cmp48_valid_out = 1'b1;
assign local_bb1_cmp53_valid_out = 1'b1;
assign local_bb1_vectorpush26_insert1_valid_out = 1'b1;
assign local_bb1__5212_valid_out = 1'b1;
assign local_bb1__5213_valid_out = 1'b1;
assign local_bb1__5214_valid_out = 1'b1;
assign local_bb1__5215_valid_out = 1'b1;
assign local_bb1_vectorpop3_extract4_valid_out = 1'b1;
assign local_bb1_vectorpop3_extract5_valid_out = 1'b1;
assign local_bb1_vectorpop3_extract6_valid_out = 1'b1;
assign local_bb1_vectorpop3_extract7_valid_out = 1'b1;
assign local_bb1_vectorpop3_extract8_valid_out = 1'b1;
assign local_bb1_scalarizer_0trunc5149_valid_out_1 = 1'b1;
assign local_bb1_scalarizer_1trunc5150_valid_out_1 = 1'b1;
assign local_bb1_scalarizer_2trunc5151_valid_out_1 = 1'b1;
assign local_bb1_scalarizer_3trunc5152_valid_out_1 = 1'b1;
assign local_bb1_conv9_reassembled5148_valid_out = 1'b1;
assign local_bb1_c1_ene1_stall_in_0 = 1'b0;
assign local_bb1_c1_ene1_stall_in_1 = 1'b0;
assign SFC_2_VALID_14_15_0_stall_in_1 = 1'b0;
assign SFC_2_VALID_14_15_0_stall_in_2 = 1'b0;
assign local_bb1_c1_ene1_stall_in_3 = 1'b0;
assign SFC_2_VALID_14_15_0_stall_in_4 = 1'b0;
assign rnode_14to15_bb1__0_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb1__1_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb1__2_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb1__3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign local_bb1_c1_ene1_stall_in_2 = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_cmp38_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_stall_in_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_valid_out_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_stall_in_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp38_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_cmp38_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_cmp38_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_cmp38_0_stall_in_0_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_cmp38_0_valid_out_0_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_cmp38_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_cmp38),
	.data_out(rnode_15to16_bb1_cmp38_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_cmp38_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_cmp38_0_reg_16_fifo.DATA_WIDTH = 1;
defparam rnode_15to16_bb1_cmp38_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_cmp38_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_cmp38_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp38_stall_in = 1'b0;
assign rnode_15to16_bb1_cmp38_0_stall_in_0_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp38_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp38_0_NO_SHIFT_REG = rnode_15to16_bb1_cmp38_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_cmp38_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp38_1_NO_SHIFT_REG = rnode_15to16_bb1_cmp38_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_cmp38_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp38_2_NO_SHIFT_REG = rnode_15to16_bb1_cmp38_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_cmp38_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp38_3_NO_SHIFT_REG = rnode_15to16_bb1_cmp38_0_reg_16_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_cmp43_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_stall_in_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_valid_out_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_stall_in_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp43_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_cmp43_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_cmp43_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_cmp43_0_stall_in_0_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_cmp43_0_valid_out_0_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_cmp43_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_cmp43),
	.data_out(rnode_15to16_bb1_cmp43_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_cmp43_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_cmp43_0_reg_16_fifo.DATA_WIDTH = 1;
defparam rnode_15to16_bb1_cmp43_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_cmp43_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_cmp43_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp43_stall_in = 1'b0;
assign rnode_15to16_bb1_cmp43_0_stall_in_0_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp43_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp43_0_NO_SHIFT_REG = rnode_15to16_bb1_cmp43_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_cmp43_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp43_1_NO_SHIFT_REG = rnode_15to16_bb1_cmp43_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_cmp43_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp43_2_NO_SHIFT_REG = rnode_15to16_bb1_cmp43_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_cmp43_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp43_3_NO_SHIFT_REG = rnode_15to16_bb1_cmp43_0_reg_16_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_cmp48_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_stall_in_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_valid_out_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_stall_in_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp48_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_cmp48_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_cmp48_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_cmp48_0_stall_in_0_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_cmp48_0_valid_out_0_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_cmp48_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_cmp48),
	.data_out(rnode_15to16_bb1_cmp48_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_cmp48_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_cmp48_0_reg_16_fifo.DATA_WIDTH = 1;
defparam rnode_15to16_bb1_cmp48_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_cmp48_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_cmp48_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp48_stall_in = 1'b0;
assign rnode_15to16_bb1_cmp48_0_stall_in_0_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp48_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp48_0_NO_SHIFT_REG = rnode_15to16_bb1_cmp48_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_cmp48_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp48_1_NO_SHIFT_REG = rnode_15to16_bb1_cmp48_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_cmp48_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp48_2_NO_SHIFT_REG = rnode_15to16_bb1_cmp48_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_cmp48_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp48_3_NO_SHIFT_REG = rnode_15to16_bb1_cmp48_0_reg_16_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_cmp53_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_stall_in_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_valid_out_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_stall_in_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_cmp53_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_cmp53_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_cmp53_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_cmp53_0_stall_in_0_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_cmp53_0_valid_out_0_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_cmp53_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_cmp53),
	.data_out(rnode_15to16_bb1_cmp53_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_cmp53_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_cmp53_0_reg_16_fifo.DATA_WIDTH = 1;
defparam rnode_15to16_bb1_cmp53_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_cmp53_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_cmp53_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp53_stall_in = 1'b0;
assign rnode_15to16_bb1_cmp53_0_stall_in_0_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp53_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp53_0_NO_SHIFT_REG = rnode_15to16_bb1_cmp53_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_cmp53_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp53_1_NO_SHIFT_REG = rnode_15to16_bb1_cmp53_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_cmp53_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp53_2_NO_SHIFT_REG = rnode_15to16_bb1_cmp53_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_cmp53_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_cmp53_3_NO_SHIFT_REG = rnode_15to16_bb1_cmp53_0_reg_16_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire local_bb1_vectorpush26_vectorpush26_insert1_inputs_ready;
wire local_bb1_vectorpush26_vectorpush26_insert1_output_regs_ready;
wire [47:0] local_bb1_vectorpush26_vectorpush26_insert1_result;
wire local_bb1_vectorpush26_vectorpush26_insert1_fu_valid_out;
wire local_bb1_vectorpush26_vectorpush26_insert1_fu_stall_out;
 reg [47:0] local_bb1_vectorpush26_vectorpush26_insert1_NO_SHIFT_REG;
wire local_bb1_vectorpush26_vectorpush26_insert1_causedstall;

acl_push local_bb1_vectorpush26_vectorpush26_insert1_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(local_bb1_c1_ene2_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpush26_insert1),
	.stall_out(local_bb1_vectorpush26_vectorpush26_insert1_fu_stall_out),
	.valid_in(SFC_2_VALID_14_15_0_NO_SHIFT_REG),
	.valid_out(local_bb1_vectorpush26_vectorpush26_insert1_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_vectorpush26_vectorpush26_insert1_result),
	.feedback_out(feedback_data_out_26),
	.feedback_valid_out(feedback_valid_out_26),
	.feedback_stall_in(feedback_stall_in_26)
);

defparam local_bb1_vectorpush26_vectorpush26_insert1_feedback.STALLFREE = 1;
defparam local_bb1_vectorpush26_vectorpush26_insert1_feedback.ENABLED = 0;
defparam local_bb1_vectorpush26_vectorpush26_insert1_feedback.DATA_WIDTH = 48;
defparam local_bb1_vectorpush26_vectorpush26_insert1_feedback.FIFO_DEPTH = 1;
defparam local_bb1_vectorpush26_vectorpush26_insert1_feedback.MIN_FIFO_LATENCY = 1;
defparam local_bb1_vectorpush26_vectorpush26_insert1_feedback.STYLE = "REGULAR";
defparam local_bb1_vectorpush26_vectorpush26_insert1_feedback.RAM_FIFO_DEPTH_INC = 1;

assign local_bb1_vectorpush26_vectorpush26_insert1_inputs_ready = 1'b1;
assign local_bb1_vectorpush26_vectorpush26_insert1_output_regs_ready = 1'b1;
assign local_bb1_vectorpush26_insert1_stall_in = 1'b0;
assign local_bb1_c1_ene2_stall_in_0 = 1'b0;
assign SFC_2_VALID_14_15_0_stall_in_3 = 1'b0;
assign local_bb1_vectorpush26_vectorpush26_insert1_causedstall = (SFC_2_VALID_14_15_0_NO_SHIFT_REG && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_vectorpush26_vectorpush26_insert1_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_vectorpush26_vectorpush26_insert1_output_regs_ready)
		begin
			local_bb1_vectorpush26_vectorpush26_insert1_NO_SHIFT_REG <= local_bb1_vectorpush26_vectorpush26_insert1_result;
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1__5212_0_valid_out_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5212_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1__5212_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5212_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1__5212_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5212_0_valid_out_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5212_0_stall_in_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5212_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1__5212_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1__5212_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1__5212_0_stall_in_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1__5212_0_valid_out_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1__5212_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1__5212),
	.data_out(rnode_15to16_bb1__5212_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1__5212_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1__5212_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1__5212_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1__5212_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1__5212_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__5212_stall_in = 1'b0;
assign rnode_15to16_bb1__5212_0_NO_SHIFT_REG = rnode_15to16_bb1__5212_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1__5212_0_stall_in_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1__5212_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1__5213_0_valid_out_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5213_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1__5213_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5213_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1__5213_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5213_0_valid_out_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5213_0_stall_in_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5213_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1__5213_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1__5213_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1__5213_0_stall_in_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1__5213_0_valid_out_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1__5213_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1__5213),
	.data_out(rnode_15to16_bb1__5213_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1__5213_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1__5213_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1__5213_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1__5213_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1__5213_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__5213_stall_in = 1'b0;
assign rnode_15to16_bb1__5213_0_NO_SHIFT_REG = rnode_15to16_bb1__5213_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1__5213_0_stall_in_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1__5213_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1__5214_0_valid_out_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5214_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1__5214_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5214_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1__5214_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5214_0_valid_out_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5214_0_stall_in_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5214_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1__5214_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1__5214_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1__5214_0_stall_in_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1__5214_0_valid_out_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1__5214_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1__5214),
	.data_out(rnode_15to16_bb1__5214_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1__5214_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1__5214_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1__5214_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1__5214_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1__5214_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__5214_stall_in = 1'b0;
assign rnode_15to16_bb1__5214_0_NO_SHIFT_REG = rnode_15to16_bb1__5214_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1__5214_0_stall_in_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1__5214_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1__5215_0_valid_out_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5215_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1__5215_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5215_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1__5215_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5215_0_valid_out_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5215_0_stall_in_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1__5215_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1__5215_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1__5215_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1__5215_0_stall_in_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1__5215_0_valid_out_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1__5215_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1__5215),
	.data_out(rnode_15to16_bb1__5215_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1__5215_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1__5215_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1__5215_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1__5215_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1__5215_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__5215_stall_in = 1'b0;
assign rnode_15to16_bb1__5215_0_NO_SHIFT_REG = rnode_15to16_bb1__5215_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1__5215_0_stall_in_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1__5215_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_vectorpop3_extract4_0_valid_out_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract4_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_vectorpop3_extract4_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract4_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_vectorpop3_extract4_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract4_0_valid_out_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract4_0_stall_in_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract4_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_vectorpop3_extract4_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_vectorpop3_extract4_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_vectorpop3_extract4_0_stall_in_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_vectorpop3_extract4_0_valid_out_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_vectorpop3_extract4_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_vectorpop3_extract4),
	.data_out(rnode_15to16_bb1_vectorpop3_extract4_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_vectorpop3_extract4_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_vectorpop3_extract4_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1_vectorpop3_extract4_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_vectorpop3_extract4_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_vectorpop3_extract4_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_vectorpop3_extract4_stall_in = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract4_0_NO_SHIFT_REG = rnode_15to16_bb1_vectorpop3_extract4_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_vectorpop3_extract4_0_stall_in_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract4_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_vectorpop3_extract5_0_valid_out_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract5_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_vectorpop3_extract5_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract5_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_vectorpop3_extract5_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract5_0_valid_out_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract5_0_stall_in_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract5_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_vectorpop3_extract5_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_vectorpop3_extract5_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_vectorpop3_extract5_0_stall_in_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_vectorpop3_extract5_0_valid_out_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_vectorpop3_extract5_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_vectorpop3_extract5),
	.data_out(rnode_15to16_bb1_vectorpop3_extract5_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_vectorpop3_extract5_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_vectorpop3_extract5_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1_vectorpop3_extract5_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_vectorpop3_extract5_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_vectorpop3_extract5_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_vectorpop3_extract5_stall_in = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract5_0_NO_SHIFT_REG = rnode_15to16_bb1_vectorpop3_extract5_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_vectorpop3_extract5_0_stall_in_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract5_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_vectorpop3_extract6_0_valid_out_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract6_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_vectorpop3_extract6_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract6_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_vectorpop3_extract6_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract6_0_valid_out_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract6_0_stall_in_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract6_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_vectorpop3_extract6_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_vectorpop3_extract6_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_vectorpop3_extract6_0_stall_in_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_vectorpop3_extract6_0_valid_out_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_vectorpop3_extract6_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_vectorpop3_extract6),
	.data_out(rnode_15to16_bb1_vectorpop3_extract6_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_vectorpop3_extract6_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_vectorpop3_extract6_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1_vectorpop3_extract6_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_vectorpop3_extract6_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_vectorpop3_extract6_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_vectorpop3_extract6_stall_in = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract6_0_NO_SHIFT_REG = rnode_15to16_bb1_vectorpop3_extract6_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_vectorpop3_extract6_0_stall_in_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract6_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_vectorpop3_extract7_0_valid_out_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract7_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_vectorpop3_extract7_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract7_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_vectorpop3_extract7_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract7_0_valid_out_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract7_0_stall_in_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract7_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_vectorpop3_extract7_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_vectorpop3_extract7_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_vectorpop3_extract7_0_stall_in_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_vectorpop3_extract7_0_valid_out_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_vectorpop3_extract7_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_vectorpop3_extract7),
	.data_out(rnode_15to16_bb1_vectorpop3_extract7_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_vectorpop3_extract7_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_vectorpop3_extract7_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1_vectorpop3_extract7_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_vectorpop3_extract7_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_vectorpop3_extract7_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_vectorpop3_extract7_stall_in = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract7_0_NO_SHIFT_REG = rnode_15to16_bb1_vectorpop3_extract7_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_vectorpop3_extract7_0_stall_in_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract7_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_vectorpop3_extract8_0_valid_out_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract8_0_stall_in_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_vectorpop3_extract8_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract8_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_vectorpop3_extract8_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract8_0_valid_out_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract8_0_stall_in_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_vectorpop3_extract8_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_vectorpop3_extract8_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_vectorpop3_extract8_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_vectorpop3_extract8_0_stall_in_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_vectorpop3_extract8_0_valid_out_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_vectorpop3_extract8_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_vectorpop3_extract8),
	.data_out(rnode_15to16_bb1_vectorpop3_extract8_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_vectorpop3_extract8_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_vectorpop3_extract8_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1_vectorpop3_extract8_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_vectorpop3_extract8_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_vectorpop3_extract8_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_vectorpop3_extract8_stall_in = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract8_0_NO_SHIFT_REG = rnode_15to16_bb1_vectorpop3_extract8_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_vectorpop3_extract8_0_stall_in_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract8_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_in_0_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_0trunc5149_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_in_1_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_0trunc5149_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_in_2_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_0trunc5149_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_in_3_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_0trunc5149_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_in_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_in_0_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_0_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_scalarizer_0trunc5149),
	.data_out(rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_scalarizer_0trunc5149_stall_in_1 = 1'b0;
assign rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_in_0_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_0trunc5149_0_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_0trunc5149_1_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_0trunc5149_2_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_0trunc5149_3_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_0trunc5149_0_reg_16_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_in_0_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_1trunc5150_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_in_1_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_1trunc5150_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_in_2_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_1trunc5150_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_in_3_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_1trunc5150_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_in_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_in_0_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_0_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_scalarizer_1trunc5150),
	.data_out(rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_scalarizer_1trunc5150_stall_in_1 = 1'b0;
assign rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_in_0_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_1trunc5150_0_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_1trunc5150_1_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_1trunc5150_2_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_1trunc5150_3_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_1trunc5150_0_reg_16_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_in_0_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_2trunc5151_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_in_1_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_2trunc5151_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_in_2_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_2trunc5151_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_in_3_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_2trunc5151_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_in_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_in_0_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_0_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_scalarizer_2trunc5151),
	.data_out(rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_scalarizer_2trunc5151_stall_in_1 = 1'b0;
assign rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_in_0_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_2trunc5151_0_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_2trunc5151_1_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_2trunc5151_2_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_2trunc5151_3_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_2trunc5151_0_reg_16_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_in_0_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_3trunc5152_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_in_1_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_3trunc5152_1_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_in_2_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_3trunc5152_2_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_in_3_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_3trunc5152_3_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [7:0] rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_in_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_in_0_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_0_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_scalarizer_3trunc5152),
	.data_out(rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_fifo.DATA_WIDTH = 8;
defparam rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_scalarizer_3trunc5152_stall_in_1 = 1'b0;
assign rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_in_0_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_3trunc5152_0_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_3trunc5152_1_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_3trunc5152_2_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb1_scalarizer_3trunc5152_3_NO_SHIFT_REG = rnode_15to16_bb1_scalarizer_3trunc5152_0_reg_16_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb1_conv9_reassembled5148_0_valid_out_NO_SHIFT_REG;
 logic rnode_15to16_bb1_conv9_reassembled5148_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_15to16_bb1_conv9_reassembled5148_0_NO_SHIFT_REG;
 logic rnode_15to16_bb1_conv9_reassembled5148_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_15to16_bb1_conv9_reassembled5148_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_conv9_reassembled5148_0_valid_out_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_conv9_reassembled5148_0_stall_in_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb1_conv9_reassembled5148_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb1_conv9_reassembled5148_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb1_conv9_reassembled5148_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb1_conv9_reassembled5148_0_stall_in_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb1_conv9_reassembled5148_0_valid_out_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb1_conv9_reassembled5148_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb1_conv9_reassembled5148),
	.data_out(rnode_15to16_bb1_conv9_reassembled5148_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb1_conv9_reassembled5148_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb1_conv9_reassembled5148_0_reg_16_fifo.DATA_WIDTH = 32;
defparam rnode_15to16_bb1_conv9_reassembled5148_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb1_conv9_reassembled5148_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb1_conv9_reassembled5148_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_conv9_reassembled5148_stall_in = 1'b0;
assign rnode_15to16_bb1_conv9_reassembled5148_0_NO_SHIFT_REG = rnode_15to16_bb1_conv9_reassembled5148_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb1_conv9_reassembled5148_0_stall_in_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_conv9_reassembled5148_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush3_insert0_stall_local;
wire [71:0] local_bb1_vectorpush3_insert0;

assign local_bb1_vectorpush3_insert0[7:0] = rnode_15to16_bb1__5212_0_NO_SHIFT_REG;
assign local_bb1_vectorpush3_insert0[71:8] = 64'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0ashr_stall_local;
wire [7:0] local_bb1_scalarizer_0ashr;

assign local_bb1_scalarizer_0ashr = ($signed(rnode_15to16_bb1_scalarizer_0trunc5149_0_NO_SHIFT_REG) >>> 8'h2);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0ashr5153_stall_local;
wire [7:0] local_bb1_scalarizer_0ashr5153;

assign local_bb1_scalarizer_0ashr5153 = ($signed(rnode_15to16_bb1_scalarizer_0trunc5149_1_NO_SHIFT_REG) >>> 8'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0ashr5157_stall_local;
wire [7:0] local_bb1_scalarizer_0ashr5157;

assign local_bb1_scalarizer_0ashr5157 = ($signed(rnode_15to16_bb1_scalarizer_0trunc5149_2_NO_SHIFT_REG) >>> 8'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0ashr5161_stall_local;
wire [7:0] local_bb1_scalarizer_0ashr5161;

assign local_bb1_scalarizer_0ashr5161 = ($signed(rnode_15to16_bb1_scalarizer_0trunc5149_3_NO_SHIFT_REG) >>> 8'h5);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1ashr_stall_local;
wire [7:0] local_bb1_scalarizer_1ashr;

assign local_bb1_scalarizer_1ashr = ($signed(rnode_15to16_bb1_scalarizer_1trunc5150_0_NO_SHIFT_REG) >>> 8'h2);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1ashr5154_stall_local;
wire [7:0] local_bb1_scalarizer_1ashr5154;

assign local_bb1_scalarizer_1ashr5154 = ($signed(rnode_15to16_bb1_scalarizer_1trunc5150_1_NO_SHIFT_REG) >>> 8'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1ashr5158_stall_local;
wire [7:0] local_bb1_scalarizer_1ashr5158;

assign local_bb1_scalarizer_1ashr5158 = ($signed(rnode_15to16_bb1_scalarizer_1trunc5150_2_NO_SHIFT_REG) >>> 8'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1ashr5162_stall_local;
wire [7:0] local_bb1_scalarizer_1ashr5162;

assign local_bb1_scalarizer_1ashr5162 = ($signed(rnode_15to16_bb1_scalarizer_1trunc5150_3_NO_SHIFT_REG) >>> 8'h5);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2ashr_stall_local;
wire [7:0] local_bb1_scalarizer_2ashr;

assign local_bb1_scalarizer_2ashr = ($signed(rnode_15to16_bb1_scalarizer_2trunc5151_0_NO_SHIFT_REG) >>> 8'h2);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2ashr5155_stall_local;
wire [7:0] local_bb1_scalarizer_2ashr5155;

assign local_bb1_scalarizer_2ashr5155 = ($signed(rnode_15to16_bb1_scalarizer_2trunc5151_1_NO_SHIFT_REG) >>> 8'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2ashr5159_stall_local;
wire [7:0] local_bb1_scalarizer_2ashr5159;

assign local_bb1_scalarizer_2ashr5159 = ($signed(rnode_15to16_bb1_scalarizer_2trunc5151_2_NO_SHIFT_REG) >>> 8'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2ashr5163_stall_local;
wire [7:0] local_bb1_scalarizer_2ashr5163;

assign local_bb1_scalarizer_2ashr5163 = ($signed(rnode_15to16_bb1_scalarizer_2trunc5151_3_NO_SHIFT_REG) >>> 8'h5);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3ashr_stall_local;
wire [7:0] local_bb1_scalarizer_3ashr;

assign local_bb1_scalarizer_3ashr = ($signed(rnode_15to16_bb1_scalarizer_3trunc5152_0_NO_SHIFT_REG) >>> 8'h2);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3ashr5156_stall_local;
wire [7:0] local_bb1_scalarizer_3ashr5156;

assign local_bb1_scalarizer_3ashr5156 = ($signed(rnode_15to16_bb1_scalarizer_3trunc5152_1_NO_SHIFT_REG) >>> 8'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3ashr5160_stall_local;
wire [7:0] local_bb1_scalarizer_3ashr5160;

assign local_bb1_scalarizer_3ashr5160 = ($signed(rnode_15to16_bb1_scalarizer_3trunc5152_2_NO_SHIFT_REG) >>> 8'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3ashr5164_stall_local;
wire [7:0] local_bb1_scalarizer_3ashr5164;

assign local_bb1_scalarizer_3ashr5164 = ($signed(rnode_15to16_bb1_scalarizer_3trunc5152_3_NO_SHIFT_REG) >>> 8'h5);

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exi1_valid_out;
wire local_bb1_c1_exi1_stall_in;
wire local_bb1_c1_exi1_inputs_ready;
wire local_bb1_c1_exi1_stall_local;
wire [63:0] local_bb1_c1_exi1;

assign local_bb1_c1_exi1_inputs_ready = rnode_15to16_bb1_conv9_reassembled5148_0_valid_out_NO_SHIFT_REG;
assign local_bb1_c1_exi1[31:0] = 32'bx;
assign local_bb1_c1_exi1[63:32] = rnode_15to16_bb1_conv9_reassembled5148_0_NO_SHIFT_REG;
assign local_bb1_c1_exi1_valid_out = 1'b1;
assign rnode_15to16_bb1_conv9_reassembled5148_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush3_insert1_stall_local;
wire [71:0] local_bb1_vectorpush3_insert1;

assign local_bb1_vectorpush3_insert1[7:0] = local_bb1_vectorpush3_insert0[7:0];
assign local_bb1_vectorpush3_insert1[15:8] = rnode_15to16_bb1__5213_0_NO_SHIFT_REG;
assign local_bb1_vectorpush3_insert1[71:16] = local_bb1_vectorpush3_insert0[71:16];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0add5177_stall_local;
wire [7:0] local_bb1_scalarizer_0add5177;

assign local_bb1_scalarizer_0add5177 = (rnode_15to16_bb1_cmp38_0_NO_SHIFT_REG ? 8'h0 : local_bb1_scalarizer_0ashr5153);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0add5181_stall_local;
wire [7:0] local_bb1_scalarizer_0add5181;

assign local_bb1_scalarizer_0add5181 = (rnode_15to16_bb1_cmp43_0_NO_SHIFT_REG ? local_bb1_scalarizer_0ashr5157 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0add5189_stall_local;
wire [7:0] local_bb1_scalarizer_0add5189;

assign local_bb1_scalarizer_0add5189 = (rnode_15to16_bb1_cmp48_0_NO_SHIFT_REG ? local_bb1_scalarizer_0ashr5161 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0add5197_stall_local;
wire [7:0] local_bb1_scalarizer_0add5197;

assign local_bb1_scalarizer_0add5197 = (rnode_15to16_bb1_cmp53_0_NO_SHIFT_REG ? local_bb1_scalarizer_0ashr5161 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert0_stall_local;
wire [87:0] local_bb1_vectorpush8_insert0;

assign local_bb1_vectorpush8_insert0[7:0] = local_bb1_scalarizer_1ashr;
assign local_bb1_vectorpush8_insert0[87:8] = 80'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1add5178_stall_local;
wire [7:0] local_bb1_scalarizer_1add5178;

assign local_bb1_scalarizer_1add5178 = (rnode_15to16_bb1_cmp38_1_NO_SHIFT_REG ? 8'h0 : local_bb1_scalarizer_1ashr5154);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1add5182_stall_local;
wire [7:0] local_bb1_scalarizer_1add5182;

assign local_bb1_scalarizer_1add5182 = (rnode_15to16_bb1_cmp43_1_NO_SHIFT_REG ? local_bb1_scalarizer_1ashr5158 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1add5190_stall_local;
wire [7:0] local_bb1_scalarizer_1add5190;

assign local_bb1_scalarizer_1add5190 = (rnode_15to16_bb1_cmp48_1_NO_SHIFT_REG ? local_bb1_scalarizer_1ashr5162 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1add5198_stall_local;
wire [7:0] local_bb1_scalarizer_1add5198;

assign local_bb1_scalarizer_1add5198 = (rnode_15to16_bb1_cmp53_1_NO_SHIFT_REG ? local_bb1_scalarizer_1ashr5162 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2add5179_stall_local;
wire [7:0] local_bb1_scalarizer_2add5179;

assign local_bb1_scalarizer_2add5179 = (rnode_15to16_bb1_cmp38_2_NO_SHIFT_REG ? 8'h0 : local_bb1_scalarizer_2ashr5155);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2add5183_stall_local;
wire [7:0] local_bb1_scalarizer_2add5183;

assign local_bb1_scalarizer_2add5183 = (rnode_15to16_bb1_cmp43_2_NO_SHIFT_REG ? local_bb1_scalarizer_2ashr5159 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2add5191_stall_local;
wire [7:0] local_bb1_scalarizer_2add5191;

assign local_bb1_scalarizer_2add5191 = (rnode_15to16_bb1_cmp48_2_NO_SHIFT_REG ? local_bb1_scalarizer_2ashr5163 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2add5199_stall_local;
wire [7:0] local_bb1_scalarizer_2add5199;

assign local_bb1_scalarizer_2add5199 = (rnode_15to16_bb1_cmp53_2_NO_SHIFT_REG ? local_bb1_scalarizer_2ashr5163 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3add5180_stall_local;
wire [7:0] local_bb1_scalarizer_3add5180;

assign local_bb1_scalarizer_3add5180 = (rnode_15to16_bb1_cmp38_3_NO_SHIFT_REG ? 8'h0 : local_bb1_scalarizer_3ashr5156);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3add5184_stall_local;
wire [7:0] local_bb1_scalarizer_3add5184;

assign local_bb1_scalarizer_3add5184 = (rnode_15to16_bb1_cmp43_3_NO_SHIFT_REG ? local_bb1_scalarizer_3ashr5160 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3add5192_stall_local;
wire [7:0] local_bb1_scalarizer_3add5192;

assign local_bb1_scalarizer_3add5192 = (rnode_15to16_bb1_cmp48_3_NO_SHIFT_REG ? local_bb1_scalarizer_3ashr5164 : 8'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3add5200_stall_local;
wire [7:0] local_bb1_scalarizer_3add5200;

assign local_bb1_scalarizer_3add5200 = (rnode_15to16_bb1_cmp53_3_NO_SHIFT_REG ? local_bb1_scalarizer_3ashr5164 : 8'h0);

// This section implements a registered operation.
// 
wire local_bb1_c1_exit_c1_exi1_inputs_ready;
 reg local_bb1_c1_exit_c1_exi1_valid_out_NO_SHIFT_REG;
wire local_bb1_c1_exit_c1_exi1_stall_in;
 reg [63:0] local_bb1_c1_exit_c1_exi1_NO_SHIFT_REG;
wire [63:0] local_bb1_c1_exit_c1_exi1_in;
wire local_bb1_c1_exit_c1_exi1_valid;
wire local_bb1_c1_exit_c1_exi1_causedstall;

acl_stall_free_sink local_bb1_c1_exit_c1_exi1_instance (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb1_c1_exi1),
	.data_out(local_bb1_c1_exit_c1_exi1_in),
	.input_accepted(local_bb1_c1_enter_c1_eni3_input_accepted),
	.valid_out(local_bb1_c1_exit_c1_exi1_valid),
	.stall_in(~(local_bb1_c1_exit_c1_exi1_output_regs_ready)),
	.stall_entry(local_bb1_c1_exit_c1_exi1_entry_stall),
	.valid_in(local_bb1_c1_exit_c1_exi1_valid_in),
	.IIphases(local_bb1_c1_exit_c1_exi1_phases),
	.inc_pipelined_thread(local_bb1_c1_enter_c1_eni3_inc_pipelined_thread),
	.dec_pipelined_thread(local_bb1_c1_enter_c1_eni3_dec_pipelined_thread)
);

defparam local_bb1_c1_exit_c1_exi1_instance.DATA_WIDTH = 64;
defparam local_bb1_c1_exit_c1_exi1_instance.PIPELINE_DEPTH = 8;
defparam local_bb1_c1_exit_c1_exi1_instance.SHARINGII = 1;
defparam local_bb1_c1_exit_c1_exi1_instance.SCHEDULEII = 1;
defparam local_bb1_c1_exit_c1_exi1_instance.ALWAYS_THROTTLE = 0;

assign local_bb1_c1_exit_c1_exi1_inputs_ready = 1'b1;
assign local_bb1_c1_exit_c1_exi1_output_regs_ready = (&(~(local_bb1_c1_exit_c1_exi1_valid_out_NO_SHIFT_REG) | ~(local_bb1_c1_exit_c1_exi1_stall_in)));
assign local_bb1_c1_exit_c1_exi1_valid_in = SFC_2_VALID_15_16_0_NO_SHIFT_REG;
assign local_bb1_c1_exi1_stall_in = 1'b0;
assign SFC_2_VALID_15_16_0_stall_in_0 = 1'b0;
assign local_bb1_c1_exit_c1_exi1_causedstall = (1'b1 && (1'b0 && !(~(local_bb1_c1_exit_c1_exi1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c1_exit_c1_exi1_NO_SHIFT_REG <= 'x;
		local_bb1_c1_exit_c1_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c1_exit_c1_exi1_output_regs_ready)
		begin
			local_bb1_c1_exit_c1_exi1_NO_SHIFT_REG <= local_bb1_c1_exit_c1_exi1_in;
			local_bb1_c1_exit_c1_exi1_valid_out_NO_SHIFT_REG <= local_bb1_c1_exit_c1_exi1_valid;
		end
		else
		begin
			if (~(local_bb1_c1_exit_c1_exi1_stall_in))
			begin
				local_bb1_c1_exit_c1_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush3_insert2_stall_local;
wire [71:0] local_bb1_vectorpush3_insert2;

assign local_bb1_vectorpush3_insert2[15:0] = local_bb1_vectorpush3_insert1[15:0];
assign local_bb1_vectorpush3_insert2[23:16] = rnode_15to16_bb1__5214_0_NO_SHIFT_REG;
assign local_bb1_vectorpush3_insert2[71:24] = local_bb1_vectorpush3_insert1[71:24];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0select_stall_local;
wire [7:0] local_bb1_scalarizer_0select;

assign local_bb1_scalarizer_0select = (rnode_15to16_bb1_vectorpop3_extract4_0_NO_SHIFT_REG + local_bb1_scalarizer_0add5177);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0select5185_stall_local;
wire [7:0] local_bb1_scalarizer_0select5185;

assign local_bb1_scalarizer_0select5185 = (local_bb1_vectorpop8_extract3 + local_bb1_scalarizer_0add5181);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0select5193_stall_local;
wire [7:0] local_bb1_scalarizer_0select5193;

assign local_bb1_scalarizer_0select5193 = (local_bb1_vectorpop8_extract7 + local_bb1_scalarizer_0add5189);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_0select5201_stall_local;
wire [7:0] local_bb1_scalarizer_0select5201;

assign local_bb1_scalarizer_0select5201 = (rnode_15to16_bb1_vectorpop3_extract8_0_NO_SHIFT_REG + local_bb1_scalarizer_0add5197);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert1_stall_local;
wire [87:0] local_bb1_vectorpush8_insert1;

assign local_bb1_vectorpush8_insert1[7:0] = local_bb1_vectorpush8_insert0[7:0];
assign local_bb1_vectorpush8_insert1[15:8] = local_bb1_scalarizer_2ashr;
assign local_bb1_vectorpush8_insert1[87:16] = local_bb1_vectorpush8_insert0[87:16];

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1select_stall_local;
wire [7:0] local_bb1_scalarizer_1select;

assign local_bb1_scalarizer_1select = (local_bb1_vectorpop8_extract0 + local_bb1_scalarizer_1add5178);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1select5186_stall_local;
wire [7:0] local_bb1_scalarizer_1select5186;

assign local_bb1_scalarizer_1select5186 = (local_bb1_vectorpop8_extract4 + local_bb1_scalarizer_1add5182);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1select5194_stall_local;
wire [7:0] local_bb1_scalarizer_1select5194;

assign local_bb1_scalarizer_1select5194 = (rnode_15to16_bb1_vectorpop3_extract5_0_NO_SHIFT_REG + local_bb1_scalarizer_1add5190);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_1select5202_stall_local;
wire [7:0] local_bb1_scalarizer_1select5202;

assign local_bb1_scalarizer_1select5202 = (local_bb1_vectorpop8_extract8 + local_bb1_scalarizer_1add5198);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2select_stall_local;
wire [7:0] local_bb1_scalarizer_2select;

assign local_bb1_scalarizer_2select = (local_bb1_vectorpop8_extract1 + local_bb1_scalarizer_2add5179);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2select5187_stall_local;
wire [7:0] local_bb1_scalarizer_2select5187;

assign local_bb1_scalarizer_2select5187 = (local_bb1_vectorpop8_extract5 + local_bb1_scalarizer_2add5183);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2select5195_stall_local;
wire [7:0] local_bb1_scalarizer_2select5195;

assign local_bb1_scalarizer_2select5195 = (rnode_15to16_bb1_vectorpop3_extract6_0_NO_SHIFT_REG + local_bb1_scalarizer_2add5191);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_2select5203_stall_local;
wire [7:0] local_bb1_scalarizer_2select5203;

assign local_bb1_scalarizer_2select5203 = (local_bb1_vectorpop8_extract9 + local_bb1_scalarizer_2add5199);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3select_stall_local;
wire [7:0] local_bb1_scalarizer_3select;

assign local_bb1_scalarizer_3select = (local_bb1_vectorpop8_extract2 + local_bb1_scalarizer_3add5180);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3select5188_stall_local;
wire [7:0] local_bb1_scalarizer_3select5188;

assign local_bb1_scalarizer_3select5188 = (local_bb1_vectorpop8_extract6 + local_bb1_scalarizer_3add5184);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3select5196_stall_local;
wire [7:0] local_bb1_scalarizer_3select5196;

assign local_bb1_scalarizer_3select5196 = (rnode_15to16_bb1_vectorpop3_extract7_0_NO_SHIFT_REG + local_bb1_scalarizer_3add5192);

// This section implements an unregistered operation.
// 
wire local_bb1_scalarizer_3select5204_stall_local;
wire [7:0] local_bb1_scalarizer_3select5204;

assign local_bb1_scalarizer_3select5204 = (local_bb1_vectorpop8_extract10 + local_bb1_scalarizer_3add5200);

// This section implements an unregistered operation.
// 
wire local_bb1_c1_exe1_valid_out;
wire local_bb1_c1_exe1_stall_in;
wire local_bb1_c1_exe1_inputs_ready;
wire local_bb1_c1_exe1_stall_local;
wire [31:0] local_bb1_c1_exe1;

assign local_bb1_c1_exe1_inputs_ready = local_bb1_c1_exit_c1_exi1_valid_out_NO_SHIFT_REG;
assign local_bb1_c1_exe1[31:0] = local_bb1_c1_exit_c1_exi1_NO_SHIFT_REG[63:32];
assign local_bb1_c1_exe1_valid_out = local_bb1_c1_exe1_inputs_ready;
assign local_bb1_c1_exe1_stall_local = local_bb1_c1_exe1_stall_in;
assign local_bb1_c1_exit_c1_exi1_stall_in = (|local_bb1_c1_exe1_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush3_insert3_stall_local;
wire [71:0] local_bb1_vectorpush3_insert3;

assign local_bb1_vectorpush3_insert3[23:0] = local_bb1_vectorpush3_insert2[23:0];
assign local_bb1_vectorpush3_insert3[31:24] = rnode_15to16_bb1__5215_0_NO_SHIFT_REG;
assign local_bb1_vectorpush3_insert3[71:32] = local_bb1_vectorpush3_insert2[71:32];

// This section implements an unregistered operation.
// 
wire local_bb1__05205_stall_local;
wire [31:0] local_bb1__05205;

assign local_bb1__05205[7:0] = local_bb1_scalarizer_0select5201;
assign local_bb1__05205[15:8] = 8'bx;
assign local_bb1__05205[23:16] = 8'bx;
assign local_bb1__05205[31:24] = 8'bx;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert2_stall_local;
wire [87:0] local_bb1_vectorpush8_insert2;

assign local_bb1_vectorpush8_insert2[15:0] = local_bb1_vectorpush8_insert1[15:0];
assign local_bb1_vectorpush8_insert2[23:16] = local_bb1_scalarizer_3ashr;
assign local_bb1_vectorpush8_insert2[87:24] = local_bb1_vectorpush8_insert1[87:24];

// This section implements a registered operation.
// 
wire local_bb1_st_c1_exe1_inputs_ready;
 reg local_bb1_st_c1_exe1_valid_out_NO_SHIFT_REG;
wire local_bb1_st_c1_exe1_stall_in;
wire local_bb1_st_c1_exe1_output_regs_ready;
wire local_bb1_st_c1_exe1_fu_stall_out;
wire local_bb1_st_c1_exe1_fu_valid_out;
wire local_bb1_st_c1_exe1_causedstall;

lsu_top lsu_local_bb1_st_c1_exe1 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb1_st_c1_exe1_fu_stall_out),
	.i_valid(local_bb1_st_c1_exe1_inputs_ready),
	.i_address((rnode_20to21_bb1_c0_exe2_0_NO_SHIFT_REG & 64'hFFFFFFFFFFFFFFFC)),
	.i_writedata(local_bb1_c1_exe1),
	.i_cmpdata(),
	.i_predicate(rnode_20to21_bb1_c0_exe3_0_NO_SHIFT_REG),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_st_c1_exe1_output_regs_ready)),
	.o_valid(local_bb1_st_c1_exe1_fu_valid_out),
	.o_readdata(),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_st_c1_exe1_active),
	.avm_address(avm_local_bb1_st_c1_exe1_address),
	.avm_read(avm_local_bb1_st_c1_exe1_read),
	.avm_enable(avm_local_bb1_st_c1_exe1_enable),
	.avm_readdata(avm_local_bb1_st_c1_exe1_readdata),
	.avm_write(avm_local_bb1_st_c1_exe1_write),
	.avm_writeack(avm_local_bb1_st_c1_exe1_writeack),
	.avm_burstcount(avm_local_bb1_st_c1_exe1_burstcount),
	.avm_writedata(avm_local_bb1_st_c1_exe1_writedata),
	.avm_byteenable(avm_local_bb1_st_c1_exe1_byteenable),
	.avm_waitrequest(avm_local_bb1_st_c1_exe1_waitrequest),
	.avm_readdatavalid(avm_local_bb1_st_c1_exe1_readdatavalid),
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

defparam lsu_local_bb1_st_c1_exe1.AWIDTH = 30;
defparam lsu_local_bb1_st_c1_exe1.WIDTH_BYTES = 4;
defparam lsu_local_bb1_st_c1_exe1.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_st_c1_exe1.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_st_c1_exe1.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb1_st_c1_exe1.READ = 0;
defparam lsu_local_bb1_st_c1_exe1.ATOMIC = 0;
defparam lsu_local_bb1_st_c1_exe1.WIDTH = 32;
defparam lsu_local_bb1_st_c1_exe1.MWIDTH = 256;
defparam lsu_local_bb1_st_c1_exe1.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_st_c1_exe1.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_st_c1_exe1.KERNEL_SIDE_MEM_LATENCY = 4;
defparam lsu_local_bb1_st_c1_exe1.MEMORY_SIDE_MEM_LATENCY = 8;
defparam lsu_local_bb1_st_c1_exe1.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_st_c1_exe1.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_st_c1_exe1.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_st_c1_exe1.NUMBER_BANKS = 1;
defparam lsu_local_bb1_st_c1_exe1.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_st_c1_exe1.INTENDED_DEVICE_FAMILY = "Cyclone V";
defparam lsu_local_bb1_st_c1_exe1.USEINPUTFIFO = 0;
defparam lsu_local_bb1_st_c1_exe1.USECACHING = 0;
defparam lsu_local_bb1_st_c1_exe1.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_st_c1_exe1.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_st_c1_exe1.ADDRSPACE = 1;
defparam lsu_local_bb1_st_c1_exe1.STYLE = "BURST-COALESCED";
defparam lsu_local_bb1_st_c1_exe1.USE_BYTE_EN = 0;

assign local_bb1_st_c1_exe1_inputs_ready = (local_bb1_c1_exe1_valid_out & rnode_20to21_bb1_c0_exe2_0_valid_out_NO_SHIFT_REG & rnode_20to21_bb1_c0_exe3_0_valid_out_NO_SHIFT_REG);
assign local_bb1_st_c1_exe1_output_regs_ready = (&(~(local_bb1_st_c1_exe1_valid_out_NO_SHIFT_REG) | ~(local_bb1_st_c1_exe1_stall_in)));
assign local_bb1_c1_exe1_stall_in = (local_bb1_st_c1_exe1_fu_stall_out | ~(local_bb1_st_c1_exe1_inputs_ready));
assign rnode_20to21_bb1_c0_exe2_0_stall_in_NO_SHIFT_REG = (local_bb1_st_c1_exe1_fu_stall_out | ~(local_bb1_st_c1_exe1_inputs_ready));
assign rnode_20to21_bb1_c0_exe3_0_stall_in_NO_SHIFT_REG = (local_bb1_st_c1_exe1_fu_stall_out | ~(local_bb1_st_c1_exe1_inputs_ready));
assign local_bb1_st_c1_exe1_causedstall = (local_bb1_st_c1_exe1_inputs_ready && (local_bb1_st_c1_exe1_fu_stall_out && !(~(local_bb1_st_c1_exe1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_st_c1_exe1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_st_c1_exe1_output_regs_ready)
		begin
			local_bb1_st_c1_exe1_valid_out_NO_SHIFT_REG <= local_bb1_st_c1_exe1_fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_st_c1_exe1_stall_in))
			begin
				local_bb1_st_c1_exe1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush3_insert4_stall_local;
wire [71:0] local_bb1_vectorpush3_insert4;

assign local_bb1_vectorpush3_insert4[31:0] = local_bb1_vectorpush3_insert3[31:0];
assign local_bb1_vectorpush3_insert4[39:32] = local_bb1_scalarizer_0ashr;
assign local_bb1_vectorpush3_insert4[71:40] = local_bb1_vectorpush3_insert3[71:40];

// This section implements an unregistered operation.
// 
wire local_bb1__15206_stall_local;
wire [31:0] local_bb1__15206;

assign local_bb1__15206[7:0] = local_bb1__05205[7:0];
assign local_bb1__15206[15:8] = local_bb1_scalarizer_1select5202;
assign local_bb1__15206[23:16] = local_bb1__05205[23:16];
assign local_bb1__15206[31:24] = local_bb1__05205[31:24];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert3_stall_local;
wire [87:0] local_bb1_vectorpush8_insert3;

assign local_bb1_vectorpush8_insert3[23:0] = local_bb1_vectorpush8_insert2[23:0];
assign local_bb1_vectorpush8_insert3[31:24] = local_bb1_scalarizer_0select;
assign local_bb1_vectorpush8_insert3[87:32] = local_bb1_vectorpush8_insert2[87:32];

// This section implements a staging register.
// 
wire rstag_25to25_bb1_st_c1_exe1_valid_out;
wire rstag_25to25_bb1_st_c1_exe1_stall_in;
wire rstag_25to25_bb1_st_c1_exe1_inputs_ready;
wire rstag_25to25_bb1_st_c1_exe1_stall_local;
 reg rstag_25to25_bb1_st_c1_exe1_staging_valid_NO_SHIFT_REG;
wire rstag_25to25_bb1_st_c1_exe1_combined_valid;

assign rstag_25to25_bb1_st_c1_exe1_inputs_ready = local_bb1_st_c1_exe1_valid_out_NO_SHIFT_REG;
assign rstag_25to25_bb1_st_c1_exe1_combined_valid = (rstag_25to25_bb1_st_c1_exe1_staging_valid_NO_SHIFT_REG | rstag_25to25_bb1_st_c1_exe1_inputs_ready);
assign rstag_25to25_bb1_st_c1_exe1_valid_out = rstag_25to25_bb1_st_c1_exe1_combined_valid;
assign rstag_25to25_bb1_st_c1_exe1_stall_local = rstag_25to25_bb1_st_c1_exe1_stall_in;
assign local_bb1_st_c1_exe1_stall_in = (|rstag_25to25_bb1_st_c1_exe1_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_25to25_bb1_st_c1_exe1_staging_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (rstag_25to25_bb1_st_c1_exe1_stall_local)
		begin
			if (~(rstag_25to25_bb1_st_c1_exe1_staging_valid_NO_SHIFT_REG))
			begin
				rstag_25to25_bb1_st_c1_exe1_staging_valid_NO_SHIFT_REG <= rstag_25to25_bb1_st_c1_exe1_inputs_ready;
			end
		end
		else
		begin
			rstag_25to25_bb1_st_c1_exe1_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush3_insert5_stall_local;
wire [71:0] local_bb1_vectorpush3_insert5;

assign local_bb1_vectorpush3_insert5[39:0] = local_bb1_vectorpush3_insert4[39:0];
assign local_bb1_vectorpush3_insert5[47:40] = local_bb1_scalarizer_1select5186;
assign local_bb1_vectorpush3_insert5[71:48] = local_bb1_vectorpush3_insert4[71:48];

// This section implements an unregistered operation.
// 
wire local_bb1__25207_stall_local;
wire [31:0] local_bb1__25207;

assign local_bb1__25207[7:0] = local_bb1__15206[7:0];
assign local_bb1__25207[15:8] = local_bb1__15206[15:8];
assign local_bb1__25207[23:16] = local_bb1_scalarizer_2select5203;
assign local_bb1__25207[31:24] = local_bb1__15206[31:24];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert4_stall_local;
wire [87:0] local_bb1_vectorpush8_insert4;

assign local_bb1_vectorpush8_insert4[31:0] = local_bb1_vectorpush8_insert3[31:0];
assign local_bb1_vectorpush8_insert4[39:32] = local_bb1_scalarizer_1select;
assign local_bb1_vectorpush8_insert4[87:40] = local_bb1_vectorpush8_insert3[87:40];

// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
 reg branch_node_valid_out_0_NO_SHIFT_REG;
 reg branch_compare_result_NO_SHIFT_REG;
wire branch_var__output_regs_ready;
wire combined_branch_stall_in_signal;

assign branch_var__inputs_ready = (rnode_24to25_bb1_c0_exe4_0_valid_out_NO_SHIFT_REG & rstag_25to25_bb1_st_c1_exe1_valid_out);
assign branch_var__output_regs_ready = (~(branch_node_valid_out_0_NO_SHIFT_REG) | (((branch_compare_result_NO_SHIFT_REG != 1'b1) & ~(stall_in_1)) | (~((branch_compare_result_NO_SHIFT_REG != 1'b1)) & ~(stall_in_0))));
assign rnode_24to25_bb1_c0_exe4_0_stall_in_NO_SHIFT_REG = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rstag_25to25_bb1_st_c1_exe1_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
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
			branch_compare_result_NO_SHIFT_REG <= rnode_24to25_bb1_c0_exe4_0_NO_SHIFT_REG;
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


// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush3_insert6_stall_local;
wire [71:0] local_bb1_vectorpush3_insert6;

assign local_bb1_vectorpush3_insert6[47:0] = local_bb1_vectorpush3_insert5[47:0];
assign local_bb1_vectorpush3_insert6[55:48] = local_bb1_scalarizer_2select5187;
assign local_bb1_vectorpush3_insert6[71:56] = local_bb1_vectorpush3_insert5[71:56];

// This section implements an unregistered operation.
// 
wire local_bb1__35208_stall_local;
wire [31:0] local_bb1__35208;

assign local_bb1__35208[7:0] = local_bb1__25207[7:0];
assign local_bb1__35208[15:8] = local_bb1__25207[15:8];
assign local_bb1__35208[23:16] = local_bb1__25207[23:16];
assign local_bb1__35208[31:24] = local_bb1_scalarizer_3select5204;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert5_stall_local;
wire [87:0] local_bb1_vectorpush8_insert5;

assign local_bb1_vectorpush8_insert5[39:0] = local_bb1_vectorpush8_insert4[39:0];
assign local_bb1_vectorpush8_insert5[47:40] = local_bb1_scalarizer_2select;
assign local_bb1_vectorpush8_insert5[87:48] = local_bb1_vectorpush8_insert4[87:48];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush3_insert7_stall_local;
wire [71:0] local_bb1_vectorpush3_insert7;

assign local_bb1_vectorpush3_insert7[55:0] = local_bb1_vectorpush3_insert6[55:0];
assign local_bb1_vectorpush3_insert7[63:56] = local_bb1_scalarizer_3select5188;
assign local_bb1_vectorpush3_insert7[71:64] = local_bb1_vectorpush3_insert6[71:64];

// This section implements an unregistered operation.
// 
wire local_bb1__cast_stall_local;
wire [31:0] local_bb1__cast;

assign local_bb1__cast = local_bb1__35208;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert6_stall_local;
wire [87:0] local_bb1_vectorpush8_insert6;

assign local_bb1_vectorpush8_insert6[47:0] = local_bb1_vectorpush8_insert5[47:0];
assign local_bb1_vectorpush8_insert6[55:48] = local_bb1_scalarizer_3select;
assign local_bb1_vectorpush8_insert6[87:56] = local_bb1_vectorpush8_insert5[87:56];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush3_insert8_stall_local;
wire [71:0] local_bb1_vectorpush3_insert8;

assign local_bb1_vectorpush3_insert8[63:0] = local_bb1_vectorpush3_insert7[63:0];
assign local_bb1_vectorpush3_insert8[71:64] = local_bb1_scalarizer_0select5193;

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert7_stall_local;
wire [87:0] local_bb1_vectorpush8_insert7;

assign local_bb1_vectorpush8_insert7[55:0] = local_bb1_vectorpush8_insert6[55:0];
assign local_bb1_vectorpush8_insert7[63:56] = local_bb1_scalarizer_0select5185;
assign local_bb1_vectorpush8_insert7[87:64] = local_bb1_vectorpush8_insert6[87:64];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert8_stall_local;
wire [87:0] local_bb1_vectorpush8_insert8;

assign local_bb1_vectorpush8_insert8[63:0] = local_bb1_vectorpush8_insert7[63:0];
assign local_bb1_vectorpush8_insert8[71:64] = local_bb1_scalarizer_1select5194;
assign local_bb1_vectorpush8_insert8[87:72] = local_bb1_vectorpush8_insert7[87:72];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush8_insert9_stall_local;
wire [87:0] local_bb1_vectorpush8_insert9;

assign local_bb1_vectorpush8_insert9[71:0] = local_bb1_vectorpush8_insert8[71:0];
assign local_bb1_vectorpush8_insert9[79:72] = local_bb1_scalarizer_2select5195;
assign local_bb1_vectorpush8_insert9[87:80] = local_bb1_vectorpush8_insert8[87:80];

// This section implements an unregistered operation.
// 
wire local_bb1_vectorpush3_insert8_valid_out;
wire local_bb1_vectorpush3_insert8_stall_in;
wire local_bb1_vectorpush8_insert10_valid_out;
wire local_bb1_vectorpush8_insert10_stall_in;
wire local_bb1__cast_valid_out;
wire local_bb1__cast_stall_in;
wire local_bb1_vectorpush8_insert10_inputs_ready;
wire local_bb1_vectorpush8_insert10_stall_local;
wire [87:0] local_bb1_vectorpush8_insert10;

assign local_bb1_vectorpush8_insert10_inputs_ready = (rnode_15to16_bb1_c1_ene1_0_valid_out_0_NO_SHIFT_REG & SFC_2_VALID_15_16_0_valid_out_1_NO_SHIFT_REG & rnode_15to16_bb1_c1_ene1_0_valid_out_1_NO_SHIFT_REG & rnode_15to16_bb1_vectorpop3_extract4_0_valid_out_NO_SHIFT_REG & rnode_15to16_bb1_vectorpop3_extract8_0_valid_out_NO_SHIFT_REG & rnode_15to16_bb1_vectorpop3_extract5_0_valid_out_NO_SHIFT_REG & rnode_15to16_bb1_vectorpop3_extract6_0_valid_out_NO_SHIFT_REG & rnode_15to16_bb1_vectorpop3_extract7_0_valid_out_NO_SHIFT_REG & rnode_15to16_bb1_cmp38_0_valid_out_0_NO_SHIFT_REG & rnode_15to16_bb1_cmp38_0_valid_out_1_NO_SHIFT_REG & rnode_15to16_bb1_cmp38_0_valid_out_2_NO_SHIFT_REG & rnode_15to16_bb1_cmp38_0_valid_out_3_NO_SHIFT_REG & rnode_15to16_bb1_cmp43_0_valid_out_0_NO_SHIFT_REG & rnode_15to16_bb1_cmp43_0_valid_out_1_NO_SHIFT_REG & rnode_15to16_bb1_cmp43_0_valid_out_2_NO_SHIFT_REG & rnode_15to16_bb1_cmp43_0_valid_out_3_NO_SHIFT_REG & rnode_15to16_bb1_cmp48_0_valid_out_0_NO_SHIFT_REG & rnode_15to16_bb1_cmp48_0_valid_out_1_NO_SHIFT_REG & rnode_15to16_bb1_cmp48_0_valid_out_2_NO_SHIFT_REG & rnode_15to16_bb1_cmp48_0_valid_out_3_NO_SHIFT_REG & rnode_15to16_bb1_cmp53_0_valid_out_0_NO_SHIFT_REG & rnode_15to16_bb1_cmp53_0_valid_out_1_NO_SHIFT_REG & rnode_15to16_bb1_cmp53_0_valid_out_2_NO_SHIFT_REG & rnode_15to16_bb1_cmp53_0_valid_out_3_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_1_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_2_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_3_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_1_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_2_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_3_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_1_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_2_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_3_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_1_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_2_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_3_NO_SHIFT_REG & rnode_15to16_bb1__5212_0_valid_out_NO_SHIFT_REG & rnode_15to16_bb1__5213_0_valid_out_NO_SHIFT_REG & rnode_15to16_bb1__5214_0_valid_out_NO_SHIFT_REG & rnode_15to16_bb1__5215_0_valid_out_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_0trunc5149_0_valid_out_0_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_1trunc5150_0_valid_out_0_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_2trunc5151_0_valid_out_0_NO_SHIFT_REG & rnode_15to16_bb1_scalarizer_3trunc5152_0_valid_out_0_NO_SHIFT_REG);
assign local_bb1_vectorpush8_insert10[79:0] = local_bb1_vectorpush8_insert9[79:0];
assign local_bb1_vectorpush8_insert10[87:80] = local_bb1_scalarizer_3select5196;
assign local_bb1_vectorpush3_insert8_valid_out = 1'b1;
assign local_bb1_vectorpush8_insert10_valid_out = 1'b1;
assign local_bb1__cast_valid_out = 1'b1;
assign rnode_15to16_bb1_c1_ene1_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign SFC_2_VALID_15_16_0_stall_in_1 = 1'b0;
assign rnode_15to16_bb1_c1_ene1_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract4_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract8_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract5_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract6_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_vectorpop3_extract7_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp38_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp38_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp38_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp38_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp43_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp43_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp43_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp43_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp48_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp48_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp48_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp48_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp53_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp53_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp53_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_cmp53_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1__5212_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1__5213_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1__5214_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1__5215_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_0trunc5149_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_1trunc5150_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_2trunc5151_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb1_scalarizer_3trunc5152_0_stall_in_0_NO_SHIFT_REG = 1'b0;

// This section implements a registered operation.
// 
wire local_bb1_vectorpush3_vectorpush3_insert8_inputs_ready;
wire local_bb1_vectorpush3_vectorpush3_insert8_output_regs_ready;
wire [71:0] local_bb1_vectorpush3_vectorpush3_insert8_result;
wire local_bb1_vectorpush3_vectorpush3_insert8_fu_valid_out;
wire local_bb1_vectorpush3_vectorpush3_insert8_fu_stall_out;
 reg [71:0] local_bb1_vectorpush3_vectorpush3_insert8_NO_SHIFT_REG;
wire local_bb1_vectorpush3_vectorpush3_insert8_causedstall;

acl_push local_bb1_vectorpush3_vectorpush3_insert8_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(rnode_15to16_bb1_c1_ene2_0_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpush3_insert8),
	.stall_out(local_bb1_vectorpush3_vectorpush3_insert8_fu_stall_out),
	.valid_in(SFC_2_VALID_15_16_0_NO_SHIFT_REG),
	.valid_out(local_bb1_vectorpush3_vectorpush3_insert8_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_vectorpush3_vectorpush3_insert8_result),
	.feedback_out(feedback_data_out_3),
	.feedback_valid_out(feedback_valid_out_3),
	.feedback_stall_in(feedback_stall_in_3)
);

defparam local_bb1_vectorpush3_vectorpush3_insert8_feedback.STALLFREE = 1;
defparam local_bb1_vectorpush3_vectorpush3_insert8_feedback.ENABLED = 0;
defparam local_bb1_vectorpush3_vectorpush3_insert8_feedback.DATA_WIDTH = 72;
defparam local_bb1_vectorpush3_vectorpush3_insert8_feedback.FIFO_DEPTH = 1;
defparam local_bb1_vectorpush3_vectorpush3_insert8_feedback.MIN_FIFO_LATENCY = 0;
defparam local_bb1_vectorpush3_vectorpush3_insert8_feedback.STYLE = "REGULAR";
defparam local_bb1_vectorpush3_vectorpush3_insert8_feedback.RAM_FIFO_DEPTH_INC = 0;

assign local_bb1_vectorpush3_vectorpush3_insert8_inputs_ready = 1'b1;
assign local_bb1_vectorpush3_vectorpush3_insert8_output_regs_ready = 1'b1;
assign local_bb1_vectorpush3_insert8_stall_in = 1'b0;
assign SFC_2_VALID_15_16_0_stall_in_3 = 1'b0;
assign rnode_15to16_bb1_c1_ene2_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign local_bb1_vectorpush3_vectorpush3_insert8_causedstall = (SFC_2_VALID_15_16_0_NO_SHIFT_REG && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_vectorpush3_vectorpush3_insert8_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_vectorpush3_vectorpush3_insert8_output_regs_ready)
		begin
			local_bb1_vectorpush3_vectorpush3_insert8_NO_SHIFT_REG <= local_bb1_vectorpush3_vectorpush3_insert8_result;
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb1_vectorpush8_vectorpush8_insert10_inputs_ready;
wire local_bb1_vectorpush8_vectorpush8_insert10_output_regs_ready;
wire [87:0] local_bb1_vectorpush8_vectorpush8_insert10_result;
wire local_bb1_vectorpush8_vectorpush8_insert10_fu_valid_out;
wire local_bb1_vectorpush8_vectorpush8_insert10_fu_stall_out;
 reg [87:0] local_bb1_vectorpush8_vectorpush8_insert10_NO_SHIFT_REG;
wire local_bb1_vectorpush8_vectorpush8_insert10_causedstall;

acl_push local_bb1_vectorpush8_vectorpush8_insert10_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(rnode_15to16_bb1_c1_ene2_1_NO_SHIFT_REG),
	.predicate(1'b0),
	.data_in(local_bb1_vectorpush8_insert10),
	.stall_out(local_bb1_vectorpush8_vectorpush8_insert10_fu_stall_out),
	.valid_in(SFC_2_VALID_15_16_0_NO_SHIFT_REG),
	.valid_out(local_bb1_vectorpush8_vectorpush8_insert10_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_vectorpush8_vectorpush8_insert10_result),
	.feedback_out(feedback_data_out_8),
	.feedback_valid_out(feedback_valid_out_8),
	.feedback_stall_in(feedback_stall_in_8)
);

defparam local_bb1_vectorpush8_vectorpush8_insert10_feedback.STALLFREE = 1;
defparam local_bb1_vectorpush8_vectorpush8_insert10_feedback.ENABLED = 0;
defparam local_bb1_vectorpush8_vectorpush8_insert10_feedback.DATA_WIDTH = 88;
defparam local_bb1_vectorpush8_vectorpush8_insert10_feedback.FIFO_DEPTH = 1;
defparam local_bb1_vectorpush8_vectorpush8_insert10_feedback.MIN_FIFO_LATENCY = 1;
defparam local_bb1_vectorpush8_vectorpush8_insert10_feedback.STYLE = "REGULAR";
defparam local_bb1_vectorpush8_vectorpush8_insert10_feedback.RAM_FIFO_DEPTH_INC = 1;

assign local_bb1_vectorpush8_vectorpush8_insert10_inputs_ready = 1'b1;
assign local_bb1_vectorpush8_vectorpush8_insert10_output_regs_ready = 1'b1;
assign local_bb1_vectorpush8_insert10_stall_in = 1'b0;
assign SFC_2_VALID_15_16_0_stall_in_4 = 1'b0;
assign rnode_15to16_bb1_c1_ene2_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign local_bb1_vectorpush8_vectorpush8_insert10_causedstall = (SFC_2_VALID_15_16_0_NO_SHIFT_REG && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_vectorpush8_vectorpush8_insert10_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_vectorpush8_vectorpush8_insert10_output_regs_ready)
		begin
			local_bb1_vectorpush8_vectorpush8_insert10_NO_SHIFT_REG <= local_bb1_vectorpush8_vectorpush8_insert10_result;
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb1_errorBuffer_5_0_coalesced_push2__cast_inputs_ready;
wire local_bb1_errorBuffer_5_0_coalesced_push2__cast_output_regs_ready;
wire [31:0] local_bb1_errorBuffer_5_0_coalesced_push2__cast_result;
wire local_bb1_errorBuffer_5_0_coalesced_push2__cast_fu_valid_out;
wire local_bb1_errorBuffer_5_0_coalesced_push2__cast_fu_stall_out;
 reg [31:0] local_bb1_errorBuffer_5_0_coalesced_push2__cast_NO_SHIFT_REG;
wire local_bb1_errorBuffer_5_0_coalesced_push2__cast_causedstall;

acl_push local_bb1_errorBuffer_5_0_coalesced_push2__cast_feedback (
	.clock(clock),
	.resetn(resetn),
	.dir(1'b1),
	.predicate(1'b0),
	.data_in(local_bb1__cast),
	.stall_out(local_bb1_errorBuffer_5_0_coalesced_push2__cast_fu_stall_out),
	.valid_in(SFC_2_VALID_15_16_0_NO_SHIFT_REG),
	.valid_out(local_bb1_errorBuffer_5_0_coalesced_push2__cast_fu_valid_out),
	.stall_in(1'b0),
	.data_out(local_bb1_errorBuffer_5_0_coalesced_push2__cast_result),
	.feedback_out(feedback_data_out_2),
	.feedback_valid_out(feedback_valid_out_2),
	.feedback_stall_in(feedback_stall_in_2)
);

defparam local_bb1_errorBuffer_5_0_coalesced_push2__cast_feedback.STALLFREE = 1;
defparam local_bb1_errorBuffer_5_0_coalesced_push2__cast_feedback.ENABLED = 0;
defparam local_bb1_errorBuffer_5_0_coalesced_push2__cast_feedback.DATA_WIDTH = 32;
defparam local_bb1_errorBuffer_5_0_coalesced_push2__cast_feedback.FIFO_DEPTH = 5095;
defparam local_bb1_errorBuffer_5_0_coalesced_push2__cast_feedback.MIN_FIFO_LATENCY = 5094;
defparam local_bb1_errorBuffer_5_0_coalesced_push2__cast_feedback.STYLE = "REGULAR";
defparam local_bb1_errorBuffer_5_0_coalesced_push2__cast_feedback.RAM_FIFO_DEPTH_INC = 0;

assign local_bb1_errorBuffer_5_0_coalesced_push2__cast_inputs_ready = 1'b1;
assign local_bb1_errorBuffer_5_0_coalesced_push2__cast_output_regs_ready = 1'b1;
assign local_bb1__cast_stall_in = 1'b0;
assign SFC_2_VALID_15_16_0_stall_in_2 = 1'b0;
assign local_bb1_errorBuffer_5_0_coalesced_push2__cast_causedstall = (SFC_2_VALID_15_16_0_NO_SHIFT_REG && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_errorBuffer_5_0_coalesced_push2__cast_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (local_bb1_errorBuffer_5_0_coalesced_push2__cast_output_regs_ready)
		begin
			local_bb1_errorBuffer_5_0_coalesced_push2__cast_NO_SHIFT_REG <= local_bb1_errorBuffer_5_0_coalesced_push2__cast_result;
		end
	end
end


endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

// altera message_off 10036
// altera message_off 10230
// altera message_off 10858
module errorDiffusion_basic_block_2
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
module errorDiffusion_function
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
		output 		avm_local_bb1_st_c1_exe1_enable,
		input [255:0] 		avm_local_bb1_st_c1_exe1_readdata,
		input 		avm_local_bb1_st_c1_exe1_readdatavalid,
		input 		avm_local_bb1_st_c1_exe1_waitrequest,
		output [29:0] 		avm_local_bb1_st_c1_exe1_address,
		output 		avm_local_bb1_st_c1_exe1_read,
		output 		avm_local_bb1_st_c1_exe1_write,
		input 		avm_local_bb1_st_c1_exe1_writeack,
		output [255:0] 		avm_local_bb1_st_c1_exe1_writedata,
		output [31:0] 		avm_local_bb1_st_c1_exe1_byteenable,
		output [4:0] 		avm_local_bb1_st_c1_exe1_burstcount,
		input 		start,
		input [31:0] 		input_width,
		input [31:0] 		input_height,
		input 		clock2x,
		input [63:0] 		input_pixels,
		output reg 		has_a_write_pending,
		output reg 		has_a_lsu_active
	);


wire [31:0] workgroup_size;
wire [31:0] cur_cycle;
wire bb_0_stall_out;
wire bb_0_valid_out;
wire [31:0] bb_0_lvb_bb0_mul;
wire bb_0_lvb_bb0_cmp22;
wire bb_1_stall_out_0;
wire bb_1_stall_out_1;
wire bb_1_valid_out_0;
wire bb_1_valid_out_1;
wire bb_1_feedback_stall_out_0;
wire bb_1_feedback_stall_out_1;
wire bb_1_acl_pipelined_valid;
wire bb_1_acl_pipelined_exiting_valid;
wire bb_1_acl_pipelined_exiting_stall;
wire bb_1_feedback_stall_out_25;
wire bb_1_feedback_stall_out_27;
wire bb_1_feedback_stall_out_24;
wire bb_1_feedback_valid_out_24;
wire [31:0] bb_1_feedback_data_out_24;
wire bb_1_feedback_valid_out_25;
wire [3:0] bb_1_feedback_data_out_25;
wire bb_1_feedback_valid_out_0;
wire bb_1_feedback_data_out_0;
wire bb_1_feedback_valid_out_1;
wire bb_1_feedback_data_out_1;
wire bb_1_feedback_valid_out_27;
wire [3:0] bb_1_feedback_data_out_27;
wire bb_1_local_bb1_ld__active;
wire bb_1_feedback_stall_out_26;
wire bb_1_feedback_stall_out_2;
wire bb_1_feedback_stall_out_3;
wire bb_1_feedback_stall_out_8;
wire bb_1_feedback_valid_out_26;
wire [47:0] bb_1_feedback_data_out_26;
wire bb_1_local_bb1_st_c1_exe1_active;
wire bb_1_feedback_valid_out_3;
wire [71:0] bb_1_feedback_data_out_3;
wire bb_1_feedback_valid_out_8;
wire [87:0] bb_1_feedback_data_out_8;
wire bb_1_feedback_valid_out_2;
wire [31:0] bb_1_feedback_data_out_2;
wire bb_2_stall_out;
wire bb_2_valid_out;
wire feedback_stall_25;
wire feedback_valid_25;
wire [3:0] feedback_data_25;
wire feedback_stall_0;
wire feedback_valid_0;
wire feedback_data_0;
wire feedback_stall_24;
wire feedback_valid_24;
wire [31:0] feedback_data_24;
wire feedback_stall_1;
wire feedback_valid_1;
wire feedback_data_1;
wire feedback_stall_27;
wire feedback_valid_27;
wire [3:0] feedback_data_27;
wire feedback_stall_3;
wire feedback_valid_3;
wire [71:0] feedback_data_3;
wire feedback_stall_8;
wire feedback_valid_8;
wire [87:0] feedback_data_8;
wire feedback_stall_26;
wire feedback_valid_26;
wire [47:0] feedback_data_26;
wire feedback_stall_2;
wire feedback_valid_2;
wire [31:0] feedback_data_2;
wire loop_limiter_0_stall_out;
wire loop_limiter_0_valid_out;
wire writes_pending;
wire [1:0] lsus_active;

errorDiffusion_basic_block_0 errorDiffusion_basic_block_0 (
	.clock(clock),
	.resetn(resetn),
	.start(start),
	.input_width(input_width),
	.input_height(input_height),
	.valid_in(valid_in),
	.stall_out(bb_0_stall_out),
	.valid_out(bb_0_valid_out),
	.stall_in(loop_limiter_0_stall_out),
	.lvb_bb0_mul(bb_0_lvb_bb0_mul),
	.lvb_bb0_cmp22(bb_0_lvb_bb0_cmp22),
	.workgroup_size(workgroup_size)
);


errorDiffusion_basic_block_1 errorDiffusion_basic_block_1 (
	.clock(clock),
	.resetn(resetn),
	.input_pixels(input_pixels),
	.input_wii_mul(bb_0_lvb_bb0_mul),
	.input_wii_cmp22(bb_0_lvb_bb0_cmp22),
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
	.feedback_valid_in_25(feedback_valid_25),
	.feedback_stall_out_25(feedback_stall_25),
	.feedback_data_in_25(feedback_data_25),
	.feedback_valid_in_27(feedback_valid_27),
	.feedback_stall_out_27(feedback_stall_27),
	.feedback_data_in_27(feedback_data_27),
	.feedback_valid_in_24(feedback_valid_24),
	.feedback_stall_out_24(feedback_stall_24),
	.feedback_data_in_24(feedback_data_24),
	.feedback_valid_out_24(feedback_valid_24),
	.feedback_stall_in_24(feedback_stall_24),
	.feedback_data_out_24(feedback_data_24),
	.feedback_valid_out_25(feedback_valid_25),
	.feedback_stall_in_25(feedback_stall_25),
	.feedback_data_out_25(feedback_data_25),
	.feedback_valid_out_0(feedback_valid_0),
	.feedback_stall_in_0(feedback_stall_0),
	.feedback_data_out_0(feedback_data_0),
	.feedback_valid_out_1(feedback_valid_1),
	.feedback_stall_in_1(feedback_stall_1),
	.feedback_data_out_1(feedback_data_1),
	.feedback_valid_out_27(feedback_valid_27),
	.feedback_stall_in_27(feedback_stall_27),
	.feedback_data_out_27(feedback_data_27),
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
	.feedback_valid_in_26(feedback_valid_26),
	.feedback_stall_out_26(feedback_stall_26),
	.feedback_data_in_26(feedback_data_26),
	.feedback_valid_in_2(feedback_valid_2),
	.feedback_stall_out_2(feedback_stall_2),
	.feedback_data_in_2(feedback_data_2),
	.feedback_valid_in_3(feedback_valid_3),
	.feedback_stall_out_3(feedback_stall_3),
	.feedback_data_in_3(feedback_data_3),
	.feedback_valid_in_8(feedback_valid_8),
	.feedback_stall_out_8(feedback_stall_8),
	.feedback_data_in_8(feedback_data_8),
	.feedback_valid_out_26(feedback_valid_26),
	.feedback_stall_in_26(feedback_stall_26),
	.feedback_data_out_26(feedback_data_26),
	.avm_local_bb1_st_c1_exe1_enable(avm_local_bb1_st_c1_exe1_enable),
	.avm_local_bb1_st_c1_exe1_readdata(avm_local_bb1_st_c1_exe1_readdata),
	.avm_local_bb1_st_c1_exe1_readdatavalid(avm_local_bb1_st_c1_exe1_readdatavalid),
	.avm_local_bb1_st_c1_exe1_waitrequest(avm_local_bb1_st_c1_exe1_waitrequest),
	.avm_local_bb1_st_c1_exe1_address(avm_local_bb1_st_c1_exe1_address),
	.avm_local_bb1_st_c1_exe1_read(avm_local_bb1_st_c1_exe1_read),
	.avm_local_bb1_st_c1_exe1_write(avm_local_bb1_st_c1_exe1_write),
	.avm_local_bb1_st_c1_exe1_writeack(avm_local_bb1_st_c1_exe1_writeack),
	.avm_local_bb1_st_c1_exe1_writedata(avm_local_bb1_st_c1_exe1_writedata),
	.avm_local_bb1_st_c1_exe1_byteenable(avm_local_bb1_st_c1_exe1_byteenable),
	.avm_local_bb1_st_c1_exe1_burstcount(avm_local_bb1_st_c1_exe1_burstcount),
	.local_bb1_st_c1_exe1_active(bb_1_local_bb1_st_c1_exe1_active),
	.feedback_valid_out_3(feedback_valid_3),
	.feedback_stall_in_3(feedback_stall_3),
	.feedback_data_out_3(feedback_data_3),
	.feedback_valid_out_8(feedback_valid_8),
	.feedback_stall_in_8(feedback_stall_8),
	.feedback_data_out_8(feedback_data_8),
	.feedback_valid_out_2(feedback_valid_2),
	.feedback_stall_in_2(feedback_stall_2),
	.feedback_data_out_2(feedback_data_2)
);


errorDiffusion_basic_block_2 errorDiffusion_basic_block_2 (
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

errorDiffusion_sys_cycle_time system_cycle_time_module (
	.clock(clock),
	.resetn(resetn),
	.cur_cycle(cur_cycle)
);


assign workgroup_size = 32'h1;
assign valid_out = bb_2_valid_out;
assign stall_out = bb_0_stall_out;
assign writes_pending = bb_1_local_bb1_st_c1_exe1_active;
assign lsus_active[0] = bb_1_local_bb1_ld__active;
assign lsus_active[1] = bb_1_local_bb1_st_c1_exe1_active;

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
module errorDiffusion_function_wrapper
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
		output 		avm_local_bb1_st_c1_exe1_inst0_enable,
		input [255:0] 		avm_local_bb1_st_c1_exe1_inst0_readdata,
		input 		avm_local_bb1_st_c1_exe1_inst0_readdatavalid,
		input 		avm_local_bb1_st_c1_exe1_inst0_waitrequest,
		output [29:0] 		avm_local_bb1_st_c1_exe1_inst0_address,
		output 		avm_local_bb1_st_c1_exe1_inst0_read,
		output 		avm_local_bb1_st_c1_exe1_inst0_write,
		input 		avm_local_bb1_st_c1_exe1_inst0_writeack,
		output [255:0] 		avm_local_bb1_st_c1_exe1_inst0_writedata,
		output [31:0] 		avm_local_bb1_st_c1_exe1_inst0_byteenable,
		output [4:0] 		avm_local_bb1_st_c1_exe1_inst0_burstcount
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
 reg [159:0] kernel_arguments_NO_SHIFT_REG;
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
		kernel_arguments_NO_SHIFT_REG <= 160'h0;
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
errorDiffusion_function errorDiffusion_function_inst0 (
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
	.avm_local_bb1_st_c1_exe1_enable(avm_local_bb1_st_c1_exe1_inst0_enable),
	.avm_local_bb1_st_c1_exe1_readdata(avm_local_bb1_st_c1_exe1_inst0_readdata),
	.avm_local_bb1_st_c1_exe1_readdatavalid(avm_local_bb1_st_c1_exe1_inst0_readdatavalid),
	.avm_local_bb1_st_c1_exe1_waitrequest(avm_local_bb1_st_c1_exe1_inst0_waitrequest),
	.avm_local_bb1_st_c1_exe1_address(avm_local_bb1_st_c1_exe1_inst0_address),
	.avm_local_bb1_st_c1_exe1_read(avm_local_bb1_st_c1_exe1_inst0_read),
	.avm_local_bb1_st_c1_exe1_write(avm_local_bb1_st_c1_exe1_inst0_write),
	.avm_local_bb1_st_c1_exe1_writeack(avm_local_bb1_st_c1_exe1_inst0_writeack),
	.avm_local_bb1_st_c1_exe1_writedata(avm_local_bb1_st_c1_exe1_inst0_writedata),
	.avm_local_bb1_st_c1_exe1_byteenable(avm_local_bb1_st_c1_exe1_inst0_byteenable),
	.avm_local_bb1_st_c1_exe1_burstcount(avm_local_bb1_st_c1_exe1_inst0_burstcount),
	.start(start_kernel),
	.input_width(kernel_arguments_NO_SHIFT_REG[127:96]),
	.input_height(kernel_arguments_NO_SHIFT_REG[95:64]),
	.clock2x(clock2x),
	.input_pixels(kernel_arguments_NO_SHIFT_REG[63:0]),
	.has_a_write_pending(has_a_write_pending),
	.has_a_lsu_active(has_a_lsu_active)
);



endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

// altera message_off 10036
// altera message_off 10230
// altera message_off 10858
module errorDiffusion_sys_cycle_time
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

