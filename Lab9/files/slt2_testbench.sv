`timescale 1ns / 1ps
module sl2_testbench();

// initialize variables
logic clk; // clock
logic [31:0] a, y; // input and output

  // instantiate device under test
   sl2 instantiated_sl2(a, y);
    
  initial begin
    clk = 0; // set initial value of clock to 0
    a = 1; #2;  // initialize a to be 1. shift left by 2
    
    // wait for 1 clock cycle
    a = 42; #2; // initialize a to be 42. shift left by 2
    
    // wait for 1 clock cycle
    a = 100; #2; // initialize a to be 100. shift left by 2
    
    // wait for 1 clock cycle
    a = 465; #2; // initialize a to be 465. shift left by 2
    
    // wait for 1 clock cycle
    a = 1903246; // initialize a to be 1903246. shift left by 2
  end

// set clock
always begin
    // 1ns for each tick, then 2ns for every clock cycle
    #1 clk = ~clk; 
end  
endmodule