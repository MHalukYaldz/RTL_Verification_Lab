`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

/*
----------------------      INHERITANCE     ----------------------------
Test edilen tasarima uyarici olusturdugumuzu dusunelim
Bazi durumlarda ara verileri hesaplamamiz gerekebilir ve sadece uyaranin DUT a dogru sekilde
gidip gitmedigini veya DUT a gonderdigimiz uyarama bir hata enjekte edip etmedigimizi
ayiklamak icindir
olusturulan sinifta bulunan ozelliklerin yanisira tum veri uyelerine de erismemiz gerekir
ve bununla birlikte yeni sinifa belirli ozellikleri ekler veya degistiririz

inheritance, hata enjekte etmemize yardimci olur
Belli alanlarda gecici degerlerin hesaplanmasina yardimci olabilir bu da uyaranin dogru 
sekilde gidip gitmedigini kontrol etmek icin kullanilabilir
Genellikle orijinal sinifa ust sinif, genisletilen sinifa alt sinif denir
*/

class first;

    int data = 12;

    function void display();
        $display("Value of data : %0d", data);
    endfunction

endclass

class second extends first; //first sinifinin yeteneklerini second sinifiyla genisletecegiz

    int temp = 34;  //genisletme de kullanilacak veri uyesi

    function void add();
        $display("Value after process : %0d", temp+4);
    endfunction
endclass

module Part1_27();

    second s;

    initial begin
        s = new();
        $display("Value of data = %0d", s.data);
        s.display();
        $display("Value of temp = %0d", s.temp);
        s.add();
    end

endmodule





/*
-------------------------      POLYMORPHISM     ----------------------------
EXTENDS ve VIRTUAL, polymorphism in vazgecilmezleridir.

Yani

Parent class handle'i child class object'ini gosterebilir.
Virtual method kullanildiginda cagrilacak method object'in gercek tipine gore belirlenir.

*/
class first;
  
  int data = 12;
  
  virtual function void display();
     $display("FIRST : Value of data : %0d", data);
  endfunction
endclass
 
 
class second extends first;
  
  int temp = 34;
  
  function void add();
    $display("secomd:Value after process : %0d", temp+4);
  endfunction
  
 
  function void display();      //OVERRIDE
    $display("SECOND : Value of data : %0d", data);
  endfunction
endclass
 
 
module Part1_27;
  
  first f;
  second s;
  
  
  initial begin
    f = new();
    s = new();
    
    f = s;  //KRITIK--> f, ana sinif referansi hafizadaki s alt sinif referansini göstermeye
            // baslar. "Handle" yonlendirmesidir. Data kopyalamaz, yeni nesne olusturmaz
            // constructor cagirmaz
    f.display();    //"virtual" olmasaydi first sinifindaki display i calistirirdi
                    //Ama second da override edilmis display i calistirmak istiyoruz
                    //"virtual function void display();" ile eger nesne alt sinifsa ve bu
                    //fonksiyonu kendi icinde override etmişse, git o alt sınıfın
                    //fonksiyonunu calistir
    
  end
endmodule
