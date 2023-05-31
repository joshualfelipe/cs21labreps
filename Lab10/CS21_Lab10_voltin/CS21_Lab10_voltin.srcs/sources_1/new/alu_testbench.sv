`timescale 1ns / 1ps
module alu_testbench();
    // initialize variables
    logic clk;              // clock
    logic [31:0] a, b;      // input values to do operations with
    logic [2:0]  alucontrol; // alucontrol inputs
    logic [31:0] result;   // output
    logic zero;  // bool output case when output = 0 

    // instantiate device under test
    alu instantiated_alu(a, b, alucontrol, result, zero);

    initial begin
        // set clock to zero
        clk = 0;
        
        // testcase 1: add a and b. set alucontrol to 010
        a = 'hDEAD0000; b = 'h0000BEEF; alucontrol = 3'b010; #2;
        // result should be 0xdeadbeef
        
        // wait for 1 clock cycle
        // testcase 2: and a and b. set alucontrol to 000
        a = 'hC0DEBABE; b = 'h0000FFFF; alucontrol = 3'b000; #2;
        // result should be 0x0000babe

        // wait for 1 clock cycle
        // testcase 3: or a and b. set alucontrol to 001
        a = 'hC0DE0000; b = 'h0000BABE; alucontrol = 3'b001; #2;
        // result should be 0xc0debabe
        
        // wait for 1 clock cycle
        // testcase 4: subtract a and b. set alucontrol to 010
        // logic, negate b and add 1 to get the 2s complement of b
        // then add it to a to get ~b + a or b - a
        a = 'h0000BABE; b = 'hC0DEBABE; alucontrol = 3'b110; #2;
        // result shoule be: 3F220000 (equivalent to 1c0de0000)
        
    end

    // clock simulator
    // Simulate clock, 2ticks for clock cycle
    // hence 2ns each clock cycle
    always begin
        #1 clk = ~clk; 
    end
endmodule