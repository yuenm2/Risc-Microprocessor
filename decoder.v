module decoder (
	
	// ------------------------------------------------------------ 
	// Inputs
	// ------------------------------------------------------------
	input wire [15:0] instruction,
	// ------------------------------------------------------------

	// ------------------------------------------------------------ 
	// Outputs
	// ------------------------------------------------------------
	output reg [3:0] 		r_addr1,
	output reg [3:0] 		r_addr2,
	output reg 			we,
	output reg [3:0] 		w_addr,
	output wire [2:0] 		alu_op,
	output reg [1:0] 		shifter_op,

	output reg 			b,
	output reg 			b_add,

	output reg 			move_const,
	output reg [15:0] 	const1,
	output reg [15:0]     const2,

	output reg 			add_sub_const, // to used before the alu

	output reg 			move,

	output reg 			l_s
	// ------------------------------------------------------------ 
	);

// -------------------------------------------------------------------- 
// Logic Declaration
// --------------------------------------------------------------------
	reg [2:0] im3 = instruction[8:6];
	reg [2:0] im5 = instruction[10:6];
	reg [2:0] im6 = instruction[5:0];
	reg [2:0] im7 = instruction[6:0];
	reg [2:0] im8 = instruction[7:0];
	reg [2:0] im11 = instruction[10:0];

	reg [2:0] op; 
	// 000: nothing, 001: add, 010: sub, 011: and, 100: eor, 101: orrs, 110: not, 111: CMP

	reg [3:0] pc_addr = 4'b1111;
	reg [3:0] lr_addr = 4'b1110;
	reg [3:0] sp_addr = 4'b1101;

	assign alu_op = op;


	always @(*) begin
	
		case(instruction[15:12])
			/*4'b0000: begin // default instructions
					r_addr1 = 4'b0000;
					r_addr2 = 4'b0000;
					we = 1'b0;
					w_addr = 4'b0000;
					op = 3'b000;
					shifter_op = 2'b00;
					b = 1'b0;
					const4 = 4'b0000;
					b_add = 1'b0;
					const11 = 11'd0;
					move_const = 1'b0;
					const8 = 8'd0;
					count7 = 7'd0;
					add_sub_const = 1'b0;
					const3 = 3'b000;
					move = 1'b0;
					l_s = 1'b0;
			end*/
			4'b0001: begin
				// 0001100 Rm Rn Rd  ADDS Rd, Rn, Rm NZCV Rd=Rn+Rm
				if(instruction[10:9] == 2'b00) begin
					r_addr1 = {1'b0, instruction[5:3]};
					r_addr2 = {1'b0, instruction[8:6]};
					we = 1'b1;
					w_addr = {1'b0, instruction[2:0]};
					op = 3'b001;
					shifter_op = 2'b00;
					b = 1'b0;
					b_add = 1'b0;
					move_const = 1'b0;
					const1 = 16'd0;
					const2 = 16'd0;
					add_sub_const = 1'b0;
					move = 1'b0;
					l_s = 1'b0;
				end
				else if(instruction[10:9] == 2'b01) begin // SUBS
					r_addr1 = {1'b0, instruction[5:3]};
					r_addr2 = {1'b0, instruction[8:6]};
					we = 1'b1;
					w_addr = {1'b0, instruction[2:0]};
					op = 3'b010;
					shifter_op = 2'b00;
					b = 1'b0;
					b_add = 1'b0;
					move_const = 1'b0;
					const1 = 16'd0;
					const2 = 16'd0;
					add_sub_const = 1'b0;
					move = 1'b0;
					l_s = 1'b0;
				end 
				// 0001110 im3 Rn Rd  ADDS Rd, Rn, #<im3> NZCV Add Rd=Rn+ExZ(<im3>)
				else if(instruction[10:9] == 2'b10) begin // ADDS IM
					r_addr1 = {1'b0, instruction[5:3]};
					r_addr2 = 4'b0000;
					we = 1'b1;
					w_addr = {1'b0, instruction[2:0]};
					op = 3'b001;
					shifter_op = 2'b00;
					b = 1'b0;
					b_add = 1'b0;
					move_const = 1'b0;
					const1 = 16'd0;
					const2 = {13'b0, im3};
					add_sub_const = 1'b1;
					move = 1'b0;
					l_s = 1'b0;
				end
				else begin // SUBS IM
					r_addr1 = {1'b0, instruction[5:3]};
					r_addr2 = 4'b0000;
					we = 1'b1;
					w_addr = {1'b0, instruction[2:0]};
					op = 3'b010;
					shifter_op = 2'b00;
					b = 1'b0;
					b_add = 1'b0;
					move_const = 1'b0;
					const1 = 16'd0;
					const2 = {13'b0, im3};
					add_sub_const = 1'b1;
					move = 1'b0;
					l_s = 1'b0;
				end
			end
			4'b0010: begin
				// MOVS
				r_addr1 = 4'b0000;
				r_addr2 = 4'b0000;
				we = 1'b1;
				w_addr = {1'b0, instruction[10:8]};
				op = 3'b000;
				shifter_op = 2'b00;
				b = 1'b0;
				b_add = 1'b0;
				move_const = 1'b1;
				const1 = {8'b0, im8};
				const2 = 16'b0;
				add_sub_const = 1'b0;
				move = 1'b0;
				l_s = 1'b0;
			end
			/*4'b0011: begin
			end*/
			4'b0100: begin
				if(instruction[10:8] == 3'b110) begin // MOV
					r_addr1 = instruction[6:3];
					r_addr2 = 4'b0000;
					we = 1'b1;
					w_addr = {1'b0, instruction[3:0]};
					op = 3'b000;
					shifter_op = 2'b00;
					b = 1'b0;
					b_add = 1'b0;
					move_const = 1'b0;
					const1 = 16'd0;
					const2 = 16'd0;
					add_sub_const = 1'b0;
					move = 1'b1;
					l_s = 1'b0;
				end
				/*else if (instruction[10:8] == 3'b111) begin
				end
				else if (instruction[10:8] == 3b'101) begin
				end*/
				else begin
					case(instruction[9:6])
						4'b0000: begin // ANDS
							r_addr1 = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							op = 3'b011;
							shifter_op = 2'b00;
							b = 1'b0;
							b_add = 1'b0;
							move_const = 1'b0;
							const1 = 16'd0;
							const2 = 16'd0;
							add_sub_const = 1'b0;
							move = 1'b0;
							l_s = 1'b0;
						end
						4'b0001: begin // EORS
							r_addr1 = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							op = 3'b100;
							shifter_op = 2'b00;
							b = 1'b0;
							b_add = 1'b0;
							move_const = 1'b0;
							const1 = 16'd0;
							const2 = 16'd0;
							add_sub_const = 1'b0;
							move = 1'b0;
							l_s = 1'b0;
						end
						4'b0010: begin // LSLS
							r_addr1 = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							op = 3'b000;
							shifter_op = 2'b00;
							b = 1'b0;
							b_add = 1'b0;
							move_const = 1'b0;
							const1 = 16'd0;
							const2 = 16'd0;
							add_sub_const = 1'b0;
							move = 1'b0;
							l_s = 1'b0;
						end
						4'b0011: begin // LSRS
							r_addr1 = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							op = 3'b100;
							shifter_op = 2'b01;
							b = 1'b0;
							b_add = 1'b0;
							move_const = 1'b0;
							const1 = 16'd0;
							const2 = 16'd0;
							add_sub_const = 1'b0;
							move = 1'b0;
							l_s = 1'b0;
						end
						4'b0100: begin
							if(instruction[10]) begin // BL <label
								// TODO
							end
							else begin // ASRS
								r_addr1 = {1'b0, instruction[2:0]};
								r_addr2 = {1'b0, instruction[5:3]};
								we = 1'b1;
								w_addr = {1'b0, instruction[2:0]};
								op = 3'b100;
								shifter_op = 2'b10;
								b = 1'b0;
								b_add = 1'b0;
								move_const = 1'b0;
								const1 = 16'd0;
								const2 = 16'd0;
								add_sub_const = 1'b0;
								move = 1'b0;
								l_s = 1'b0;
							end
						
						end
						/*4'b0101: begin // nothing
						
						end
						4'b0110: begin
						end*/
						4'b0111: begin //RORS
							r_addr1 = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							op = 3'b100;
							shifter_op = 2'b11;
							b = 1'b0;
							b_add = 1'b0;
							move_const = 1'b0;
							const1 = 16'd0;
							const2 = 16'd0;
							add_sub_const = 1'b0;
							move = 1'b0;
							l_s = 1'b0;
						end
						/*4'b1000: begin //
						
						end
						4'b1001: begin // 
						
						end*/
						4'b1010: begin // CMP
							r_addr1 = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							op = 3'b111;
							shifter_op = 2'b00;
							b = 1'b0;
							b_add = 1'b0;
							move_const = 1'b0;
							const1 = 16'd0;
							const2 = 16'd0;
							add_sub_const = 1'b0;
							move = 1'b0;
							l_s = 1'b0;
						end
						4'b1011: begin // 
						
						end
						4'b1100: begin // ORRS
							r_addr1 = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							op = 3'b101;
							shifter_op = 2'b00;
							b = 1'b0;
							b_add = 1'b0;
							move_const = 1'b0;
							const1 = 16'd0;
							const2 = 16'd0;
							add_sub_const = 1'b0;
							move = 1'b0;
							l_s = 1'b0;
						end
						4'b1101: begin //
						
						end
						4'b1110: begin // BX RM
							r_addr1 = 4'b0000;
							r_addr2 = 4'b0000;
							we = 1'b1;
							w_addr = pc_addr;
							op = 3'b000;
							shifter_op = 2'b00;
							b = 1'b1;
							b_add = 1'b0;
							move_const = 1'b0;
							const1 = {12'b0, instruction[6:3]};
							const2 = 16'd0;
							add_sub_const = 1'b0;
							move = 1'b0;
							l_s = 1'b0;
						end
						4'b1111: begin // MVNS
							r_addr1 = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							op = 3'b110;
							shifter_op = 2'b00;
							b = 1'b0;
							b_add = 1'b0;
							move_const = 1'b0;
							const1 = 16'd0;
							const2 = 16'd0;
							add_sub_const = 1'b0;
							move = 1'b0;
							l_s = 1'b0;
						end
					endcase
				end
			end
			4'b0101: begin
			
			end
			4'b0110: begin
				if(instruction[11]) begin // LOAD
					r_addr1 = instruction[5:3] + instruction[9:5];
					r_addr2 = 4'b0000;
					we = 1'b1;
					w_addr = {1'b0, instruction[2:0]};
					op = 3'b000;
					shifter_op = 2'b00;
					b = 1'b0;
					b_add = 1'b0;
					move_const = 1'b0;
					const1 = 16'd0;
					const2 = 16'd0;
					add_sub_const = 1'b0;;
					move = 1'b0;
					l_s = 1'b1;
				end
				else begin // STORE
					r_addr1 = {1'b0, instruction[2:0]};
					r_addr2 = 4'b0000;
					we = 1'b1;
					w_addr = instruction[5:3] + instruction[9:5];
					op = 3'b000;
					shifter_op = 2'b00;
					b = 1'b0;
					b_add = 1'b0;
					move_const = 1'b0;
					const1 = 16'd0;
					const2 = 16'd0;
					add_sub_const = 1'b0;
					move = 1'b0;
					l_s = 1'b1;
				end
			
			end
			/*4'b0111: begin
			
			end
			4'b1000: begin
			
			end
			4'b1001: begin
			
			end
			4'b1010: begin
			
			end*/
			4'b1011: begin
				if(!instruction[11]) begin
					if(instruction[7]) begin // ADD SP
						r_addr1 = sp_addr;
						r_addr2 = 4'b0000;
						we = 1'b1;
						w_addr = sp_addr;
						op = 3'b001;
						shifter_op = 2'b00;
						b = 1'b0;
						b_add = 1'b0;
						move_const = 1'b0;
						const2 = 16'b0;
						const1 = {9'b0, instruction[6:0]};
						add_sub_const = 1'b1;
						move = 1'b0;
						l_s = 1'b0;
					end
					else begin // SUB SP
						r_addr1 = sp_addr;
						r_addr2 = 4'b0000;
						we = 1'b1;
						w_addr = sp_addr;
						op = 3'b010;
						shifter_op = 2'b00;
						b = 1'b0;
						b_add = 1'b0;
						move_const = 1'b0;
						const2 = 16'b0;
						const1 = {9'b0, instruction[6:0]};
						add_sub_const = 1'b1;
						move = 1'b0;
						l_s = 1'b0;
					end
				end
				else begin // NOOP
					r_addr1 = 4'b0000;
					r_addr2 = 4'b0000;
					we = 1'b0;
					w_addr = 4'b0000;
					op = 3'b000;
					shifter_op = 2'b00;
					b = 1'b0;
					b_add = 1'b0;
					move_const = 1'b0;
					const1 = 16'd0;
					const2 = 16'd0;
					add_sub_const = 1'b0;
					move = 1'b0;
					l_s = 1'b0;
				end
			
			end
			4'b1100: begin
			
			end
			4'b1101: begin // B<Cc>
				if (instruction[11:8]) begin
					r_addr1 = pc_addr;
					r_addr2 = 4'b0000;
					we = 1'b1;
					w_addr = pc_addr;
					op = 3'b001;
					shifter_op = 2'b00;
					b = 1'b0;
					b_add = 1'b1;
					move_const = 1'b0;
					const2 = 16'd0;
					const1 = {8'd0, im8};
					add_sub_const = 1'b0;
					move = 1'b0;
					l_s = 1'b0;
				end
				else begin
					r_addr1 = pc_addr;
					r_addr2 = 4'b0000;
					we = 1'b1;
					w_addr = pc_addr;
					op = 3'b001;
					shifter_op = 2'b00;
					b = 1'b0;
					const4 = 4'b0000;
					b_add = 1'b1;
					move_const = 1'b0;
					const1 = 16'd0;
					const2 = 16'd0;
					add_sub_const = 1'b0;
					move = 1'b0;
					l_s = 1'b0;
				end
			
			end
			4'b1110: begin // B <label>
				r_addr1 = pc_addr;
				r_addr2 = 4'b0000;
				we = 1'b1;
				w_addr = pc_addr;
				op = 3'b001;
				shifter_op = 2'b00;
				b = 1'b0;
				b_add = 1'b1;
				move_const = 1'b0;
				const1 = {5'b0, im11};
				const2 = 16'd0;;
				add_sub_const = 1'b0;
				const3 = 3'b000;
				move = 1'b0;
				l_s = 1'b0;
			end
			4'b1111: begin
			
			end
		endcase
		
	end
// --------------------------------------------------------------------
endmodule
// --------------------------------------------------------------------