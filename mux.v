module mux #(parameter length = 1,
		       sel_length = $clog2(length),
		       width = 16)
	(
	// ------------------------------------------------------------ 
	// Inputs
	// ------------------------------------------------------------
	input wire [length-1:0][width-1:0] data
	input wire [sel_length-1:0] select,
	// ------------------------------------------------------------

	// ------------------------------------------------------------ 
	// Outputs
	// ------------------------------------------------------------
	output wire [width-1:0] out
	// ------------------------------------------------------------ 
	);

// -------------------------------------------------------------------- 
// Logic Declaration
// --------------------------------------------------------------------	
	if(length == 1) begin
		assign out = data;
		wire open  = select;
	end
	
	else begin
		assign out = data[select];
	end
// --------------------------------------------------------------------
endmodule
// --------------------------------------------------------------------
