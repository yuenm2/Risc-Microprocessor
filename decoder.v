module decoder(clk, reset, instruction, cpsr_reg, conditionBool, bOffset, branch, branchLink, LS, rd, rn, rm, rs, read_reg, rs_boolean, wr_reg);

	input wire clk, reset;
	input wire [15:0] instruction, cpsr_reg;
	output reg conditionBool; //Stores whether or not the condition has been satisfied

	//Value storage for manipulation
	wire [3:0] condition;
	wire [1:0] typeOfInstruction;
	output reg wr_reg;

	//Branching information
	output reg branch, branchLink, read_reg, rs_boolean;
	output reg [15:0] bOffset;
	
	reg oldBranch, oldCondition, conditionBooln;

	//Codes for data processing
	output reg [3:0] rd, rn , rm, rs;
	wire [3:0] opCode;

	//bits for LDR
	output reg LS;

	//Bits that are constant regardless of type of instruction
	assign condition = instruction[11:8];
	assign typeOfInstruction = instruction[27:26];
	assign opCode = instruction[24:21];

	//Block handles logic for condition bits based off of CPSR register
	always @(*) begin
		case(condition) //Case statement for branching conditions
			4'b0000: conditionBooln = cpsr_reg[14]; //EQ: Z set
			4'b0001: conditionBooln = !cpsr_reg[14]; //NE: Z clear
			4'b0010: conditionBooln = cpsr_reg[13]; //CS: C set
			4'b0011: conditionBooln = !cpsr_reg[13]; //CC: C clear
			4'b0100: conditionBooln = cpsr_reg[15]; //MI: N set
			4'b0101: conditionBooln = !cpsr_reg[15]; //PL: N clear
			4'b0110: conditionBooln = cpsr_reg[12]; //VI: V set
			4'b0111: conditionBooln = !cpsr_reg[12]; //VC: V clear
			4'b1000: conditionBooln = (cpsr_reg[13] && !cpsr_reg[14]); //HI: C set and Z clear
			4'b1001: conditionBooln = (!cpsr_reg[13] || cpsr_reg[14]); //LS: C clear or Z set
			4'b1010: conditionBooln = (cpsr_reg[15]==cpsr_reg[12]); //GE: N equals V
			4'b1011: conditionBooln = (cpsr_reg[15]!=cpsr_reg[12]); //LT: N not equal to V
			4'b1100: conditionBooln = (!cpsr_reg[14] && (cpsr_reg[15]==cpsr_reg[12])); //GT: Z clear and (N equals V)
			4'b1101: conditionBooln = (cpsr_reg[14] || (cpsr_reg[15]!=cpsr_reg[12])); //LE: Z set or (N not equal to V)
			4'b1110: conditionBooln = 1; //AL: 1
			default: begin
							conditionBooln = 0;
						end
		endcase
	end

	integer j;

	//Instruction decoding logic
	always @(*) begin
		rn = instruction[19:16];
		rd = instruction[15:12];
		bOffset = 32'b0;
		branchLink = 0;
		branch = 0;
		LS = 0;
		rm = 4'b0;
		read_reg = 0;
		j = 0;
		wr_reg = 0;
		case(typeOfInstruction)
			2'b00: begin //Data Processing
				if ((opCode==4'b1000)||(opCode==4'b1001)||(opCode==4'b1010)) wr_reg = 0;
				else wr_reg = 1;
				read_reg = 1;
				
				if(!instruction[25]) rm = instruction[3:0];
			end

			2'b01: begin //LDR & STR
				LS = 1;
				read_reg = 1;
				if(instruction[20]) wr_reg = 1;
				else wr_reg = 0;
				if(instruction[25]) rm = instruction[3:0];
			end

			2'b10: begin //B or BL, branching instructions will be sent to the top module to do branch jumping
				//This should be interpreted as a signed 2's complement number
				//The 24 bit offset is shifted left 2 bits then signed extended to 32 bits
				bOffset = 32'b0;
				bOffset[23:2] = instruction[21:0];

				for (j=24; j<32; j = j + 1) begin
					bOffset[j] = bOffset[23];
				end

				branch = 1;
				branchLink = instruction[24];
				if (branchLink) begin
					rd = 4'b1110; //If branch link is true, current address should be stored in reg R14
				end
				rn = 4'b0;
				rm = 4'b0;
			end

			default: begin
							rn = instruction[19:16];
							rd = instruction[15:12];
							bOffset = 32'b0;
							branchLink = 0;
							branch = 0;
							LS = 0;
							read_reg = 0;
						end
		endcase

		//The shift is using a register value
		if((~LS && ~instruction[25] && instruction[4])||(LS && instruction[25] && instruction[4])) begin
			rs_boolean = 1;
			rs = instruction[11:8];
		end
		else begin
			rs = 4'b0;
			rs_boolean = 0;
		end
		
		if (oldBranch && oldCondition) conditionBool = 0;
		else conditionBool = conditionBooln;
	end

	always @(posedge clk) begin
		oldBranch <= branch;
		oldCondition <= conditionBool;
	end

endmodule

