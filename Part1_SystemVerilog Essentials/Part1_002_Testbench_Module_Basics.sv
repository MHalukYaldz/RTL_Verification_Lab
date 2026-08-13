`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// A module without ports is commonly used as a testbench top,
// but having no ports does not itself make a module a testbench.
module Part1_2();   
    reg a = 0; 

    initial a=1;

    initial begin
        a = 1;
        #10;
        a = 0;
    end
endmodule
