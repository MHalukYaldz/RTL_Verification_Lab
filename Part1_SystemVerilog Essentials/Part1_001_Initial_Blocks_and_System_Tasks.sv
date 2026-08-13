`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Part1_1();

////////Global Signal clk, reset
    
    reg clk;
    reg reset;

    reg [3:0] temp ;

    //1.Initialized Global Variables
    initial begin           // Globalleri baslatma icin initial blogu 
        clk     = 1'b0;
        reset   = 1'b0;
    end

    // 2.Random signal for data/control
    initial begin
        reset = 1'b1;
        #30;    //sifirlamanin ilk 30ns yuksek olmasini istedigimizi varsayalim ve sonra kaldiralim
        reset = 1'b0;
    end
    
    initial begin           // Cok bitli sinyaller icin rastgele dalga formu
        temp = 4'b0100;
        #10;
        temp = 4'b1100;
        #10;
        temp = 4'b0011;
        #10;
    end

    // 3.System task at the start
    initial begin // $dumpfile specifies the VCD output file.
				  // $dumpvars enables waveform dumping for simulation signals.
        $dumpfile("dump.vcd");
        $dumpvars;
        #200;
        $finish();// Ends the simulation.
    end

    // 4.Analyzing values of variable on console
    initial begin   //Dalga formundan analiz etmek yerine konsoldaki degisken degerlerine bakariz
    $monitor("Temp : %0d at time : %t", temp,$time);//Raporlama mekanizmasi icin kullaniriz
    end             // Monitor bu konuda siklikla kullanilir

    // 5.Stop simulation by forcefully calling $finish
    initial begin
        #200;
        $finish();
    end
endmodule
