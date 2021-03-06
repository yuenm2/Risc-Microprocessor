module mux2
	(
	// ------------------------------------------------------------ 
	// Inputs
	// ------------------------------------------------------------
	input [15:0] data1,
	input [15:0] data0,
	input select,
	// ------------------------------------------------------------

	// ------------------------------------------------------------ 
	// Outputs
	// ------------------------------------------------------------
	output [15:0] out
	// ------------------------------------------------------------ 
	);

// -------------------------------------------------------------------- 
// Logic Declaration
// --------------------------------------------------------------------	
	always @(*) begin

		if(select) out = data1;
		else out = data0;

	end
// --------------------------------------------------------------------
endmodule
// --------------------------------------------------------------------

