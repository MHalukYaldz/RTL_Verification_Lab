`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



//Orijinal veriyi saklayip islemek icin kopyasini kullanmamiz gerekebilir
//Veri uyesine degil veri uyesinin degerine erisebiliriz
class first;
    int data;
endclass

module Part1_26();

    first f1;   //Handle
    first p1;

    initial begin
        f1 = new();//1. constructor 

        f1.data = 24;//2. processing

        p1 = new f1;// 3. copying data from f1 to p1

        $display("Value of data member : %0d", f1.data);//4. processing

        p1.data = 12;

        $display("Value of data member : %0d", p1.data);//4. processing
        $display("Kopyadan sonra --> Value of data member : %0d", f1.data);//4. processing
    end

endmodule




//class --> birkaç veri uyesi --> Metod --> Custom Copy Metod
// Class ----> Shallow Copy(SIG KOPY.)
// |   | ---->
// Class ----> Deep Copy(DERIN KOPY.)           

//Ilk durumumuzda sadece bir veri uyemiz olsun ve bu veri uyesini yeni nesneye kopyalayalim

class first;

    int data = 34;

endclass

module Part1_26();

    first f1;
    first f2;

    initial begin
        
        f1 = new(); //Constructor

        f1.data = 45;   //Guncelledik

        f2 = new f1;    //Kopyaladik
        f2.data = 123;

        $display("Value of data : %0d", f1.data);
        $display("Value of data : %0d", f2.data);

    end
endmodule




// Ozel bir kopyalama yontemi ekleyelim; bir fonk. class nesnesini dondurecektir

class first;

    int data = 34;

    function first copy();
        copy = new();   //Constructor
        copy.data = data;   //Kopyalama
    endfunction

endclass

module Part1_26();

    first f1;
    first f2;

    initial begin
        
        f1 = new(); //Constructor

        f1.data = 45;   //Guncelledik

        f2 = new f1;    //Kopyaladik
        f2.data = 123;

        $display("Value of data : %0d", f1.data);
        $display("Value of data : %0d", f2.data);



    end
endmodule


//Birden fazla veri olursa asagidaki gibi yapariz
/////////////////////////////////////////////////////////////////////////////////////////
class first;

    int data = 34;
    bit [7:0] temp = 8'h11;

    function first copy();
        copy = new();   //Constructor cagrisi / yeni nesne
        copy.data = data;   //Kopyalama
        copy.temp = temp;
    endfunction

endclass

module Part1_26();

    first f1;   //handle
    first f2;   //handle

    initial begin
        
        f1 = new();
        f2 = new();

        f2 = f1.copy;
        $display("data : %0d, temp : %0x", f2.data, f2.temp);
    end

    /*
    initial begin
        
        f1 = new(); //Constructor

        f1.data = 45;   //Guncelledik

        f2 = new f1;    //Kopyaladik
        f2.data = 123;

        $display("Value of data : %0d", f1.data);
        $display("Value of data : %0d", f2.data);
    end
*/
    endmodule
/////////////////////////////////////////////////////////////////////////////////////////




//SHALLOW COPY --> Bir kaç veri uyesinden olusur
class first;
  
  int data = 12;
  
endclass
 
class second;
  
  int ds = 34;
  
  first f1;     //First nesnesini gosteren handle
  
  function new();   //Diger class icin olusturdugumuz handle constructor a eklenebilir
    f1 = new();     //ve onu kullanilabilir bir class haline getirir
  endfunction       //Constructor eklemezsek o class i kullanamayiz
  
  
endclass
 
 
module Part1_26;
  
  second s1, s2;    //s1 second in orijinalidir; s2 kopyalanandir
  
  initial begin
    s1 = new(); //İsleeyicimiz icin nesne olusturacak bir metot ekliyoruz
    
    s1.ds = 45;
    
    s2 = new s1;    //SIG KOPYA ISLEMI
    
    $display("Value of ds: %0d", s2.ds);
    
    s2.ds = 78;
    
    $display("Value of ds: %0d", s1.ds);
    
    s2.f1.data = 56;
    
    $display("Value of data: %0d", s1.f1.data);
    
  end
endmodule
/*
Burada yapilan sıg kopyalamayla second sinifi kopyalanip "ds" verisi birbirinden bagımsız 
degerlere sahip olabilir.
*/





//////////////////////////////////////////////////////////////////////////////////////////


class first;

    integer unsigned a;
    integer unsigned b;
    
    function integer unsigned mult(input integer unsigned a, input integer unsigned b);
        return a * b;
    endfunction

    function void display(input integer unsigned guncel, input integer unsigned beklenen);
        if(guncel == beklenen)
            $display("Test Passed");
        else
            $display("Test Failed");
        
    endfunction

endclass

module Part1_26;

    first f;
    integer unsigned beklenen;
    integer unsigned result;

    initial begin
        f = new;
        beklenen = 50;
        result = f.mult(2,10);
        f.display(result, beklenen);
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////





//Deep copy 
/*
Kopyalanan nesnedeki veri uyelerinin yaninda handle larla alt nesnelerde kopyalanir
s1 ve s2 deki f1 nesnesi de birbirinden ve orijinal nesneden bagimsizdir
*/

class first;
  
  int data = 12;
  
  function first copy();
        copy = new();
        copy.data = data;   //Tum veri uyeleri bu sekilde eklemeliyiz
    endfunction

endclass
 
class second;
  
  int ds = 34;
  
  first f1;     //First nesnesini gosteren handle
  
  function new();   //Diger class icin olusturdugumuz handle constructor a eklenebilir
    f1 = new();     //ve onu kullanilabilir bir class haline getirir
  endfunction       //Constructor eklemezsek o class i kullanamayiz

  function second copy();
      copy = new();
      copy.ds = ds;   
      copy.f1 = f1.copy;
  endfunction
    
endclass
 
module Part1_26;
  
  second s1, s2;
  
  initial begin
    s1 = new();
    s2 = new();

    s1.ds = 45; //ds=34 tur ve degeri degistirdik
    s2 = s1.copy();     //s1 orijinal nesnemizin tum veri uyelerinin kopyasini aliriz
    $display("Value of ds : %0d", s2.ds);   //s1 handle'ine verdigimiz deger s2 de gorulecek mi?
    s2.ds = 56;//Verdigimiz degeri s1 den gorelim
    $display("Value of ds : %0d", s1.ds);   //s2 deki ds degeri s1 yansımamıştır
    s2.f1.data = 98;//s2 de verdigimiz deger digerinden gorulecek mi bakalim-->data=12
    $display("s1.f1.data : %0d", s1.f1.data);
  end
endmodule

/////////////////////////////////////////////////////////////////////////////////////////
class generator;
  
  bit [3:0] a = 5,b =7;
  bit wr = 1;
  bit en = 1;
  bit [4:0] s = 12;
  
  function void display();
    $display("a:%0d b:%0d wr:%0b en:%0b s:%0d", a,b,wr,en,s);
  endfunction
 
  function generator copy();
    copy = new();
    copy.a  = a;
    copy.b  = b;
    copy.wr = wr;
    copy.en = en;
    copy.s  = s;
  endfunction
endclass
////////////////////////////////////////////////////////////////////////////////////////

module Part1_26;
    
    generator g1, g2;

    initial begin
        g1 = new();

        g2 = g1.copy();

        g1.display();
        g2.display();

        g2.a = 7;
        g2.b = 7;
        g2.en = 0;
        g2.wr = 0;
        g2.s = 7;


        g1.display();
        g2.display();
        
    end

endmodule