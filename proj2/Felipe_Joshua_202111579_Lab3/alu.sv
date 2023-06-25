`timescale 1ns / 1ps
module alu(input  logic [31:0] a, b,
           input  logic [4:0]  alucontrol,
           output logic [31:0] result,
           output logic        zero);
  
  logic [31:0] condinvb, sum, xori;
  
  assign xori = {16'b0, b[15:0]};       // Zero extend the immediate
  assign condinvb = alucontrol[4] ? ~b : b;
  assign sum = a + condinvb + alucontrol[4];
  
  always_comb
    case (alucontrol[3:0])
      4'b0000: result = a & b;
      4'b0001: result = a | b;
      4'b0010: result = sum;
      4'b0011: result = sum[31];
      4'b0100: result = a^xori;         // XORI
      4'b0101: result = {b, 16'b0};     // LUI
      4'b0110: result = b >> a;         // SRLV
      4'b0111: result = b;              // LI
      4'b1000: result = (a[31] === 0 & a > 0) ? 0 : 1; // BGTZ - check if not negative and greater than 0
    endcase

  assign zero = (result == 32'b0);
endmodule