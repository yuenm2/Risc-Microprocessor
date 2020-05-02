module reg_file (
	// ------------------------------------------------------------ 
	// Inputs
	// ------------------------------------------------------------
	input wire clk,
	input wire we,
	input wire[3:0] w_addr,
	input wire[15:0] w_data,
	input wire[3:0] r_addr1,
	input wire[3:0] r_addr2,
	// ------------------------------------------------------------

	// ------------------------------------------------------------ 
	// Outputs
	// ------------------------------------------------------------
	output wire[15:0] r_data1,
	output wire[15:0] r_data2
	// ------------------------------------------------------------ 
	);

	reg [15:0] reg_array [15:0];
	
	always @(posedge clk) begin
		if(we) begin
			reg_array[w_addr] <= w_data;
		end
	end

	assign r_data1 = reg_array[r_addr1];
	assign r_data2 = reg_array[r_addr2];


endmodule
// --------------------------------------------------------------------
