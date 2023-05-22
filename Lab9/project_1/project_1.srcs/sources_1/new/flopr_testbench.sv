`timescale 1ns / 1ps
module flopr_testbench();

// initialize variables
logic clk, reset; // clock and reset
logic [31:0] d, q;   // d input and q output

  // instantiate device under test
   flopr #(32) instantiated_flopr(clk, reset, d, q);
    
  initial begin
    clk = 0; // set initial value of clock to 0
    
    d = 1; #2;  // no reset. start input with 1.
                // would only output during the next rising edge
    
    // wait for 1 clock cycle
    reset = 1; d = 90; #2;  // reset before reading 90
                            // will never get read by q since a new value will be
                            // read on the next rising edge
    
    // wait for 1 clock cycle
    reset = 0; d = 51; #2;  // no reset. immediately output 51 on the rising edge
    
    // wait for 1 clock cycle
    d = 100; #2             // no reset. output 100 on the next rising edge
    
    // wait for 1 clock cycle
    reset = 1; d = 65536;    // reset. will clear q and will never output 65536
  end

// set clock
always begin
    // 1ns for each tick, then 2ns for every clock cycle
    #1 clk = ~clk; 
end  
endmodule