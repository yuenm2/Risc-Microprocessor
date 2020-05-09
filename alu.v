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
	output wire [15:0] OutputAdd,
	output wire [15:0] OutputSub,
	output wire [15:0] OutputAnd,
	output wire [15:0] OutputOr,
	output wire [15:0] OutputXor,
	output wire [15:0] OutputNot,
	output wire [15:0] OutputCMP
	
	output wire carry;
	// ------------------------------------------------------------ 
	);

// -------------------------------------------------------------------- 
// Logic Declaration
// --------------------------------------------------------------------	
	assign {carry, OutputAdd} = op1+op2;
	assign {carry, OutputSub} = op1+~op2+1;
	assign OutputAnd = op1&op2;
	assign OutputOr  = op1|op2;
	assign OutputXor = op1^op2;
	assign OutputNot = ~op1   ;
	assign {carry, OutputCMP} = op1+~op2+1;
	
// --------------------------------------------------------------------


endmodule
// --------------------------------------------------------------------

