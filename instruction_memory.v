module instruction_memory (clk, reset, address, instruction);

	input wire [15:0] address;
   input wire reset, clk;
	output reg [15:0] instruction;

	reg [15:0] memory [0:31];

	initial begin
		 //Set these values to 0 once this module has proven to work
		 // remove the comment to read from text file
		 $readmemb("../../src/verilog/instructions.txt",memory);
		 	/*
			memory[0]  <= 32'b11100001010000010001000000000000; //AL CMP R1, R0 || R0 shift 0
			
			memory[1]  <= 32'b00001011000000000000000001000000; //BLEQ 0x64 ||condition not met
			memory[2]  <= 32'b00011010000000000000000000000010; //BNE 0x1 10
			memory[3]  <= 32'b11100011101001000011000000001000; //AL MOV R3, #8  ||instruction should do nothing
			memory[4]  <= 32'b11100011101001000011000000001010; //AL MOV R3, #10 || instruction should do nothing
			memory[5]  <= 32'b0;
			memory[6]  <= 32'b0;
			memory[7]  <= 32'b0;
			memory[8]  <= 32'b0;
			memory[9]  <= 32'b0;
			memory[10] <= 32'b11100001101001000011000000000100; //AL MOV R3, R4  || R4 shift 0 -> R3 = 4;
			memory[11] <= 32'b11100001111001010101000000000100; //AL MVN R5, R3  || R5 should equal ~(32'b4) -> R4 = ~R3
			memory[12] <= 32'b11100010100001100110000000000111; //AL ADD R6, R6 #7 || -> R6 = 6 + 7;
			memory[13] <= 32'b11100010010001110111000000001000; //AL SUB R7, R7 #8 || -> R7 = 7 + 8;
			memory[14] <= 32'b11100001000110110100000000001100; //AL TST R13, R12 | R13 && R12
			memory[15] <= 32'b11100000100010001001000000001011; //AL ADD R9, R8, R11 || -> R1 = 8 + 11;
			memory[16] <= 32'b00000001010000011010000000000000; //Condition fails
			memory[17] <= 32'b11100001000000010001000000000000; //TST R1, R1, R0
			memory[18] <= 32'b11100001001000010001000000000000; //TEQ R1, R1, R0
			memory[19] <= 32'b11100000100000010001000000000000; //ADD R1, R1, R0
			memory[24] <= 32'b11101010000000000000000000000001; //B #4
			memory[21] <= 32'b11100101010100000001000000000001; // Load I U False P B W true R0 R1 Offset
			memory[22] <= 32'b11100101010000000001000000000001; // Store I U False P B W true R0 R1 Offset
			memory[23] <= 32'b11100101011100000001000000000001; // Load I w U False P B true R0 R1 Offset
			memory[20]  <= 32'b0;
			memory[25]  <= 32'b0;
			memory[26]  <= 32'b0;
			memory[27]  <= 32'b0;
			memory[28]  <= 32'b0;
			memory[29]  <= 32'b0;
			memory[30]  <= 32'b0;
			memory[31]  <= 32'b0;
			*/
		
	end
	
	always @(posedge clk) begin
		instruction <= memory[address];
	end


endmodule

