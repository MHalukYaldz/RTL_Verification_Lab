`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*------------------------------------------------------------------------
module Part1_15();
    
    bit arr1[8];
    bit arr2[];

initial begin
    $display("Size of arr1 : %0d", $size(arr1));
    $display("Size of arr2 : %0d", $size(arr2));

    $display("Value of first element : %0d", arr1[0]);
    arr1[1] = 1;
    $display("Value of second element : %0d", arr1[1]);
    arr2[5] = 1;
    arr2[0] = 1;

    $display("Value of all elements of arr2 : %0p", arr2); //HATA
end

endmodule
------------------------------------------------------------------------*/

/*
Fixed-size array --> bit arr[7:0] veya bit arr[8];

Dynamic array --> bit arr[] = '{1,0,1,1};
Dynamic array'in boyutu calisma zamaninda belirlenebilir. $size(arr) ifadesi
dizinin mevcut eleman sayisini verir.

Dynamic array baslangicta boyutlandirilmamissa boyutu 0'dir. Tek tek elemanlara
deger atamaya calismak dizinin boyutunu arttirmaz. Boyut new[N] kullanilarak veya
tum diziye yapilan bir array assignment ile belirlenebilir.

Unique values:
int arr[] = '{1,2,3,4};
Bu atama dynamic array'i 4 elemanli hale getirir ve degerleri sirayla yerlestirir.

bit arr[] = '{1,2,3,4};
bit 1-bit oldugu icin her eleman 1 bite donusturulur.
Sonuc: '{1,0,1,0}

Repetitive values:
int arr[] = '{6{1}};
6 elemanli bir dynamic array olusur ve tum elemanlara 1 atanir.

Default value:
int arr[6] = '{default:0};
Fixed-size array'in tum elemanlarina 0 atanir.

Uninitialized array elemanlarinin baslangic degeri elemanin veri tipine baglidir.
Ornegin bit elemanlari 0, logic elemanlari X ile baslar.
*/

module Part1_15();

    bit arr1[5];
    int arr2[5];
    logic arr3[5];
    int arr4[5] = '{1,2,3,4,5};  // Eger tum degerler doldurulmazsa hata verir
    int arr5[5] = '{5{0}};
    int arr6[10] = '{default : 2}; 

initial begin
    $display("arr1 : %0p", arr1);
    $display("arr2 : %0p", arr2);
    $display("arr3 : %0p", arr3);
    $display("arr4 : %0p", arr4);
end
    
endmodule
