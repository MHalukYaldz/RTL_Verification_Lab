`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

/*/////////////////////////      DESIGN          //////////////////////////////////
module add(
    input [3:0] a,b,
    output reg [4:0] sum,
    input clk
);

always@(posedge clk)
    begin
        sum <= a + b;
    end

endmodule
//////////////////////////      DESIGN          ////////////////////////////////*/

/*
Interface TB/module seviyesinde instance olarak olusturulur:

add_if aif();

Class icinde ise interface'in kendisini olusturmayiz. Mevcut interface instance'ini
gosteren bir virtual interface handle kullaniriz:

virtual add_if aif;

Boylece class, TB'de olusturulmus interface uzerinden DUT sinyallerine erisebilir.
*/
interface add_if;

    logic [3:0] a, b;
    logic [4:0] sum;
    logic clk;

endinterface

class driver;

    virtual add_if aif;
/*
Surucunun mailbox i bekleyecegini ve ardindan mailbox tan verileri alacagini biliyoruz.
Bundan dolayi sonsuza kadar bekleyecegiz. Mailbox kullanmasak bile formatimizi ve iskeletimizi
tamamen benzersiz tutacagiz. 
*/
    task run(); //Ana gorev toplayicinin sinyallerini surmektir
        forever begin
            @(posedge aif.clk);
            aif.a <= 2;
            aif.b <= 3;
            $display("[DRV] : Interface Trigger");
        end

    endtask

endclass

module Part1_36;

    add_if aif();

    add dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

    initial begin
        aif.clk <= 0;   //Testbench sinyallerinde her zaman non-blocking kullanmak zorunlu degildir.
                //Clock kenarlarinda DUT ile race riskini azaltmak icin NBA kullanilabilir.
    end

    always #10 aif.clk <= ~aif.clk;

    driver drv;      //Handle
        
    initial begin
        drv = new();    //Constructor
        drv.aif = aif;  //Class ta sahip oldugumuz interface i testbench e bagladik 
        drv.run();
    end

    initial begin
        #100;
        $finish();
    end
endmodule

/*
Yukaridaki kod birden fazla class sinif ekledigimizde ve siniflardan bir DUT' a sinyal 
gondermeye calistigimizda tipik iskeletimiz olacaktir.

Herhangi bir class bir interface e erisim gerektiriyorsa "virtual" anahtar sozcugu, interface
adi ve kullanici tanimli ad eklememiz gerekiyor.
*/

/*/////////////////////      DUT      ////////////////////////////////////////////////
module add
  (
    input [3:0] a,b,
    output reg [4:0] sum,
    input clk
  );
  
  always@(posedge clk)
    begin
      sum <= a + b;
    end
endmodule

/////////////////////////   Testbench Code  ///////////////////////////////////////////

interface add_if;
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] sum;
  logic clk;
endinterface

class driver;
  
  virtual add_if aif;
  
  task run();
    forever begin
      @(posedge aif.clk);  
      aif.a <= 2;
      aif.b <= 3;
      $display("[DRV] : Interface Trigger");
    end
  endtask
endclass

module tb;
  
 add_if aif();
  driver drv;
  
  add dut (aif.a, aif.b, aif.sum, aif.clk );
 
 
  initial begin
    aif.clk <= 0;
  end
  
  always #10 aif.clk <= ~aif.clk;
 
   initial begin
     drv = new();
     drv.aif = aif;
     drv.run();
     
   end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;  
    #100;
    $finish();
  end
  
endmodule
*/

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

/*
Modport yon belirtmek icin kullanilir. Kablolama da hatalari onlememizi saglar.
Ornegin "logic" kullandigimizde sinyal cift tarafli olarak surulebilir mesela monitorden
cikisin kontrol edilmesi kabul edilemezdir ve bu modport ile onlenebilir.

Asagidaki tasarimda A ve B icin surucumuzden cikislar verilecektir anccak digerleri giris 
olmalidir
*/
interface add_if;
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] sum;
  logic clk;

  modport DRV (output a, b, input clk, sum);

endinterface

class driver;
  
  virtual add_if.DRV aif;
  
  task run();
    forever begin
      @(posedge aif.clk);  
      aif.a <= 2;
      aif.b <= 3;
      $display("[DRV] : Interface Trigger");
    end
  endtask
endclass

module Part1_36;
  
 add_if aif();
  driver drv;
  
  add dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk) );
 
 
  initial begin
    aif.clk <= 0;
  end
  
  always #10 aif.clk <= ~aif.clk;
 
   initial begin
     drv = new();
     drv.aif = aif;
     drv.run();
     
   end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;  
    #100;
    $finish();
  end
endmodule
/*
Yukaridaki kodu farkli derleyicilerde denedigimizde kimisi a ve b nin driver giris 
verilmedigini ayirt edip sadece cikis oldugunu kabul ederek calisacakken kimisi 
herhangi bir hata firlatmadan calismayi surdurecektir.
Dikkat edilerek dusunulmesi gereken sey a ve b nin driver dan cikis, sum ve clk nin
driver a giris olarak olarak verildigidir.
*/

/*//////////////////////////Design
module add
(
    input [3:0] a,b,
    output reg [4:0] sum,
    input clk
  );
  
  
  always@(posedge clk)
    begin
      sum <= a + b;
    end
   
   
endmodule

//////////////////////////////////Testbench

interface add_if;
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] sum;
  logic clk;
  
  modport DRV (input a,b, input sum,clk);
endinterface

class driver;
  
  virtual add_if.DRV aif;
  
  task run();
    forever begin
      @(posedge aif.clk);  
      aif.a <= 2;
      aif.b <= 3;
      $display("[DRV] : Interface Trigger");
    end
  endtask
endclass
module tb;
  
 add_if aif();
  driver drv;
  
  add dut (aif.a, aif.b, aif.sum, aif.clk );
 
 
  initial begin
    aif.clk <= 0;
  end
  
  always #10 aif.clk <= ~aif.clk;
 
   initial begin
     drv = new();
     drv.aif = aif;
     drv.run();
     
   end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;  
    #100;
    $finish();
  end
endmodule*/
