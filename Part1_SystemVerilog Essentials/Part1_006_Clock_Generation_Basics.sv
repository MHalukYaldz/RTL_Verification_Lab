`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Part1_6();

reg clk;
reg rst;

initial begin
    clk = 1'b0;
    rst = 1'b0;
end

reg clk100 = 0;
reg clk50  = 0;
reg clk25  = 0;

always #5  clk100 = ~clk100;  // 100 MHz
always #10 clk50  = ~clk50;   // 50 MHz
always #20 clk25  = ~clk25;   // 25 MHz

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
end

initial begin
    #200;
    $finish();
end
endmodule
/*
Always ile initial blogu arasindeki en temel farklardan birisi:
always blogu simulasyon sonuna kadar sürekli olarak çalışır ve belirli bir koşula bağlı 
olarak tetiklenir. Initial blogu ise sadece bir kez çalışır ve genellikle başlangıç 
değerlerini atamak veya test senaryolarını başlatmak için kullanılır. always blogu simulasyon boyunca tekrar tekrar calisir. Kullanima gore delay veya event control ile zamanlamasi belirlenebilir. initial blogu sadece 
simülasyonun başlangıcında çalışır ve daha sonra tekrar çalışmaz. 
Bu nedenle, always blogu sürekli olarak çalışırken, initial blogu sadece bir kez çalışır 
ve ardından durur.

Testbench tarafinda always blogunun yaygin kullanimlarindan biri saat sinyali uretmektir.

Burada 100MHz frekans uretmek istedigimizi varsayalim:
100MHz -> 10ns
50MHz -> 20ns
25MHz -> 40ns

Burada 5ns high ve 5ns low ile saat frakansımız olusmus olur.

Bir always blogu surekli olarak tekrarlanir. Bir always blogunda gecikme, olay denetimi
veya enegelleyici islem bulunmuyorsa bu durum sifir sureli sonsuz bir dongu olusturabilir
ve simulasyon suresinin ilerlemesini engelleyebilir.

*/
