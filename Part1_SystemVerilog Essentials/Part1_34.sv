`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
Semaphore, birden fazla surecin ortak bir kaynaga erisimini kontrol etmek icin kullanilir.

new(N) ile baslangictaki anahtar sayisi belirlenir.
get(N), yeterli anahtar yoksa bekler.
put(N), kullanilan anahtarlari semaphore'a geri verir.

Semaphore veri tasimak icin degil, kaynak erisimini senkronize etmek icin kullanilir.
*/

class first;
  
  rand int data;
  constraint data_c {data < 10; data > 0;}
 
endclass

class second;
  
  rand int data;
  constraint data_c {data > 10; data < 20;}
  
endclass
 
class main;
  
  semaphore sem;
  
  first f;
  second s;
  
   int data;
   int i = 0;
  
  
  task send_first();
    
        sem.get(1);
    
    for(i = 0; i<10; i++) begin
      f.randomize();
      data = f.data;
      $display("First access Semaphore and Data sent : %0d", f.data);
      #10;
    end 
    
    sem.put(1);
    
    $display("Semaphore Unoccupied");
  endtask
  
    task send_second();
    sem.get(1); 
    
    for(i = 0; i<10; i++) begin   
      s.randomize();
      data = s.data;
      $display("Second access Semaphore and Data sent : %0d", s.data);
      #10;
    end  
    
    sem.put(1);
    $display("Semaphore Unoccupied");
    
  endtask
  
  task run();
    sem = new(1);
    f = new();
    s = new();
  
   fork
     send_first();
     
     send_second();
   join
   
  endtask
endclass
 
module Part1_34;
  
  main m;
  
  initial begin
    m = new();
    m.run(); 
  end
  
  initial begin
    #250;
    $finish();
  end
  
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Mailbox siniflar veya paralel surecler arasinda veri aktarmak icin kullanilir.

put() mailbox'a veri ekler.
get() mailbox'tan veri alir.

Generator ve driver'in haberlesebilmesi icin ikisinin de ayni mailbox object'ine
erismesi gerekir. Bu nedenle mailbox TB'de bir kez olusturulup iki class'a da ayni
handle aktarilir.

Typed mailbox kullanimi:
mailbox #(transaction)
*/

class generator;
  
  int data = 12;
   mailbox mbx;
  
  task run();
    mbx.put(data);
    $display("[GEN] : Data Send from Gen : %0d ",data);
  endtask
  
endclass
 
class driver;
  mailbox mbx;
  int data;
  
  task run();
    mbx.get(data);
    $display("[DRV] : DATA rcvd : %0d",data);
  endtask
  
endclass

module Part1_34;
  generator gen;
  driver drv;
  mailbox mbx;
  
  initial begin
    gen = new();
    drv = new();
    mbx = new();
    
   gen.mbx = mbx;
   drv.mbx = mbx; 
    
    gen.run();
    drv.run();
  end
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Farkli siniflar arasinda constructor eklemek yerine ozel bir constructor dan yardim alarak
siniflar arasinda calisan mailbox ile degistirmeyi deneyelim
*/
class generator;
  
  int data = 56;
  
  mailbox mbx; ///gen2drv
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    mbx.put(data);
    $display("[GEN] : SENT DATA : %0d", data);    
  endtask   
endclass
 
class driver;
  int datac = 0;
  mailbox mbx;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    mbx.get(datac);
    $display("[DRV] : RCVD Data : %0d", datac);
  endtask
  
endclass
 
module Part1_34;
  
  generator gen;
  driver drv;
  mailbox mbx;
  
  initial begin
    mbx = new();
    
    gen = new(mbx);
    drv = new(mbx);

    gen.run();
    drv.run();
    
  end
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Mailbox i transaction class i ile kullanmayi deneyelim
*/
class transaction;
  
  rand bit [3:0] din1;
  rand bit [3:0] din2;
  bit [4:0] dout;
 
  
endclass

class generator;
  
  transaction t;
  mailbox mbx;
  
  function new(mailbox mbx);
  this.mbx = mbx;  
  endfunction
  
  task main();
    
    for(int i = 0; i < 10; i++) begin
      t = new();
      assert(t.randomize()) else $display("Randomization Failed");
      $display("[GEN] : DATA SENT : din1 : %0d and din2 : %0d", t.din1, t.din2);
      mbx.put(t);      
      #10;
    end
  endtask
  
endclass

class driver;
  
  transaction dc;
  mailbox mbx;
  
  function new(mailbox mbx);
  this.mbx = mbx;  
  endfunction
  
  task main();
    forever begin
      mbx.get(dc);
      $display("[DRV] : DATA RCVD : din1 : %0d and din2 : %0d", dc.din1, dc.din2);
      #10;
    end
    endtask
  
endclass
 
module Part1_34;
  generator g;
  driver d;
  mailbox mbx;

  initial begin
    mbx = new();
    g = new(mbx);
    d = new(mbx);

    fork 
      g.main();
      d.main();
    join

  end
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Parametrelendirilmis mailbox
    Buyuk kod tabanlariyla calisirken cok kullanislidir.

    Asagidaki parametrelendirilmemis mailbox kullanimidir
*/

class transaction;

    bit [7:0] data;

endclass

class generator; 

    int data = 12;

    mailbox mbx;

    logic [7:0] temp;

    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction

    task run();
        mbx.put(temp);
        $display("[GEN] : Data Send from Gen : %0d", data);
    endtask
endclass

class driver;
    mailbox mbx;
    transaction data;

    function new;
        this.mbx = mbx;
    endfunction

    task run;
        mbx.get(data);
        $display("[DRV] : DATA rcvd : %0d", data.data);
    endtask    
endclass

module Part1_34;
    generator gen;
    driver drv;
    mailbox mbx;

    initial begin
        mbx = new();
        gen = new(mbx);
        drv = new(mbx);

        gen.run();
        drv.run();
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Parametrelendirilmis hali asagidadir => #(transaction)||||||||||||||
*/
class transaction;

    bit [7:0] data;

endclass

class generator; 

    int data = 12;
    transaction t;

    mailbox #(transaction) mbx;

    logic [7:0] temp = 3;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        t = new();//////////////////////////////////////////////////
        t.data = 45;//////////////////////////////////////////////////
        mbx.put(t);
        $display("[GEN] : Data Send from Gen : %0d", t.data);
    endtask
endclass

class driver;
    mailbox #(transaction) mbx;
    transaction data;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run;
        mbx.get(data);
        $display("[DRV] : DATA rcvd : %0d", data.data);
    endtask    
endclass

module Part1_34;
    generator gen;
    driver drv;
    mailbox #(transaction) mbx;

    initial begin
        mbx = new();
        gen = new(mbx);
        drv = new(mbx);

        gen.run();
        drv.run();
    end
endmodule

/*
Yukaridaki yapilarda parametre dedigimiz; siniflar arasinda gonderilen veri turunu
belirttigimiz yapilardir
Parametre kullandigimizda amac sadece "log" taki uyarilari kaldirmak icin degildir ayrica
yanlis veri gonderdigimizde da hata verecektir
*/

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Asagidaki ornek mailbox kullanilarak transaction islemi yaptigimiz ornektir burada parametre
ekleyerek tekrar inceleyelim
*/

class transaction;
  
  rand bit [3:0] din1;
  rand bit [3:0] din2;
  bit [4:0] dout;
 
  
endclass

class generator;
  
  transaction t;
  //mailbox mbx;
  mailbox #(transaction) mbx;     //<<<<<---------
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;  
  endfunction
  
  task main();
    
    for(int i = 0; i < 10; i++) begin
      t = new();
      assert(t.randomize()) else $display("Randomization Failed");
      $display("[GEN] : DATA SENT : din1 : %0d and din2 : %0d", t.din1, t.din2);
      mbx.put(t);      
      #10;
    end
  endtask
  
endclass

class driver;
  
  transaction dc;
  mailbox #(transaction) mbx;
  
  function new(mailbox #(transaction) mbx);
  this.mbx = mbx;  
  endfunction
  
  task main();
    forever begin
      mbx.get(dc);
      $display("[DRV] : DATA RCVD : din1 : %0d and din2 : %0d", dc.din1, dc.din2);
      #10;
    end
    endtask
  
endclass
 
module Part1_34;
  generator g;
  driver d;
  mailbox #(transaction) mbx;

  initial begin
    mbx = new();
    g = new(mbx);
    d = new(mbx);

    fork 
      g.main();
      d.main();
    join

  end
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


class transaction;
 
bit [7:0] addr = 7'h12;
bit [3:0] data = 4'h4;
bit we = 1'b1;
bit rst = 1'b0;
 
endclass

class generator;
  
  transaction t;
  mailbox #(transaction) mbx;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run;
    t = new();
    mbx.put(t);
    $display("[GEN] => addr : %0d | data : %0d | we : %0b | rst : %0b", t.addr, t.data, t.we, t.rst);
  endtask
endclass

class driver;
  
  transaction t;
  mailbox #(transaction) mbx;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run();
    t = new();//////////////////////////////////////////////////////
    mbx.get(t);
    $display("[DRV] => addr : %0d | data : %0d | we : %0b | rst : %0b", t.addr, t.data, t.we, t.rst);
  endtask
endclass

module Part1_34;

  generator gen;
  driver drv;
  mailbox #(transaction) mbx;

  initial begin

    mbx = new();
    gen = new(mbx);
    drv = new(mbx);

    fork
      gen.run();
      drv.run();
  join

  end

endmodule

/*
Yukaridaki kodda gozden kacirdigim sey zaten "generator" tarafinda uretilen "t=new();"
bos nesnesini "driver" da tekrar uretmemdir. Buna gerek yok zaten uretilip ici doldurulmus
bir nesne vardir. "put" ile verilip "get" ile de tasinmistir. Bu sadece bellekte gereksiz
yer kaplar.
*/

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


class transaction;
 
rand bit [7:0] a;
rand bit [7:0] b;
rand bit wr;
 
endclass

class generator;

  transaction t;
  mailbox #(transaction) mbx;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run;
    for(int i=0; i<10; i++) begin
      t = new();
      assert(t.randomize()) else $display("Randomization Failed!!!");
      mbx.put(t);
      $display("[GEN] => a : %0d | b : %0d | wr : %0d", t.a, t.b, t.wr);
    end
  endtask
endclass

class driver;

  transaction t;
  mailbox #(transaction) mbx;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run;
    for(int i=0; i<10; i++) begin
      mbx.get(t);
      $display("[DRV] => a : %0d | b : %0d | wr : %0d", t.a, t.b, t.wr);
    end
  endtask
endclass

module Part1_34;

  mailbox #(transaction) mbx;
  generator gen;
  driver drv;

  initial begin

    mbx = new();
    gen = new(mbx);
    drv = new(mbx);
  
    fork
      gen.run();
      drv.run();
    join
  end
endmodule