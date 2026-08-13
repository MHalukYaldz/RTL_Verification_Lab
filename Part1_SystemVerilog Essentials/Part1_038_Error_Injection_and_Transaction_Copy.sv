`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*      3 ALTIN KURAL
------Add constructor to Transaction in the Custom Constructor of Generator------
/////////////////////////////////////////////////////////////////////////
class generator;                                                        |
    transaction trans;                                                  |
                                                                        |
    function new(mailbox #(transaction) mbx);                           |
        this.mbx = mbx;                                                 |
        trans = new();                                                  |
    endfunction                                                         |
endclass                                                                |
/////////////////////////////////////////////////////////////////////////
Yukaridaki yapiyla gecmisi hatirlayabilen tek bir alan olusturmamiz saglanir ve dogru
"randc" davranisini elde ederiz.

------Send Deep Copy of transaction object instead of Original transaction object------
"mbx.put(trans)" yazarsak mailbox'a object'in kendisinin yeni bir kopyasi degil,
ayni object'i gosteren class handle aktarilir. Generator 10ns hizinda cok hizli calistigi icin surekli olarak o RAM
adresindeki veriyi degistirir(randomize). Driver kendi yavas 20ns hizinda mailbox tan 
o veriyi alip dosyaya baktiginda, eski veriyi coktan kacirmis olur. Karsisinda hep generator
in en son ezdigi guncel veriyi bulur. Yani hizli olan taraf, yavas olan tarafin okumasina
firsat vermeden veriyi ezer.

Eger "mbx.put(trans.copy())" yazarsak, generator o anki degerlerin hafizada yepyeni bir 
klonunu yaratir ve mailbox a bu bagimsiz klonu atar. Artik generator 10ns hiziyla deli gibi
yeni rastgele sayilar uretip kendi ana nesnesini degistirse bile, mailbox taki klonlar 
bundan kesinlikle etkilenmez. Driver 20ns veya 100ns gibi yavas hizda calissa bile mailbox
a gittiginde verileri sirasiyla ve ezilmemis halde bulur.

----------------Send Deep Copy---------------------------------------------------------
Normal test akisini bozmadan araya bozuk veriler sizdirmamiz gerekir. Inheritance ve Deep 
copy yetenegimiz sayesinde belirli kosullar saglandiginda kasten yanlis hesaplanmis klon 
paketleri driver a caktirmadan mailbox a atariz.
*/
class transaction;
 randc bit [3:0] a;
 randc bit [3:0] b;
  bit [4:0] sum;
  
  
   function void display();
    $display("a : %0d \t b: %0d \t sum : %0d",a,b,sum);
  endfunction
  
  
endclass
 
class error extends transaction;
  
  constraint data_c {a ==  0; b == 0;}
  
endclass

 
class generator;
  
  transaction trans;
  mailbox #(transaction) mbx;
  event done;
 
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run();
    trans = new();
    for(int i = 0; i<10; i++) begin
      trans.randomize();
      mbx.put(trans);
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
  
  modport DRV (input a,b, input sum,clk);
  
 
  
endinterface
 
 
class driver;
  
  virtual add_if aif;
  
  mailbox #(transaction) mbx;
  
  transaction data;
  
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

module Part1_38;
  
 add_if aif();
 driver drv;
 generator gen;
  error err;
  
  
  event done;
 
  
   mailbox #(transaction) mbx;
  
  add dut (aif.a, aif.b, aif.sum, aif.clk );
 
 
  initial begin
    aif.clk <= 0;
  end
  
  always #10 aif.clk <= ~aif.clk;
 
   initial begin
     mbx = new();
     err = new();
     drv = new(mbx);
     gen = new(mbx);
     
     gen.trans = err;
     
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

class transaction;
    randc bit [3:0] a,b;
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



class error extends transaction;
    constraint data_c {a == 0 ; b == 0;}
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
        for(int i=0; i<10; i++) begin
            trans.randomize();
            mbx.put(trans.copy);
            $display("[GEN] : Data Sent to Driver");
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

module Part1_38;
    add_if aif();
    driver drv;
    generator gen;
    event done;
    event next;
    error er;

    mailbox #(transaction) mbx;

    add dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

    initial begin
        aif.clk <= 0;
    end

    always #10 aif.clk <= ~aif.clk;
    
    initial begin
        mbx = new();
        drv = new(mbx);
        gen = new(mbx);
        drv.aif = aif;
        er = new();
        gen.trans = er;
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
//Yukaridaki testbench i duzenleyip islevlerinin degistirelim
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

class transaction;
    randc bit [3:0] a,b;
    bit [4:0] sum;

    function void display();
        $display("a : %0d \t b : %0d \t sum : %0d", a, b, sum);
    endfunction
    
    virtual function transaction copy();    //<<<<<<<------------
        copy = new();
        copy.a = this.a;
        copy.b = this.b;
        copy.sum = this.sum;
    endfunction
endclass



class error extends transaction;
    //constraint data_c {a == 0 ; b == 0;}

    function transaction copy();    //<<<<<<<------------
        copy = new();               //<<<<<<<------------
        copy.a = 0;                 //<<<<<<<------------
        copy.b = 0;                 //<<<<<<<------------
        copy.sum = this.sum;        //<<<<<<<------------
    endfunction                     //<<<<<<<------------
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
        for(int i=0; i<10; i++) begin
            trans.randomize();
            mbx.put(trans.copy);
            $display("[GEN] : Data Sent to Driver");
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

module Part1_38;
    add_if aif();
    driver drv;
    generator gen;
    event done;
    event next;
    error er;

    mailbox #(transaction) mbx;

    add dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

    initial begin
        aif.clk <= 0;
    end

    always #10 aif.clk <= ~aif.clk;
    
    initial begin
        mbx = new();
        drv = new(mbx);
        gen = new(mbx);
        drv.aif = aif;
        er = new();
        gen.trans = er;
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
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
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
  
  virtual function transaction copy();
    copy = new();
    copy.a = this.a;
    copy.b = this.b;
    copy.sum = this.sum;
  endfunction
  
endclass
 
class error extends transaction;
  
  constraint data_c {a == 0 ;  b == 0;} 
  
function transaction copy();
    copy = new();
    copy.a = 12;
    copy.b = 12;
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
 
 
 
module tb;
  
 add_if aif();
 driver drv;
 generator gen;
  event done;
  event next;  
  error er;
 
  
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
     er = new();
     gen.trans = er;
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
