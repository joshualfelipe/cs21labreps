`timescale 1ns / 1ps
module alu(input  logic [31:0] a, b,
           input  logic [3:0]  alucontrol,
           output logic [31:0] result,
           output logic        zero);
  
  logic [31:0] condinvb, sum;
  assign condinvb = alucontrol[3] ? ~b : b;
  assign sum = a + condinvb + alucontrol[3];
 
  always_comb
    case (alucontrol[2:0])
      3'b000: result = a & b;
      3'b001: result = a | b;
      3'b010: result = sum;
      3'b011: result = sum[31];
      3'b100: result = a ^ b;       // XORI
      3'b101: result = {b, 16'b0};  // LUI
      3'b110: result = b >> a;      // SRLV
      3'b111: result = b;           // LI
    endcase

  assign zero = (result == 32'b0);
endmodule