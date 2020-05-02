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
	wire [3:0] 		r_addr1;
	wire [3:0] 		r_addr2;
	wire 			we;
	wire [3:0] 		w_addr;
	wire [2:0] 		alu_op;
	wire [1:0] 		shifter_op;

	wire 			b;
	wire [3:0] 		const4;
	wire 			b_add;
	wire [3:0] 		const11;

	wire 			move_const;
	wire [7:0] 		const8;
	wire [6:0]     count7;

	wire 			add_sub_const; // to used before the alu
	wire [2:0] 		const3;

	reg 			move;

	reg 			l_s;
	
// --------------------------------------------------------------------

	always @(*) begin
		case(ps)
		
			1'b0: begin
				fetchInstruction = 1;
				ns = 1b'1;
			end
			
			1'b1: begin
				fetchInstruction = 0;
				ns = 1'b0;1
			end
	end
	
	instruction_memory inst_mem(clk, reset, pc, fetchInstruction, instruction);
	decoder decoder(instruction, rd_addr1, rd_addr2, we, wr_addr, alu_op, shifter_op, b, b_add, move_const, const1, const2, add_sub_const, move, l_s);
	reg_file register (clk, we,wr_addr,wr_data,rd_addr1,rd_addr2, rd_data1, rd_data2);
	mux2 muxop1 (const2,rd_data2 , add_sub_const, op1);
	alu alu(op1, rd_data2, OutputAdd, OutputSub,OutputAnd,OutputOr,OutputXor,OutputNot,OutputCMP);
	shifter shift(rd_data1, rd_data2, shifter_op, shift_out);
	mux8 muxcheck (OutputAdd, OutputSub,OutputAnd,OutputOr,OutputXor,OutputNot,OutputCMP,  shifter_out,const1, rd_data1, rd_data2, dm_out, mux_out)
	

	
	always (@posedge clk) begin
		if(reset) begin
		
		end
		else begin
			ps <= ns;
		end
	end
endmodule
// --------------------------------------------------------------------

