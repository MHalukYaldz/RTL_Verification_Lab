`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

/*
Birden fazla uyaranla calisirken dikkatli olmak icin : 
10ns bekleme nesnenin tum surecten gecmesine yetmiyorsa dogru yaniti almadan once nesnenin
icerigi degistirilebilir 
islemi zamaninda tamamlamaz ve randomize yontemini tekrar cagirirsak eski veriler 
kaybolacaktir ve bu da istenmeyebilir
nesne dongude belirtilen gecikmeden daha fazla zaman alirsa bazen yanlis sonuclar verebilir
bunu asmak icin her yeni uyaran icin yeni ve bagimsiz bir nesne uretilebilir

Bunun için de constructor for döngüsünün içine alınarak her yeni deger yeni nesnede saklanir

*/
class generator;
  
  rand bit [3:0] a, b; ////////////rand or randc 
  bit [3:0] y;
  
  
endclass
 
module Part1_30;
  generator g;
  int i = 0;
  int status = 0;
  
  initial begin
   
    
    for(i=0;i<10;i++) begin
      g = new();
      g.randomize();
      $display("Value of a :%0d and b: %0d", g.a,g.b);
      #10;
    end
    
  end
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

//Constraintler sinifa dahili veya harici eklenebilir

class generator;

    randc bit [3:0] a, b;
    bit [3:0] y;

    /*
    constraint data_a {a > 3; a <7;}
    constraint data_b {b ==3;}
    */

    constraint data {a >3; a <7; b >0;}

endclass

module Part1_30;

    generator g;
    int i = 0;
    int status = 0;

    initial begin

        for(i=0; i<10; i++) begin
        
            g = new();
            g.randomize();
            $display("Value of a : %0d and b = %0d", g.a, g.b);
            #10;

        end

    end

endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

//Degerimiz belirli bir aralikta olacaksa "inside" eklemeliyiz

class generator;

    randc bit [3:0] a, b;
    bit [3:0] y;

    constraint data {
                    a inside {[0:8],[10:11],15};
                    b inside {[3:11]};
                    }

endclass
module Part1_30;

    generator g;
    int i = 0;
    int status = 0;

    initial begin
        for(i=0; i<10; i++) begin
        
            g = new();
            g.randomize();
            $display("Value of a = %0d and b : %0d", g.a, g.b);
            #10;
        
        end
    end

endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

//Belirli bir degeri almamamiz gerektiginde ise
class generator;

    randc bit [3:0] a, b;
    bit [3:0] y;

    /*
    constraint data {
                    a inside {[0:8],[10:11],15};
                    b inside {[3:11]};
                    }
    */


    //En disa parantez ekleyerek ve not operatoruyle yaptik
    constraint data {
                    !(a inside {[3:7]});
                    !(b inside {[5:9]});
                    }

endclass
module Part1_30;

    generator g;
    int i = 0;
    int status = 0;

    initial begin
        for(i=0; i<10; i++) begin
            g = new();
            g.randomize();
            $display("Value of a : %0d and b : %0d", g.a, g.b);
            #10;
        end
    end

endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


//Kisitlamalar sinif disindan da olabilir
//Bunlar icinde "extern" anahtar sozcugunu kullaniriz
class generator;

    randc bit [3:0] a, b;
    bit [3:0] y;

    extern constraint data;/////////////////////////////////////////////////////////

    extern function void display();///////Fonksiyon prototipini tanimladik
    //deger donmeyecegi icin "void" yaptik

endclass

//////////////////////////////////////////////////////////////////////////////////
constraint generator::data {                    //"::" operatorune scope denir
                            a inside {[0:3]};
                            b inside {[12:15]};
                            };


function void generator::display();
    $display("Value of a : %0d and b : %0d", a, b);
endfunction
//////////////////////////////////////////////////////////////////////////////////

module Part1_30;

    generator g;
    int i = 0;
    int status = 0;

    initial begin
        g = new();

        for(i=0; i<10; i++)begin

            assert(g.randomize()) else $display("Randomization Failed");            
                g.display();
                #10;
        end
    
    end

endmodule
