

//EDAPlayGround egzersizidir

//Benim kodum
/*
`include "test.sv"


module tb;
  
  reg resetn = 0;   //////rst represent DUT reset Signal

  /////// User Logic goes here
  

  initial begin
    resetn = 1'b0;
    #100;
    resetn = 1'b1;
    #50;
    resetn = 1'b0;
    #50;
    resetn = 1'b1;    
  end
  
  
  
  /////// User code ends here
 
  
  test t1 = new();
  
  initial begin
    #201;
    t1.no_gen(resetn);
    t1.display();
  end
  
  
endmodule
*/

`include "test.sv"
 
 
module Part1_4;
  
  reg resetn = 0;   //////rst represent DUT reset Signal
 
  /////// User Logic goes here
  
   
  initial begin
    resetn = 0;      // Start with resetn active (low)
    #100 resetn = 1;  // Deactivate resetn after 100 ns
    #50  resetn = 0;
    #50  resetn = 1;
  end
  
  
  
  
  /////// User code ends here
 
  
  test t1 = new();
  
  initial begin
    #201;
    t1.no_gen(resetn);
    t1.display();
  end
  
  
endmodule
