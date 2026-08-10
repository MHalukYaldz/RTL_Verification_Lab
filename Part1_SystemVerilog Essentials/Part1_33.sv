`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
     __(task_gen)__                                  (task_driver)
    |  GENERATOR  |  --------------------------->   |  DRIVER     |
    |_____________|         HOLD SIMULATION         |_____________|

GEN     ->  P
DRV     ->  A
MON     ->  R
SCR     ->  A
ENV     ->  L
TEST    ->  E
AGENT   ->  L

    Generator : Verileri uretip driver a gondermelidir
    Driver    : Verileri alacak ve DUT a uygulayacak 
    Bunlar disinda unutulmamasi gereken tum uyaricilari gondermeyi tamamlayana kadar tum 
    simulasyonu tutacak bir goreve daha ihtiyacimiz var.
*/
module Part1_33;

    int data1, data2;
    event done;

    int i;

    ///////GENERATOR
    initial begin
        
        for(i=0; i<10; i++) begin
            data1 = $urandom();   //32-bit isaretsiz tamsayi uretecektir
            $display("Data Sent : %0d", data1);
            #10;                  // 10ns araliklarla yeni veri uretilecektir
        end
        -> done;
    end

    ///////DRIVER
    initial begin
        forever begin               //Simulasyon bitene kadar islemi tekrarlamamizi saglar
            #10;                    //Generator un verilerini olusturmasini bekledik
            data2 = data1;          //data1 den okuyup data2 de saklayacagiz
            $display("Data RCVD : %0d", data2);
        end
    end

/*
Simulasyonu durdurmak icin tum uyaricilari uretmeyi tamamlayip tamamlamadigimizda takip 
edecek bagimsiz bir goreve ihtiyacimiz var. Asagidaki blokta da bunu ekliyoruz :
*/

    initial begin

        wait(done.triggered);
        $finish;

    end
endmodule

/*
Cikti da gormeyi beklemedigimiz şeyler gorecegiz ornegin ilk verinin iletilmemesi ve
son verinin 3 defa goruntulenmesi gerceklesti

Burada sorunumuz tum "initial" bloklarinin paralel calistirilirken girilen yaris durumudur
(race condition).

Fork-join paralel islemleri duzenlemek icin kullanilir.
Race condition'i tek basina cozmez; surecler arasinda event, mailbox veya benzeri
senkronizasyon mekanizmalari kullanmamiz gerekir.
Bu birden fazla islemimiz oldugunda ve 
bunlari paralel olarak calistirmamiz gerektiginde kullaniriz. AMA PROCEDURAL BLOKLARDA 
KULLANACAGIMIZI UNUTMAMALIYIZ. Fork-join isleminin icindeki ifadeler 0ns den itibaren
yurutulmeye baslatilir.

Icerideki islemler yurutulene veya islemlerini tamamlayana kadar bir join den sonra sahip
oldugumuz kodu calistirmamiza izin vermeyecektir.

Sonraki sorunumuz ise hangi baslangic blogunun oncelikli olacagidir, her bir gorev icin 
bunu tahmin edemeyiz takip edilmesi gerekir.

Fork-join
Fork-join_any
Fork-join_none
*/

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module Part1_33;

    int i = 0;
    bit [7:0] data1, data2;
    event done;
    event next;

    task generator();
        for(i=0; i<10; i++) begin
            data1 = $urandom();
            $display("Data Sent : %0d", data1);
            #10;
            wait(next.triggered);
        end
        
        -> done;
    
    endtask

    task receiver();
        forever begin
            #10;
            data2 = data1;
            $display("Data RCVD : %0d", data2);
			-> next;
		end


    endtask

    task wait_event();
        wait(done.triggered);
        $display("Completed Sending all stimulus");
        $finish;
    endtask

    initial begin
        fork
            generator();
            receiver();
            wait_event();
        join

    end
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Simdi farkli fork-join versiyonlari arasindeki farklari anlamaya calisacagiz.

Asagidaki kodda beklenildigi gibi fork-join icindeki tum surecler tamamlandiktan sonra
ucuncu gorev yurutuldu.
Burada surec tamamlanmasaydi fork-join icinden cikamaz ve sonraki isleme gidemezdik
*/
module Part1_33;
  
      task first();
        $display("Task 1 Started at %0t",$time);
      #20;      
        $display("Task 1 Completed at %0t",$time);     
    endtask

    task second();
      $display("Task 2 Started at %0t",$time);
      #30;      
     $display("Task 2 Completed at %0t",$time);     
    endtask

    task third();
      $display("Reached next to Join at %0t",$time);     
    endtask
  
  
  initial begin
    fork
      first();
      second(); 
    join
    
      third();
  end
  
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Fork-join_any ile devam edelim

Burada fork-join icindeki sureclerden birisi tamamlanir tamamlanmaz join den sonraki
sahip oldugumuz sureci yurutmemize izin verecektir
Yani 20.ns de first gorevi tamamlandiktan sonra third gorevi yurutulur.
*/
module Part1_33;
  
      task first();
        $display("Task 1 Started at %0t",$time);
      #20;      
        $display("Task 1 Completed at %0t",$time);     
    endtask

    task second();
      $display("Task 2 Started at %0t",$time);
      #30;      
     $display("Task 2 Completed at %0t",$time);     
    endtask

    task third();
      $display("Reached next to Join at %0t",$time);     
    endtask
  
  
  initial begin
    fork
      first();
      second(); 
    join_any
    
      third();
  end
  
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Fork-join_none ile devam edelim
Adindan da engellemesiz oldugunu anlayabiliriz, icerideki sureclere bakilmaksizin direkt
fork-join den sonraki islemi yurutmeye devam eder
*/

module Part1_33;
  
      task first();
        $display("Task 1 Started at %0t",$time);
      #20;      
        $display("Task 1 Completed at %0t",$time);     
    endtask

    task second();
      $display("Task 2 Started at %0t",$time);
      #30;      
     $display("Task 2 Completed at %0t",$time);     
    endtask

    task third();
      $display("Reached next to Join at %0t",$time);     
    endtask
  
  
  initial begin
    fork
      first();
      second(); 
  join_none
    
      third();
  end
  
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
GENERATOR CLASS     -> task main();
DRIVER CLASS        -> task main();
MONITOR CLASS       -> task main();
SCOREBOARD CLASS    -> task main();
ENVIRONMENT CLASS   -> task main();

Tum bu sistemlerde kullanacagimizi dusunursek isleyis genel olarak soyledir(HOLD SIMULATION):
    1. On_test dedigimiz sifirlama gorevi
    2. Ana testimiz
    3. Son gelen ciktilarin karsilastirilmasi icin yapılmasi gerekenler ornegin scoreboard
        ta verilerimizi gorup karsilastirmak gibi vs.

Yukarida anlatilan siralama da tum simulasyon surecimizi tutan yapilar gosterilmek
istenmistir. Ancak her bir blok(gen.main(); , driv.main();...) icin on test, ana test ve 
son test yapilacaktir. 
*/



//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


module tb;

int count1 = 0;
int count2 = 0;

task first;
    forever begin
        #20;
        $display("Task1 Trigger");
        count1++;
    end
endtask

task second;
    forever begin
        #40;
        $display("Task2 Trigger");
        count2++;
    end
endtask

initial begin
    fork
        first();
        second();
        #200;
        
    join_any

    $display("--------------------------------------");
    $display("Task1 : %0d", count1);
    $display("Task2 : %0d", count2);
    $display("--------------------------------------");

    $finish;

end
endmodule