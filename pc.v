module pc(clk, reset, input_pc, rn, rm, stall, branch, bOffset, rs_boolean, conditionBool, output_pc, instruction );
  input wire clk, reset, branch, rs_boolean, conditionBool, stall;
  input wire [15:0] input_pc, bOffset, instruction;
  input wire [3:0] rn, rm;
  output reg [15:0] output_pc;

  reg stall_flag;
  reg [1:0] ps, ns;
  reg [15:0] offset;
  
  wire [1:0] typeOfInstruction;
  wire rm_flag;
  
  assign typeOfInstruction = instruction[27:26];

  assign rm_flag = (((typeOfInstruction == 2'b00)&&(~instruction[25]))||((typeOfInstruction == 2'b01)&&(instruction[25])));
  
  always @(*) begin

    if (reset) begin 
	 
		output_pc = 16'b0;
		stall_flag = 0;
		offset = 16'b0;
		ns = 1'b0;
	 end
	 else begin


		 if (branch && conditionBool) stall_flag = 1;
		 else stall_flag = 0;
			
		 if (stall_flag && (ps == 2'b00)) offset = bOffset-1;
		 else offset = 32'b0;
		 
		 case(ps)
			1'b0: begin

			  if (stall_flag) begin 
					ns = 1'b1;
					output_pc = input_pc + offset;
			  end
			  else begin 
				  ns = 1'b0;
				  //Prefetch logic
				if (stall) output_pc = input_pc;
				else begin
					if (!branch && conditionBool) begin
						if ((rn==4'b1111) || ((rm==4'b1111)&&rm_flag)) begin
						  if (rs_boolean) output_pc = input_pc + (3);
						  else output_pc = input_pc + (2);
						end
						else output_pc = input_pc + (1);
					end
					else output_pc = input_pc + (1);
					 
				end
				 
			  end
			end
			1'b1: begin 
				ns = 1'b0;
				output_pc = input_pc;
			end
			default: begin
			  ns = 1'b0;
			  ps = 1'b0;
			end
		 endcase
	 end
  end

  always @(posedge clk) begin
    if (reset) ps <= 1'b0;
    else ps <= ns;
  end

endmodule
