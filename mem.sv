module memory (
	
	// ------------------------------------------------------------ 
	// Inputs
	// ------------------------------------------------------------
	input wire [1:0] clk,
	input wire [1:0] l_s,
	input wire [3:0] addr,
	input wire [15:0] w_data,
	// ------------------------------------------------------------

	// ------------------------------------------------------------ 
	// Outputs
	// ------------------------------------------------------------
	output reg [15:0] 		r_data
	// ------------------------------------------------------------ 
	);

	reg [7:0] memory [15:0];

	initial begin
		$readmemh("test.txt", memory)
	end

	always @(posedge clk) begin
  		if (l_s == 2'b01) begin
   			memory[addr] <= w_data;
   		end
 	end
 	assign rd_data = (l_s ==2'b10) ? memory[addr]: 16'd0;

 endmodule