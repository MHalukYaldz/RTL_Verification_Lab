`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

////////////    Interprocess Communication IPC  //////////////////////////////////

/*
Generator' dan Driver' a veri ileteceksek kullaniriz
    Birinci senaryo belirli bir surecin tamamlandigini iletmek istedigimizde event i 
    kullaniriz.
    Ikinci senaryo siniflar arasinda veri iletisimi kurmak istedigimizde semaphore veya 
    mailboz kullaniriz.


    EVENT : Siniflar arasi mesaj iletiminde kullaniriz(Veri iletiminde değil).
            Ornegin bir uretici sinifimiz var ve bir kullanici son uyarici uretmeyi talep etti
            Son uyaran olusturmayi bitirdikten sonra, uyaran olusturmayi bitirdigimize dair
            mesaj iletmek istiyoruz ve artik sinif simulasyonu zorla durdurabilir. Bu durumda 
            event kullanabiliriz
            Event islemlerinde temel olarak "->", "@" ve "wait" kullanabiliriz.

			"->" : Event'i tetikler.
		
			"@"  : Event'in bir sonraki tetiklenmesini bekler ve bloklayicidir.
		
			"wait(a.triggered)" :
           Event'in mevcut time slot icinde tetiklenip tetiklenmedigini kontrol eder.
           Kosul saglanana kadar wait de bloklayicidir.

    SEMAPHORE : Belirli kaynaklara erisim icin kullaniriz. En yaygin ornegi arayuze 
                erismektir. Baska bir ornek, birden fazla sinifin veri eklemek istedigi bir 
                veri kaynagimiz olabilir. Bu tip durumlarda kullanilir.
                    2 operatorumuz vardir : "get" "put"
                        "get" : Belirli bir sinifin bir kaynaga erisebilmesi icin semaforu
                        nasil alacagi amaciyla kullanilir. 
                        
                        "put" : Islem tamamlandiktan sonra nasil geri koyacagimizi veya 
                        serbest birakacagimizi belirtir.

    MAILBOX : Siniflar arasinda veri ve ozellikle de islem verisi gondermemizi saglar. 
              Dolayisiyla bir generator un islem verisi uretecegini, bu verinin bir driver
              a gonderilecegini ve son olarak driver in bunu bir arayuz yardimiyle DUT a 
              uygulayacagini zaten biliyoruz dolayisiyla bir islemin verilerini generator 
              ve driver arasinda iletmek icin mailbox kullaniriz yani monitor ile scoreboard
              arasindaki veriler bir mailbox ile gonderilir. TEMELDE BLOKLAMADIR.
                2 operatorumuz vardir : "get" "put" ayrica "try_get" ve "try_put" ta vardir
                    "put" : Bounded mailbox doluysa bos yer acilana kadar bekleyebilir.
        Unbounded mailbox'ta normalde bloklanmaz.

"get" : Mailbox bos ise veri gelene kadar bekler.

"try_get" ve "try_put" bloklamayan alternatiflerdir.
                    "try_get" ve "try_put" : Bloklama yapmayan versiyonlardir. Bunlar islem
                    o an basarili olmasa bile kodu kilitlemeden aninda geri donus yapar ve
                    akisin alt satirdan devam etmesini saglar.
*/
module Part1_32();

    event a;

    initial begin   //bagimsiz initial bloklari paralel calisir
        #10;
        -> a;
    end

    initial begin
        @(a);   //Bu bir engellemedir. Etkinlik bize ulasana kadar burada bekleyecegiz
        $display("Received Event at %0t", $time);   //10ns sonra edge aldigimizi capraz 
    end                                             //dogrulayacagiz
endmodule

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


//  wait kullanalim. Olayin tetiklenmesini bekleriz
module Part1_32();

    event a;

    initial begin
        #10;
        -> a;
    end

    initial begin
        wait(a.triggered);
        $display("Received Event at %0t", $time);
    end
endmodule

/*
Yukaridaki iki kodda ayni sonucu verir ancak aralarindaki fark "@" kullandigimizda olay adini
parantez icinde belirtirken "wait" ile olay_adi belirtmemizdir
Burada bir olayi beklemek icin "@" ve "wait" kullandik.
*/

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/*
Kenara ve seviyeye duyarli operator ile calisirken hatirlamamiz gerekenler : 

    Kodda olayin tetiklenmeleri arasinda bekleme koyulmamasinin sebebi kenara duyarli
    operator icin engelleme davranisini gorelim diyedir
*/
module Part1_32();

    event a1, a2;

    initial begin
        -> a1;
        -> a2;
    end

    initial begin
        @(a1);
        $display("Event A1 Trigger");
        @(a2);
        $display("Event A2 Trigger");
    end
endmodule

module Part1_32();

    event a1, a2;

    initial begin
        -> a1;
        #10;
        -> a2;
    end

    initial begin
        @(a1);
        $display("Event A1 Trigger");
        @(a2);
        $display("Event A2 Trigger");
    end
endmodule

/*
ilk kodda da ikinci kodda da ciktiyi goremeyecegiz cünkü kenar duyarli oldugundan algilama
aninda olay tekrar gerceklesene kadar sonsuza kadar beklemeye giriyor ancak bu bekleme
olan seviyeye duyarli bir operatorle gerceklesmez cunku mevcut zaman damgasi icin ilerliyor
olacagiz yani olayin seviyesini algilayabilecegiz

@ bir kenar uzerinde calisir bu nedenle bazen bir olayi algilamayi kacirabiliriz bu da 
wait oper.une kiyasla benzersiz kilan ozelligidir
*/


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/* 
a1 bolumunu wait ile degistirip gecikmeyi sabit birakiyoruz ve boylece iki gecikmeyi de 
gorecegiz cunku wait in bittigi anda 10ns bekleme baslamis ve a2 hatti dinliyor ve olacak
10 ns sonunda a2 bekledigine ulasmis olup mesaj yazdirilacaktir
*/
module Part1_32();

    event a1, a2;

    initial begin
        -> a1;
        #10;
        -> a2;
    end

    initial begin
        wait(a1.triggered);
        $display("Event A1 Trigger");
        @(a2);
        $display("Event A2 Trigger");
    end
endmodule

/* 
Gecikmeyi kaldirirsak a2 olayini goremeyiz cunku a2 olayinda kenar algilandi ve a2 nin
tekrar tetiklenme anini gorene kadar bekleyecektir
*/
module Part1_32();

    event a1, a2;

    initial begin
        -> a1;
        //#10;
        -> a2;
    end

    initial begin
        wait(a1.triggered);
        $display("Event A1 Trigger");
        @(a2);
        $display("Event A2 Trigger");
    end
endmodule

// Yukaridakini asagidaki kodla degistirirsek her iki mesaji da goruruz
module Part1_32();

    event a1, a2;

    initial begin
        -> a1;
        //#10;
        -> a2;
    end

    initial begin
        wait(a1.triggered);
        $display("Event A1 Trigger");
        wait(a2.triggered);
        $display("Event A2 Trigger");
    end
endmodule