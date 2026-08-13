`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
//Asagida argumanla bildirilerek yapilan islem vardir

module Part1_22();

task add(input bit [3:0] a, input bit [3:0] b, output bit [4:0] y);
    y = a + b;
endtask

bit [3:0] a,b;
bit [4:0] y;

initial begin
    a = 7;
    b = 7;
    add(a, b, y);
    $display("Value of y : %0d", y);
end

endmodule
*/

//Task, module scope'ta tanimlanan degiskenlere dogrudan erisebilir.
//Bu durumda a, b ve y'yi task'a arguman olarak vermek zorunda degiliz.

/*
module Part1_22();

bit [3:0] a,b;
bit [4:0] y;

task add();     //input bit [3:0] a, input bit [3:0] b, output bit [4:0] y
    y = a + b;
endtask

initial begin
    a = 7;
    b = 7;
    add();
    $display("Value of y : %0d", y);
end

endmodule
*/

//Module scope'taki degiskenleri task icinde dogrudan kullanirsak argumana ihtiyacimiz olmaz.
/*
module Part1_22();

bit [3:0] a,b;
bit [4:0] y;

task add();     //input bit [3:0] a, input bit [3:0] b, output bit [4:0] y
    y = a + b;
endtask

initial begin
    a = 7;
    b = 7;
    add();
    $display("Value of y : %0d", y);
end

endmodule
*/

/*
module Part1_22();

bit [3:0] a,b;
bit [4:0] y;

bit clk = 0;

always #5 clk = ~clk;  //10 ns period --> 100 MHz

task add();     //input bit [3:0] a, input bit [3:0] b, output bit [4:0] y
    y = a + b;
    $display("a : %0d and b : %0d and y : %0d", a, b, y);
endtask

task  stim_a_b();
    a = 1;
    b = 3;
    add();
    #10;
    a = 5;
    b = 6;
    add();
    #10;
    a = 7;
    b = 8;
    add();
    #10;
endtask

task stim_clk();
    @(posedge clk); // clk nin yukselen kenarini bekle
    a = $urandom();
    b = $urandom();
    add();
endtask 

initial begin
    #110;
    $finish();
end

initial begin
    ///stim_a_b();

    for(int i=0; i<11; i++) begin
        stim_clk();
    end
end

endmodule
*/



//`timescale 1ns/1ps
module Part1_22();

bit clk = 0;
bit en = 0;
bit wr = 0;
bit [5:0] addr = 6'b000000;


always #20 clk = ~clk;  //25MHz

task stim(input bit en_i, input bit wr_i, input bit [5:0] addr_i);
    @(posedge clk);
    en      = en_i;
    wr      = wr_i;
    addr    = addr_i;

        $display("Time = %0t, en = %0b, wr = %0b, addr = %0d", $time, en, wr, addr);

endtask

initial begin
    stim(1'b1, 1'b1, 12);
    stim(1'b1, 1'b1, 14);
    stim(1'b1, 1'b0, 23);
    stim(1'b1, 1'b0, 48);
    stim(1'b0, 1'b0, 56);
end

initial begin
    
    #200;
    $finish();

end

endmodule
