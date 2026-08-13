`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
Array assignment:
Uyumlu tip ve boyuta sahip unpacked array'ler dogrudan birbirine atanabilir.

Array comparison:
== ve != operatorleri array elemanlarini karsilastirmak icin kullanilabilir.
*/
/*--------------------------------------------------------------------------------
module Part1_18();

    int arr1[5];
    int arr2[5];
    //int arr2[7];
    //shortint arr2[5];

    initial begin
        for(int i=0; i<5; i++) begin
            arr1[i] = i * 5;
        end

        arr2 = arr1;

        $display("arr2 : %0p", arr2);

    end

endmodule
--------------------------------------------------------------------------------*/

/*--------------------------------------------------------------------------------
module Part1_18();

    int arr1[5] = '{1,2,3,4,5};
    int arr2[5] = '{1,2,3,4,5};

    int status;

    initial begin
        status = (arr1 == arr2);
        $display("Status : %0d", status);
    end

endmodule
--------------------------------------------------------------------------------*/

module Part1_18();

    int arr1[5] = '{1,2,3,4,5};
    int arr2[5] = '{1,2,7,4,5};

    int status;

    initial begin
        status = (arr1 != arr2);
        $display("Status : %0d", status);
    end

endmodule
