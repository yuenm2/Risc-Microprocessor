module decoder (
	
	// ------------------------------------------------------------ 
	// Inputs
	// ------------------------------------------------------------
	input wire clk,
	input wire reset,
	input wire [15:0] instruction,
	// ------------------------------------------------------------

	// ------------------------------------------------------------ 
	// Outputs
	// ------------------------------------------------------------
	output wire [15:0] out,
	output reg [3:0] 		r_addr1,
	output reg [3:0] 		r_addr2,
	output reg 			we,
	output reg [3:0] 		w_addr,
	output reg [15:0] 		w_data,
	output wire [2:0] 		alu_op,
	output reg [1:0] 		shifter_op,

	output reg 			b,
	output reg [3:0] 		const4,
	output reg 			b_add,
	output reg [3:0] 		const11,

	output reg 			move_const,
	output reg [7:0] 		const8,
	output reg [6:0]     count7,

	output reg 			add_sub_const, // to used before the alu
	output reg [2:0] 		const3,

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
			/*4'b0000: begin
				// do nothing or make default NOOP
				we = 1'b0;
				add_sub_const = 1'b0;
				op = 3'b000;
				move_const = 1'b0;
				move = 1'b0;
				r_addr2 = 4'b0000;
				r_addr1 = 4'b0000;
				w_addr = 4'b0000;
			end*/
			4'b0001: begin
				// 0001100 Rm Rn Rd  ADDS Rd, Rn, Rm NZCV Rd=Rn+Rm
				if(instruction[10:9] == 2'b00) begin
					r_addr2 = {1'b0, instruction[8:6]};
					r_addr1 = {1'b0, instruction[5:3]};
					we = 1'b1;
					w_addr = {1'b0, instruction[2:0]};
					op = 3'b001;
					add_sub_const = 1'b0;
				end
				else if(instruction[10:9] == 2'b01) begin // SUBS
					r_addr2 = {1'b0, instruction[8:6]};
					r_addr1 = {1'b0, instruction[5:3]};
					we = 1'b1;
					w_addr = {1'b0, instruction[2:0]};
					op = 3'b010;
					add_sub_const = 1'b0;
				end 
				// 0001110 im3 Rn Rd  ADDS Rd, Rn, #<im3> NZCV Add Rd=Rn+ExZ(<im3>)
				else if(instruction[10:9] == 2'b10) begin // ADDS IM
					const3 = im3;
					r_addr1 = {1'b0, instruction[5:3]};
					we = 1'b1;
					w_addr = {1'b0, instruction[2:0]};
					op = 3'b001;
					add_sub_const = 1'b1;
				end
				else begin // SUBS IM
					const3 = im3;
					r_addr1 = {1'b0, instruction[5:3]};
					we = 1'b1;
					w_addr = {1'b0, instruction[2:0]};
					op = 3'b010;
					add_sub_const = 1'b1;
				end
				move = 1'b0;
				move_const = 1'b0;
			end
			4'b0010: begin
				// MOVS
				we = 1'b1;
				w_addr = {1'b0, instruction[10:8]};
				op = 3'b000;
				add_sub_const = 1'b0;
				move_const = 1'b1;
				const8 = im8;
				move = 1'b0;
				r_addr2 = 4'b0000;
				r_addr1 = 4'b0000;
			end
			/*4'b0011: begin
				we = 1'b0;
				add_sub_const = 1'b0;
				op = 3'b000;
				move_const = 1'b0;
				move = 1'b0;
				r_addr2 = 4'b0000;
				r_addr1 = 4'b0000;
				w_addr = 4'b0000;
			end*/
			4'b0100: begin
				if(instruction[10:8] == 3'b110) begin // MOV
					we = 1'b1;
					w_addr = {1'b0, instruction[3:0]};
					op = 3'b000;
					add_sub_const = 1'b0;
					move_const = 1'b0;
					move = 1'b1;
					r_addr1 = instruction[6:3];
					r_addr2 = 4'b0000;
				end
				/*else if (instruction[10:8] == 3'b111) begin
					
				end
				else if (instruction[10:8] == 3b'101) begin
				
				end*/
				else begin
					case(instruction[9:6])
						4'b0000: begin // ANDS
							op = 3'b011;
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							r_addr1 = {1'b0, instruction[2:0]};
							add_sub_const = 1'b0;
							move_const = 1'b0;
							move = 1'b0;
						end
						4'b0001: begin // EORS
							op = 3'b100;
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							r_addr1 = {1'b0, instruction[2:0]};
							add_sub_const = 1'b0;
							move_const = 1'b0;
							move = 1'b0;
						end
						4'b0010: begin // LSLS
							op = 3'b000;
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							r_addr1 = {1'b0, instruction[2:0]};
							add_sub_const = 1'b0;
							move_const = 1'b1;
							move = 1'b0;
							shifter_op = 2'b00;
						end
						4'b0011: begin // LSRS
							op = 3'b000;
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							r_addr1 = {1'b0, instruction[2:0]};
							add_sub_const = 1'b0;
							move_const = 1'b1;
							move = 1'b0;
							shifter_op = 2'b01;
						end
						4'b0100: begin
							if(instruction[10]) begin // BL <label
								// TODO
							end
							else begin // ASRS
								op = 3'b000;
								we = 1'b1;
								w_addr = {1'b0, instruction[2:0]};
								r_addr2 = {1'b0, instruction[5:3]};
								r_addr1 = {1'b0, instruction[2:0]};
								add_sub_const = 1'b0;
								move_const = 1'b1;
								move = 1'b0;
								shifter_op = 2'b10;
							end
						
						end
						/*4'b0101: begin // nothing
						
						end
						4'b0110: begin
						end*/
						4'b0111: begin //RORS
							op = 3'b000;
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							r_addr1 = {1'b0, instruction[2:0]};
							add_sub_const = 1'b0;
							move_const = 1'b1;
							move = 1'b0;
							shifter_op = 2'b11;
						end
						/*4'b1000: begin //
						
						end
						4'b1001: begin // 
						
						end*/
						4'b1010: begin // CMP
							op = 3'b111;
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							r_addr1 = {1'b0, instruction[2:0]};
							add_sub_const = 1'b0;
							move_const = 1'b0;
							move = 1'b0;
						end
						4'b1011: begin // 
						
						end
						4'b1100: begin // ORRS
							op = 3'b101;
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							r_addr1 = {1'b0, instruction[2:0]};
							add_sub_const = 1'b0;
							move_const = 1'b1;
							move = 1'b0;
						end
						4'b1101: begin //
						
						end
						4'b1110: begin // BX RM
							op = 3'b000;
							we = 1'b1;
							w_addr = pc_addr;
							r_addr2 = 4'b0000;
							r_addr1 = 4'b0000;
							add_sub_const = 1'b0;
							move_const = 1'b0;
							move = 1'b0;
							b = 1'b1;
							const4 = instruction[6:3];
						end
						4'b1111: begin // MVNS
							op = 3'b110;
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							r_addr2 = {1'b0, instruction[5:3]};
							r_addr1 = {1'b0, instruction[2:0]};
							add_sub_const = 1'b0;
							move_const = 1'b0;
							move = 1'b0;
						end
					endcase
				end
			end
			4'b0101: begin
			
			end
			4'b0110: begin
				if(instruction[11]) begin // LOAD
					op = 3'b000;
					we = 1'b1;
					w_addr = {1'b0, instruction[2:0]};
					r_addr2 = 4'b0000;
					r_addr1 = instruction[5:3] + instruction[9:5];
					add_sub_const = 1'b0;
					move_const = 1'b0;
					move = 1'b0;
					l_s = 1'b0;
				end
				else begin // STORE
					op = 3'b000;
					we = 1'b1;
					w_addr = instruction[5:3] + instruction[9:5];;
					r_addr2 = {1'b0, instruction[2:0]};
					//r_addr1 = ;
					add_sub_const = 1'b0;
					move_const = 1'b0;
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
						r_addr2 = 4'b0000;
						r_addr1 = sp_addr;
						we = 1'b1;
						w_addr = sp_addr;
						op = 3'b001;
						add_sub_const = 1'b1;
						count7 = instruction[6:0];
					end
					else begin // SUB SP
						r_addr2 = 4'b0000;
						r_addr1 = sp_addr;
						we = 1'b1;
						w_addr = sp_addr;
						op = 3'b010;
						add_sub_const = 1'b1;
						count7 = instruction[6:0];
					end
				end
				else begin // NOOP
					we = 1'b0;
					add_sub_const = 1'b0;
					op = 3'b000;
					move_const = 1'b0;
					move = 1'b0;
					r_addr2 = 4'b0000;
					r_addr1 = 4'b0000;
					w_addr = 4'b0000;
				end
			
			end
			4'b1100: begin
			
			end
			4'b1101: begin // B<Cc>
				if (instruction[11:8]) begin
					op = 3'b001;
					we = 1'b1;
					w_addr = pc_addr;
					r_addr2 = 4'b0000;
					r_addr1 = pc_addr;
					add_sub_const = 1'b0;
					move_const = 1'b0;
					move = 1'b0;
					b = 1'b0;
					const11 = {3'b000, im8};
					b_add = 1'b1;
				end
				else begin
					op = 3'b001;
					we = 1'b1;
					w_addr = pc_addr;
					r_addr2 = 4'b0000;
					r_addr1 = pc_addr;
					add_sub_const = 1'b0;
					move_const = 1'b0;
					move = 1'b0;
					b = 1'b0;
					const11 = 11'd1;
					b_add = 1'b1;
				end
			
			end
			4'b1110: begin // B <label>
				op = 3'b001;
				we = 1'b1;
				w_addr = pc_addr;
				r_addr2 = 4'b0000;
				r_addr1 = pc_addr;
				add_sub_const = 1'b0;
				move_const = 1'b0;
				move = 1'b0;
				b = 1'b0;
				const11 = im11;
				b_add = 1'b1;
			end
			4'b1111: begin
			
			end
		endcase
		
	end
// --------------------------------------------------------------------
endmodule
// --------------------------------------------------------------------