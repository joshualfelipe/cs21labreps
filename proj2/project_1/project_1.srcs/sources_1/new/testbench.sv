`timescale 1ns / 1ps
module xori_testbench();

// initialize variables
logic clk;  // initialie clock
logic [15:0] a, b;  // initializes inputs a and b. 16bits that's why [15:0]
logic [15:0] s; // initialize output s

  // instantiate device under test
   xori #(16) instantiated_xori(a, b, s);
    
  initial begin
    clk = 0; // set initial value of clock to 0
    
    //testcase 1:
    a = 4'b0100; b = 4'b1010; #2;
    //testcase 1:
    a = 4'b1100; b = 4'b1100; #2;
   end

// set clock
always begin
    // 1ns for each tick, then 2ns for every clock cycle
    #1 clk = ~clk; 
end  
endmodule