`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


///////////////     INTERFACE       ////////////////////////////

/*
module add (            // TASARIM
 input [3:0] a, b,      // TASARIM
 output [4:0] sum       // TASARIM
 );                     // TASARIM
                        // TASARIM
 assign sum = a + b;    // TASARIM
                        // TASARIM
endmodule               // TASARIM
*/


interface add_if;

    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] sum;

endinterface



module Part1_35;

    add_if aif();

//    add dut (aif.a, aif.b, aif.sum);    //Positional map
    add dut (.b(aif.b), .a(aif.a), .sum(aif.sum));      //mapping by name

    initial begin
        aif.a = 4; //Burada simdilik blocking assignment ile devam edelim
        aif.b = 4;
        #10;
        aif.a = 3;
        #10;
        aif.b = 7;
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/////////////Reference DUT

/*
module and4 (
  input [3:0] a,
  input [3:0] b,
  output [3:0] y
 
);
  
 assign y = a & b; 
  
  
endmodule
*/

////////////////////Interface and TB



interface and_if;
  logic [3:0] a;
  logic [3:0] b;
  logic [3:0] y;
    
  endinterface
 
 
module Part1_35;
  
  and_if aif();
  
  and4 dut (.a(aif.a), .b(aif.b), .y(aif.y));
  
  initial begin
    aif.a = 4'b0100;
    aif.b = 4'b1100;
    #10;
    $display("a : %b , b : %b and y : %b",aif.a, aif.b, aif.y );
  end
  
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

 /*
module add (            // TASARIM
 input [3:0] a, b,      // TASARIM
 output reg [4:0] sum,  // TASARIM
 input clk              // TASARIM
 );                     // TASARIM
                        // TASARIM
always@(posedge clk)    // TASARIM
    begin               // TASARIM
        sum <= a + b;   // TASARIM
    end                 // TASARIM
endmodule               // TASARIM
*/

interface add_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] sum;
    logic clk;
endinterface

module Part1_35;
    add_if aif();

    add dut (.b(aif.b), .a(aif.a), .sum(aif.sum), .clk(aif.clk));

    initial begin
        aif.clk = 0;
    end

    always #10 aif.clk = ~aif.clk;
    
    initial begin
        aif.a = 1;
        aif.b = 5;
        #22;
        aif.a = 3;
        #20;
        aif.a = 4;
        #8;
        aif.a = 5;
        #20;
        aif.a = 6;
    end

    initial begin
        #100;
        $finish();
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*////////////////////////////////////////////////////////////////////////////////
Buraya kadar ki kodlarda blocking operator kullandik bundan sonraki kodda non-blocking
operator kullanilmistir
*/////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

interface add_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] sum;
    logic clk;
endinterface

module Part1_35;
    add_if aif();

    add dut (.b(aif.b), .a(aif.a), .sum(aif.sum), .clk(aif.clk));

    initial begin
        aif.clk = 0;
    end

    always #10 aif.clk = ~aif.clk;
    
    initial begin
        aif.a <= 1;
        aif.b <= 5;
        @(posedge aif.clk);//bir saat tiki gecikme ekledik
        
        aif.a <= 3;
        #20;
        aif.a <= 4;
        #8;
        aif.a <= 5;
        #20;
        aif.a <= 6;
    end

    initial begin
        #100;
        $finish();
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

interface add_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] sum;
    logic clk;
endinterface

module Part1_35;
    add_if aif();

    add dut (.b(aif.b), .a(aif.a), .sum(aif.sum), .clk(aif.clk));

    initial begin
        aif.clk = 0;
    end

    always #10 aif.clk = ~aif.clk;
    
    initial begin
        aif.a <= 1;
        aif.b <= 5;
        repeat(3) @(posedge aif.clk)//kac saat tiki gecikme istiorsak "repeat" 
                                    //ekler, tekrari yazariz
        
        aif.a <= 3;
        #20;
        aif.a <= 4;
        #8;
        aif.a <= 5;
        #20;
        aif.a <= 6;
    end

    initial begin
        #100;
        $finish();
    end
endmodule

/*
Buraya kadar ki kismi daha rahat anlamak icin sources klasorundaki dalga formu analizlerine
bakmak daha mantikli olur cunku ayrimlari daha net gorunuyor.
"=" yazılım mantigina daha yakindir
"<=" ise ff ve register yapisina cok daha yakin calismaktadir
*/

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
"wire" bir net tipidir ve genellikle continuous assignment veya module baglantilarinda
kullanilir.

"reg" Verilog'da procedural bloklardan deger atanan variable tipidir.
Bir output port "reg" olabilir.

SystemVerilog'daki "logic" ise testbench ve RTL kodunda reg yerine yaygin olarak
kullanilan variable tipidir.

Portun input/output olmasi ile wire/reg/logic secimi ayni sey degildir.
*/

///////////////////////     TASARIM     //////////////////////////////////////////////
/*                                                                           /////////
module and4 (                                                                /////////
  input [3:0] a,b,                                                           /////////
  output [3:0] sum                                                           /////////
);                                                                           /////////
                                                                             /////////
 assign sum = a + b;                                                         /////////
                                                                             /////////
endmodule                                                                    /////////
*/                                                                           /////////
//////////////////////////////////////////////////////////////////////////////////////

/*
Bu ornekte asil problem aif.sum sinyalinin hem DUT cikisi tarafindan hem de testbench
icindeki initial blogundan surulmeye calisilmasidir.

Ayni variable'i birden fazla kaynaktan surmekten kacinmaliyiz.
*/
interface add_if;
    reg [3:0] a;
    reg [3:0] b;  
    reg [4:0] sum;
endinterface      

module Part1_35;
    add_if aif();

    add dut (.b(aif.b), .a(aif.a), .sum(aif.sum));
    
    initial begin
        aif.a = 1;
        aif.b = 3;
        aif.sum = 5;
    end

    initial begin
        #100;
        $finish();
    end
endmodule

//Tumunu "wire" olarak degistirirsek :

/*
Ancak bu durumda da cikis portunda "wire" tipi kullanmamiza izin verilirken bir uyarici
olusturmamiz zorlasir. Bir uyarici olusturmak icin ya bir "always" blogu yada "initial"
blogu kullanacagiz ve "wire" turlerinin prosedurel bloklar icinde kullanilmasina izin
verilmez.
Tum tipleri "wire" yaptigimizda "add_if prosedurel bir atamanin gecerli bir
sol tarafi degildir" hatasini aliriz.(Prosedurel "always" ve "initial" icin denir)
*/

interface add_if;
    wire [3:0] a;
    wire [3:0] b;  
    wire [4:0] sum;
endinterface   

module Part1_35;
    add_if aif();

    add dut (.b(aif.b), .a(aif.a), .sum(aif.sum));
    
    initial begin
        aif.a = 1;
        aif.b = 3;
    end

    initial begin
        #100;
        $finish();
    end
endmodule

/*////////////////////////////       UNUTULMAMALI        //////////////////////////////
"wire" bir net tipidir ve procedural always/initial bloklarinda dogrudan surulemez.

"reg" Verilog'da procedural bloklardan deger atanan variable tipidir ve output olarak da
kullanilabilir.

SystemVerilog'da "logic", testbench ve RTL kodunda reg yerine yaygin olarak kullanilir.
Ancak bir logic sinyalini birden fazla kaynaktan surmemeye dikkat edilmelidir.

Portun input/output olmasi ile wire/reg/logic secimi ayni sey degildir.
////////////////////////////////////////////////////////////////////////////////////*/

/*
Yukarida verilen arayuzler calismayacaktir cunku tasarim adi ile interface kismindaki 
"add dut (.b......)" kismindaki "add" isimlendirmesi tasarimdakiyle ayni degildir!!!
*/
