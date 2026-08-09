`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*

module Part1_11();

    reg clk     = 0;
    reg clk_50  = 0;   //50MHz clock, 20ns period
    reg clk_100 = 0;

    always #5 clk = ~clk; // 10 ns period, 100 MHz frequency

    real phase = 10;
    real T_on_1  = 5;
    real T_off_1 = 5;

    real phase_2 = 20;
    real T_on_2  = 10;
    real T_off_2 = 10;

    initial begin
        #phase;
        while(1) begin
            clk_100 = 1;
            #T_on_1;
            clk_100 = 0;
            #T_off_1; 
        end
    end

    initial begin
        #phase_2;
        while(1) begin
            clk_50 = 1;
            #T_on_2;
            clk_50 = 0;
            #T_off_2;
        end
    end




    initial begin
        #200;
        $finish();
    end

endmodule

*/


/*
clk_100 sinyali simulasyon baslangicindan 10 ns gecikmeli olarak baslatilmaktadir.
Task kullanimi sayesinde phase, T_on ve T_off degerleri disaridan verilerek farkli
clock sinyalleri daha esnek bir sekilde uretilebilir.
*/

module Part1_11();

    reg clk     = 0;
    //reg clk_50  = 0;   //50MHz clock, 20ns period
    reg clk_100 = 0;

    always #5 clk = ~clk; // 10 ns period, 100 MHz frequency

    task clkgen(input real phase, input real T_on, input real T_off);
        #phase;
        while(1) begin
            clk_100 = 1;
            #T_on;
            clk_100 = 0;
            #T_off; 
        end
    endtask

    initial begin
        clkgen(10, 5, 5); 
    end

    initial begin
        #200;
        $finish();
    end

endmodule