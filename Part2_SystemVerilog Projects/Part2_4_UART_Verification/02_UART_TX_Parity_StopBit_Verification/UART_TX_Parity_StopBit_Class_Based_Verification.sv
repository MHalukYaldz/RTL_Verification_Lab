/*/////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////		HATIRLATMALAR		///////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

Testbench'ten DUT'a giden sinyalleri her zaman clock kenarına hizalayarak ve non-blocking (<=) atama ile sürülmeli.

UART haberleşmesinde Scoreboard'un işini bitirmesi (sconext), zaten Monitör'ün seri veriyi okumayı bitirdiği ve tüm çerçevenin tamamlandığı anlamına gelir. Bu nedenle Generator içinde sadece Scoreboard'u beklemek yeterlidir.

///////////////////////////////////////////////////////////////////////////////////////////////////
*//////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////	Interface

interface uart_if;

	logic clk;
	logic rst;
	logic newd;
	logic [7:0] tx_data;
	logic uclk;
	logic tx;
	logic donetx;

endinterface


//////////////////////	Transaction

class transaction;
	
	rand bit [7:0] tx_data;
		
	bit newd;
	bit tx;
	bit donetx;
	bit received_parity;
	bit [7:0] received_data;
	bit received_stop_bit;
	
//	constraint control_newd {
//	    newd dist {1 := 80 , 0 := 20};
//	}
	function void display(input string tag);
		$display("[%0s] : TX_Data : %0d", tag, tx_data);
	endfunction
	
	function transaction copy();
		copy = new();
		copy.newd = this.newd;
		copy.tx_data = this.tx_data;
		copy.tx = this.tx;
		copy.donetx = this.donetx;
		copy.received_parity = this.received_parity;
		copy.received_data = this.received_data;
		copy.received_stop_bit = this.received_stop_bit;
	endfunction
	
endclass


//////////////////////	Generator

