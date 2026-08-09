`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////

module Part1_16();

    int unsigned arr[0:9] = '{0, 1, 4, 9, 16, 25, 36, 49, 64, 81};

    initial begin
        $display("Array elemnts : %0p", arr);
    end

endmodule

/*
Fixed-size unsigned integer array example.
Each element is initialized with the square of its index.
*/