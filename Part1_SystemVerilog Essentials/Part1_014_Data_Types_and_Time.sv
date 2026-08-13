`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
module Part1_14();

bit a = 0;

byte b = 0;
shortint c = 0 ;
int d = 0 ;
longint e = 0 ;

bit [7:0] f = 0 ;
bit [15:0] g = 0 ;

real h= 0 ;

initial begin

    a = 1'b0;

end

endmodule
*/

/*---------------------------------------------------------------------------------------
module Part1_14();

byte var1 = 127;
bit [7:0] var2 = 130;

initial begin
    #10;
    $display("Value of VAR : %0d", var2);
end

shortint var3 = 0;

endmodule
---------------------------------------------------------------------------------------*/


/*
SystemVerilog veri tipleri genel olarak 2-state ve 4-state veri tipleri olarak
incelenebilir. 2-state tipler yalnızca 0 ve 1 değerlerini temsil ederken,
4-state tipler 0, 1, X ve Z değerlerini temsil edebilir.

Bu bölümde temel veri tipleri, fixed-size ve dynamic array yapıları, queue kullanimi,
dizi baslatma yontemleri ve diziler uzerinde for, foreach ve repeat gibi dongulerle
yapilan islemler incelenmektedir.
*/

/*---------------------------------------------------------------------------------------
Simulation  --> fixed-point time    --> 64-bit 
                floating-point time --> 64-bit

Variable    --> fixed   --> 2-state --> signed      -->  8-bit  --> byte    |
                                                        16-bit  --> shortint|
                                                        32-bit  --> int     |
                                                        64-bit  --> longint |> FIXED-POINT
                                        unsigned    --> [7:0]   --> bit     |
                                                        [15:0]  --> bit     |
                                                        [31:0]  --> bit     |
                            4-state --> integer --> integer 32-bit signed

                floating--> real    -->64-bit double precision 

Hardware    --> reg   --> Procedural bloklarda atanabilir. Continuous assignment'in LHS'i olarak kullanilmaz.
				wire  --> Net tipidir. Continuous assignment veya module baglantilariyla surulebilir.
				logic --> SystemVerilog variable tipidir. Procedural assignment icin kullanilabilir;
          tek surucu oldugu surece continuous/module cikisi tarafinda da kullanilabilir.
---------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------------
module Part1_14();

    time fix_time = 0;      //store fixed-point time value
    realtime real_time = 0; //store floating-point time value

    /////$time();       return current simulation time in fixed-point format
    /////$realtime();   return current simulation time in floating-point format

    initial begin
        #12;
        fix_time = $time();
        $display("Current Simulation time : %0t", fix_time);
    end

    initial begin
        #12.23;
        fix_time = $time();
        $display("Current Simulation time : %0t", fix_time);
    end

    initial begin
        #12.23;
        real_time = $realtime();
        $display("Current Simulation time : %0t", real_time);
    end

    initial begin
        #12.67;
        fix_time = $realtime();
        $display("Current Simulation time : %0t", fix_time);
    end
    //12.34 -> 12
    //12.67 -> 13

endmodule
---------------------------------------------------------------------------------------*/

//*---------------------------------------------------------------------------------------
module Part1_14(
    input a,b,sel,
    output y
    );

    reg temp;

    always@(*)
    begin
        if(sel==1'b0)
            temp = a;
        else
            temp = b;
    end

    assign y = temp;

endmodule
//---------------------------------------------------------------------------------------*/
