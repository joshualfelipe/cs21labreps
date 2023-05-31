`timescale 1ns / 1ps
module cutout_testbench();
    // initialize variables
    logic [31:0] instruction, wd3;      // input values to add
    logic clk, we3, muxcontrol;              // carry in
    logic [2:0] alucontrol;    // output
    logic zero;             // carry out
    logic [31:0]  result;              // clock

    // instantiate device under test
    cutout instantiated_cutout(instruction, wd3, clk, we3, muxcontrol, alucontrol, zero, result);

    initial begin
        // set clock to zero
        clk = 0;    // set clock to 0
        we3 = 1; #1;    // enable writing
        
        // set writing address to reg 1 or wa2 [15:11] to 1 and set writing data to 0xc0de0000
        // set other inputs to don't care values
        instruction = 'h00000800; wd3 = 'hc0de0000; muxcontrol = 1'dx; alucontrol = 1'dx; #2;
        
         // set writing address to reg 2 or wa2 [15:11] to 2 and set writing data to 0x0000babe
        // set other inputs to don't care values
        instruction = 'h00001000; wd3 = 'h0000babe; muxcontrol = 1'dx; alucontrol = 1'dx; #2;
        
        
        we3 = 0; #2; // disable writing
        
        // read the through the instructions. Get register values from reg 1 and 2 by reading bits [25:21] and [20:16]
        // set mux to 0 to read original value of reg 2. Set alucontrol to 010 to conduct addition
        instruction = 'h00220000; wd3 = 1'dx; muxcontrol = 0; alucontrol = 3'b010; #2;
        
        // read the through the instructions. Get register values from reg 1 and 2 by reading bits [25:21] and [20:16]
        // set mux to 0 to read original value of reg 2. Set alucontrol to 001 to conduct OR operation
        instruction = 'h00220000; wd3 = 1'dx; muxcontrol = 0; alucontrol = 3'b001; #2;
        
        // read the through the instructions. Get register values from reg 1 and 2 by reading bits [25:21] and [20:16]
        // set mux to 0 to read original value of reg 2. Set alucontrol to 000 to conduct AND operation
        instruction = 'h00220000; wd3 = 1'dx; muxcontrol = 0; alucontrol = 3'b000; #2;
                
    end

    // clock simulator
    // Simulate clock, 2ticks for clock cycle
    // hence 2ns each clock cycle
    always begin
        #1 clk = ~clk; 
    end
endmodule
