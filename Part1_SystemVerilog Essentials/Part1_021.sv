`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
class first_class;
    bit [0:2] data;
    bit [0:1] data2;
endclass

module Part1_21();

    first_class f;    //HANDLE --> class tipindeki object'i gosterecek referanstir.
                      //Sadece handle tanimlamak object olusturmaz.

    initial begin
        f = new();    //Object olusturulur.
        f.data  = 3'b101;   //Handle uzerinden class uyesine erisim.
        f.data2 = 2'b01;    //Handle uzerinden class uyesine erisim.
    end

endmodule
*/

//Verilog/SystemVerilog modulleri statik yapilardir ve simulasyon boyunca bulunurlar.
//
//Class'lardan olusturulan object'ler ise dinamiktir.
//Ihtiyac oldugunda object olusturulur ve object'lere handle uzerinden erisilir.
//
//Ornegin:
//
//first f;
//
//ifadesi yalnizca "f" isimli bir handle tanimlar.
//Bu noktada herhangi bir object olusturulmaz ve f'nin degeri null'dir.
//
//Object olusturmak icin:
//
//f = new();
//
//kullanilir. new() constructor'i cagirir ve object icin gerekli bellek alaninin
//ayrilmasini saglar.
//
//Class icinde kullanici tarafindan bir constructor tanimlanmasa bile SystemVerilog
//default bir constructor saglar. Bu nedenle asil onemli nokta, object'e erismeden once
//new() ile object'in olusturulmasidir.
//
//new() cagirilmadan:
//
//f.data = ...
//
//gibi bir erisim yapilmaya calisilirsa f null oldugu icin null handle / null pointer
//hatasina yol acar.
//
//Class'i bir module, program blogu, package veya baska bir class icinde kullanirken
//once class tipinde bir handle tanimlanir, daha sonra new() ile object olusturulur.
//
//Class veri uyelerine ve metotlarina "." operatoru ile erisilir:
//
//f.data
//f.data2
//
//Class degiskenlerine yapilan normal procedural atamalardan sonra sadece verilerin
//"oturmasi" icin #1 gibi bir gecikme eklemek gerekli degildir.

/*
class first_class;
    bit [0:2] data;
    bit [0:1] data2;
endclass

module Part1_21();

    first_class f;

    initial begin
        f = new();
        $display("Value of data : %0d and data2 : %0d", f.data, f.data2);
    end

endmodule
*/

// Bir veri uyesine erisip deger ekleme

/*
class first;
    bit [0:2] data;
    bit [0:1] data2;
endclass

module Part1_21();

    first f;

    initial begin
        f = new();

        f.data  = 3'b101;    //Class veri uyesine handle uzerinden deger atadik.
        f.data2 = 2'b01;

        $display("Value of data : %0d and data2 : %0d", f.data, f.data2);

        //Handle'in object ile olan baglantisini kaldirir.
        //Object'e baska bir handle referans vermiyorsa artik object'e erisilemez.
        f = null;

        //Bu noktadan sonra f.data gibi bir erisim yapilirsa
        //f null oldugu icin runtime null handle hatasi olusur.
    end

endmodule
*/
/*
class first;

integer unsigned a;
integer unsigned b;
integer unsigned c;

endclass

module Part1_21;

first f;

initial begin
    f = new();
    f.a = 45;
    f.b = 78;
    f.c = 90;
    $display("a : %0d, b : %0d, c : %0d", f.a, f.b, f.c);
end

endmodule
*/

/*
Bir class'a metot eklemek icin "function" veya "task" kullanabiliriz.

TASK:
Task simulation zamani tuketebilir ve timing control ifadeleri kullanabilir.

Ornegin:

#10;
@(posedge clk);
wait(done);

gibi yapilar task icinde kullanilabilir.

Bu nedenle DUT resetleme, sinyal surme, bir clock kenarini bekleme veya belirli bir
protokol islemini gerceklestirme gibi zaman gerektiren testbench islemlerinde task
yaygin olarak kullanilir.

FUNCTION:
Function simulation zamani tuketmeden tamamlanmalidir. Bu nedenle #, @ veya wait gibi
zaman ilerleten timing control ifadeleri normal bir function icinde kullanilmaz.

Function bir deger dondurebilir:

function int add(...);
    return ...;
endfunction

Herhangi bir deger dondurmek istemiyorsak "void function" kullanabiliriz:

function void display_data();
    ...
endfunction

Function'lar input, output, inout veya ref argumanlara sahip olabilir. Bu nedenle
"task birden fazla sonuc verir, function sadece tek sonuc verebilir" seklinde kesin bir
ayrim yapmak dogru degildir.

Function ile task arasindaki en temel fark zaman kontroludur:
Task zaman tuketebilir, function ise sifir simulation zamaninda tamamlanir.

Class constructor'i da "new" isimli ozel bir function'dir.

Ornegin DUT resetlemek zaman gerektirdigi icin genellikle task kullanilir:

reset = 1;
#30;
reset = 0;

Class tabanli testbenchlerde hem function hem de task metotlari yaygin olarak kullanilir.
*/

/*

//function a dogrudan sabit degerler verebiliriz

module Part1_21;

    function bit [4:0] add(input bit [3:0] a, b);   //[4:0] carry icin vardir
    return a + b;
    endfunction

    bit [4:0] res = 0;  //Func'in dondurdugu degeri tutmasi icin-Ayni tur olmalidir-

    initial begin
        res = add(4'b0100, 4'b0010);
        $display("Value of addition : %0d", res);
    end

endmodule
*/

// Diger kullanim da sabit deger vermek yerine degisken tanimlayabilir, arguman olarak verebiliriz

/*
module Part1_21();

    function bit [4:0] add(input bit [3:0] a, b);   //[4:0] carry icin vardir
    return a + b;
    endfunction

    bit [4:0] res = 0;  //Func'in dondurdugu degeri tutmasi icin-Ayni tur olmalidir-
    bit [3:0] a_in = 4'b0100;
    bit [3:0] b_in = 4'b0010;

    initial begin
        res = add(a_in, b_in);  //argumanlar eklendi
        $display("Value of addition : %0d", res);
    end

endmodule

*/

// Default value ile yapalim
// Default deger vermeyip function'i argumansiz cagirirsak hata aliriz.
// Ancak default deger verirsek function'i argumansiz cagirabiliriz.

/*
module Part1_21();

    function bit [4:0] add(   //[4:0] carry icin vardir
    input bit [3:0] a = 4'b0100,
    input bit [3:0] b = 4'b0010
    );
    return a + b;
    endfunction

    bit [4:0] res = 0;  //Func'in dondurdugu degeri tutmasi icin-Ayni tur olmalidir-

    initial begin
        res = add();
        $display("Value of addition : %0d", res);
    end

endmodule
*/

// Simdi argumanlari kaldirip bunun yerine testbench te tanimlanmis degiskenlerle 
//calisabiliriz

/*
module Part1_21();

    bit [3:0] a = 4'b0100;
    bit [3:0] b = 4'b0010;

    function bit [4:0] add();   //[4:0] carry icin vardir
    return a + b;
    endfunction

    bit [4:0] res = 0;  //Func'in dondurdugu degeri tutmasi icin-Ayni tur olmalidir-

    initial begin
        res = add();
        $display("Value of addition : %0d", res);
    end

endmodule
*/

// Arguman eklemek istiyorsak; argumanin yönünü, veri tipini belirtmeliyiz, ayrica return 
// type da bildirilmelidir

/* 
Bazi durumlarda deger dondurmeyi istemeyip sadece konsola yazdirmak isteyebiliriz. Bu durumda
function herhangi bir deger dondurmeyecegi icin "void" kullaniriz
*/

/*
module Part1_21();

    bit [3:0] a = 4'b0100;
    bit [3:0] b = 4'b0010;
    bit [4:0] res = 0; 

    function void display_a_b();
        $display("Value of a : %0d and b : %0d", a, b);
    endfunction

    initial begin
        display_a_b();
    end

endmodule
//Herhangi argumana da gerek yoktur cünkü module icinde tanimli olanlarla calisacak
//Herhangi bir deger dondurulmedigi icin farkli bir degiskene de atanmamiza gerek yok
*/



/*
Function ile calismanin birden fazla yolu vardir

1.function a dogrudan sabit deger verilebilir
2.function a degiskenleri arguman olarak verebilebilir
3.function argumanlarina dafeult deger verilebilir
4.function icinde module seviyesinde tanimlanmis degiskenleri kullanabiliriz
*/

module Part1_21();

    integer unsigned D1 = 4'b1001;
    integer unsigned D2 = 4'b0111;

    function integer unsigned mult();
        return D1 * D2;
    endfunction

    integer unsigned result;

    initial begin
        result = mult();
        $display("RESULT : %0d", result);

        if (result == 63)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");
    end
endmodule
