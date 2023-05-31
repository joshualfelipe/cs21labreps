`timescale 1ns / 1ps

// These are all the necessary inputs to create cutout
// values were based on the diagram provided
module cutout(input  logic [31:0] instruction, wd3,
               input logic clk, we3, muxcontrol,
               input logic [2:0] alucontrol,
               output logic zero,
               output logic [31:0]  result);

// Additional wires to connect the different modules
logic [31:0] rd1, rd2, y, muxresult;


// instantiate the different modules to be used
// regfile module
regfile instantiated_regfile(clk, we3, instruction[25:21], instruction[20:16], instruction[15:11], wd3, rd1, rd2);

// sign extend module
signext instantiated_signext(instruction[15:0], y);

// 2-way multiplexer module
mux2 #(32) instantiated_mux2(rd2, y, muxcontrol, muxresult);

// alu module
alu instantiated_alu(rd1, muxresult, alucontrol, result, zero);


endmodule