class generator;

	transaction tr;
	mailbox #(transaction) mbx;
	event done;
	event sconext;
	//event drvnext;
	int count = 0;
	
	function new(mailbox #(transaction) mbx);	//GEN -> DRV
		this.mbx = mbx;
		tr = new();
	endfunction
	
	task run();
		repeat(count) begin
			assert(tr.randomize()) else $error("[GEN] : Randomization Failed!!");
			mbx.put(tr.copy());
			tr.display("GEN");
			
			@(sconext);
			//@(drvnext);
		end
		->done;	
	endtask
	
endclass


//////////////////////	Driver

class driver;

	virtual uart_if uif;
	transaction tr;
	mailbox #(transaction) mbx;		// GEN -> DRV
	mailbox #(bit [7:0]) mbxDS;		// DRV -> SCO
	//event drvnext;
	
	function new(mailbox #(bit [7:0]) mbxDS, mailbox #(transaction) mbx);
		this.mbx = mbx;
		this.mbxDS = mbxDS;
	endfunction
	
	task reset();
		uif.rst = 1'b1;
		uif.newd = 1'b0;
		uif.tx_data = 8'h00;
		repeat(60) @(posedge uif.clk);
		uif.rst = 1'b0;
		repeat(5) @(posedge uif.clk);
		
		$display("[DRV] : RESET DONE");
		$display("-------------------------");
	endtask
	
	task run();
		forever begin
			mbx.get(tr);
			@(negedge uif.uclk);	//RACE CONDITION OLMAMASI ICIN UNUTULMAMALI
			uif.newd <= 1'b1;
			uif.tx_data <= tr.tx_data;
			mbxDS.put(tr.tx_data);
			@(posedge uif.uclk);
			@(negedge uif.uclk);
			uif.newd <= 1'b0;
			@(posedge uif.donetx);
			
			$display("[DRV] : DATA SENT : %0d", tr.tx_data);
			
			//-> drvnext;
			
			@(posedge uif.uclk);
		end
	endtask
endclass


//////////////////////	Monitor

class monitor;
	
	transaction tr;
	mailbox #(transaction) mbx;		// 
	
	virtual uart_if uif;
	
	
	function new(mailbox #(transaction) mbx);
		this.mbx = mbx;
	endfunction
	
	task run();
		tr = new();
		forever begin
			@(negedge uif.tx);		//START BIT
			
			@(negedge uif.uclk);	//START BIT FINISH
			
			for(int i=0; i<8; i++) begin	//DATA BIT
				@(negedge uif.uclk);
				tr.received_data[i] = uif.tx;
			end
			
			@(negedge uif.uclk);	//PARITY BIT
			tr.received_parity = uif.tx;

			@(negedge uif.uclk);	//STOP BIT
			tr.received_stop_bit = uif.tx;
			
			$display("[MON] : DATA RCVD : %0d | Parity : %0d", tr.received_data, tr.received_parity);
			mbx.put(tr.copy());
		end
	endtask
endclass


//////////////////////	Scoreboard

class scoreboard;
	
	transaction tr_mon;
	
	mailbox #(transaction) mbx;
	mailbox #(bit [7:0]) mbxDS;
	event sconext;
	
	bit [7:0] ds;
	
	function new(mailbox #(transaction) mbx, mailbox #(bit [7:0]) mbxDS);
		this.mbx = mbx;
		this.mbxDS = mbxDS;
	endfunction
	
	task run();
		forever begin
			mbx.get(tr_mon);
			mbxDS.get(ds);
			
			if(tr_mon.received_data == ds) begin
				$display("[SCO] : DRV : %0d | MON : %0d", ds, tr_mon.received_data);
			end
			else begin
				$display("DATA FAIL");
			end
			
			if((^~ds) == tr_mon.received_parity) begin
				$display("[SCO] : PARITY PASS");			end
			else begin
				$display("[SCO] : PARITY FAIL");
			end
			
			if(tr_mon.received_stop_bit == 1'b1) begin
				$display("[SCO] : STOP PASS");
				$display("---------------------------------");
			end
			else begin
				$display("[SCO] : STOP FAIL");
				$display("---------------------------------");
			end
			
			->sconext;
		end
	endtask
	
endclass


//////////////////////	Environment

class environment;
	
	generator gen;
	driver drv;
	monitor mon;
	scoreboard sco;
	
	event nextgs;
	event nextgd;
	
	mailbox #(transaction) mbxGD;		//GEN -> DRV
	mailbox #(bit [7:0]) mbxDS;			//DRV -> SCO
	mailbox #(transaction) mbxMS;		//MON -> SCO

	virtual uart_if uif;
	
	function new(virtual uart_if uif);
		
		mbxGD = new();
		mbxDS = new();
		mbxMS = new();
		
		gen = new(mbxGD);
		drv = new(mbxDS, mbxGD);
		mon = new(mbxMS);
		sco = new(mbxMS, mbxDS);
		
		this.uif = uif;
		drv.uif = this.uif;
		mon.uif = this.uif;
		
		gen.sconext = nextgs;
		sco.sconext = nextgs;
		
		//gen.drvnext = nextgd;
		//drv.drvnext = nextgd;
	endfunction
	
	task pre_test();
		drv.reset();
	endtask
	
	task test();
		fork
			gen.run();
			drv.run();
			mon.run();
			sco.run();
		join_any
	endtask
	
	task post_test();
		wait(gen.done.triggered);
		$finish();
	endtask
	
	task run();
		pre_test();
		test();
		post_test();
	endtask
endclass

module tb;
	
	uart_if uif();
	
	uarttx dut(uif.clk, uif.rst, uif.newd, uif.tx_data, uif.tx, uif.donetx);
	
	initial begin
		uif.clk <= 0;
	end
	
	always #500 uif.clk = ~uif.clk;
	
	assign uif.uclk = dut.uclk;
	
	environment env;
	
	initial begin
		env = new(uif);
		env.gen.count = 5;
		env.run();
	end
	
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end
	
endmodule