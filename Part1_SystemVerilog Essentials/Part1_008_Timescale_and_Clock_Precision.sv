/*
`timescale 1ns / 1ps

şu demek:

Zaman birimi: 1 ns
Hassasiyet: 1 ps = 0.001 ns
Virgülden sonra 3 basamak hassasiyet

Yuvarlama ise şudur:

Yazdığın #delay değeri, time precision basamağına uydurulur.

Yani “yuvarlama” derken, örneğin #31.2567 gibi bir değerin simülatör tarafından 
mevcut hassasiyete göre 31.257 ns gibi bir değere çekilmesidir.
*/



//ASAGIDAKI KOD INCELENEBILIR---------------------------------------------------

`timescale 1ns / 1ps   //10^3 -> 3
 
module Part1_8();
 
  
 
  
  reg clk16 = 0;
  reg clk8 = 0;  ///initialize variable
  
 
   always #31.25 clk16 = ~clk16;
   always #62.5 clk8 = ~clk8;
  
 
 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
 
 
  initial begin
    #200;
    $finish();
  end
  
endmodule
