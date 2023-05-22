`timescale 1ns / 1ps
module mux2_testbench();

// initialize variables
logic clk; // clock
logic [31:0] d0, d1;   // data stored in multiplexer. d0 and d1
logic s;               // selector
logic [31:0] y;        // data output

  // instantiate device under test
   mux2 #(32) instantiated_mux2(d0, d1, s, y);
    
  initial begin
    clk = 0; // set initial value of clock to 0
    
    // Testcase 1
    // set first the values of d0 and d1
    d0 = 1; d1 = 2; s = 0; #2; // select d0 and output 1 since s = 0
    
    // wait for 1 clock cycle
    // Testcase 2
    // set first the values of d0 and d1
    d1 = 1782; d0 = 3271; s = 0; #2; // select d0 and output 1782 since s = 0
    
    // wait for 1 clock cycle
    // Testcase 3
    // set first the values of d0 and d1
    d0 = 103; d1 = 1024; s = 0; #2; // select d0 and output 103 since s = 0
    
    // wait for 1 clock cycle
    // Testcase 4
    // set first the values of d0 and d1
    d0 = 68392; d1 = 10; s = 1; #2; // select d1 and output 10 since s = 0
    
    // wait for 1 clock cycle
    // Testcase 5
    // set first the values of d0 and d1
    d1 = 256; d0 = 512; s = 1; // select d1 and output 256 since s = 0
  end

// set clock
always begin
    // 1ns for each tick, then 2ns for every clock cycle
    #1 clk = ~clk; 
end  
endmodule