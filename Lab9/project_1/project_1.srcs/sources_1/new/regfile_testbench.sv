`timescale 1ns / 1ps
module regfile_testbench();

// initialize variables
logic clk; // clock
logic we3; // write enable
logic [4:0]  ra1, ra2, wa3; // ra1 and ra2 register addresses, wa3 write address
logic [31:0] wd3;   // data to write
logic [31:0] rd1, rd2;  // data to read address in 1 and 2

  // instantiate device under test
   regfile instantiated_regfile(clk, we3, ra1, ra2, wa3, wd3, rd1, rd2);
    
  initial begin
    clk = 0; // set initial value of clock to 0
    ra1 = 'b00011; // set read address port 1 to register 3
    we3 =1; #1;     // enable write and wait for 1ns
    we3 = 0; #5;    // disable write and wait for 5ns
    // enable writing and save 0xC0DEBABE to register 3 and wait for 2ns
    wa3 = 'b00011; we3 =1; wd3 = 'hC0DEBABE; #2;   
    
    // Disable writing. 0xBAADBEEF will never be written to a register. Wait for 1ns
    we3 =0; wd3 = 'hBAADBEEF; #1;   
  end

// set clock
always begin
    // 1ns for each tick, then 2ns for every clock cycle
    #1 clk = ~clk; 
end  
endmodule