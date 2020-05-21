module write_back(clk, reset, conditionBool, branch, branchLink, LS, bOffset, pc, Dmem_out, alu_out, instruction, rs_boolean, wr1, wr2, wr_reg1, wr_reg2, wr_data1, wr_data2, wb);
  input wire reset, conditionBool, branch, branchLink, LS, rs_boolean, clk;
  input wire [15:0] bOffset, pc, Dmem_out, alu_out, instruction, wb;
  output reg wr1, wr2;
  output reg [3:0] wr_reg1, wr_reg2;
  output reg [15:0] wr_data1, wr_data2;
  
  wire [1:0] typeOfInstruction;
  wire [3:0] rm, rn, rd, opCode;
  wire rm_flag, wr1_1, wr1_2;

  assign typeOfInstruction = instruction[27:26];
  assign opCode = instruction[24:21];
  assign wr1_1 = (typeOfInstruction == 2'b00) && ((opCode!=4'b1000)&&(opCode!=4'b1001)&&(opCode!=4'b1010));
  assign wr1_2 = (typeOfInstruction == 2'b01) && instruction[20]; //LOAD
  assign rm = instruction[3:0];
  assign rn = instruction[19:16];
  assign rd = instruction[15:12];
  
  assign typeOfInstruction = instruction[27:26];

  assign rm_flag = (((typeOfInstruction == 2'b00)&&(~instruction[25]))||((typeOfInstruction == 2'b01)&&(instruction[25])));

  always @(*) begin
    if (reset) begin
      wr1 = 0;
      wr2 = 0;
      wr_data1 = 16'b0;
      wr_data2 = 16'b0;
      wr_reg1 = 4'b0;
      wr_reg2 = 4'b0;

    end
	 else begin
		 if (conditionBool) begin
			wr1 = (wr1_1 || branch || wr1_2) && conditionBool;
			wr2 = (branch && conditionBool && branchLink) || (LS && instruction[21] && (rn != 4'b1111));
			if (branch && conditionBool) begin
			  if ((rn==4'b1111) || (rm==4'b1111 && rm_flag)) begin
				if (rs_boolean) wr_data1 = pc - (3) + bOffset;
				else wr_data1 = pc - (2) + bOffset;
			  end
			  else wr_data1 = pc - (1) + bOffset;
			 wr_reg1 = 4'b1111; //R15 update
			 if (branchLink) begin
			  //Don't account for prefetch
			  wr_data2 = {pc[31:2],2'b00}; //R14[1:0] are always cleared, unsure if the adjusting for prefetch here works
			  wr_reg2 = 4'b1110; //R14 update
			 end
			 else begin
				wr_data2 = 32'b0;
				wr_reg2 = 4'b0;
			 end 
			end
			else begin
			  wr_reg1 = rd;
			  //data depends on if the instruction loads from a register or not
			  wr_data1 = (LS && instruction[20]) ? Dmem_out : alu_out;
			  if (LS && instruction[21] && (rn != 4'b1111)) begin
				 wr_reg2 = rn;
				 wr_data2 = wb;
			  end
			  else begin
				wr_reg2 = 4'b0;
				wr_data2 = 16'b0;
			  end
			end
		  end
		  
		  else begin
			wr1 = 0;
			wr2 = 0;
			wr_data1 = 16'b0;
			wr_data2 = 16'b0;
			wr_reg1 = 4'b0;
			wr_reg2 = 4'b0;
		  end
		  
	  end
    end

endmodule
