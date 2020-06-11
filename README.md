# ALU-Design

This code is an FPGA structure for ALU design. According to the required features that said in the task,
I have designed an ALU that is able to add and substruct two inputs, left shift and right shift an input.

As it is said, the structure does not depend on the input size. At the beginning there are two selection inputs (s0, s1)
that are used for choosing the feature of the ALU. 

I have created the truth table of each of the feature of the ALU. Here is the Truth table:
<p align="left">
  <img src="images/truth-table.png" width="150" title="How It Works?">
</p>

Let's choose s0 as 0000 (means 0) and s1 as 1111 (means 1). This corresponds to the substruction. So, only the result
that is coming from the substruction module will be used.

I have connected LEDs to the ports of the output and simulated this code and it works fine. You can use it for any input.

Note: The left shift and right shift part only shifts the input A as I have set it like this. You can change it to input be to shift it. 
