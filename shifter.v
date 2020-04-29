module shifter (
	// ------------------------------------------------------------ 
	// Inputs
	// ------------------------------------------------------------
	input wire [15:0] data,
	input wire [15:0] shift,
	input wire [1:0]  control,
	// ------------------------------------------------------------

	// ------------------------------------------------------------ 
	// Outputs
	// ------------------------------------------------------------
	output wire [15:0] out
	// ------------------------------------------------------------ 
	);

// -------------------------------------------------------------------- 
// Logic Declaration
// --------------------------------------------------------------------	
	always @( * ) begin
		case (control)
			2'b00: begin // Logic shift left
				out = data << shift;
			end
			
			2'b01: begin // Logic shift right
				out = data >> shift;
			end
			
			2'b10: begin // Arithmetic shift right
				out = data >>> shift;
			end
	
			2'b11: begin // Rotate right shift
				if (shift == 0) out = data;
				else out = {data[shift-1:0],data[16:shift]};
			end
			
			default: begin
				out = 16'b0;
			end
			
		endcase	
	end
// --------------------------------------------------------------------

endmodule
// --------------------------------------------------------------------

