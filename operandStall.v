module operandStall(clk, reset, instruction_alu, instruction_reg_file, stall);
	input wire clk, reset;
	input wire [15:0] instruction_alu, instruction_reg_file;
	output reg stall;
	
	reg ps, ns;
	wire load, branch;
	wire [3:0] reg_rn, reg_rm, alu_rd;
	
	assign load = (instruction_alu[27:26]==2'b01)&&instruction_alu[20];
	assign reg_rn = instruction_reg_file[19:16];
	assign reg_rm = instruction_reg_file[3:0];
	assign alu_rd = instruction_alu[15:12];
	assign branch = instruction_reg_file[27:26]==2'b10;
	
	always @(*) begin
		case(ps)
			1'b0: begin
				stall = 0;
				if (load&&((reg_rn==alu_rd)||(reg_rm==alu_rd))&&!branch) begin
					ns = 1'b1;
				end
				else ns = ps;
			end
			1'b1: begin
				ns = 1'b0;
				stall = 1;
			end
			
		endcase
	end
	
	always @(posedge clk) begin
		if (reset) ps <= 0;
		else ps <= ns;
	end
	
	

endmodule 