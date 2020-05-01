module decoder (clk, reset, instruction, 
	
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
	output wire [width-1:0] out,
	output wire [3:0] 		r_addr1,
	output wire [3:0] 		r_addr2,
	output wire 			we;
	output wire [3:0] 		w_addr1,
	output wire [15:0] 		w_data,
	output wire [2:0] 		alu_op;

	output wire 			move_const;

	output wire 			add_sub_const; // to used before the alu
	output wire [2:0] 		const3;

	output wire 			move;
	output wire [7:0] 		const8;
	// ------------------------------------------------------------ 
	);

// -------------------------------------------------------------------- 
// Logic Declaration
// --------------------------------------------------------------------
	logic [2:0] im3 = instruction[8:6];
	logic [2:0] im5 = instruction[10:6];
	logic [2:0] im6 = instruction[5:0];
	logic [2:0] im7 = instruction[6:0];
	logic [2:0] im8 = instruction[7:0];
	logic [2:0] im11 = instruction[10:0];

	logic [2:0] op; // 000: nothing, 001: add, 010: sub, 011: and

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
				w_data = {8'b00000000, im8};
				move = 1'b0;
				r_addr2 = 4'b0000;
				r_addr1 = 4'b0000;
			end
			/*4'b0011: begin
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
			4'b0100: begin
				if(instruction[10:8] == 3'b110) begin // MOV
					we = 1'b1;
					w_addr = {1'b0, instruction[3:0]};
					op = 3'b000;
					add_sub_const = 1'b0;
					move_const = 1'b0;
					move = 1'b1;
					const8 = im8;
					r_addr1 = instruction[6:3];
					r_addr2 = 4'b0000;
				end
				/*else if (instruction[10:8] == 3'b111) begin
					
				end*/
				else if (instruction[10:8] == 3b'101) begin // BL <lable>
				
				end
				else begin
					case(instruction[9:6])
						4'b0000: begin // ANDS
							we = 1'b1;
							w_addr = {1'b0, instruction[2:0]};
							op = 3'b011;
							add_sub_const = 1'b0;
							move_const = 1'b1;
							move = 1'b0;
							r_addr2 = {1'b0, instruction[2:0]};
							r_addr1 = {1'b0, instruction[2:0]};
						end
						4'b0001: begin // EORS
						
						end
						4'b0010: begin // LSLS
						
						end
						4'b0011: begin // LSRS
						
						end
						4'b0100: begin
							if(instruction[10]) begin // BL <label
							
							end
							
							else begin // ASRS
							
							end
						
						end
						4'b0101: begin // 
						
						end
						4'b0110: begin //
						
						end
						4'b0111: begin //RORS
						
						end
						4'b1000: begin //
						
						end
						4'b1001: begin // 
						
						end
						4'b1010: begin // CMP
						
						end
						4'b1011: begin // 
						
						end
						4'b1100: begin // ORRS
						
						end
						4'b1101: begin // 
						
						end
						4'b1110: begin // BX RM
						
						end
						4'b1111: begin // MVNS
						
						end
					endcase
				end
			end
			4'b0101: begin
			
			end
			4'b0110: begin // LOAD STORE
				if(instruction[11]) begin
					
				end
				
				else begin
					
				end
			
			end
			4'b0111: begin
			
			end
			4'b1000: begin
			
			end
			4'b1001: begin
			
			end
			4'b1010: begin
			
			end
			4'b1011: begin
				if(!instruction[11]) begin
					if(instruction[7]) begin // ADD SP
					
					end
					else begin // SUB SP
					
					end
				end
				else begin // NOOP
				
				end
			
			end
			4'b1100: begin
			
			end
			4'b1101: begin // B<Cc>
			
			end
			4'b1110: begin // B <label>
			
			end
			4'b1111: begin
			
			end
		endcase
		
	end
// --------------------------------------------------------------------
endmodule
// --------------------------------------------------------------------
