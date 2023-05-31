`timescale 1ns / 1ps
module voltin(input  logic [31:0] a, b,
               input  logic         cin,
               output logic [31:0] finout,
               output logic         cout    );

logic [31:0] s;

adder #(32) instantiated_adder(a, b, cin, s, cout);
sl2 instantiated_sl2(s, finout);

endmodule
