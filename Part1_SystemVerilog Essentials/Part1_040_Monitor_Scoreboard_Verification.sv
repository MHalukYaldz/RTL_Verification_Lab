`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


/*Reference DUT:

module top
(
  input clk,
  input [3:0] a,b,
  output reg [7:0] mul
);
  
  always@(posedge clk)
    begin
     mul <= a * b;
    end
  
endmodule*/

interface top_if;
  logic clk;
  logic [3:0] a, b;
  logic [7:0] mul;
  
endinterface

class packet;

    logic [3:0] a;
    logic [3:0] b;
    logic [7:0] mul;

    function void display();
        $display("a : %0d \t b : %0d \t mul : %0d", a, b, mul);
    endfunction

endclass

class monitor;

    mailbox #(packet) mbx;
    virtual top_if vif;
    packet pkt;

    function new(mailbox #(packet) mbx);
        this.mbx = mbx;
    endfunction

    task run();
		forever begin
			@(posedge vif.clk);
	
			pkt = new();
	
			//DUT'un bu clock kenarinda kullandigi girisleri al
			pkt.a = vif.a;
			pkt.b = vif.b;
	
			//DUT'taki non-blocking assignment'in guncellenmesini bekle
			#1;
			pkt.mul = vif.mul;
	
			$display("-------------------------------------");
			$display("[MON] : Data Sent to Scoreboard");
			pkt.display();
	
			mbx.put(pkt);
		end
	endtask
endclass

class scoreboard;
    
    mailbox #(packet) mbx;
    packet pkt;

    function new(mailbox #(packet) mbx);
        this.mbx = mbx;
    endfunction

    task compare(input packet pkt);
        if((pkt.mul) == (pkt.a * pkt.b))
            $display("[SCO] : Mul Result Matched");
        else
            $error("[SCO] : Mul Result Mismatched");
    endtask

    task run();
        forever begin
            mbx.get(pkt);
            $display("[SCO] : Data RCVD from Monitor");
            pkt.display();
            compare(pkt);
            $display("-------------------------------------");
            #10;
        end
    endtask
endclass

//Testbench Top Code:

module Part1_40;
  
    top_if vif();
    monitor mon;
    scoreboard sco;
    mailbox #(packet) mbx;
  
    top dut (vif.clk, vif.a, vif.b, vif.mul);
  
    initial begin
		vif.clk <= 0;
		vif.a   <= 0;
		vif.b   <= 0;
	end
  
    always #5 vif.clk <= ~vif.clk;
  
    initial begin
        for(int i = 0; i<20; i++) begin
            @(posedge vif.clk);
            vif.a <= $urandom_range(1,15);
            vif.b <= $urandom_range(1,15);
        end
    end

    initial begin
        mbx = new();
        mon = new(mbx);
        sco = new(mbx);
        mon.vif = vif;
    end

    initial begin
        fork
            mon.run();
            sco.run();
        join
    end
  
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;    
        #300;
        $finish();
    end
  
endmodule


///////////////////////////////////////////////////////////////////////////////////////
/*

interface top_if;
  logic clk;
  logic [3:0] a, b;
  logic [7:0] mul;
  
endinterface

class packet;

    logic [3:0] a;
    logic [3:0] b;
    logic [7:0] mul;

    function void display();
        $display("a : %0d \t b : %0d \t mul : %0d", a, b, mul);
    endfunction

endclass

class monitor;

    mailbox #(packet) mbx;
    virtual top_if vif;
    packet pkt;

    function new(mailbox #(packet) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        forever begin
            pkt = new();
            @(posedge vif.clk);
          	pkt.a = vif.a;
            pkt.b = vif.b;
            #10;
            pkt.mul = vif.mul;
            $display("-------------------------------------");
            $display("[MON] : Data Sent to Scoreboard");
            pkt.display();
            mbx.put(pkt);
        end
    endtask
endclass

class scoreboard;
    
    mailbox #(packet) mbx;
    packet pkt;

    function new(mailbox #(packet) mbx);
        this.mbx = mbx;
    endfunction

    task compare(input packet pkt);
        if((pkt.mul) == (pkt.a * pkt.b))
            $display("[SCO] : Mul Result Matched");
        else
            $error("[SCO] : Mul Result Mismatched");
    endtask

    task run();
        forever begin
            mbx.get(pkt);
            $display("[SCO] : Data RCVD from Monitor");
            pkt.display();
            compare(pkt);
            $display("-------------------------------------");
        end
    endtask
endclass

//Testbench Top Code:

module Part1_40;
  
    top_if vif();
    monitor mon;
    scoreboard sco;
    mailbox #(packet) mbx;
  
    top dut (vif.clk, vif.a, vif.b, vif.mul);
  
    initial begin
        vif.clk <= 0;
    end
  
    always #5 vif.clk <= ~vif.clk;
  
    initial begin
        for(int i = 0; i<20; i++) begin
            @(posedge vif.clk);
            vif.a <= $urandom_range(1,15);
            vif.b <= $urandom_range(1,15);
        end
    end

    initial begin
        mbx = new();
        mon = new(mbx);
        sco = new(mbx);
        mon.vif = vif;
    end

    initial begin
        fork
            mon.run();
            sco.run();
        join
    end
  
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;    
        #300;
        $finish();
    end
  
endmodule

*/
