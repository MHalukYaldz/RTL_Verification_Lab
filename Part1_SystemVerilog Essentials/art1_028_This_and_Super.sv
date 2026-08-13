`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
"this" anahtar sozcugu arguman ve veri uyesi icin ayni adi kullandigimiz bir durumda bir
islevin argumanlari ve veri uyeleri arasinda ayrim yapmamizi saglar

"super" anahtar sozcugu ust sinif ve alt sinifin yontemleri arasinda ayrim yapmak icin
kullanilir.
*/

class first; ////////////parent class
  int data;
  
  function new(input int data);
    this.data = data;  
  endfunction
  
  
endclass
 
class second extends first;
  int temp;
  
  function new(int data, int temp);
    super.new(data);
    this.temp = temp;
  endfunction
  
endclass
 
module Part1_28;
  second s;
  
  initial begin
    s = new(67, 45);
    $display("Value of data : %0d and Temp : %0d", s.data, s.temp);
  end
  
endmodule
