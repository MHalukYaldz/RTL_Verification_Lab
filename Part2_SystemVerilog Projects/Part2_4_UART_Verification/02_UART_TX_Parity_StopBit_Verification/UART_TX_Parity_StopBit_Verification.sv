/////////////       REFERENCE DUT     ///////////////////////////////////
/*
`timescale 1ns / 1ps
 
 
module uarttx
#(
parameter clk_freq = 1000000,
parameter baud_rate = 9600
)
(
input clk,rst,
input newd,
input [7:0] tx_data,
output reg tx,
output reg donetx
);
 
  localparam clkcount = (clk_freq/baud_rate);
  
integer count = 0;      // Clock Counter
integer counts = 0;     // Bit Counter
 
reg uclk = 0;
  
enum bit[1:0] {idle = 2'b00, start = 2'b01, transfer = 2'b10, send_parity = 2'b11} state;
 
 ///////////uart_clock_gen
  always@(posedge clk)
    begin
      if(count < (clkcount/2) - 1)
		count <= count + 1;
	  else begin
		count <= 0;
		uclk <= ~uclk;
	  end
    end
  
  
  reg [7:0] din;
  reg parity = 0; /// store odd parity
  ////////////////////Reset decoder
  
  
  always@(posedge uclk)
    begin
      if(rst) 
		begin
			state  <= idle;
			counts <= 0;
			din    <= 8'h00;
			parity <= 1'b0;
			tx     <= 1'b1;
			donetx <= 1'b0;
		end
     else
     begin
     case(state)
     
     //////detect new data and start transmission
       idle:
         begin
           counts <= 0;
           tx <= 1'b1;
           donetx <= 1'b0;
           
           if(newd) 
           begin
             state <= transfer;
             din <= tx_data;
             tx <= 1'b0; 
             parity <= ~^tx_data;
           end
           else
             state <= idle;       
         end
       
 
      ///// wait till transmission of data is completed
      transfer: begin 
          
        if(counts <= 7) 
        begin
           counts <= counts + 1;
           tx     <= din[counts];
           state  <= transfer;
        end
        else 
        begin
           counts <= 0;
           tx     <= parity;
           state  <= send_parity;
        end
      end
      
      //// send stop bit and complete transmission
	send_parity:
	begin
    tx     <= 1'b1;
    state  <= idle;
    donetx <= 1'b1;
	end
      
      default : state <= idle;
      
    endcase
  end
end
 
endmodule
*/

///////////////////     TESTBENCH       ////////////////////////////////////
module uart_tb;
reg clk = 0,rst = 0;
reg newd;
reg [7:0] tx_data;
wire tx;
wire donetx;
 
uarttx #(1000000, 9600) dut (clk, rst, newd, tx_data, tx, donetx);
  
always #500 clk = ~clk;  
 
reg [7:0] data_tx = 8'h00;
//////////////////////////////////////////////////
reg received_parity = 1'b0;
reg expected_parity = 1'b0;
//////////////////////////////////////////////////

initial 
begin
	rst     = 1'b1;
	newd    = 1'b0;
	tx_data = 8'h00;
	
	repeat(2) @(posedge dut.uclk);
	
	// Release reset away from the DUT sampling edge
	@(negedge dut.uclk);
	rst = 1'b0;
	
	for(int i = 0; i < 10; i++)
	begin
		newd = 1'b1;
		tx_data = $urandom();
		expected_parity = ~^tx_data;

        @(negedge dut.uclk);
        newd = 0;
            
            /////////// START BIT
            if(tx == 0)
                $display("Start Bit Pass");
            else
                 $display("Start Bit Fail");

            //////////  DATA
            for(int j = 0; j < 8; j++)
            begin
            @(negedge dut.uclk);
            data_tx = {tx,data_tx[7:1]};
            end
            
            /////////   DATA COMPARE
            if(data_tx == tx_data)
                $display("Data Match!!!!!!!");
            else
                $display("Data Fail!!!!!!!!!!!!!!!!!!!!!!");

            /////////   PARITY CHECK
            @(negedge dut.uclk);
            received_parity = tx;

            if(expected_parity == received_parity)
                $display("Parity Pass");
            else
                $display("Parity Fail");

            @(negedge dut.uclk);
            if(tx == 1)
                $display("Stop Bit Pass");
            else
                $display("Stop Bit Fail");
        if(donetx == 1)
                $display("Transmission Complete");
        else
            $display("donetx Fail");
        
        end
        
        $finish;
 
end
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, clk);
    $dumpvars(0, rst);
    $dumpvars(0, newd);
    $dumpvars(0, tx_data);
    $dumpvars(0, tx);
    $dumpvars(0, donetx);
    $dumpvars(0, data_tx);
    $dumpvars(0, expected_parity);
    $dumpvars(0, received_parity);
    $dumpvars(0, dut.uclk);
end
 
 
endmodule