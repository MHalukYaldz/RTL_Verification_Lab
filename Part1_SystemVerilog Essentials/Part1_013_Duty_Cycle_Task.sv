`timescale 1ns / 1ps

module Part1_13;

  // Signal declaration
  reg clk = 0;

  // Parameters for waveform generation
  real period = 50.0;       // Period in nanoseconds
  real duty_cycle = 0.6;    // Duty cycle (60%)
  real high_time, low_time;  /// high and low time

  ///////////User code for clock generation starts here 
  
  task calc(input real period, input real duty_cycle);
    high_time = period * duty_cycle;
    low_time = period - high_time;
endtask

task clkgen(input real high_time, input real low_time);
    while(1) begin
        clk = 1;
        #high_time;
        clk = 0;
        #low_time;
    end
endtask

  
  initial begin
    calc(period, duty_cycle);
    clkgen(25, 25);
  end

  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #55;
    $stop;
  end
  
endmodule
