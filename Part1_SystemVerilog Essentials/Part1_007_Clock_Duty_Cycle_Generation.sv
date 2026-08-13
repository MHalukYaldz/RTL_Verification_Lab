`timescale 1ns / 1ps
 
module Part1_7();
 
  
  reg clk; //initial value = X
  
  reg clk50;
  reg clk25 = 0;  ///initialize variable
  
 
  initial begin
    clk = 1'b0;
    clk50 = 0; 
  end
 
 
  
  always #5 clk = ~clk;		// 100MHz
  
  always begin				// 50MHz
  #5;   // Total clock period = 20 ns -> 50 MHz
   clk50 = 1;
  #10;
   clk50 = 0; 
   #5; 
  end
  
  always begin
    #5;
    clk25 = 1;
    #20;
    clk25 = 0;
    #15;  
  end

  initial begin
    #200;
    $finish();
  end
  
endmodule
