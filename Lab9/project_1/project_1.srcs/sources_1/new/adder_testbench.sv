`timescale 1ns / 1ps
module adder_testbench();

// initialize variables
logic clk;  // initialie clock
logic [15:0] a, b;  // initializes inputs a and b. 16bits that's why [15:0]
logic cin;  // initialize cin. For carry
logic [15:0] s; // initialize output s
logic cout; // initialize cout

  // instantiate device under test
   adder #(16) instantiated_adder(a, b, cin, s, cout);
    
  initial begin
    clk = 0; // set initial value of clock to 0
    
    // Testcase 1: check if cin works
    a = 0; b = 0; cin = 1; #2;
    
    // wait for 1 clock cycle
    // Testcase 2: max 4 bits addition
    a = 15; b = 15; cin = 0; #2;
    
    // wait for 1 clock cycle
    // Testcase 3: simple addition
    a = 64; b = 32; cin = 0; #2;
    
    // wait for 1 clock cycle
    // Testcase 4: added carry
    a = 1075; b = 618; cin = 1; #2;
    
    // wait for 1 clock cycle
    // Testcase 5: simple addition
    a = 4905; b = 1273; cin = 0; #2;
   
    // wait for 1 clock cycle
    // Testcase 6: carry addition with overflow
    a = 10728; b = 55000; cin = 1; #2;
    
    // wait for 1 clock cycle
    // Testcase 7: max addition
    a = 65535; b = 65535; cin = 0; #2;
    
    // wait for 1 clock cycle
    // Testcase 8: max addition with carry
    a = 65535; b = 65535; cin = 1; #2;
  end

// set clock
always begin
    // 1ns for each tick, then 2ns for every clock cycle
    #1 clk = ~clk; 
end  
endmodule