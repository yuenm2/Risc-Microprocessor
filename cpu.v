module cpu(
  input wire clk,
  input wire nreset,
  output wire led,
  output wire [7:0] debug_port1,
  output wire [7:0] debug_port2,
  output wire [7:0] debug_port3,
  output wire [7:0] debug_port4,
  output wire [7:0] debug_port5,
  output wire [7:0] debug_port6,
  output wire [7:0] debug_port7
  );

  // Controls the LED on the board.
  assign led = 1'b1;

  wire reset;
  assign reset = ~nreset;

  wire [15:0] write_back;
  reg [15:0] pc; //logic for pc
  wire [15:0] npc;
  //Register_file variables
  
  reg[1:0] typeOfInstruction;

  reg rm_flag, alu_condition_in;
  
  wire wr1, wr2;
  reg [15:0] processed_reg1_value, processed_reg2_value, processed_reg3_value;
  wire [15:0] wr_data1, wr_data2;
  wire [3:0] rd_reg1, rd_reg2;
  wire [3:0] wr_reg1, wr_reg2;

  wire [15:0] bOffset, reg2Value, reg1Value, rnValue, rmValue;
  wire branch, branchLink, LS, read_reg, rs_boolean, wr_reg, reg_file_read, stall;
  wire [3:0] rd, rn, rm, rs;

  //logic for the ALU unit
  //bits: 31=N, 30=Z, 29=C, 28=F flags
  wire [15:0] cpsr_reg, alu_out, shift_out, alu_out_Dmem;

  //Logic for Dmem_r
  wire [15:0] Dmem_out;

  //Registers to hold the conditional boolean values for different instructions and hold the different instructions
  wire [15:0] instruction_Imem, instruction_reg_file, instruction_alu, instruction_Dmem;
  wire condition_decoder, condition_reg_file, condition_alu, condition_Dmem;
  wire LS_decoder, LS_reg_file, LS_alu, LS_Dmem;

  //Fetches instruction from instruction memory this should be running all the time
	instruction_memory instr_mem (clk, reset, pc, instruction_Imem);
  //Decodes instruction for printing and branching logic
	decoder decode (clk, reset, instruction_Imem, cpsr_reg, condition_decoder, bOffset, branch, branchLink, LS_decoder, rd, rn, rm, rs, read_reg, rs_boolean, wr_reg);
  //Handles PC value updating
  //assign pc = npc;
  pc pc_logic (clk, reset, pc, rn, rm, stall, branch, bOffset, rs_boolean, condition_decoder, npc, instruction_Imem);

  //If a branch occurs or boolean condition is not met, then the rest of this code should not run for the instruction
  //Instantiates register_file, need to run the control logic through the FSM before using in the register file
  //One write logic is solely for R15 (PC) and the other write logic is for write back
  assign reg_file_read = (read_reg && condition_decoder);
  register_file reg_file (clk, reset, stall, condition_decoder, LS_decoder, instruction_Imem, wr_data1, wr_data2, wr1, wr2, wr_reg1, wr_reg2, rn, rm, reg_file_read, reg1Value, reg2Value, instruction_reg_file, condition_reg_file, LS_reg_file, rd_reg1, rd_reg2);

  //operandforwarding
  operandForwarding opF (reset, instruction_reg_file, instruction_alu, instruction_Dmem, reg1Value, reg2Value, alu_out, Dmem_out, rnValue, rmValue);
  operandStall opS (clk, reset, instruction_alu, instruction_reg_file, stall);
  
  always @(*) begin
    typeOfInstruction = instruction_reg_file[27:26];

    rm_flag = (((typeOfInstruction == 2'b00)&&(~instruction_reg_file[25]))||((typeOfInstruction == 2'b01)&&(instruction_reg_file[25])));
    //Add conditional boolean check for the current instruction
    if (rd_reg1==4'b1111) begin
      if (rs_boolean) processed_reg1_value = rnValue - (3);
      else processed_reg1_value = rnValue - (2);
    end
    else processed_reg1_value = rnValue;
    if (rd_reg2==4'b1111 && rm_flag) begin
      if (rs_boolean) processed_reg2_value = rmValue - (3);
      else processed_reg2_value = rmValue - (2);
    end
    else processed_reg2_value = rmValue;
	 
	 if(stall) alu_condition_in = 0;
	 else alu_condition_in = condition_reg_file;
  end
  
  //ALU unit
  alu single_alu (clk, reset, alu_condition_in, LS_reg_file, instruction_reg_file, processed_reg1_value, processed_reg2_value, processed_reg3_value, alu_out, cpsr_reg, shift_out, condition_alu, instruction_alu, LS_alu);

  //Dynamic memory for LDR/STR
  Dmem_r dynamic_mem (clk, reset, instruction_alu, alu_out, reg1Value, reg2Value, condition_alu, LS_alu, shift_out, Dmem_out, write_back, condition_Dmem, LS_Dmem, alu_out_Dmem, instruction_Dmem); //Need rdAddr from shifter

  write_back wrb (clk, reset, condition_Dmem, branch, branchLink, LS_Dmem, bOffset, pc, Dmem_out, alu_out_Dmem, instruction_Dmem, rs_boolean, wr1, wr2, wr_reg1, wr_reg2, wr_data1, wr_data2, write_back);

	always @(posedge clk) begin
		if (reset) begin
      pc <= 16'b0;
    end
		else begin
      pc <= npc;
		end
	end
endmodule

