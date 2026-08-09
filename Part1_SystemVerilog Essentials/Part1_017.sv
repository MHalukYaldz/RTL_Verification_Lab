`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*------------------------------------------------------------------------------
module Part1_17();

    int arr[10];
    int i;

    initial begin
        for(i=0; i<10; i++) begin
            arr[i] = i;
        end

            $display("Arr : %0p", arr);
    end
    
endmodule
--------------------------------------------------------------------------------*/

/*
Repetitive Operations --> Foor Loop
                      --> Repeat Loop
                      --> Foreach Loop

*/


/*------------------------------------------------------------------------------
module Part1_17();
    int arr[10];
    int i=0;

    initial begin
        foreach(arr[j]) begin // 0-9
            arr[j] = j;
            $display("%0d", arr[j]);
        end
    end

endmodule
--------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
module Part1_17();
    int arr[10];
    int i=0;

    initial begin
        foreach(arr[j]) begin // 0-9
            arr[j] = 5;
            $display("%0d", arr[j]);
        end
    end

endmodule
--------------------------------------------------------------------------------*/

module Part1_17();

    int arr[10];
    int i=0;

    initial begin
        repeat(10) begin
            arr[i]=i;
            i++;
        end
    
        $display("arr : %0p", arr);

    end


endmodule
