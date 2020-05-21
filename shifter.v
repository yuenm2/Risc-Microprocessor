module shifter (reset, I, LS, operand2, inValue, reg_shift_value, cpsr, out, shifter_carry);

  input wire reset, I, LS; //I=Immediate_Operand, S=Set_Condition_Codes, LS=LDR_or_STR
  input wire [11:0] operand2;
  input wire [15:0] inValue; //The value located in the 2nd operand register (Rm)
  input wire [15:0] reg_shift_value; //The shift value (output of the reg_file)
  input wire [15:0] cpsr; //n, z, c, v
  reg [7:0] shift_value; //The actual shift amount
  reg [15:0] value; //The value to be shifted
  reg [2:0] shift_type; //The type of shift instruction[6:5]
  reg [5:0] rotate_value;
  output reg [15:0] out; // The correct offset value
  output reg shifter_carry;

 

  always @(*) begin
    if ((I&&LS) || ((~I)&&(~LS))) begin //offset is a register (Rs)
      value = inValue;
      shift_type = {1'b0, operand2[6:5]};
    end
    else if ((~I)&&LS) begin //Out is an immediate value
      shift_type = 3'b100;
		value = 16'b0;
    end
    else begin //operand2 is an immediate value to be rotated
      value = {23'b0, operand2[7:0]};
      shift_type = 3'b011;
    end
		
	 //Shift contains a shift register
    if (((~I)&&operand2[4]&&(~LS))||(I&&operand2[4]&&LS)) begin
      shift_value = reg_shift_value[7:0];
    end
	 //Shift is a 5 bit integer
    else begin
      shift_value = {3'b0, operand2[11:7]};
    end
	 
	 rotate_value = operand2[11:8] + operand2[11:8];
	 if (rotate_value > 31) rotate_value = rotate_value % 32; //rotate_value in range 0 to 32
  end

  always @(*) begin
	 out = 16'b0;
    shifter_carry = 0;
    case(shift_type)
      3'b000: begin //logical left
        out = value << shift_value;
        if ((shift_value > 0)&&(shift_value < 32)) shifter_carry = value[31-shift_value];
        else if (shift_value == 0) shifter_carry = cpsr[29];
        else begin //shift value is greater than 31
          if ((shift_value==32)&&((value<<shift_value)==0)) shifter_carry = inValue[0];
          else if ((shift_value>32)&&(value<<shift_value)==0) shifter_carry = 0;
        end
      end
      3'b001: begin //logical right
        out = value >> shift_value;
        if ((shift_value > 0)&&(shift_value < 32)) shifter_carry = value[shift_value-1];
        else begin //shift value is greater than 31
          if ((shift_value==32)&&((value<<shift_value)==0)) shifter_carry = inValue[31];
          else if ((shift_value>32)&&(value<<shift_value)==0) shifter_carry = 0;
        end
      end
      3'b010: begin //Arithmetic right
        out = value >>> shift_value;
        if ((shift_value > 0)&&(shift_value < 32)) shifter_carry = value[shift_value-1];
        else if ((shift_value>32)&&(value<<shift_value)==0) shifter_carry = inValue[31];
      end
      3'b011: begin //rotate right
		  if (rotate_value == 0) out = value;
		  else out = (value << (6'b100000 + {1'b1, ~rotate_value} + 1'b1)) | (value >> rotate_value);
        shifter_carry = value[31];
      end
      3'b100: begin
        out = {20'b0, operand2};
      end
      default: begin
        out = 16'b0;
        shifter_carry = 0;
      end
    endcase
  end

endmodule
