module alu (
	// ------------------------------------------------------------ 
	// Inputs
	// ------------------------------------------------------------
	input wire [15:0] op1,
	input wire [15:0] op2,
	// ------------------------------------------------------------

	// ------------------------------------------------------------ 
	// Outputs
	// ------------------------------------------------------------
	output wire [16:0] OutputAdd,
	output wire [16:0] OutputSub,
	output wire [15:0] OutputAnd,
	output wire [15:0] OutputOr,
	output wire [15:0] OutputXor,
	output wire [15:0] OutputNot,
	output wire [16:0] OutputCMP

	// ------------------------------------------------------------ 
	);

// -------------------------------------------------------------------- 
// Logic Declaration
// --------------------------------------------------------------------	
	assign OutputAdd = op1+op2;
	assign OutputSub = op1+~op2+1;
	assign OutputAnd = op1&op2;
	assign OutputOr  = op1|op2;
	assign OutputXor = op1^op2;
	assign OutputNot = ~op1   ;
	assign OutputCMP = op1+~op2+1;
	
// --------------------------------------------------------------------


endmodule
// --------------------------------------------------------------------