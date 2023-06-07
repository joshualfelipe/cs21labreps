`timescale 1ns / 1ps
module testbench_2();

  logic        clk;
  logic        reset;

  logic [31:0] writedata, dataadr;
  logic        memwrite;

  // instantiate device to be tested
  top dut(clk, reset, writedata, dataadr, memwrite);
  
  // initialize test
  initial
    begin
      clk = 0;
      
      if(memwrite) begin
        if(dataadr === 16 & writedata == 0) begin
          $display("Simulation succeeded");
          $stop;
        end
      end
    end

  // generate clock to sequence tests

  // check results
    
      always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end
endmodule