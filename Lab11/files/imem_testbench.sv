`timescale 1ns / 1ps

module dmem_testbench();

logic [5:0] a;      // 6 bit input
logic [31:0] rd;    // 32 bit output
logic clk;          // clock

imem instantiated_imem(a, rd);
    // setup initial values
  initial begin
    clk = 0;    // set clock to 0
    
    // since we are only going to implement a lookup table the 
    // output are hardcoded in the memfile. The 32 bit output are
    // written in hex values.
    // In order to output properly in vivado, I used a for loop to avoid
    // repeteated lines of code. This for loop would iterate through all
    // possible 6 bit combinations or 0 - 63 in decimal
    for(a = 0; a <= 63; a = a + 1)begin
        #2;     // wait for 1 clock cycle before checking next value
    end
  end

    // clock simulator
    // Simulate clock, 2ticks for clock cycle
    // hence 2ns each clock cycle
    always begin
        #1 clk = ~clk; 
    end
endmodule

