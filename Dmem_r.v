module  Dmem_r (clk, reset, instruction, alu_in, rnAddr, rdAddr, condition_in, LS_in, shiftd, out, writeback, condition_out, LS_out, alu_out, instruction_out);

  input wire clk, reset, LS_in, condition_in;
  input wire [11:0] shiftd;
  input wire [15:0] instruction, alu_in;
  wire [3:0] rn, rd;
  input wire [15:0] rnAddr, rdAddr;
  reg [15:0] memory [0:50];
  output reg  [15:0] out;
  output reg  [15:0] writeback, alu_out, instruction_out;
  output reg condition_out, LS_out;
  reg [11:0] offset;
  wire I, P, U, L;
  reg W;
  reg [15:0] rnSub;

  assign I = instruction[25];
  assign P = instruction[24];
  assign U = instruction[23];
  assign L = instruction[20];
  assign rn = instruction[19:16];
  assign rd = instruction[15:12];

  always @(*) begin
		if(I) offset = shiftd;
		else offset = instruction[11:0];
    if(rn == 4'b1111) W = 0;
    else W = instruction[21];
	 if(U)
		rnSub = rnAddr - offset;
    else
		rnSub = rnAddr + offset;
  end
  integer i;
  
  initial begin
		 //Set these values to 0 once this module has proven to work
			memory[0]  <= 32'b11100001010000010001000000000000; //AL CMP R1, R0 || R0 shift 0
			
			memory[1]  <= 32'b00001011000000000000000001000000; //BLEQ 0x64 ||condition not met
			memory[2]  <= 32'b00011010000000000000000000000010; //BNE 0x1 10
			memory[3]  <= 32'b11100011101001000011000000001000; //AL MOV R3, #8  ||instruction should do nothing
			memory[4]  <= 32'b11100011101001000011000000001010; //AL MOV R3, #10 || instruction should do nothing
			memory[5]  <= 32'b00101010101010101010101010101010;
			memory[6]  <= 32'b00000000001111111111100000000000;
			memory[7]  <= 32'b01111100000000001011111111000000;
			memory[8]  <= 32'b01111110000000000111111111100001;
			memory[9]  <= 32'b01111000001010101010101000001111;
			memory[10] <= 32'b11100001101001000011000000000100; //AL MOV R3, R4  || R4 shift 0 -> R3 = 4;
			memory[11] <= 32'b11100001111001010101000000000100; //AL MVN R5, R3  || R5 should equal ~(32'b4) -> R4 = ~R3
			memory[12] <= 32'b11100010100001100110000000000111; //AL ADD R6, R6 #7 || -> R6 = 6 + 7;
			memory[13] <= 32'b11100010010001110111000000001000; //AL SUB R7, R7 #8 || -> R7 = 7 + 8;
			memory[14] <= 32'b11100001000110110100000000001100; //AL TST R13, R12 | R13 && R12
			memory[15] <= 32'b11100000100010001001000000001011; //AL ADD R9, R8, R11 || -> R1 = 8 + 11;
			
		end
  always @(posedge clk) begin


    if (LS_in && condition_in) begin

  		if (L) begin
  			out <= memory[rdAddr];
  			if(W) begin
  				if(P)
  					writeback <= memory[rnSub];
  				else
  					writeback <= memory[rnAddr];
  			end
  		end

  		else begin
  			if(rd == 4'b1111) begin
  				memory[rdAddr] <= rdAddr + 12;
  			end
  			else begin
  				memory[rdAddr] <= memory[rnAddr];
  			end

  			if(W) begin
  				if(P)
  					writeback <= memory[rnSub];
  				else
  					writeback <= memory[rnAddr];
  			end
  		end

	  end
	
		if (condition_in) begin
			 instruction_out <= instruction;
			 condition_out <= condition_in;
			 LS_out <= LS_in;
			 alu_out <= alu_in;
		end
  end


endmodule //


