module mux8
	(
	// ------------------------------------------------------------ 
	// Inputs
	// ------------------------------------------------------------
	input [15:0] data0,
	input [15:0] data1,
	input [15:0] data2,
	input [15:0] data3,
	input [15:0] data4,
	input [15:0] data5,
	input [15:0] data6,
	input [15:0] data7,
	input [15:0] data8,
	input [15:0] data9,
	input [15:0] data10,
	input [15:0] data11,
	input [15:0] data12,
	input [15:0] data13,
	input [15:0] data14,
	input [15:0] data15,
	input [3:0]select,
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

		case(select)
			4'b0000: begin
				out = data0;
			end
			4'b0001: begin
				out = data1;
			end
			4'b0010: begin
				out = data2;
			end
			4'b0011: begin
				out = data3;
			end
			4'b0100: begin
				out = data4;
			end
			4'b0101: begin
				out = data5;
			end
			4'b0110: begin
				out = data6;
			end
			4'b0111: begin
				out = data7;
			end
			4'b1000: begin
				out = data8;
			end
			4'b1001: begin
				out = data9;
			end
			4'b1010: begin
				out = data10;
			end
			4'b1011: begin
				out = data11;
			end
			4'b1100: begin
				out = data12;
			end
			4'b1101: begin
				out = data13;
			end
			4'b1110: begin
				out = data14;
			end
			4'b1111: begin
				out = data15;
			end
		endcase

	end
// --------------------------------------------------------------------
endmodule
// --------------------------------------------------------------------

