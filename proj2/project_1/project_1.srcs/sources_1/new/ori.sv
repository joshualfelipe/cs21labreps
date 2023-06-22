// proj2.1: xori

module xori #(parameter N = 8)
              (input  logic [N-1:0] a, b,
               output logic [N-1:0] s);

  assign s = a ^ b; 
endmodule
