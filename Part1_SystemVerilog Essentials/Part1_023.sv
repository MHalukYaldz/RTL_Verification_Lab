`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

/*
PASS BY VALUE

Task veya function cagirildiginda argumanin degeri formal argumana kopyalanir.

Task icindeki x ve y, disaridaki degiskenlerin yerel kopyalaridir.
Bu kopyalar uzerinde yapilan degisiklikler asil degiskenleri etkilemez.
*/
/*
module Part1_23();

int sum;
int a = 10;
int b = 20;

task add(int x , int y);
    sum = x + y;
endtask

initial begin
    add(a, b);
    $display("Sum : %0d", sum);
end

endmodule
*/

/*
    PASS BY REFERENCE
*/
/*------------------------------------------------------------------------------------
module Part1_23();

int x = 10;
int y = 20;

task automatic add(ref int a, b);
    a = a + 5;
    b = b + 5;
endtask

initial begin
    add(x, y);
    $display("x : %0d and y : %0d", x, y);
end

endmodule
------------------------------------------------------------------------------------*/

/*
PASS BY VALUE ve PASS BY REFERENCE hem tek degiskenlerde hem de dizilerde kullanilabilir.

PASS BY VALUE:
Argumanin yerel bir kopyasi olusturulur. Task veya function icinde bu kopya degistirilse
bile cagiran taraftaki asil degisken degismez.

PASS BY REFERENCE:
Formal arguman, cagiran taraftaki asil degiskenin bir alias'i/referansi gibi davranir.
Bu nedenle task veya function icindeki degisiklikler asil degiskene dogrudan yansir.

Ornek:
ref int a[];

Bu kullanimda task/function dizinin asil haline erisir ve diziyi degistirebilir.

Eger referans ile erismek ancak degiskenin task/function tarafindan degistirilmesini
engellemek istiyorsak const ref kullanabiliriz:

const ref int a[];

const ref, veriyi kopyalamadan referans ile erismemizi saglarken task/function icinden
degistirilmesini engeller.
*/

/*
module Part1_23();

task swap(input bit [1:0] a, b);
    bit [1:0] temp;

    temp = a;
    a = b;
    b = temp;

    $display("Value of a : %0d and b : %0d", a, b);

endtask

bit [1:0] a;
bit [1:0] b;

initial begin
a = 1;
b = 2;
swap(a, b);

$display("Value of a : %0d and b : %0d", a, b);

end

endmodule
*/
/*
PASS BY VALUE

Task icinde a ve b'nin yerel kopyalari degistirilir.
Cagiran taraftaki asil a ve b degiskenleri hic degismedigi icin task tamamlandiktan
sonra degerleri yine 1 ve 2 olarak kalir.
*/

/*
module Part1_23();

task automatic swap(ref bit [1:0] a, b);    //function automatic bit [1:0] add(arguments);
    bit [1:0] temp;                         //Yukaridaki gibi de function da kullanim 
                                            //gösterilmistir
    temp = a;
    a = b;
    b = temp;

    $display("Value of a : %0d and b : %0d", a, b);

endtask

bit [1:0] a;
bit [1:0] b;

initial begin
a = 1;
b = 2;
swap(a, b);

$display("Value of a : %0d and b : %0d", a, b);

end

endmodule
*/
/*
CONST REF

const ref kullanildiginda degisken referans ile task'a aktarilir ancak task icinden
degistirilmesine izin verilmez.

Asagidaki ornekte a sadece okunabilirken b degistirilebilir.
*/
module Part1_23();

task automatic copy_a_to_b(const ref bit [1:0] a, ref bit [1:0] b);

    //a = b;   //HATA: a const ref oldugu icin degistirilemez.
    b = a;

    $display("Task icinde a : %0d and b : %0d", a, b);

endtask

bit [1:0] a;
bit [1:0] b;

initial begin
    a = 1;
    b = 2;

    copy_a_to_b(a, b);

    $display("Task sonrasinda a : %0d and b : %0d", a, b);
end

endmodule