`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


/*
Rastgelelestirmeden once veya rastgelelestirmeden sonra bir seyler yapmanin yollarini
inceleyecegiz
Bunun icin iki yontemimiz vardır : pre_randomize ve post_randomize
pre  -> randomize() islemi baslamadan once tetiklenir. Ortami hazirlar. Rastgele degerler 
        uretilmeden once belirli degiskenleri sifirlamak bazi kisitlamalari acip kapatmak
        veya rastgelelestirilecek bazi on degerleri atamak icin kullanilir
post -> randomize() islemi bittikten hemen sonra baslar. Son rotuslari yapar. Yeni uretilen
        rastgele sayilari kullanarak kisitlanamayan baska degiskenleri hesaplamak veya 
        degerleri ekrana yazdirmak icin kullanilir

*/
class generator;

    randc bit [3:0] a, b;
    bit [3:0] y;

    int max;
    int min;

    function void pre_randomize(input int min, input int max);
    this.min = min;
    this.max = max;
    endfunction

    constraint data{
        a inside {[min:max]};
        b inside {[min:max]};
    }

    function void post_randomize();
        $display("Value of a : %0d and b : %0d", a, b);
    endfunction
endclass

module Part1_31();

int i = 0;
generator g;

initial begin
    g = new();

    for(i=0; i<10; i++) begin
        g.pre_randomize(3,8);
        g.randomize();
        #10;
    end
end

endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Verdigimiz ilk kisitlamanin bir kova oldugunu dusunursek kisitlamayi degistirdigimiz an da
icinde bir dizi bulunan yeni bir kova olustururuz
Onceki yinelemedeki degerleri tekrar gorebiliriz cunku kisitlamayi degistirir degistirmez
yeni bir kova olustururuz
Randc ile calisirken bunlara dikkat etmeliyiz
*/
class generator;

    randc bit [3:0] a, b;
    bit [3:0] y;

    int max;
    int min;

    function void pre_randomize(input int min, input int max);
    this.min = min;
    this.max = max;
    endfunction

    constraint data{
        a inside {[min:max]};
        b inside {[min:max]};
    }

    function void post_randomize();
        $display("Value of a : %0d and b : %0d", a, b);
    endfunction
endclass

module Part1_31();

int i = 0;
generator g;

initial begin
    g = new();

    $display("SPACE 1");
    g.pre_randomize(3,8);
    for(i=0; i<6; i++) begin
        g.randomize();
        #10;
    end

    $display("SPACE 2");
    g.pre_randomize(3,8);
    for(i=0; i<6; i++) begin
        g.randomize();
        #10;
    end
end

endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
AGIRLIKLI DAGILIM OPERATORU --> dist

":=" operatorunde verilen agirlik, araliktaki her bir degere ayri ayri uygulanir.

    sel dist {0 := 10, [1:3] := 60};

    Agirliklar:
    0 -> 10
    1 -> 60
    2 -> 60
    3 -> 60

    Toplam agirlik = 190

":/" operatorunde verilen agirlik, araliktaki degerler arasinda esit olarak bolunur.

    sel dist {0 :/ 10, [1:3] :/ 60};

    Agirliklar:
    0 -> 10
    1 -> 20
    2 -> 20
    3 -> 20

    Toplam agirlik = 70
*/


class first;

    rand bit wr ;   //  :=
    rand bit rd ;   //  :/

    constraint cntrl {
                      wr dist {0 := 30 , 1 := 70};
                      rd dist {0 :/ 30 , 1 :/ 70};
    };

endclass

module Part1_31();

    first f;

    initial begin
        f = new();
        
        for(int i=0; i<10; i++) begin
            f.randomize();

            $display("Value of wr : %0d and rd : %0d", f.wr, f.rd);
        end
    end

endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

class first;

    rand bit wr ;   //  :=
    rand bit rd ;   //  :/

    constraint cntrl {
                      wr dist {0 := 30 , 1 := 70};
                      rd dist {0 :/ 30 , 1 :/ 70};
    };

endclass

module Part1_31();

    first f;

    initial begin
        f = new();
        
        for(int i=0; i<10; i++) begin
            f.randomize();

            $display("Value of wr : %0d and rd : %0d", f.wr, f.rd);
        end
    end

endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

class first;

    rand bit wr ;   //  :=
    rand bit rd ;   //  :/

    rand bit [1:0] var1;
    rand bit [1:0] var2;

    constraint data {
                    var1 dist {0 := 30 , [1:3] := 90};  // 0=30/300 , 1,2,3=90/300 
                    var2 dist {0 :/ 30 , [1:3] :/ 90};  // 0,1,2,3=0.25
                };

    constraint cntrl {
                      wr dist {0 := 30 , 1 := 70};
                      rd dist {0 :/ 30 , 1 :/ 70};
    };

endclass

module Part1_31();

    first f;

    initial begin
        f = new();
        
        for(int i=0; i<10; i++) begin
            f.randomize();

            $display("Value of var1(:=) : %0d and var2(:/) : %0d", f.var1, f.var2);
        end
    end

endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Kisitlamaya karmasiklik katmak icin 3 operator vardir :
    ///// Implication "->" /////
        Eger sol taraf dogruysa sag taraf kesinlikle dogru olmalidir ; sol taraf yanlissa
        sag tarafla hic ilgilenmez herhangi deger alabilir

    ///// Equivalence "<->" /////
        Iki durumun ve degiskenin durumunu birbirine kilitler, biri dogruysa digeri de 
        dogru, biri yanlissa digeri de yanlistir

    ///// If-else /////
        Implication a cok benzer ancak buyuk farki "else" senaryosu sunabilmesidir ayrica
        "{}" ile daha fazla kist eklenebilir

*/
/////////////////////   IMPLICATION    /////////////////////////////
class generator;

    rand bit a;
    rand bit rst;
    rand bit ce ;
    
    constraint control_rst {
        rst dist {0 := 80 , 1 := 20};
    }
    constraint control_ce {
        ce dist {1 := 80 , 0 := 20};
    }
    constraint control_rst_ce {
        ( rst == 0) -> ( ce == 1);
    }

endclass

module Part1_31();

    generator g;

    initial begin
        g = new();
        
        for(int i=0; i<10; i++) begin
            assert(g.randomize()) else $display("Randomization Failed!");
            $display("Value of rst : %0d and ce : %0d", g.rst, g.ce);
        end
    end

endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/////////////////////   EQUIVALENCE    /////////////////////////////
class generator;

    rand bit [3:0] a;
    rand bit wr;    //write to mem
    rand bit oe;    //output enable
    
    //Yazma ve cikis etkinliginin birbirini dislayan eylem oldugunu unutmayalim (1 ise 0)

    constraint control_wr {
        wr dist {0 := 50 , 1 := 50};
    }
    constraint control_oe {
        oe dist {1 := 50 , 0 := 50};
    }
    constraint control_wr_oe {
        ( wr == 1) <-> ( oe == 0);
    }

endclass

module Part1_31();

    generator g;

    initial begin
        g = new();
        
        for(int i=0; i<10; i++) begin
            assert(g.randomize()) else $display("Randomization Failed!");
            $display("Value of wr : %0d and oe : %0d", g.wr, g.oe);
        end
    end

endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/////////////////////   IF-ELSE    /////////////////////////////
class generator;

    rand bit [3:0] raddr, waddr;
    rand bit wr;    //write to mem
    rand bit oe;    //output enable
    
    //Yazma ve cikis etkinliginin birbirini dislayan eylem oldugunu unutmayalim (1 ise 0)

    constraint control_wr {
        wr dist {0 := 50 , 1 := 50};
    }
    constraint control_oe {
        oe dist {1 := 50 , 0 := 50};
    }
    constraint write_read {
        if(wr == 1)
        {
            waddr inside {[11:15]};
            raddr == 0;
        }
        else
            {
                waddr == 0;
                raddr inside {[11:15]};
            }
    }

endclass

module Part1_31();

    generator g;

    initial begin
        g = new();
        
        for(int i=0; i<15; i++) begin
            assert(g.randomize()) else $display("Randomization Failed!");
            $display("Value of wr : %0b | oe : %0b | raddr : %0d | waddr : %0d |", g.wr
            , g.oe, g.raddr, g.waddr);
        end
    end

endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Bazi durumlarda belirli kisitlamalari calistirmayi isteyebiliriz 
*/
class generator;
  
  randc bit [3:0] raddr, waddr;
  rand bit wr; ///write to mem
  rand bit oe; ///output enable
  
  constraint wr_c {
    wr dist {0:= 50, 1 := 50};
  }
  
  
  constraint oe_c {
    oe dist {1:= 50, 0 := 50};
  }
  
  constraint wr_oe_c {
    ( wr == 1 ) -> (oe == 0); 
  }
 
endclass
 
module Part1_31;
  
  generator g;
  
  initial begin
    g = new();
   
    g.wr_oe_c.constraint_mode(0); ///1 -> COnstraint is on // 0-> constraint is off 
      $display("Constraint Status oe_c : %0d",g.wr_oe_c.constraint_mode()); 
    for (int i = 0; i<20 ; i++) begin
      assert(g.randomize()) else $display("Randomization Failed");
      $display("Value of wr : %0b | oe : %0b | ", g.wr, g.oe);
    end
    
  end
 
endmodule


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////



class generator;

rand logic [7:0] x, y, z;

function void pre_randomize();
    this.x = x;
    this.y = y;
    this.z = z;
endfunction

function void post_randomize();
    $display("Time : %0t ns | Value of x: %0d | y : %0d | z : %0d", $time, x, y, z);
endfunction

endclass

module Part1_31;

    generator g;

    initial begin
        g = new();
        g.pre_randomize();
        for(int i=0; i<20; i++) begin
        assert(g.randomize()) else $display("Randomization Failed !!!");
        #20;
        end
    end

endmodule


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////



class generator;

rand logic [7:0] x, y, z;

int min;
int max;

function void pre_randomize(input int min, input int max);
    this.min = min;
    this.max = max;
endfunction

    constraint cntrl {
        x inside {[min:max]};
        y inside {[min:max]};
        z inside {[min:max]};
    }

function void post_randomize();
    $display("Time : %0t ns | Value of x: %0d | y : %0d | z : %0d", $time, x, y, z);
endfunction

endclass

module Part1_31;

    generator g;

    initial begin
        g = new();
        g.pre_randomize(0,50);
        for(int i=0; i<20; i++) begin
        assert(g.randomize()) else $display("Randomization Failed !!!");
        #20;
        end
    end

endmodule


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////



class generator;
  
  rand bit [4:0] a;
  rand bit [5:0] b;

/*
 constraint data {
    a inside {[0:8]};
    b inside {[0:5]};
 }
*/
 constraint err_data {a<20 ; b<13 ; }
  
endclass

module Part1_31;

    generator g;
    int status;
    int err = 0;

    initial begin
        g = new();
        for(int i=0; i<20; i++) begin
        status = g.randomize();
            //if(status == 0)begin
            //    err = err + 1;
            //end
            if(g.a>8 || g.b>5) begin
                err = err + 1;
            end
        $display("Iteration : %0d | Value of a :%0d and b: %0d status : %0d", i, g.a,g.b, status);
        end

        $display("Error count : %0d", err);
    end


endmodule


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


class generator;

    rand bit wr;
    rand bit rst;

    constraint wr_cntrl {
        wr dist {0 := 30 , 1 := 70};
    }
    constraint rst_cntrl {
        rst dist {0 := 50 , 1 := 50};
    }
    /*
        constraint wr_rst_cntrl {
      (wr == 1) -> (rst == 0);
    }
    */
    constraint wr_rst_cntrl {
        if(wr == 1)
        {    
            rst == 0;
        }
        else
        {
            rst == 1;
        }
    }
endclass

module Part1_31;

    generator g;

    initial begin
        g = new();

        for(int i=0; i<20; i++) begin    
            assert(g.randomize()) else $display("Randomization Failed !!!");
            $display("Iteration : %0t | wr : %0d | rst: %0d", $time, g.wr, g.rst);
            #20;
        end
        
    end

endmodule



//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////



class generator;
  
rand bit [3:0] addr;
rand bit wr;

constraint addr_wr_cntrl{
    if(wr == 1)
    {
        addr inside {[0:7]};
    }
    else
    {
        addr inside {[8:15]};
    }
}

endclass

module Part1_31;

    generator g;

    initial begin
        g = new();

        for(int i=0; i<20; i++) begin    
            assert(g.randomize()) else $display("Randomization Failed !!!");
            $display("Iteration : %0t | addr : %0d | wr: %0d", $time, g.addr, g.wr);
            #20;
        end
        
    end

endmodule


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
FIFO pin
    input clk
    input rst
    input wreq
    input rreq
    input wdata   [7:0]
    output rdata [7:0]
    output full
    output empty
*/

class generator;

    bit clk;
    bit rst;

    rand bit wreq, rreq;
	rand bit [7:0] wdata;

	bit [7:0] rdata;
    bit full;
    bit empty;

    constraint wreq_cntrl {
        wreq dist {0 := 30, 1 := 70};
    }
    constraint rreq_cntrl {
        rreq dist {0 := 30, 1 := 70};
    }
    constraint wreq_rreq_cntrl {
        wreq != rreq; 
    }
endclass