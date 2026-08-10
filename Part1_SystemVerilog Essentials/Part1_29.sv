`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
Yonlendirilmis Test - Kisitli Rastgeler Test

Uyarani bir dogrulama planina gore olusturabiliriz ancak sistemi
kullanmaya basladigimizda daha sonra bilebilecegimiz gizli hatalari her zaman 
bulamayabiliriz

Zamani azaltmak ve tum olasi hatalari, hic aklimiza gelmeyenleri bile tespit etmek icin iyi
bir strateji kisitli rastgele test kullanmaktir

Bilmemiz gereken ilk sey tasarimimizdaki giris portlari icin rastgele degerler uretmektir

3 kategoride dusunmeliyiz
    Global sinyaller -> clock reset
    Veri sinyalleri  -> WDATA RDATA
    Kontrol sinyalleri-> WR EN CS CE

    rand -> Tekrarlanan adresler istedigimizde kullanilir
    randc -> Tum olasi degerler kapsanana kadar tekrarlanan adrs istemedigimizde 
*/
class generator;
  
  rand bit [3:0] a, b; ////////////rand or randc 
  bit [3:0] y;
endclass
 
module Part1_29;
  generator g;
  int i = 0;
  int status = 0;///////////////////////////////////////////
  
  initial begin
    g = new();
    
    for(i=0;i<10;i++) begin
      g.randomize();
      $display("Value of a :%0d and b: %0d", g.a,g.b);
      #10;
    end
    
  end
endmodule


class generator;
  
  randc bit [3:0] a, b; ////////////rand or randc 
  bit [3:0] y;    
endclass
 
module Part1_29;
  generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    g = new();
    
    for(i=0;i<10;i++) begin
      g.randomize();
      $display("Value of a :%0d and b: %0d", g.a,g.b);
      #10;
    end
    
  end
endmodule

// Randomization in dogru calistigini anlamak icin if-else veya assert kullanabiliriz
//bunlar arasinda hicbir perfomans farki yoktur

// Asagida status degeri randomization isleminin dogru olup olmadigini 0 ve 1 ile gösterir
class generator;
  
  randc bit [3:0] a, b; ////////////rand or randc 
  bit [3:0] y;    
endclass
 
module Part1_29;
  generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    g = new();
    
    for(i=0;i<10;i++) begin
      
      status = g.randomize();
      
      $display("Value of a :%0d and b: %0d with status : %0d", g.a,g.b, status);
      #10;
    end
    
  end
endmodule

//Hatali durumu gormek icin "constraint" kısıtı ekliyoruz
class generator;
  
  randc bit [3:0] a, b; ////////////rand or randc 
  bit [3:0] y;
  
  constraint data { a > 16};//4-bit oldugu icin hata vermesini bekliyoruz

endclass
 
module Part1_29;
  generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    g = new();
    
    for(i=0;i<10;i++) begin
      
      status = g.randomize();
      
      $display("Value of a :%0d and b: %0d with status : %0d", g.a,g.b, status);
      #10;
    end
    
  end
endmodule


//Basarili olunca bildirime gerek yok basarisiz durum icin bildirim alalim
class generator;
  
  randc bit [3:0] a, b; ////////////rand or randc 
  bit [3:0] y;
  
  constraint data { a > 15};//0-15 arasi icin hatalidir

endclass
 
module Part1_29;
  generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    g = new();
    
    for(i=0;i<10;i++) begin
      
      if(!g.randomize()) begin
        $display("Randomization Failed at %0d", $time);
        //finish();
      end
      
      $display("Value of a :%0d and b: %0d with status : %0d", g.a,g.b, status);
      #10;
    end
    
  end
endmodule





//Assert kullanimi
class generator;
  
  randc bit [3:0] a, b;
  bit [3:0] y;
  
  constraint data { a > 15};//0-15 arasi icin rand basarisiz olmali

endclass
 
module Part1_29;
  generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    g = new();
    
    for(i=0;i<10;i++) begin
      /*
      if(!g.randomize()) begin
        $display("Randomization Failed at %0d", $time);
        finish();
      end
      */

        assert(g.randomize()) else begin
            $display("Randomization Failed at %0d", $time);
            finish();
        end

      $display("Value of a :%0d and b: %0d with status : %0d", g.a,g.b, status);
      #10;
    end
    
  end
endmodule