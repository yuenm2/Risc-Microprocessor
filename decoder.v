module decoder (clk, reset, instruction, 
	
	// ------------------------------------------------------------ 
	// Inputs
	// ------------------------------------------------------------
	input wire clk,
	input wire reset,
	input wire [15:0] instruction,
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
	always @(*) begin
	
		case(instruction[15:12])
			4'b0000: begin
			
			end
			4'b0001: begin
				if(instruction[10:9] == 2'b00) begin // ADDS
				
				end
				else if(instruction[10:9] == 2'b01) begin // SUBS
				
				end 
				else if(instruction[10:9] == 2'b10) begin // ADDS IM
				
				end
				else begin // SUBS IM
				
				end
			
			end
			4'b0010: begin
				// MOVS
			end
			4'b0011: begin
			
			end
			4'b0100: begin
				if(instruction[10:8] == 3'b110) begin // MOV
				
				end
				else if (instruction[10:8] == 3'b111) begin
				
				end
				else if (instruction[10:8] == 3b'101) begin
				
				end
				else begin
					case(instruction[9:6])
						4'b0000: begin // ANDS
						
						end
						4'b0001: begin // EORS
						
						end
						4'b0010: begin // LSLS
						
						end
						4'b0011: begin // LSRS
						
						end
						4'b0100: begin
							if(instruction[10]) begin // BL <label
							
							end
							
							else begin // ASRS
							
							end
						
						end
						4'b0101: begin // 
						
						end
						4'b0110: begin //
						
						end
						4'b0111: begin //RORS
						
						end
						4'b1000: begin //
						
						end
						4'b1001: begin // 
						
						end
						4'b1010: begin // CMP
						
						end
						4'b1011: begin // 
						
						end
						4'b1100: begin // ORRS
						
						end
						4'b1101: begin // 
						
						end
						4'b1110: begin // BX RM
						
						end
						4'b1111: begin // MVNS
						
						end
					endcase
				end
			end
			4'b0101: begin
			
			end
			4'b0110: begin // LOAD STORE
				if(instruction[11]) begin
					
				end
				
				else begin
					
				end
			
			end
			4'b0111: begin
			
			end
			4'b1000: begin
			
			end
			4'b1001: begin
			
			end
			4'b1010: begin
			
			end
			4'b1011: begin
				if(!instruction[11]) begin
					if(instruction[7]) begin // ADD SP
					
					end
					else begin // SUB SP
					
					end
				end
				else begin // NOOP
				
				end
			
			end
			4'b1100: begin
			
			end
			4'b1101: begin // B<Cc>
			
			end
			4'b1110: begin // B <label>
			
			end
			4'b1111: begin
			
			end
		endcase
		
	end
	
	
// --------------------------------------------------------------------
endmodule
// --------------------------------------------------------------------
