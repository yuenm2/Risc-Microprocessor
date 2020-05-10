module branch (
	
	// ------------------------------------------------------------ 
	// Inputs
	// ------------------------------------------------------------
	input wire [3:0] 	op,
	input wire 			zd_flag,
	input wire 			carry_flag,
	input wire 			overflow_flag,
	input wire 			negative_flag,
	// ------------------------------------------------------------

	// ------------------------------------------------------------ 
	// Outputs
	// ------------------------------------------------------------
	output reg 			do_branch;

	);

	always @(*) begin
		case(op)
			4'd0: begin
				do_brach = (zd_flag == 1);
			end
			4'd1: begin
				do_brach = (zd_flag == 0);
			end
			4'd2: begin
				do_brach = (carry_flag == 1);
			end
			4'd3: begin
				do_brach = (carry_flag == 0);
			end
			4'd4: begin
				do_brach = (negative_flag == 1);
			end
			4'd5: begin
				do_brach = (negative_flag == 0;
			end
			4'd6: begin
				do_brach = (overflow_flag == 1);
			end
			4'd7: begin
				do_brach = (overflow_flag == 0);
			end
			4'd8: begin
				do_brach = (carry_flag == 1 & zd_flag == 0);
			end
			4'd9: begin
				do_brach = (carry_flag == 0 | zd_flag == 1);
			end
			4'd10: begin
				do_brach = (negative_flag == overflow_flag);
			end
			4'd11: begin
				do_brach = (~negative_flag == overflow_flag);
			end
			4'd12: begin
				do_brach = (zd_flag == 0 & negative_flag == overflow_flag);
			end
			4'd13: begin
				do_brach = (zd_flag == 1 | ~negative_flag == overflow_flag);
			end
			4'd14: begin
				do_brach = 1'b1;
			end
			4'd15: begin
				do_brach = 1'b0;
			end
		
	end



// --------------------------------------------------------------------
endmodule
// 