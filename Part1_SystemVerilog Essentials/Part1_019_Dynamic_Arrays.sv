`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*--------------------------------------------------------------------------------
module Part1_19();

    int arr[];

    initial begin
        arr = new[5];

        for(int i=0; i<5 ; i++) begin
            arr[i] = i * 5;
        end

        $display("arr : %0p", arr);

        arr.delete();

        for(int i=0; i<5 ; i++) begin// delete yaptigimiz icin hata verecektir
            arr[i] = i * 5;
        end

    end

endmodule
--------------------------------------------------------------------------------*/

/*--------------------------------------------------------------------------------
module Part1_19();

    int arr[];

    initial begin
        arr = new[5];

        for(int i=0; i<5 ; i++) begin
            arr[i] = i * 5;
        end

        $display("arr : %0p", arr);

        arr = new[30];  //Yeni 30 elemanli bir dynamic array olusturulur ve onceki icerik kaybedilir.
Yeni elemanlar kendi veri tiplerinin default degerleriyle baslatilir.

        $display("arr : %0p", arr); // Ciktida 0 gorecegiz

        //arr.delete();
          
        //for(int i=0; i<5 ; i++) begin// delete yaptigimiz icin hata verecektir
        //    arr[i] = i * 5;
        //end
        
    end

endmodule
--------------------------------------------------------------------------------*/


/*--------------------------------------------------------------------------------
module Part1_19();

    int arr[];

    initial begin
        arr = new[5];

        for(int i=0; i<5 ; i++) begin
            arr[i] = i * 5;
        end

        
        arr = new[30](arr); // Ilk 5 degeri buraya kopyalar

        $display("arr : %0p", arr); // Ciktida ilk 5 deger ve 25 tane 0 gorecegiz

        
    end

endmodule
--------------------------------------------------------------------------------*/

//Yukaridaki diziyi sabit dizide saklamak istiyorsak boyut ve tur ayni olmali
/*Fixed-size array, dynamic array ve queue farkli kullanim amaclarina sahiptir.
Fixed-size array'in boyutu sabittir. Dynamic array'in boyutu new ile degistirilebilir.
Queue ise eleman ekleme ve cikarma islemlerinin sik yapildigi durumlarda kullanislidir.
Queue kullanmak her durumda daha az bellek kullanilacagi anlamina gelmez.
*/
module Part1_19();

    int arr[];
    int fix_arr[30];

    initial begin
        arr = new[5];

        for(int i=0; i<5 ; i++) begin
            arr[i] = i * 5;
        end

        
        arr = new[30](arr);

        $display("arr : %0p", arr);

        fix_arr = arr;
        $display("fix_arr : %0p", fix_arr);
    end

endmodule
