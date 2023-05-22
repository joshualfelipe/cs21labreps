`timescale 1ns / 1ps
module regfile_testbench_2();

// initialize variables
logic clk; // clock
logic we3; // write enable
logic [4:0]  wa3; // wa3 write address
logic [31:0] wd3;   // data to write
logic [4:0]  ra1, ra2; // ra1 and ra2 register addresses, 
logic [31:0] rd1, rd2;  // data to read address in 1 and 2

  // instantiate device under test
   regfile instantiated_regfile(clk, we3, ra1, ra2, wa3, wd3, rd1, rd2);
    
  initial begin
   
    clk = 0; // set initial value of clock to 0
    we3 = 1; #1;     // enable write and wait for 1ns
    
    // Writing portion of code
    // iterate from 0 to 31 to write the values of i + 2 to ith register
    for (int i = 0; i <= 31; i=i+1) begin
        wa3 = i; wd3 = i + 2; #2;       // every one clock cycle iterate
    end
    
    we3 = 0; wa3 = 1'dx; wd3 = 1'dx;    // For readability
    
    
    // Reading portion of the code
    // iterate from 0 to 31 to read the values of ith register. Must use to registers
    // since requirement is to read two values per clock cycle
    for (int i = 0; i <= 31; i=i+2) begin
        ra1 = i;           // read the value of ith register
        ra2 = i + 1; #2;   // alongside read the value of i + 1 register
    end
    
    ra1 = 1'dx; ra2 = 1'dx;             // for readability
  end

// set clock
always begin
    // 1ns for each tick, then 2ns for every clock cycle
    #1 clk = ~clk; 
end  
endmodule