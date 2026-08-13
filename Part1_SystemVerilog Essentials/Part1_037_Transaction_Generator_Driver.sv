`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
Generator ve transaction sinifini dahil edecek sekilde genisletelim
Ilk dusunulmesi gereken 2-state mi 4-state ile mi calisacagimizdir
Bu ornekte 2-state ile calistigimizi varsayalim
*/

class transaction;

    randc bit [3:0] a;
    randc bit [3:0] b;
    bit [4:0] sum;

    function void display();
        $display("a : %0d \t b : %0d \t sum : %0d", a, b, sum);
    endfunction

    function transaction copy();
		copy = new();
		copy.a = this.a;
		copy.b = this.b;
		copy.sum = this.sum;
	endfunction
endclass

class generator;
    transaction trans;
    mailbox #(transaction) mbx;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
        trans = new();
    endfunction

    task run();
        for(int i=0; i<10; i++) begin
            //trans = new(); //Burada kullanirsak degerler tekrarlanir. Deep copy ile calisalim
            assert(trans.randomize()) else $display("Randomization Failed!!!");
            $display("[GEN] : DATA SENT TO DRIVER");
            trans.display();
            mbx.put(trans.copy);
        end
    endtask
endclass

module Part1_37;

generator gen;
mailbox #(transaction) mbx;

initial begin
    mbx = new();
    gen = new(mbx);
    gen.run();
end

endmodule

/*
Yukaridaki kodda dikkat edilmesi gereken şeylerden birincisi "trans.new" in dongu icinde
yazilmasiyle degerin her dongu baslangicinda hafizaya alinmayip tekrar eden degerler verilmesi
gorulur.
Bunu asmak icin dongu disina gelisi guzel koyulursa da tek bir nesne guncellenip posta
kutusuna atilirsa ve driver bu veriyi okumakta gecikirse generator dongude donup ayni nesnenin
icindeki a ve b degerlerini ezerek degistirir. Driver paketi actiginda eski verileri degil
en son uretilen yani ezilmis veriyi gorur.

Bunlari gidermek icin asil nesneyi koruyup kopyalari gonderiyoruz
    
    Tek bir ana nesne yaratiyoruz : Generator un new fonksiyonunda trans.new diyerek tek bir
    ana nesne yarattik. Artik trans.randomize calistikca randc hafizasi korunacak ve tekrar
    etmeyecek.

    Driver a klonlari getir : mbx.put(trans) demek yerine transaction sinifinin icine 
    yazdigimiz ozel kopyalama fonksiyonunu cagirarak mbx.put(trans.copy) diyoruz.

    Kazancimiz ne oldu : Driver a ana nesneyi degil, o anki degerlerle doldurulmus yepyeni
    ve bagimsiz bir klon nesne gonderiyoruz. Boylece generator ana nesneyi bir sonraki
    dongude guncellese bile posta kutusundaki bagimsiz klonlar etkilenmiyor. Hem randc
    duzgun calisiyor hem de veriler ezilmiyor. 
*/


/*
Hatirlamamiz gereken onemli kurallar soyledir :

1.  Transaction constructor inin generator in ozel constructor ina eklemektir.

2.  Generator ve driver arasindaki islemin bir kopyasini yada bunun yerine derin bir kopyasini
    gondermektir. Boylece nesnemizi bir testbench in tum yolunu tamamlamak icin harcanan
    sureden bagimsiz tutacaktir.
*/

/*///////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

class transaction;
  
 randc bit [3:0] a;
 randc bit [3:0] b;
  
  function void display();
    $display("a : %0d \t b: %0d ", a,b);
  endfunction
  
  function transaction copy();
    copy = new();
    copy.a = this.a;
    copy.b = this.b;
  endfunction
  
endclass
 
 
 
class generator;
  
  transaction trans;
  mailbox #(transaction) mbx;
  int i = 0;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    trans = new();
  endfunction 
  
  task run();
    for(i = 0; i<20; i++) begin
      assert(trans.randomize()) else $display("Randomization Failed");
      $display("[GEN] : DATA SENT TO DRIVER");
      trans.display();
      mbx.put(trans.copy);
    end
 
  endtask
   
  
endclass
 
 
 
module tb;
  
generator gen;
mailbox #(transaction) mbx;
  
  
  
  initial begin
    mbx = new();
    gen = new(mbx);
    gen.run();
    end
 
  
endmodule

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////*/

////////////////////////        SIMDI TUMUNU BIRLESTIRELIM      ////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

class transaction;
    randc bit [3:0] a;
    randc bit [3:0] b;
    bit [4:0] sum;
  
    function void display();
        $display("a : %0d \t b: %0d \t sum : %0d",a,b,sum);
    endfunction
  
    function transaction copy();
        copy = new();
        copy.a = this.a;
        copy.b = this.b;
        copy.sum = this.sum;
    endfunction
  
endclass
 
 
class generator;
  
    transaction trans;
    mailbox #(transaction) mbx;
    event done;
  
    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
        trans = new();
    endfunction
  
  
    task run();
        for(int i = 0; i<10; i++) begin
            trans.randomize();
            mbx.put(trans.copy);
            $display("[GEN] : DATA SENT TO DRIVER");
            trans.display();
            #20;
        end
        -> done;
    endtask
  
endclass
 
interface add_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] sum;
    logic clk;
endinterface
 
 
class driver;
  
    virtual add_if aif;
    mailbox #(transaction) mbx;
    transaction data;
    event next;
  
    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction 
  
  
    task run();
        forever begin
          mbx.get(data);
          @(posedge aif.clk);  
          aif.a <= data.a;
          aif.b <= data.b;
          $display("[DRV] : Interface Trigger");
          data.display();
        end
    endtask
  
  
endclass

module Part1_37;
  
    add_if aif();
    driver drv;
    generator gen;
    event done;
 
  
    mailbox #(transaction) mbx;
  
    add dut (aif.a, aif.b, aif.sum, aif.clk );
 
 
    initial begin
        aif.clk <= 0;
    end
  
    always #10 aif.clk <= ~aif.clk;
 
    initial begin
        mbx = new();
        drv = new(mbx);
        gen = new(mbx);
        drv.aif = aif;
        done = gen.done;
    end
  
    initial begin
    fork
        gen.run();
        drv.run();
    join_none
        wait(done.triggered);
        $finish();
    end
  
  
    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars;  
    end
  
endmodule

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

//Design Code:
//
//module top
//(
//  input clk,
//  input [3:0] a,b,
//  output reg [7:0] mul
//);
//  
//  always@(posedge clk)
//    begin
//     mul <= a * b;
//    end
//  
//endmodule

class transaction;

    randc logic [3:0] a, b;
    logic [7:0] mul;

    function transaction copy();
        copy = new();
        copy.a = this.a;
        copy.b = this.b;
        copy.mul = this.mul;
    endfunction

    function void display();
      $display("a : %0d \t b : %0d \t mul : %0d", a, b, mul);
    endfunction
endclass

class generator;

    transaction trans;
    mailbox #(transaction) mbx;
    event done;
    int i;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
        trans = new();      //<<<<<<-----------
    endfunction

    task run();
        for(i=0; i<10; i++) begin
            trans.randomize();
          mbx.put(trans.copy());
            $display("[GEN] : Data Sent to Driver");
            trans.display();
            #20;
        end
        -> done;
    endtask
endclass


interface top_if;
    
    logic clk;
    logic [3:0] a;
    logic [3:0] b;
  	logic [7:0] mul;

endinterface


class driver;

    virtual top_if tif;
    mailbox #(transaction) mbx;
    transaction data;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        forever begin
          mbx.get(data);
            @(posedge tif.clk);
            tif.a <= data.a;
            tif.b <= data.b;
            $display("[DRV] : Interface Trigger");
            data.display();
        end
    endtask
endclass

module Part1_37;

    top_if tif();
    driver drv;
    generator gen;
    event done;
    
    mailbox #(transaction) mbx;

    top dut (.a(tif.a), .b(tif.b), .mul(tif.mul), .clk(tif.clk));

    initial begin
        tif.clk <= 0;
    end

    always #10 tif.clk = ~tif.clk;

    initial begin
        mbx = new();
        drv = new(mbx);
        gen = new(mbx);
        drv.tif = tif;
        done = gen.done;
    end

    initial begin
        fork
            gen.run();
            drv.run();
        join_none
            wait(done.triggered);
            $finish();
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
    
endmodule
