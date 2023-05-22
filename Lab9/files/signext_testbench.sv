`timescale 1ns / 1ps
module signext_testbench();

// initialize variables
logic clk; // clock
logic [15:0] a;
logic [31:0] y;

  // instantiate device under test
   signext instantiated_signext(a, y);
    
  initial begin
    clk = 0;        // set initial value of clock to 0
    // wait for 1 clock cycle
    a = 1; #2;      // input is 0b0000000000000001
    // wait for 1 clock cycle
    a = 255; #2;    // input is 0b0000000011111111
    // wait for 1 clock cycle
    a = 65534; #2;  // input is 0b1111111111111110
    // wait for 1 clock cycle
    a = -15; #2;    // input is 0b1111111111110001
    // wait for 1 clock cycle
    a = -17920;     // input is 0b1011101000000000
    
  end

// set clock
always begin
    // 1ns for each tick, then 2ns for every clock cycle
    #1 clk = ~clk; 
end  
endmodule