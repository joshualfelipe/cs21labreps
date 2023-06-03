`timescale 1ns / 1ps

module aludec_testbench();

logic [5:0] funct;      // 6 bit funct code
logic [1:0] aluop;    // 1 bit aluop code
logic [2:0] alucontrol; // 3 bit output of alu
logic clk;          // clock

aludec instantiated_aludec(funct, aluop, alucontrol);
    // setup initial values
  initial begin
    clk = 0;    // set clock to 0
    
    // The aludec module will always read both values of funct and aluop
    // However, it will always check first the value of aluop.
    // If unsatisfied from the conditionals it would check the funct code.
    // Specific outputs for the alucontrol are given for every condition
    
    // Case 1: aluop: 00 -> valid output immediately to alucontrol 010     
    funct = 'b100000; aluop = 'b00; #2;
    
    // wait for 1 clock cycle
    // Case 2: aluop: 00 -> valid output immediately to alucontrol 010     
    funct = 'b100010; aluop = 'b00; #2;
    
    // wait for 1 clock cycle
    // Case 3: aluop: 11 -> invalid aluop check funct code: 100010 -> valid, output immediately alucontrol 110     
    funct = 'b100010; aluop = 'b11; #2;
    
    // wait for 1 clock cycle
    // Case 4: aluop: 10 -> invalid aluop check funct code: 100000 -> valid, output immediately alucontrol 010  
    funct = 'b100000; aluop = 'b10; #2;
    
    // wait for 1 clock cycle
    // Case 5: aluop: 10 -> invalid aluop check funct code: 100100 -> valid, output immediately alucontrol 000  
    funct = 'b100100; aluop = 'b10; #2;
  end

    // clock simulator
    // Simulate clock, 2ticks for clock cycle
    // hence 2ns each clock cycle
    always begin
        #1 clk = ~clk; 
    end
endmodule