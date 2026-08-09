`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

/*
module Part1_12();

reg clk       = 0;
reg clk_phase = 0;


always #5 clk = ~clk;


task calc(input real phase, input real freq_hz, input real duty_cycle, output real ton, 
output real toff, output real pout);
    pout = phase;
    ton = (1.0/freq_hz)*duty_cycle*1_000_000_000;
    toff = (1_000_000_000/freq_hz)-ton;
endtask

task clkgen(input real phase, input real ton, input real toff);
    #phase;
    while(1) begin
        clk_phase =1;
        #ton;
        clk_phase = 0;
        #toff;
    end
endtask

// calc taskindan elde edilen degerleri saklamak icin module scope degiskenleri
real phase;
real ton;
real toff;

initial begin
    calc(10, 100_000_000, 0.5, ton, toff, phase);
    clkgen(phase, ton,toff);
end

endmodule
*/

/*
module Part1_12();

reg clk       = 0;
reg clk_phase = 0;


always #5 clk = ~clk;


task calc(input real phase, input real freq_hz, input real duty_cycle, output real ton, 
output real toff, output real pout);
    pout = phase;
    ton = (1.0/freq_hz)*duty_cycle*1_000_000_000;
    toff = (1_000_000_000/freq_hz)-ton;
endtask

task clkgen(input real phase, input real ton, input real toff);
    @(posedge clk);
    #phase;
    while(1) begin
        clk_phase =1;
        #ton;
        clk_phase = 0;
        #toff;
    end
endtask

real phase;     // calc taskindan elde edilen degerleri saklamak icin module scope degiskenleri
real ton;
real toff;

initial begin
    calc(0, 100_000_000, 0.5, ton, toff, phase);
    clkgen(phase, ton,toff);
end

endmodule
*/
module Part1_12();

reg clk       = 0;
reg clk_phase = 0;


always #5 clk = ~clk;


task calc(input real phase, input real freq_hz, input real duty_cycle, output real ton, 
output real toff, output real pout);
    pout = phase;
    ton = (1.0/freq_hz)*duty_cycle*1_000_000_000;
    toff = (1_000_000_000/freq_hz)-ton;
endtask

task clkgen(input real phase, input real ton, input real toff);
    @(posedge clk);
    #phase;
    while(1) begin
        clk_phase =1;
        #ton;
        clk_phase = 0;
        #toff;
    end
endtask

real phase; // calc taskindan elde edilen degerleri saklamak icin module scope degiskenleri
real ton;
real toff;

initial begin
    calc(10, 100_000_000, 0.1, ton, toff, phase);
    clkgen(phase, ton,toff);
end

initial begin
    #200;
    $finish();
end

endmodule