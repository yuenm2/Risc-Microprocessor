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
	output reg [15:0] out
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
				if (shift == 16'b0) out = data;
				else out = (data << (6'b100000 + {1'b1, ~shift} + 1'b1)) | (data >> shift);
			end
			
			default: begin
				out = 16'b0;
			end
			
		endcase	
	end
// --------------------------------------------------------------------

endmodule
// --------------------------------------------------------------------

