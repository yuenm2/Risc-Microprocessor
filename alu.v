module alu(clk, reset, condition_in, LS_in, instruction, rnValue, rmValue, rsValue, out, cpsr, shift_out, condition_out, instruction_out, LS_out);
  input wire clk, reset, LS_in, condition_in;
  input wire [15:0] instruction;
  input wire [15:0] rnValue, rmValue, rsValue;
  wire [3:0] sel; //Will take in opCode
  reg [15:0] nOut; //Next output
  wire zFlag, cFlag, nFlag, S;
  reg vFlag;
  wire shifter_carry;
  output reg [15:0] cpsr, out, instruction_out;
  output wire [31:0] shift_out;
  output reg condition_out, LS_out;

  assign S = instruction[20];
  assign sel = instruction[24:21];

  shifter shift (reset, instruction[25], LS_in, instruction[11:0], rmValue, rsValue, cpsr, shift_out, shifter_carry);

  //Arithmetic block including logic for the CPSR register
  always @(*) begin
    case(sel)
      4'b0100: nOut = rnValue + shift_out; //Addition
      4'b0010: begin //Subtraction, do we need to specify signed or unsigned?
              //nOut = input1 + (~input2 + 1); //Signed subtraction
              nOut = rnValue - shift_out; //Unsigned subtraction
            end
      4'b0001: nOut = rnValue ^ shift_out; //Exclusive or
      4'b1010: begin //CMP
        if (shift_out[31]) nOut = rnValue + shift_out;
        else nOut = rnValue + (~shift_out + 1);
      end
      4'b1001: nOut = rnValue ^ shift_out; //TEQ
      4'b1000: nOut = rnValue & shift_out; //TST
      4'b1100: nOut = rnValue | shift_out; //ORR
      4'b1101: nOut = shift_out; //MOV
      4'b1110: nOut = rnValue & (~shift_out); //BIC
      4'b1111: nOut = ~shift_out; //MVN
      default: begin
                 nOut = 16'b0;
               end
    endcase
  end

  assign zFlag = (nOut==0);
  assign cFlag = shifter_carry;
  assign nFlag = nOut[31];

  always @(*) begin
    //vFlag logic
    //Signed overflow is true when two positive numbers sum to negative
    //two negative numbers sum to positive
    if (sel==4'b1010 || sel==4'b0100) vFlag = ((rnValue[31]==nOut[31]) && (nOut[31]!=rnValue[31]));
    else vFlag = 0;
  end

  always @(posedge clk) begin
    if (reset) begin
      out <= 0;
      cpsr <= 32'b0;
    end
    else if (condition_in) begin
      out <= nOut[31:0];

      //If set conditions code is true then update the CPSR register
      if (S && (instruction[27:26]==2'b00)) begin
        cpsr[15] <= nFlag;
        cpsr[14] <= zFlag;
        cpsr[13] <= cFlag;
        cpsr[12] <= vFlag;
      end
		
		condition_out <= condition_in;
		instruction_out <= instruction;
		LS_out <= LS_in;

    end
  end

endmodule

