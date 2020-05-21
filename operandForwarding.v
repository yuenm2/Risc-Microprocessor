module operandForwarding (reset, instruction_reg_file, instruction_alu, instruction_Dmem, reg_rnValue, reg_rmValue, alu_out, Dmem_out, rnValue, rmValue);
	input wire reset;
	input wire [15:0] reg_rnValue, reg_rmValue, alu_out, Dmem_out;
	input wire [15:0] instruction_reg_file, instruction_alu, instruction_Dmem;
	output reg [15:0] rnValue, rmValue;
	
	wire [3:0] reg_rn, reg_rm, alu_rd, Dmem_rd, Dmem_opCode, alu_opCode;
	wire [1:0] alu_type_instruction, Dmem_type_instruction;
	reg choose_alu, choose_Dmem;
	
	assign reg_rn = instruction_reg_file[19:16];
	assign reg_rm = instruction_reg_file[3:0];
	assign alu_rd = instruction_alu[15:12];
	assign Dmem_rd = instruction_Dmem[15:12];
	
	assign alu_type_instruction = instruction_alu[27:26];
	assign alu_opCode = instruction_alu[24:21];
	assign Dmem_type_instruction = instruction_Dmem[27:26];
	assign Dmem_opCode = instruction_Dmem[24:21];
	
	always @(*) begin
		if (alu_type_instruction!=2'b10) begin
			if (alu_type_instruction==2'b00&&((alu_opCode==4'b1000)||(alu_opCode==4'b1001)||(alu_opCode==4'b1010))) choose_alu = 0;
			else choose_alu = 1;
		end 
		
		else choose_alu = 0;
		
		if (Dmem_type_instruction!=2'b10) begin
			if (Dmem_type_instruction==2'b00&&((Dmem_opCode==4'b1000)||(Dmem_opCode==4'b1001)||(Dmem_opCode==4'b1010))) choose_Dmem = 0;
			else choose_Dmem = 1;
		end 
		
		else choose_Dmem = 0;
		
		if ((reg_rn==alu_rd)&&choose_alu) begin
			rnValue = alu_out;
		end
		else if ((reg_rn==Dmem_rd)&&choose_Dmem) begin
			rnValue = Dmem_out;
		end
		else begin
			rnValue = reg_rnValue;
		end
		
		if ((reg_rm==alu_rd)&&choose_alu) begin
			rmValue = alu_out;
		end
		else if ((reg_rm==Dmem_rd)&&choose_Dmem) begin
			rmValue = Dmem_out;
		end
		else begin
			rmValue = reg_rmValue;
		end
	end 
	
endmodule 