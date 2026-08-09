
//EDAPlayGround

`include "test.sv"
`timescale 1ns/1ps

module Part1_9;
  
  reg sclk = 0;   //////sclk represent SPI Clock Signal
  
  
  /////// User code for generating clock goes here
  ///// Generate 9 MHz Clock stimulus for signal sclk with 50% Duty cycle and up to 3 decimal places
  
	initial begin
    	sclk = 1'b0;
    end
    
  	always begin
      #55.555;
      sclk = 1'b1;
      #55.555;
      sclk = 1'b0;
    end
  
  
  /////// User code ends here
 
  
  
  
 
  /////Do not change any code after this ->
  
  sub_tb s (sclk);
  
 initial 
   begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #800;
    $stop;
  end
  
  
endmodule
/*
Bir SPI modülünün "sclk" adlı seri saat sinyalinden oluştuğunu varsayalım. Bir başlangıç 
bloğu kullanarak sclk'yi '0' olarak başlatın ve sclk sinyali için 9 MHz'lik bir kare 
dalga dalga formu oluşturun. Zaman ölçeğinin 1 ns/1 ps olduğunu varsayalım. Saat 
periyodunun yarısı değeri, kayan nokta sayısal değer durumunda virgülden sonra en fazla 3 basamak hassasiyete sahip olmalıdır.

111.111 ns

Edaplayground projesinde bir test tezgahı iskeleti zaten sağlanmıştır. Göreviniz, sclk 
sinyalini kullanarak saat uyarısı oluşturmaktır. Yalnızca "Saat oluşturmak için kullanıcı 
kodu buraya gelir" bölümüne mantık ekleyin ve "kullanıcı kodu burada biter" ifadesinden 
önce kodu tamamlayın.

İhtiyacınız olduğu kadar satır kullanabilirsiniz. Kendi kendini kontrol eden mantık için 
gerekli olduğundan kodun geri kalanını değiştirmeyin, ancak bu alan içindeki kodunuzu 
serbestçe değiştirebilirsiniz.
*/

//----------------------------------------------------------
/*

`include "test.sv"
`timescale 1ns/1ps
 
module tb;
  
  reg rst  = 0;   //////rst represent DUT reset Signal
  bit clk = 0; 
  always #55.556 clk = ~clk;
  
  sub_tb s (clk);
  
 initial 
   begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #400;
    $stop;
  end
  
  
endmodule
---------------------------------------------------------------------------------
*/