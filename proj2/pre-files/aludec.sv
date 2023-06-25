`timescale 1ns / 1ps
module aludec(input  logic [5:0] op,
              input  logic [5:0] funct,
              input  logic [1:0] aluop,
              output logic [4:0] alucontrol);

   always_comb
    case(aluop)
      2'b00: alucontrol <= 5'b00010;                // add (for lw/sw/addi)
      2'b01: alucontrol <= 5'b10010;                // sub (for beq)
      2'b10: case(funct)                            // R-type instructions
          6'b100000: alucontrol <= 5'b00010;        // add
          6'b100010: alucontrol <= 5'b10010;        // sub
          6'b100100: alucontrol <= 5'b00000;        // and
          6'b100101: alucontrol <= 5'b00001;        // or
          6'b101010: alucontrol <= 5'b10011;        // slt
          6'b000110: alucontrol <= 5'b00110;        // SRLV
          default:   alucontrol <= 5'bxxxxx;        // ???
        endcase
      2'b11: case(op)                               // I-type instructions
          6'b001110: alucontrol <= 5'b00100;        // xori
          6'b001111: alucontrol <= 5'b00101;        // lui
          6'b011101: alucontrol <= 5'b01000;        // bgtz
          6'b010001: alucontrol <= 5'b00111;        // li
          default:   alucontrol <= 5'bxxxxx;        // ???
        endcase
    endcase
endmodule