/*
Below FPGA structure is for ALU design. According to the required features that said in the task,
I have designed an ALU that is able to add and substruct two inputs, left shift and right shift an input.

As it is said, the structure does not depend on the input size. At the beginning there are two selection inputs (s0, s1)
that are used for choosing the feature of the ALU. 

I have created the truth table of each of the feature of the ALU. Here is the Truth table:

s0   s1   Add   Substruct   Left_Shift   Right_Shift
0    0    1         0           0             0
0    1    0         1           0             0
1    0    0         0           1             0
1    1    0         0           0             1

Let's choose s0 as 0000 (means 0) and s1 as 1111 (means 1). This corresponds to the substruction. So, only the result
that is coming from the substruction module will be used.

I have connected LEDs to the ports of the output and simulated this code and it works fine. You can use it for any input.

Note: The left shift and right shift part only shifts the input A as I have set it like this. You can change it to input be to shift it. 
*/

module ALU(S);
  //s0 and s1 are selection inputs to choose one of the features of the ALU.
  //You need to set them as full 1s or 0s (ex: s0 = 4'b0000 or s0 = 4'b1111).
  //The reason behind this is to make logical operation between arrays, like s0 and A.
  //A and B are the inputs for the ALU. 
  //S is the output of the ALU.
  wire [len-1:0] s0 = 4'b0000;
  wire [len-1:0] s1 = 4'b0000;
  output [len-1:0] S;
  wire [len-1:0] A = 4'b0011;
  wire [len-1:0] B = 4'b0011;
 
  //The parameter "len" is for determining the length of inputs and outputs to make the program dynamic.
  parameter len = 4;
  
  //out1, out2, out3, out4 are the outputs of each feature (addition, substruction, left shift and right shift)
  wire [len-1:0] out1,out2,out3,out4;
  
  //In this part, we find the all four outputs and store them inside of the "out" wires.
  //I have used parameter feature of the modules to use the "len" value inside of the each module.
  Full_Adder_updated #(.length(len)) fa(A,B,out1);
  full_subtractor_updated #(.length(len)) fs(A,B,out2);
  rshift #(.length(len)) rs(A,out3);
  lshift #(.length(len)) ls(A,out4);
  
  //This last step determines the output of the ALU. I have created the truth table of each feature according to each possible
  //outcome of s0 and s1. So, just simply "and" them with the corresponding combination and taking "or" of them will give us only
  //the true results, the other ones will be made zero. 
  assign S = ((out1 & (~s0 & ~s1)) | (out2 & (~s0 & s1)) | (out3 & (s0 & ~s1)) | (out4 & (s0 & s1)));

endmodule

//In order to make any number of addition, I have implemented the parameter length to achieve this.
//Rest of the part is same with the full adder structure.
module Full_Adder_updated(A, B, S);
  parameter length;
  input [length-1:0] A;
  input [length-1:0] B;
  output [length-1:0] S;

  wire   [length:0] c;

  assign c[0] = 0;
  
  genvar i;
  generate
    for (i = 0; i < length; i=i+1) 
      begin : make_fadders
        full_Adder fa(.A( A[i] ),
                    .B( B[i] ),
                    .Cin(  c[i]   ),
                    .S( S[i] ),
                    .Cout( c[i+1] )
                    );
    end
  endgenerate

endmodule

module Full_Adder(A, B, Cin, S, Cout);
input A, B, Cin;
output S, Cout;
wire w1, w2, w3;

xor g1(w1, A, B);
xor g2(S, w1, Cin);

and g3(w2, w1, Cin);
and g4(w3, A, B);
or g5(Cout, w2, w3);

endmodule

module rshift(I,O);
  parameter length;
  input [length-1:0] I;
  output [length-1:0] O;

  genvar i;
  generate
    for (i = 0; i < length; i=i+1) 
      begin : make_fadders
        if(i == 0)
          assign O[length-1-i] = 0;
        else 
          assign O[length-1-i] = I[length-i];
    end
  endgenerate

endmodule

module lshift(I,O);
  parameter length;
  input [length-1:0] I;
  output [length-1:0] O;

  genvar i;
  generate
    for (i = 0; i < length; i=i+1) 
      begin : make_fadders
        if(i == 0)
          assign O[i] = 0;
        else 
          assign O[i] = I[i-1];
    end
  endgenerate

endmodule

module full_subtractor(a0, a1, Bin, D, Bout);
input a0, a1, Bin;
output D, Bout;

assign D = a0^a1^Bin;
assign Bout = (Bin & (~a0 | a1)) | (~a0 & a1);

endmodule

module full_subtractor_updated(A,B,D);
  parameter length;
  input [length-1:0] A;
  input [length-1:0] B;
  output [length-1:0] D;

  wire   [length:0] b;

  assign b[0] = 0;

  genvar i;
  generate
    for (i = 0; i < length; i=i+1) 
      begin : make_fadders
        full_subtractor fs(.a0( A[i] ),
                           .a1( B[i] ),
                           .Bin( b[i] ),
                           .D( D[i] ),
                           .Bout( b[i+1] )
                          );
    end
  endgenerate

endmodule


