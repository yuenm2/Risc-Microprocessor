module cpu (
	// ------------------------------------------------------------ 
	// Inputs
	// ------------------------------------------------------------
	input wire clk,
	input wire nreset,
	// ------------------------------------------------------------

	// ------------------------------------------------------------ 
	// Outputs
	// ------------------------------------------------------------
	output wire [7:0] debug_port1,
	output wire [7:0] debug_port2,
	output wire [7:0] debug_port3,
	output wire [7:0] debug_port4,
	output wire [7:0] debug_port5,
	output wire [7:0] debug_port6,
	output wire [7:0] debug_port7 
	// ------------------------------------------------------------ 
	);

// -------------------------------------------------------------------- 
// Logic Declaration
// --------------------------------------------------------------------	
	wire reset;
	assign reset = ~nreset;
	reg ps, ns;
	reg fetchInstruction;
	wire [15:0] instruction;
	wire [3:0] 		rd_addr1, wr_addr, wr_addr_c;
	wire [3:0] 		rd_addr2;
	wire 			we;
	wire [3:0] 		wr_addr;
	wire [2:0] 		alu_op;
	wire [1:0] 		shifter_op;

	wire 			b;
	wire 			b_add;

	wire 			move_const;
	wire [15:0] 	const1;
	wire [15:0]     count2;

	wire 			add_sub_const; // to used before the alu
	wire fetched;
	reg 			move;

	reg 			l_s;
	wire [15:0]sub1,sub2,sub3;
	assign sub1 = 16'b0;
	assign sub2 = 16'b0;
	assign sub3 = 16'b0;
	
	wire pc = 16'b0;
	reg [15:0] OutputAdd, OutputSub, OutputAnd, OutputOr, OutputXor, OutputNot, OutputCMP, shift_out, shifter_out, mux_out, dm_out;
	wire z_flag, o_flag, n_flag;
// --------------------------------------------------------------------

	always @(*) begin
		case(ps)
		
			1'b0: begin
				fetchInstruction = 1;
				fetched = 0;
				ns = 1'b1; 
				wr_data = pc;
				wr_addr = 4'b1111;
			end
			
			1'b1: begin
				fetchInstruction = 0;
				fetched = 1;
				ns = 1'b0;
				wr_data =  mux_out;
				wr_addr = wr_addr_c;
			end
		endcase
	end
	
	//instruction_memory inst_mem(clk, reset, pc, fetchInstruction, instruction);
	decoder decode(instruction, rd_addr1, rd_addr2, we, wr_addr, alu_op, shifter_op, b, b_add, move_const, const1, const2, add_sub_const, move, l_s, muxsel, fetched);
	reg_file register (clk, we,wr_addr,wr_data,rd_addr1,rd_addr2, rd_data1, rd_data2);
	mux2 muxop1 (const2,rd_data2 , add_sub_const, op1);
	alu alu(op1, rd_data2, OutputAdd, OutputSub,OutputAnd,OutputOr,OutputXor,OutputNot,OutputCMP);
	shifter shift(rd_data1, rd_data2, shifter_op, shifter_out);
	mux8 muxcheck (OutputAdd, OutputSub,OutputAnd,OutputOr,OutputXor,OutputNot,OutputCMP,  shifter_out,const1,const2, rd_data1, rd_data2, dm_out,sub1,sub2,sub3,muxsel,  mux_out);
	zd zflag (mux_out, z_flag);
	

	
	always @(posedge clk) begin
		if(reset) begin
		
		end
		else begin
			ps <= ns;
		end
	end
endmodule
// --------------------------------------------------------------------

