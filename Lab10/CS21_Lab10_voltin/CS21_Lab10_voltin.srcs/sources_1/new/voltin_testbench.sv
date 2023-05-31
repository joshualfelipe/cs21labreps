`timescale 1ns / 1ps
module voltin_testbench();
    // initialize variables
    logic [31:0] a, b;      // input values to add
    logic cin;              // carry in
    logic [31:0] finout;    // output
    logic cout;             // carry out
    logic clk;              // clock

    // instantiate device under test
    voltin instantiated_voltin(a, b, cin, finout, cout);

    initial begin
        // set clock to zero
        clk = 0;
        // no carry value
        cin = 0;

        // first test case
        a = 'h00000001; b = 'h00000005; cin = 'b0; #2;   
        // the result should be (1+5)*4 = 24

        // second test case
        a = 'h00000002; b = 'h00000006; cin = 'b0; #2;
        // the result should be (2+6)*4 = 32

        // third test case
        a = 'h00000003; b = 'h00000007; cin = 'b0; #2;
        //  the result should be (3+7)*4 = 40

        // fourth test case
        a = 'h00000004; b = 'h00000008; cin = 'b0; #2;
        // the result should be (4+8)*4 = 48 
    end

    // clock simulator
    // Simulate clock, 2ticks for clock cycle
    // hence 2ns each clock cycle
    always begin
        #1 clk = ~clk; 
    end
endmodule