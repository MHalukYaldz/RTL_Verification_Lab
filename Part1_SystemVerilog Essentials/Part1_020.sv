`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
module Part1_20();

    int arr[$];

    initial begin
        arr = {1, 2, 3};
        $display("arr : %0p", arr);
    end

endmodule
*/

//  Siklikla yapilan islemlerden biri kuyruga yeni eleman eklemektir
//push_front --> Yeni elemani kuyrugun basina ekler.
//push_back  --> Yeni elemani kuyrugun sonuna ekler.
//pop_front  --> Kuyrugun ilk elemanini cikarir ve geri dondurur.
//pop_back   --> Kuyrugun son elemanini cikarir ve geri dondurur.
//insert     --> Belirtilen indekse yeni eleman ekler.
//delete     --> Belirtilen indeksteki elemani veya tum queue'yu silebilir.

/*
module Part1_20();

    int arr[$];
    int j = 0;

    initial begin
        arr = {1, 2, 3};
        $display("arr : %0p", arr);

        arr.push_front(7);
        $display("arr : %0p", arr);

        arr.push_back(9);
        $display("arr : %0p", arr);

        arr.insert(2, 10);
        $display("arr : %0p", arr);
        
        j = arr.pop_front();
        $display("arr : %0p", arr);
        $display("Value of j : %0d", j);

        j = arr.pop_back();
        $display("arr : %0p", arr);
        $display("Value of j : %0d", j);
    
        arr.delete(2);
        $display("arr : %0p", arr);

    end

endmodule
*/
//15 eleman depolayabilen iki adet reg türünde dizi  $urandom işlevini kullanarak 
//diziye 15 değer ekle Dizideki tüm elemanların değerlerini tek bir satırda yazdır

/*
module Part1_20();

    reg arr_a[15];
    reg arr_b[15];

    initial begin
        
        for(int i=0; i<15; i++) begin
            arr_a[i] = $urandom();
            arr_b[i] = $urandom();
        end
        $display(" arr_a : %0p, arr_b : %0p", arr_a, arr_b);

    end


endmodule
*/

//7 eleman depolayabilen dinamik bir dizi oluştur diziye 7'den başlayarak 7'nin katları 
//olan değerleri ekle (7, 14, 21, ..., 49). 20 nanosaniye sonra dinamik dizinin boyutunu 
//20 olarak güncelle dizinin mevcut değerlerini olduğu gibi bırak ve geri kalan 13 
//elemanı 5'ten başlayarak 5'in katları olacak şekilde güncelle tüm elemanları 
//güncelledikten sonra dinamik dizinin değerini yazdır
//
//Beklenen sonuç: 7, 14, 21, 28 ..... 49, 5, 10, 15 ..... 65 .

/*
module Part1_20();

    int arr[];

    initial begin
        
        arr = new[7];
        
        for(int i=0; i<7; i++) begin
            arr[i] = (i+1) * 7;
            
        end
        
        #20;
        arr = new[20](arr);

        for(int j=7; j<20; j++) begin
            arr[j] = (j - 6) * 5;
        end

        $display("arr : %0p", arr);

    end


endmodule
*/


//20 eleman depolayabilecek sabit boyutlu bir dizi oluştur $urandom işlevini kullanarak 
//20 elemanın tümüne rastgele değerler ekle
//sabit boyutlu dizinin ilk elemanı kuyruğun son elemanı olacak şekilde, sabit boyutlu dizinin tüm elemanlarını kuyruğa 
//ekle hem sabit boyutlu dizinin hem de kuyruğun tüm elemanlarını konsola yazdır

module Part1_20();

    int arr[20];
    int jump[$];

    initial begin
        
        //arr = $urandom;
        for(int i=0; i<20; i++) begin
            arr[i] = $urandom;
            
        end
        $display("arr : %0p", arr);

        for(int j=0; j<20; j++) begin
            jump.push_front(arr[j]);
        end
        $display("jump : %0p", jump);

    end


endmodule