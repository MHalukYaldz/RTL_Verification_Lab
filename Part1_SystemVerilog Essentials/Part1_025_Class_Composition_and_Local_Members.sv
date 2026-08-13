`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
Bu bolumde class icinde task kullanimina bakalim.

Task'lar input, output, inout veya ref argumanlar alabilir.
Task'in function gibi bir return degeri yoktur ancak output/ref argumanlar veya
class veri uyeleri uzerinden sonuc uretebilir.
Task ayrica zaman kontrolu iceren islemlerde kullanilabilir.
*/

/*
class first;
  
  int data1;
  bit [7:0] data2;
  shortint data3;
  
  function new(input int data1 = 0, input bit[7:0] data2 = 8'h00, input shortint data3 = 0);
   this.data1 = data1;
   this.data2 = data2;
   this.data3 = data3;    
  endfunction
  
  task display();
    $display("Value of Data1 : %0d , Data2 : %0d and Data3 : %0d", data1, data2, data3);    
  endtask
 
  
endclass
 
 
module Part1_25;
  
  first f1;
  
  initial begin
 
    f1 = new( .data2(4), .data3(5), .data1(23));
    f1.display();   //Sinifta tanimlanan metodu boyle cagiriyoruz
    end
  
  
endmodule
*/

/*
class first;
  
    bit [3:0] data1;
    bit [3:0] data2;
    bit [3:0] data3;
    bit [11:0] out;

  function new(input bit[3:0] a = 0, input bit[3:0] b = 0, input bit[3:0] c = 0);
    this.data1 = a;
    this.data2 = b;
    this.data3 = c;
  endfunction
  
  task display();
    $display("Value of data1: %0d, data2: %0d, data3: %0d, out: %0d", data1, data2, data3, out);
  endtask

  task add();
    out = data1 + data2 + data3;
  endtask
 
  
endclass
 
 
module Part1_25;
  
  first f1;

    initial begin
 
    f1 = new(1, 2, 4);
    f1.add();
    f1.display();   //Sinifta tanimlanan metodu boyle cagiriyoruz
    end
  
  
endmodule
*/

/*
Class composition kullanimina bakalim.
Bir class, baska bir class tipinde handle bulundurabilir.
*/

//*
class first;

    int data = 34;

endclass

class second;

    first f1;   // Gecis icin handle olusturduk

    function new(); //Bunlari kullanilabilir hale getirmek icin constructor olusturmaliyiz
        f1 = new(); //Boylece diger sinif icin metot cagirip erisim sagliyoruz
    endfunction

endclass

module Part1_25();

    second s;

    initial begin
        s = new();
        $display("Value of data: %0d", s.f1.data);
    end
//  s.f1.data   
//Second class inda first class inin instance i var
//Erisebildigimizi dogrulamak icin başlangıc degeri verdik ve goruntuledik
endmodule



//*
//Iceriye task ekleyerek gorelim
class first;

    int data = 34;

    task display();
        $display("Value of Data : %0d", data);
    endtask

endclass

class second;

    first f1;   // Gecis icin handle olusturduk

    function new(); //Bunlari kullanilabilir hale getirmek icin constructor olusturmaliyiz
        f1 = new(); //Boylece diger sinif icin metot cagirip erisim sagliyoruz
    endfunction

endclass

module Part1_25();

    second s;

    initial begin
        s = new();
        $display("Value of data: %0d", s.f1.data);
        s.f1.display();     //Erismek icin " . " operatorunu kullaniyoruz

        s.f1.data = 45;     //Adim adim veriye gidip degistirdigimizi dusunmeliyiz
        s.f1.display();
    end
endmodule





//Eger veriyi class ta yerel tutmayi istiyorsak yani degiskenin kapsamini class icinde tutmayi isteriz
//"local" bunu saglar
class first;

    local int data = 34;
///////////////////////////////////////////////////////////////////////////////////
// Local olan veriye erismek icin bagimsiz yontemler getirdik 
    task set(input int data);// local veri uyesinin degerini ayarlamak icin
        this.data = data ;  //Burada keramet "this"tedir
    endtask

    function int get(); //local veriyi almamizi saglar ve deger donecegi icin func secildi
        return data;
    endfunction
///////////////////////////////////////////////////////////////////////////////////
    task display();
        $display("Value of Data : %0d", data);
    endtask

endclass

class second;

    first f1;   // Gecis icin handle olusturduk

    function new(); //Bunlari kullanilabilir hale getirmek icin constructor olusturmaliyiz
        f1 = new(); //Boylece diger sinif icin metot cagirip erisim sagliyoruz
    endfunction

endclass

module Part1_25();

    second s;

    initial begin
        s = new();
        s.f1.set(123);
        $display("Value of Data : %0d", s.f1.get);
        //s.f1.display();
    end
endmodule
