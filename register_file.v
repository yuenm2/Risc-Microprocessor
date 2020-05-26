//Values stored in the registers will be treated as unsigned values, if there
//is a need to store a signed value, the value will be converted to unsigned
//before being stored into the register.


module register_file (clk, reset, stall, condition_in, LS_in, instruction_in, wrData1, wrData2, wr1, wr2, wrReg1, wrReg2, rdReg1, rdReg2, rd1, out1, out2, instruction_out, condition_out, LS_out, rd_reg1, rd_reg2);

	input wire reset, wr1, wr2, rd1, clk, condition_in, LS_in, stall;
	input wire [15:0] wrData1, wrData2, instruction_in;
	input wire [3:0] wrReg1, wrReg2, rdReg1, rdReg2;
	reg [15:0] registers [15:0];
	output reg [15:0] out1, out2, instruction_out;
	output wire[3:0] rd_reg1, rd_reg2;
	output reg condition_out, LS_out;

	initial begin
	
		registers[0]  <= 16'b0000000000000000;
		registers[1]  <= 16'b0000000000000001;
		registers[2]  <= 16'b0000000000000010;
		registers[3]  <= 16'b0000000000000011;
		registers[4]  <= 16'b0000000000000100;
		registers[5]  <= 16'b0000000000000101;
		registers[6]  <= 16'b0000000000000110;
		registers[7]  <= 16'b0000000000000111;
		registers[8]  <= 16'b0000000000001000;
		registers[9]  <= 16'b0000000000001001;
		registers[10] <= 16'b0000000000001010;
		registers[11] <= 16'b0000000000001011;
		registers[12] <= 16'b0000000000001100;
		registers[13] <= 16'b1000000000000000;
		registers[14] <= 16'b0000000000001110;
		registers[15] <= 16'b0000000000000000;
			
	end
	
  //Logic for reading and writing to registers
	always @(posedge clk) begin
    //Write logic
		if (wr1) registers[wrReg1] <= wrData1;
		
    //Read logic
		if (rd1) begin
			out1 <= registers[rdReg1];
		 	out2 <= registers[rdReg2];
		end
		
		if (condition_in&&(!stall)) begin
			instruction_out <= instruction_in;
			condition_out <= condition_in;
			LS_out <= LS_in;
		end
	end
	
	assign rd_reg1 = rdReg1;
	assign rd_reg2 = rdReg2;

endmodule
