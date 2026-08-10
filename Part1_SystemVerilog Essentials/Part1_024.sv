`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
Diziler value ile aktarildiginda veri kopyalanir.
Dizinin asil haline dogrudan erismek ve gerekirse degistirmek icin ref kullanabiliriz.
*/


module Part1_24();

bit [3:0] res[16];

function automatic void init_arr(ref bit [3:0] a[16]); //Disaridaki diziye erisim icin 
    for (int i=0; i<=15; i++) begin     //kullaniyoruz Ayrica fonk bir sey dondurmediginden 
        a[i] = i;                       //"void" geldi Ve tabiki "automatic" dememiz gerekiyor
    end
endfunction

initial begin
    init_arr(res);

    for (int i=0; i<=15; i++) begin     //Ayrica fonk bir sey dondurmediginden "void" geldi
        $display("res[%0d] = %0d", i, res[i]); //Ve tabiki "automatic" dememiz gerekiyor
    end

end

endmodule


/**/


module Part1_24();

bit [7:0] res[32];

function automatic void init_arr(ref bit [7:0] a[32]);
    for (int i=0; i<32; i++) begin     
        a[i] = i * 8;                       
    end
endfunction

initial begin
    init_arr(res);

    for (int i=0; i<32; i++) begin     
        $display("res[%0d] = %0d", i, res[i]);
    end

end

endmodule


//Task ve funtion i class a eklemeye bakalim
/*
Kurucumuz bir argümandan oluşur, bu nedenle bir kurucuyu çağırdığınızda, 
bir başlangıç değeri belirtmediğimiz için veri girdisini belirtmeniz zorunludur
*/

class first;

int data;

function new(input int datain);
    data = datain;
endfunction

endclass

module Part1_24;

    first f1;

    initial begin
    f1 = new(32);//iceriye datain  yazabilmek icin tanimlanmasi lazim ama direkt deger
    $display("Data : %0d", f1.data);//vererek kullanabiliriz

    end

endmodule


class first;

int data;

function new(input int datain = 0);//Constructor a arguman olan 0 i ekleyedebiliriz
    data = datain;
endfunction

endclass

module Part1_24;

    first f1;

    initial begin
    f1 = new(23);//Yine de baslatmak istedigimiz degeri secebiliriz
    $display("Data : %0d", f1.data);

    end

endmodule

/*
Constructor, class icindeki ozel new() function'idir.
Normal function'lardan farkli olarak constructor icin return type yazilmaz.
Bu nedenle "void" da kullanilmaz.

Dogru kullanim:
function new(...);
*/

//constructor a birden fazla arguman eklemeye bakalim


class first;

int data1;
bit [7:0] data2;
shortint data3;

//farkli isimde arguman eklemistik ama bazen ayni adi vermemiz gerekebilir. Veri uyesi ve
//argumana ayni adi verirsek atıf icin "this" kullanmaliyiz, boylece de ayirt edilebilirler
function new(input int data1 = 0, input bit [7:0] data2 = 8'h00, input shortint data3 = 0); 
    this.data1 = data1;
    this.data2 = data2;
    this.data3 = data3;
endfunction

endclass

module Part1_24;

    first f1;

    initial begin
    f1 = new(23, 4, 35);//pozisyona gore argumana deger veririz
  //f1 = new(23,, 35); //Boyle calistirirsak baslangıc degeri verdigimiz icin sorun yoktur
    $display("Data1 : %0d, Data2 : %0d, Data3 : %0d", f1.data1, f1.data2, f1.data3);

    end

endmodule


//Fonk u takip etmemize gerek olmadigini varsayalim, bu durumda ismi takip ederiz


class first;

int data1;
bit [7:0] data2;
shortint data3;

function new(input int data1 = 0, input bit [7:0] data2 = 8'h00, input shortint data3 = 0); 
    this.data1 = data1;
    this.data2 = data2;
    this.data3 = data3;
endfunction

endclass

module Part1_24;

    first f1;

    initial begin
    f1 = new(23, 4, 35);//pozisyona gore argumana deger veririz
  //f1 = new(23,, 35); //Boyle calistirirsak baslangıc degeri verdigimiz icin sorun yoktur
  
  //data2 ile baslattigimizi varsayalim
  //f1 = new(.data2(4), .data3(5), .data1(23));
  //"." ile pozisyonu devredisi birakip isme gore atama yapabiliyoruz ve "()" ile deger verdik
    $display("Data1 : %0d, Data2 : %0d, Data3 : %0d", f1.data1, f1.data2, f1.data3);

    end

endmodule


/*
Yukarida da goruldugu gibi bir fonksiyonda birden fazla argumana deger atamak icin iki 
yontemimiz vardir: pozisyon takip ve isim takiptir
Pozisyonda beyan edilen pozisyona sadik kalinmalidir
*/



/**/
class first;

logic [7:0] Data1 = 4'b0001;
logic [7:0] Data2 = 4'b0010;
logic [7:0] Data3 = 4'b0011;

function new(input logic [7:0] a=0, input logic [7:0] b=0, input logic [7:0] c=0);
    $display("ILK DEGERLER --> Data1 : %0d, Data2 : %0d, Data3 : %0d", Data1, Data2, Data3);
    
    $display("NEW ILE GELEN --> a : %0d, b : %0d, c : %0d", a, b, c);

    this.Data1 = a;
    this.Data2 = b;
    this.Data3 = c;

    $display("ATAMA SONRASI --> Data1 : %0d, Data2 : %0d, Data3 : %0d", Data1, Data2, Data3);
    
endfunction

endclass


module Part1_24();

    first f;

    initial begin
        f = new(2, 4, 56);
        $display("MODUL ICINDE --> Data1 : %0d, Data2 : %0d, Data3 : %0d", f.Data1, f.Data2, f.Data3);
    end

endmodule
/*
Beklenildigi gibi son degerler degismistir
*/
