`timescale 1ns / 1ps
/*
İki saat sinyalini (clk1 ve clk2) başlatmak için bir başlatma bloğu kullanın. Kullanıcı 
aşağıdaki saat sinyallerini oluşturmalıdır:

clk1: 100 MHz frekanslı bir saat sinyali.

clk2: 50 MHz frekanslı bir saat sinyali.
*/
`include "test.sv"

module Part1_10;

  reg clk1 ;   // 100 MHz clock signal
  reg clk2 ;   // 50 MHz clock signal

  // User Clock generation logic start here

  initial begin
    clk1 = 0;   // Initialize clk1 to 0
    clk2 = 0;   // Initialize clk2 to 0
  end

  always #5 clk1 = ~clk1;   // Toggle clk1 every 5 ns (100 MHz)
 always #10 clk2 = ~clk2;  // Toggle clk2 every 10 ns (50 MHz)
  ////// User clock generation logic ends here


  // Instantiate the test class
  test t1 = new();

  initial begin
    #80;   // Sample clocks at 80 ns
    t1.no_gen(clk1, clk2);
    t1.display();
    $stop;
  end
  
endmodule


//
/*
`include "test.sv"
 
module tb;
 
  reg clk1 = 0;   // 100 MHz clock signal
  reg clk2 = 0;   // 50 MHz clock signal
 
  // Clock generation logic
  // clk1: 100 MHz, period = 10 ns
  always #5 clk1 = ~clk1;
 
  // clk2: 50 MHz, period = 20 ns
  always #10 clk2 = ~clk2;
 
  // Instantiate the test class
  test t1 = new();
 
  initial begin
    #80;   // Sample clocks at 80 ns
    t1.no_gen(clk1, clk2);
    t1.display();
    $stop;
  end
  
endmodule
*/
